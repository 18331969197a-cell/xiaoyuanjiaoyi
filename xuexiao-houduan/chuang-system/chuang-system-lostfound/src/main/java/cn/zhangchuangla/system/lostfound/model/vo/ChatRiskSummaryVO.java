package cn.zhangchuangla.system.lostfound.model.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 聊天对象风险摘要
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(name = "聊天对象风险摘要")
public class ChatRiskSummaryVO {

    @Schema(description = "目标用户ID")
    private Long targetUserId;

    @Schema(description = "是否存在风险")
    private Boolean risky;

    @Schema(description = "风险等级：LOW/MEDIUM/HIGH")
    private String riskLevel;

    @Schema(description = "风险等级（中文）")
    private String riskLevelText;

    @Schema(description = "风险记录总数")
    private Integer totalCount;

    @Schema(description = "未处理风险数")
    private Integer openCount;

    @Schema(description = "最近风险类型")
    private String latestRiskType;

    @Schema(description = "最近风险类型（中文）")
    private String latestRiskTypeText;

    @Schema(description = "最近处置动作")
    private String latestActionType;

    @Schema(description = "最近处置动作（中文）")
    private String latestActionTypeText;

    @Schema(description = "最近风险状态")
    private String latestEventStatus;

    @Schema(description = "最近风险状态（中文）")
    private String latestEventStatusText;

    @Schema(description = "最近风险时间")
    private LocalDateTime latestEventTime;

    @Schema(description = "展示给用户的风险提示")
    private String hint;
}
