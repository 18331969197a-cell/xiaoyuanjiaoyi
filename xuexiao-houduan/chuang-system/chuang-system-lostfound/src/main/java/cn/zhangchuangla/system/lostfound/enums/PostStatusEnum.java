package cn.zhangchuangla.system.lostfound.enums;

import com.baomidou.mybatisplus.annotation.EnumValue;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 帖子状态枚举
 *
 * @author Chuang
 */
@Getter
@AllArgsConstructor
public enum PostStatusEnum {

    DRAFT("DRAFT", "草稿"),
    PENDING("PENDING", "待审核"),
    PUBLISHED("PUBLISHED", "已发布"),
    CLAIMING("CLAIMING", "认领中"),
    CLOSED("CLOSED", "已结案"),
    REJECTED("REJECTED", "已拒绝"),
    OFFLINE("OFFLINE", "已下线");

    @EnumValue
    @JsonValue
    private final String code;
    private final String desc;
}
