package cn.zhangchuangla.system.lostfound.enums;

import com.baomidou.mybatisplus.annotation.EnumValue;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 帖子类型枚举
 *
 * @author Chuang
 */
@Getter
@AllArgsConstructor
public enum PostTypeEnum {

    LOST("LOST", "寻物"),
    FOUND("FOUND", "招领");

    @EnumValue
    @JsonValue
    private final String code;
    private final String desc;
}
