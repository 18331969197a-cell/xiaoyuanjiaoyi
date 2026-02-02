package cn.zhangchuangla.system.lostfound.enums;

import com.baomidou.mybatisplus.annotation.EnumValue;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 举报状态枚举
 *
 * @author Chuang
 */
@Getter
@AllArgsConstructor
public enum ReportStatusEnum {

    PENDING("PENDING", "待处理"),
    RESOLVED("RESOLVED", "已处理"),
    REJECTED("REJECTED", "已驳回");

    @EnumValue
    @JsonValue
    private final String code;
    private final String desc;
}
