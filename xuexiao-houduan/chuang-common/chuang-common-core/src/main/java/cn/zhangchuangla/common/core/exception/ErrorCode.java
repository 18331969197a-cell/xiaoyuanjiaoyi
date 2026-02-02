package cn.zhangchuangla.common.core.exception;

import lombok.Getter;

/**
 * 错误码枚举
 * 
 * @author Chuang
 */
@Getter
public enum ErrorCode {

    // 通用错误 1000-1999
    SUCCESS(0, "操作成功"),
    BUSINESS_ERROR(1000, "业务处理失败"),
    PARAM_ERROR(1001, "参数错误"),
    DATA_NOT_FOUND(1002, "数据不存在"),
    DATA_ALREADY_EXISTS(1003, "数据已存在"),
    OPERATION_NOT_ALLOWED(1004, "操作不允许"),
    
    // 用户相关 2000-2999
    USER_NOT_FOUND(2001, "用户不存在"),
    USER_NOT_VERIFIED(2002, "用户未完成身份认证"),
    USER_ALREADY_VERIFIED(2003, "用户已完成身份认证"),
    STUDENT_NO_BOUND(2004, "学号已被其他用户绑定"),
    VERIFICATION_FAILED(2005, "身份认证失败"),
    
    // 帖子相关 3000-3999
    POST_NOT_FOUND(3001, "帖子不存在"),
    POST_NO_PERMISSION(3002, "无权操作此帖子"),
    POST_STATUS_ERROR(3003, "帖子状态不允许此操作"),
    POST_SENSITIVE_CONTENT(3004, "内容包含敏感信息"),
    
    // 认领相关 4000-4999
    CLAIM_NOT_FOUND(4001, "认领单不存在"),
    CLAIM_NO_PERMISSION(4002, "无权操作此认领单"),
    CLAIM_STATUS_ERROR(4003, "认领单状态不允许此操作"),
    CLAIM_ALREADY_EXISTS(4004, "已提交过认领申请"),
    
    // 积分相关 5000-5999
    POINTS_NOT_ENOUGH(5001, "积分不足"),
    POINTS_DEDUCT_FAILED(5002, "积分扣减失败"),
    
    // 礼品相关 6000-6999
    GIFT_NOT_FOUND(6001, "礼品不存在"),
    GIFT_OFFLINE(6002, "礼品已下架"),
    GIFT_STOCK_NOT_ENOUGH(6003, "礼品库存不足"),
    GIFT_EXCHANGE_FAILED(6004, "兑换失败"),
    
    // 订单相关 7000-7999
    ORDER_NOT_FOUND(7001, "订单不存在"),
    ORDER_NO_PERMISSION(7002, "无权操作此订单"),
    ORDER_STATUS_ERROR(7003, "订单状态不允许此操作"),
    
    // 文件相关 8000-8999
    FILE_UPLOAD_FAILED(8001, "文件上传失败"),
    FILE_TYPE_NOT_ALLOWED(8002, "文件类型不允许"),
    FILE_SIZE_EXCEEDED(8003, "文件大小超出限制"),
    FILE_CONTENT_INVALID(8004, "文件内容无效"),
    
    // 系统错误 9000-9999
    SYSTEM_ERROR(9000, "系统错误"),
    SYSTEM_BUSY(9001, "系统繁忙，请稍后重试");

    private final int code;
    private final String message;

    ErrorCode(int code, String message) {
        this.code = code;
        this.message = message;
    }
}
