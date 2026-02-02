package cn.zhangchuangla.system.lostfound.service.impl;

import cn.zhangchuangla.common.core.exception.ServiceException;
import cn.zhangchuangla.system.lostfound.enums.NotificationTypeEnum;
import cn.zhangchuangla.system.lostfound.mapper.BizExchangeOrderMapper;
import cn.zhangchuangla.system.lostfound.mapper.BizGiftMapper;
import cn.zhangchuangla.system.lostfound.model.entity.BizExchangeOrder;
import cn.zhangchuangla.system.lostfound.model.entity.BizGift;
import cn.zhangchuangla.system.lostfound.service.ExchangeOrderService;
import cn.zhangchuangla.system.lostfound.service.NotificationService;
import cn.zhangchuangla.system.lostfound.service.PointsService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

/**
 * 兑换订单服务实现
 *
 * @author Chuang
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class ExchangeOrderServiceImpl implements ExchangeOrderService {

    private final BizExchangeOrderMapper exchangeOrderMapper;
    private final BizGiftMapper giftMapper;
    private final PointsService pointsService;
    @Lazy
    private final NotificationService notificationService;
    
    /**
     * 乐观锁重试次数
     */
    private static final int MAX_RETRY_TIMES = 3;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long exchangeGift(Long userId, Long giftId, Integer quantity,
                             String receiverName, String receiverPhone, String receiverAddress) {
        // 1. 查询礼品信息
        BizGift gift = giftMapper.selectById(giftId);
        if (gift == null || gift.getDeleted() == 1) {
            throw new ServiceException("礼品不存在");
        }
        if (!"ON".equals(gift.getStatus())) {
            throw new ServiceException("礼品已下架");
        }

        // 2. 检查库存
        int totalQuantity = quantity == null ? 1 : quantity;
        if (gift.getStock() < totalQuantity) {
            throw new ServiceException("礼品库存不足");
        }

        // 3. 计算所需积分
        int totalPoints = gift.getPointsCost() * totalQuantity;

        // 4. 检查用户积分
        int userPoints = pointsService.getUserPoints(userId);
        if (userPoints < totalPoints) {
            throw new ServiceException("积分不足，无法兑换");
        }

        // 5. 实物礼品检查收货信息
        if ("PHYSICAL".equals(gift.getGiftType())) {
            if (!StringUtils.hasText(receiverName)) {
                throw new ServiceException("请填写收货人姓名");
            }
            if (!StringUtils.hasText(receiverPhone)) {
                throw new ServiceException("请填写收货人电话");
            }
            if (!StringUtils.hasText(receiverAddress)) {
                throw new ServiceException("请填写收货地址");
            }
        }

        // 6. 扣减积分
        pointsService.deductPoints(userId, "EXCHANGE", totalPoints, "兑换礼品: " + gift.getName());

        // 7. 使用乐观锁扣减库存（带重试机制）
        boolean stockUpdated = false;
        for (int retry = 0; retry < MAX_RETRY_TIMES; retry++) {
            // 重新获取最新的礼品信息（包含最新version）
            gift = giftMapper.selectById(giftId);
            if (gift == null || gift.getStock() < totalQuantity) {
                // 库存不足，回滚积分
                pointsService.awardPoints(userId, "REFUND", totalPoints, "EXCHANGE_FAILED", null);
                throw new ServiceException("兑换失败，库存不足");
            }
            
            // 使用乐观锁更新库存
            BizGift updateGift = new BizGift();
            updateGift.setId(giftId);
            updateGift.setStock(gift.getStock() - totalQuantity);
            updateGift.setExchangeCount(gift.getExchangeCount() + totalQuantity);
            updateGift.setVersion(gift.getVersion());
            
            int updated = giftMapper.updateById(updateGift);
            if (updated > 0) {
                stockUpdated = true;
                log.info("礼品库存扣减成功: giftId={}, quantity={}, retry={}", giftId, totalQuantity, retry);
                break;
            }
            log.warn("乐观锁冲突，重试扣减库存: giftId={}, retry={}", giftId, retry + 1);
        }
        
        if (!stockUpdated) {
            // 重试失败，回滚积分
            pointsService.awardPoints(userId, "REFUND", totalPoints, "EXCHANGE_FAILED", null);
            throw new ServiceException("系统繁忙，请稍后重试");
        }

        // 8. 创建订单
        BizExchangeOrder order = new BizExchangeOrder();
        order.setOrderNo(generateOrderNo());
        order.setUserId(userId);
        order.setGiftId(giftId);
        order.setGiftName(gift.getName());
        order.setGiftType(gift.getGiftType());
        order.setPointsCost(totalPoints);
        order.setQuantity(totalQuantity);
        order.setStatus("PENDING");
        order.setReceiverName(receiverName);
        order.setReceiverPhone(receiverPhone);
        order.setReceiverAddress(receiverAddress);
        order.setCreatedAt(LocalDateTime.now());
        order.setUpdatedAt(LocalDateTime.now());

        // 虚拟礼品直接设置内容并完成
        if ("VIRTUAL".equals(gift.getGiftType())) {
            order.setVirtualContent(gift.getVirtualContent());
            order.setStatus("COMPLETED");
            order.setCompletedAt(LocalDateTime.now());
        }

        exchangeOrderMapper.insert(order);
        
        // 发送兑换成功通知
        sendExchangeNotification(userId, gift.getName(), totalPoints, order.getId(), 
            "VIRTUAL".equals(gift.getGiftType()) ? "COMPLETED" : "PENDING");
        
        return order.getId();
    }

    /**
     * 发送兑换相关通知
     */
    private void sendExchangeNotification(Long userId, String giftName, int points, Long orderId, String status) {
        try {
            String title;
            String content;
            switch (status) {
                case "PENDING":
                    title = "积分兑换成功";
                    content = "您已成功兑换「" + giftName + "」，消耗" + points + "积分，请等待发货。";
                    break;
                case "COMPLETED":
                    title = "积分兑换成功";
                    content = "您已成功兑换「" + giftName + "」，消耗" + points + "积分，虚拟礼品已发放。";
                    break;
                case "SHIPPED":
                    title = "订单已发货";
                    content = "您兑换的「" + giftName + "」已发货，请注意查收。";
                    break;
                case "CANCELLED":
                    title = "订单已取消";
                    content = "您兑换的「" + giftName + "」订单已取消，" + points + "积分已退还。";
                    break;
                default:
                    return;
            }
            notificationService.createNotification(userId, NotificationTypeEnum.POINTS, title, content, "ORDER", orderId);
        } catch (Exception e) {
            // 通知发送失败不影响主流程
        }
    }


    @Override
    public Page<BizExchangeOrder> listUserOrders(Page<BizExchangeOrder> page, Long userId, String status) {
        LambdaQueryWrapper<BizExchangeOrder> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(BizExchangeOrder::getUserId, userId);
        if (StringUtils.hasText(status)) {
            wrapper.eq(BizExchangeOrder::getStatus, status);
        }
        wrapper.orderByDesc(BizExchangeOrder::getCreatedAt);
        return exchangeOrderMapper.selectPage(page, wrapper);
    }

    @Override
    public BizExchangeOrder getOrderById(Long orderId, Long userId) {
        BizExchangeOrder order = exchangeOrderMapper.selectById(orderId);
        if (order == null) {
            throw new ServiceException("订单不存在");
        }
        // 如果传入userId，校验订单归属
        if (userId != null && !userId.equals(order.getUserId())) {
            throw new ServiceException("无权查看此订单");
        }
        return order;
    }

    @Override
    public Page<BizExchangeOrder> listOrdersForAdmin(Page<BizExchangeOrder> page, String orderNo, String status, Long userId) {
        LambdaQueryWrapper<BizExchangeOrder> wrapper = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(orderNo)) {
            wrapper.like(BizExchangeOrder::getOrderNo, orderNo);
        }
        if (StringUtils.hasText(status)) {
            wrapper.eq(BizExchangeOrder::getStatus, status);
        }
        if (userId != null) {
            wrapper.eq(BizExchangeOrder::getUserId, userId);
        }
        wrapper.orderByDesc(BizExchangeOrder::getCreatedAt);
        return exchangeOrderMapper.selectPage(page, wrapper);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void shipOrder(Long orderId, String trackingNo) {
        BizExchangeOrder order = exchangeOrderMapper.selectById(orderId);
        if (order == null) {
            throw new ServiceException("订单不存在");
        }
        if (!"PENDING".equals(order.getStatus())) {
            throw new ServiceException("当前订单状态不允许发货");
        }
        if (!"PHYSICAL".equals(order.getGiftType())) {
            throw new ServiceException("虚拟礼品无需发货");
        }

        LambdaUpdateWrapper<BizExchangeOrder> updateWrapper = new LambdaUpdateWrapper<>();
        updateWrapper.eq(BizExchangeOrder::getId, orderId)
                .set(BizExchangeOrder::getStatus, "SHIPPED")
                .set(BizExchangeOrder::getTrackingNo, trackingNo)
                .set(BizExchangeOrder::getShippedAt, LocalDateTime.now());
        exchangeOrderMapper.update(null, updateWrapper);
        
        // 发送发货通知
        sendExchangeNotification(order.getUserId(), order.getGiftName(), order.getPointsCost(), orderId, "SHIPPED");
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void cancelOrder(Long orderId, String cancelReason) {
        BizExchangeOrder order = exchangeOrderMapper.selectById(orderId);
        if (order == null) {
            throw new ServiceException("订单不存在");
        }
        if ("COMPLETED".equals(order.getStatus()) || "CANCELLED".equals(order.getStatus())) {
            throw new ServiceException("当前订单状态不允许取消");
        }

        // 退还积分
        pointsService.awardPoints(order.getUserId(), "REFUND", order.getPointsCost(), "EXCHANGE_ORDER", order.getId());

        // 恢复库存
        LambdaUpdateWrapper<BizGift> giftUpdateWrapper = new LambdaUpdateWrapper<>();
        giftUpdateWrapper.eq(BizGift::getId, order.getGiftId())
                .setSql("stock = stock + " + order.getQuantity())
                .setSql("exchange_count = exchange_count - " + order.getQuantity());
        giftMapper.update(null, giftUpdateWrapper);

        // 更新订单状态
        LambdaUpdateWrapper<BizExchangeOrder> updateWrapper = new LambdaUpdateWrapper<>();
        updateWrapper.eq(BizExchangeOrder::getId, orderId)
                .set(BizExchangeOrder::getStatus, "CANCELLED")
                .set(BizExchangeOrder::getCancelReason, cancelReason)
                .set(BizExchangeOrder::getCancelledAt, LocalDateTime.now());
        exchangeOrderMapper.update(null, updateWrapper);
        
        // 发送取消通知
        sendExchangeNotification(order.getUserId(), order.getGiftName(), order.getPointsCost(), orderId, "CANCELLED");
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void confirmReceive(Long orderId, Long userId) {
        BizExchangeOrder order = exchangeOrderMapper.selectById(orderId);
        if (order == null) {
            throw new ServiceException("订单不存在");
        }
        if (!userId.equals(order.getUserId())) {
            throw new ServiceException("无权操作此订单");
        }
        if (!"SHIPPED".equals(order.getStatus())) {
            throw new ServiceException("当前订单状态不允许确认收货");
        }

        LambdaUpdateWrapper<BizExchangeOrder> updateWrapper = new LambdaUpdateWrapper<>();
        updateWrapper.eq(BizExchangeOrder::getId, orderId)
                .set(BizExchangeOrder::getStatus, "COMPLETED")
                .set(BizExchangeOrder::getCompletedAt, LocalDateTime.now());
        exchangeOrderMapper.update(null, updateWrapper);
    }

    /**
     * 生成订单号
     */
    private String generateOrderNo() {
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        String uuid = UUID.randomUUID().toString().replace("-", "").substring(0, 8).toUpperCase();
        return "EX" + timestamp + uuid;
    }
}
