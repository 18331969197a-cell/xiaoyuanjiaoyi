package cn.zhangchuangla.system.lostfound.service;

import cn.zhangchuangla.system.lostfound.model.entity.BizExchangeOrder;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;

/**
 * 兑换订单服务接口
 *
 * @author Chuang
 */
public interface ExchangeOrderService {

    /**
     * 兑换礼品
     *
     * @param userId          用户ID
     * @param giftId          礼品ID
     * @param quantity        数量
     * @param receiverName    收货人姓名（实物礼品必填）
     * @param receiverPhone   收货人电话（实物礼品必填）
     * @param receiverAddress 收货地址（实物礼品必填）
     * @return 订单ID
     */
    Long exchangeGift(Long userId, Long giftId, Integer quantity,
                      String receiverName, String receiverPhone, String receiverAddress);

    /**
     * 获取用户兑换记录
     *
     * @param page   分页参数
     * @param userId 用户ID
     * @param status 订单状态（可选）
     * @return 订单列表
     */
    Page<BizExchangeOrder> listUserOrders(Page<BizExchangeOrder> page, Long userId, String status);

    /**
     * 获取订单详情
     *
     * @param orderId 订单ID
     * @param userId  用户ID（用于权限校验，管理员传null）
     * @return 订单详情
     */
    BizExchangeOrder getOrderById(Long orderId, Long userId);

    /**
     * 管理员获取订单列表
     *
     * @param page    分页参数
     * @param orderNo 订单号（可选）
     * @param status  订单状态（可选）
     * @param userId  用户ID（可选）
     * @return 订单列表
     */
    Page<BizExchangeOrder> listOrdersForAdmin(Page<BizExchangeOrder> page, String orderNo, String status, Long userId);

    /**
     * 发货
     *
     * @param orderId    订单ID
     * @param trackingNo 物流单号
     */
    void shipOrder(Long orderId, String trackingNo);

    /**
     * 取消订单（管理员）
     *
     * @param orderId      订单ID
     * @param cancelReason 取消原因
     */
    void cancelOrder(Long orderId, String cancelReason);

    /**
     * 用户确认收货
     *
     * @param orderId 订单ID
     * @param userId  用户ID
     */
    void confirmReceive(Long orderId, Long userId);
}
