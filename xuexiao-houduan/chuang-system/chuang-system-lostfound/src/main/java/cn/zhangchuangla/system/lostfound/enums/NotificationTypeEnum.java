package cn.zhangchuangla.system.lostfound.enums;

import com.baomidou.mybatisplus.annotation.EnumValue;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 通知类型枚举
 *
 * @author Chuang
 */
@Getter
@AllArgsConstructor
public enum NotificationTypeEnum {

    SYSTEM("SYSTEM", "系统通知"),
    AUDIT("AUDIT", "审核通知"),
    CLAIM("CLAIM", "认领通知"),
    REPORT("REPORT", "举报通知"),
    POINTS("POINTS", "积分通知"),
    VERIFICATION("VERIFICATION", "认证通知"),
    ANNOUNCEMENT("ANNOUNCEMENT", "公告通知"),
    COMMENT("COMMENT", "评论通知"),
    POST("POST", "帖子通知");

    @EnumValue
    @JsonValue
    private final String code;
    private final String desc;
}
