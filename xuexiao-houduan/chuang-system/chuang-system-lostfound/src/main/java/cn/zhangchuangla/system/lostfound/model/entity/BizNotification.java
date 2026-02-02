package cn.zhangchuangla.system.lostfound.model.entity;

import cn.zhangchuangla.system.lostfound.enums.NotificationTypeEnum;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

import java.time.LocalDateTime;

/**
 * 通知实体
 *
 * @author Chuang
 */
@TableName("biz_notification")
@Data
@Schema(name = "通知实体")
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BizNotification {

    @TableId(type = IdType.AUTO)
    @Schema(description = "通知ID")
    private Long id;

    @Schema(description = "接收用户ID")
    private Long userId;

    @Schema(description = "通知类型")
    private NotificationTypeEnum type;

    @Schema(description = "通知标题")
    private String title;

    @Schema(description = "通知内容")
    private String content;

    @Schema(description = "关联类型")
    private String relatedType;

    @Schema(description = "关联ID")
    private Long relatedId;

    @Schema(description = "是否已读")
    private Integer isRead;

    @Schema(description = "阅读时间")
    private LocalDateTime readAt;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;
}
