package cn.zhangchuangla.system.lostfound.service.impl;

import cn.zhangchuangla.common.core.exception.BusinessException;
import cn.zhangchuangla.common.core.exception.ErrorCode;
import cn.zhangchuangla.system.lostfound.mapper.BizGiftMapper;
import cn.zhangchuangla.system.lostfound.model.entity.BizGift;
import cn.zhangchuangla.system.lostfound.service.GiftService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 礼品服务实现
 *
 * @author Chuang
 */
@Service
@RequiredArgsConstructor
public class GiftServiceImpl implements GiftService {

    private final BizGiftMapper giftMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createGift(BizGift gift, Long userId) {
        if (gift.getName() == null || gift.getName().trim().isEmpty()) {
            throw new BusinessException(ErrorCode.PARAM_ERROR, "礼品名称不能为空");
        }
        if (gift.getPointsCost() == null || gift.getPointsCost() <= 0) {
            throw new BusinessException(ErrorCode.PARAM_ERROR, "所需积分必须大于0");
        }
        if (gift.getStock() == null) {
            gift.setStock(0);
        }
        if (gift.getGiftType() == null) {
            gift.setGiftType("PHYSICAL");
        }
        if (gift.getStatus() == null) {
            gift.setStatus("ON");
        }
        if (gift.getExchangeCount() == null) {
            gift.setExchangeCount(0);
        }
        if (gift.getSort() == null) {
            gift.setSort(0);
        }
        gift.setCreatedBy(userId);
        giftMapper.insert(gift);
        return gift.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateGift(BizGift gift) {
        giftMapper.updateById(gift);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteGift(Long id) {
        giftMapper.deleteById(id);
    }

    @Override
    public BizGift getGiftById(Long id) {
        return giftMapper.selectById(id);
    }

    @Override
    public Page<BizGift> listGiftsForUser(Page<BizGift> page, Long categoryId, String keyword) {
        LambdaQueryWrapper<BizGift> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(BizGift::getStatus, "ON");
        if (categoryId != null) {
            wrapper.eq(BizGift::getCategoryId, categoryId);
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            wrapper.like(BizGift::getName, keyword.trim());
        }
        wrapper.orderByAsc(BizGift::getSort);
        wrapper.orderByDesc(BizGift::getCreatedAt);
        return giftMapper.selectPage(page, wrapper);
    }

    @Override
    public Page<BizGift> listGiftsForAdmin(Page<BizGift> page, Long categoryId, String status, String keyword) {
        LambdaQueryWrapper<BizGift> wrapper = new LambdaQueryWrapper<>();
        if (categoryId != null) {
            wrapper.eq(BizGift::getCategoryId, categoryId);
        }
        if (status != null && !status.trim().isEmpty()) {
            wrapper.eq(BizGift::getStatus, status);
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            wrapper.like(BizGift::getName, keyword.trim());
        }
        wrapper.orderByAsc(BizGift::getSort);
        wrapper.orderByDesc(BizGift::getCreatedAt);
        return giftMapper.selectPage(page, wrapper);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateStatus(Long id, String status) {
        BizGift gift = new BizGift();
        gift.setId(id);
        gift.setStatus(status);
        giftMapper.updateById(gift);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean decreaseStock(Long giftId, Integer quantity) {
        int rows = giftMapper.decreaseStock(giftId, quantity);
        return rows > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void increaseExchangeCount(Long giftId, Integer quantity) {
        giftMapper.increaseExchangeCount(giftId, quantity);
    }

    @Override
    public boolean canExchange(Long giftId, Integer quantity) {
        BizGift gift = giftMapper.selectById(giftId);
        if (gift == null) {
            return false;
        }
        if (!"ON".equals(gift.getStatus())) {
            return false;
        }
        return gift.getStock() >= quantity;
    }
}
