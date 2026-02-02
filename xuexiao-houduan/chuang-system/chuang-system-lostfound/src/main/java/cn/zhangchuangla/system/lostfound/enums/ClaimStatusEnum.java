package cn.zhangchuangla.system.lostfound.enums;

import com.baomidou.mybatisplus.annotation.EnumValue;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 认领状态枚举
 *
 * @author Chuang
 */
@Getter
@AllArgsConstructor
public enum ClaimStatusEnum {

    APPLIED("APPLIED", "已提交"),
    IN_CHAT("IN_CHAT", "沟通中"),
    NEED_PROOF("NEED_PROOF", "需补充佐证"),
    APPROVED("APPROVED", "已通过"),
    IN_HANDOVER("IN_HANDOVER", "交接中"),
    REJECTED("REJECTED", "已拒绝"),
    CANCELLED("CANCELLED", "已取消"),
    COMPLETED("COMPLETED", "已完成");

    @EnumValue
    @JsonValue
    private final String code;
    private final String desc;
}
