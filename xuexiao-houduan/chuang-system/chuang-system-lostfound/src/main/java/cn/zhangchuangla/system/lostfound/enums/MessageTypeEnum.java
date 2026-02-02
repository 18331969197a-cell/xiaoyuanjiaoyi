package cn.zhangchuangla.system.lostfound.enums;

import com.baomidou.mybatisplus.annotation.EnumValue;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 消息类型枚举
 *
 * @author Chuang
 */
@Getter
@AllArgsConstructor
public enum MessageTypeEnum {

    TEXT("TEXT", "文本"),
    IMAGE("IMAGE", "图片"),
    SYSTEM("SYSTEM", "系统消息");

    @EnumValue
    @JsonValue
    private final String code;
    private final String desc;
}
