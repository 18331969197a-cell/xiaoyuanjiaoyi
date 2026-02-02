package cn.zhangchuangla.system.lostfound.enums;

import com.baomidou.mybatisplus.annotation.EnumValue;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 悬赏托管状态
 */
@Getter
@AllArgsConstructor
public enum RewardStatusEnum {
    NONE("NONE", "无悬赏"),
    HOLD("HOLD", "托管中"),
    PAID("PAID", "已发放"),
    REFUND("REFUND", "已退款");

    @EnumValue
    @JsonValue
    private final String code;
    private final String desc;
}
