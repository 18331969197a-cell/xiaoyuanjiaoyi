package cn.zhangchuangla.system.lostfound.enums;

import com.baomidou.mybatisplus.annotation.EnumValue;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 交接状态枚举
 *
 * @author Chuang
 */
@Getter
@AllArgsConstructor
public enum HandoverStatusEnum {

    PENDING("PENDING", "待确认"),
    RESCHEDULED("RESCHEDULED", "已改约"),
    NO_SHOW("NO_SHOW", "爽约待处理"),
    DISPUTED("DISPUTED", "争议处理中"),
    CONFIRMED("CONFIRMED", "已确认"),
    CANCELLED("CANCELLED", "已取消");

    @EnumValue
    @JsonValue
    private final String code;
    private final String desc;
}
