package cn.zhangchuangla.system.lostfound.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

import java.time.LocalDateTime;

/**
 * 消息会话实体
 *
 * @author Chuang
 */
@TableName("biz_msg_thread")
@Data
@Schema(name = "消息会话实体")
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BizMsgThread {

    @TableId(type = IdType.AUTO)
    @Schema(description = "会话ID")
    private Long id;

    @Schema(description = "关联帖子ID")
    private Long postId;

    @Schema(description = "关联认领单ID")
    private Long claimId;

    @Schema(description = "用户A ID")
    private Long userAId;

    @Schema(description = "用户B ID")
    private Long userBId;

    @Schema(description = "最后一条消息ID")
    private Long lastMessageId;

    @Schema(description = "最后消息时间")
    private LocalDateTime lastMessageTime;

    @Schema(description = "用户A未读数")
    private Integer userAUnread;

    @Schema(description = "用户B未读数")
    private Integer userBUnread;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

    @Schema(description = "更新时间")
    private LocalDateTime updateTime;

    // ========== 非持久化字段 ==========

    @TableField(exist = false)
    @Schema(description = "对方用户ID")
    private Long targetUserId;

    @TableField(exist = false)
    @Schema(description = "对方用户名")
    private String targetUserName;

    @TableField(exist = false)
    @Schema(description = "对方用户头像")
    private String targetUserAvatar;

    @TableField(exist = false)
    @Schema(description = "当前用户未读数")
    private Integer unreadCount;

    @TableField(exist = false)
    @Schema(description = "最后消息内容")
    private String lastMessageContent;

    @TableField(exist = false)
    @Schema(description = "帖子标题")
    private String postTitle;
}
