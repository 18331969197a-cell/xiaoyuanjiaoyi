package cn.zhangchuangla.system.lostfound.model.entity;

import cn.zhangchuangla.system.lostfound.enums.ReportStatusEnum;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 举报实体
 *
 * @author Chuang
 */
@TableName(value = "biz_report", autoResultMap = true)
@Data
@Schema(name = "举报实体")
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BizReport {

    @TableId(type = IdType.AUTO)
    @Schema(description = "举报ID")
    private Long id;

    @Schema(description = "举报人ID")
    private Long reporterId;

    @Schema(description = "举报目标类型：POST-帖子，COMMENT-评论，USER-用户")
    private String targetType;

    @Schema(description = "举报目标ID")
    private Long targetId;

    @Schema(description = "举报原因类型")
    private String reasonType;

    @Schema(description = "举报详情")
    private String reasonDetail;

    @TableField(typeHandler = JacksonTypeHandler.class)
    @Schema(description = "证据图片JSON数组")
    private List<String> evidenceImagesJson;

    @Schema(description = "状态")
    private ReportStatusEnum status;

    @Schema(description = "处理人")
    private Long resolveBy;

    @Schema(description = "处理时间")
    private LocalDateTime resolveAt;

    @Schema(description = "处理结果")
    private String resolveResult;

    @Schema(description = "处理动作")
    private String resolveAction;

    @Schema(description = "举报时间")
    private LocalDateTime createTime;

    @Schema(description = "更新时间")
    private LocalDateTime updateTime;

    // ========== 非数据库字段 ==========

    @TableField(exist = false)
    @Schema(description = "被举报内容标题")
    private String targetTitle;

    @TableField(exist = false)
    @Schema(description = "举报人用户名")
    private String reporterName;
}
