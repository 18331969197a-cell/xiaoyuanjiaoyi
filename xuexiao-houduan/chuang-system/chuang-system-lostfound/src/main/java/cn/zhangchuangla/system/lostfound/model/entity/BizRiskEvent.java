package cn.zhangchuangla.system.lostfound.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

import java.time.LocalDateTime;

/**
 * 风险事件实体
 */
@TableName("biz_risk_event")
@Data
@Schema(name = "风险事件实体")
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BizRiskEvent {

    @TableId(type = IdType.AUTO)
    @Schema(description = "事件ID")
    private Long id;

    @Schema(description = "来源类型：REPORT/HANDOVER")
    private String sourceType;

    @Schema(description = "来源ID")
    private Long sourceId;

    @Schema(description = "关联举报ID")
    private Long reportId;

    @Schema(description = "目标类型")
    private String targetType;

    @Schema(description = "目标ID")
    private Long targetId;

    @Schema(description = "风险类型")
    private String riskType;

    @Schema(description = "处置动作")
    private String actionType;

    @Schema(description = "事件状态：OPEN/RESOLVED")
    private String eventStatus;

    @Schema(description = "权限范围类型：GLOBAL/DEPT")
    private String scopeType;

    @Schema(description = "权限范围ID")
    private Long scopeId;

    @Schema(description = "备注")
    private String remark;

    @Schema(description = "处理人")
    private Long resolvedBy;

    @Schema(description = "处理时间")
    private LocalDateTime resolvedAt;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

    @Schema(description = "更新时间")
    private LocalDateTime updateTime;

    @TableField(exist = false)
    @Schema(description = "举报人")
    private String reporterName;

    @TableField(exist = false)
    @Schema(description = "处理人名称")
    private String resolverName;

    @TableField(exist = false)
    @Schema(description = "举报原因")
    private String reportReasonDetail;
}

