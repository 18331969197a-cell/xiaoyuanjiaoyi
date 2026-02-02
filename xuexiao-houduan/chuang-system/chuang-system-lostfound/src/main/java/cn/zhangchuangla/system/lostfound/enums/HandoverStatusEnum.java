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
    CONFIRMED("CONFIRMED", "已确认");

    @EnumValue
    @JsonValue
    private final String code;
    private final String desc;
}
