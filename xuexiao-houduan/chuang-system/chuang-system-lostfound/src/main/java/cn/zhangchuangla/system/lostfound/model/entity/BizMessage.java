package cn.zhangchuangla.system.lostfound.model.entity;

import cn.zhangchuangla.system.lostfound.enums.MessageTypeEnum;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

import java.time.LocalDateTime;

/**
 * 消息实体
 *
 * @author Chuang
 */
@TableName("biz_message")
@Data
@Schema(name = "消息实体")
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BizMessage {

    @TableId(type = IdType.AUTO)
    @Schema(description = "消息ID")
    private Long id;

    @Schema(description = "会话ID")
    private Long threadId;

    @Schema(description = "发送者ID")
    private Long senderId;

    @Schema(description = "接收者ID")
    private Long receiverId;

    @Schema(description = "消息类型")
    private MessageTypeEnum msgType;

    @Schema(description = "消息内容")
    private String content;

    @Schema(description = "图片URL")
    private String imageUrl;

    @Schema(description = "已读时间")
    private LocalDateTime readAt;

    @Schema(description = "发送时间")
    private LocalDateTime createTime;

    // ========== 非持久化字段 ==========

    @TableField(exist = false)
    @Schema(description = "发送者用户名")
    private String senderName;

    @TableField(exist = false)
    @Schema(description = "发送者头像")
    private String senderAvatar;
}
