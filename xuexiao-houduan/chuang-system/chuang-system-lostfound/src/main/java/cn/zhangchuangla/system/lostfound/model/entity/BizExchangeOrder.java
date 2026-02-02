package cn.zhangchuangla.system.lostfound.model.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 兑换订单实体
 *
 * @author Chuang
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("biz_exchange_order")
public class BizExchangeOrder {

    /**
     * 主键ID
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 订单编号
     */
    private String orderNo;

    /**
     * 用户ID
     */
    private Long userId;

    /**
     * 礼品ID
     */
    private Long giftId;

    /**
     * 礼品名称(冗余)
     */
    private String giftName;

    /**
     * 礼品类型 PHYSICAL实物 VIRTUAL虚拟
     */
    private String giftType;

    /**
     * 消耗积分
     */
    private Integer pointsCost;

    /**
     * 兑换数量
     */
    private Integer quantity;

    /**
     * 订单状态 PENDING待发货 SHIPPED已发货 COMPLETED已完成 CANCELLED已取消
     */
    private String status;

    /**
     * 收货人姓名
     */
    private String receiverName;

    /**
     * 收货人电话
     */
    private String receiverPhone;

    /**
     * 收货地址
     */
    private String receiverAddress;

    /**
     * 物流单号
     */
    private String trackingNo;

    /**
     * 发货时间
     */
    private LocalDateTime shippedAt;

    /**
     * 虚拟礼品内容
     */
    private String virtualContent;

    /**
     * 完成时间
     */
    private LocalDateTime completedAt;

    /**
     * 取消时间
     */
    private LocalDateTime cancelledAt;

    /**
     * 取消原因
     */
    private String cancelReason;

    /**
     * 创建时间
     */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    /**
     * 更新时间
     */
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;
}
