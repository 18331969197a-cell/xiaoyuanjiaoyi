package cn.zhangchuangla.system.lostfound.model.entity;

import cn.zhangchuangla.system.lostfound.enums.ClaimStatusEnum;
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
 * 认领单实体
 *
 * @author Chuang
 */
@TableName(value = "biz_claim", autoResultMap = true)
@Data
@Schema(name = "认领单实体")
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BizClaim {

    @TableId(type = IdType.AUTO)
    @Schema(description = "认领ID")
    private Long id;

    @Schema(description = "帖子ID")
    private Long postId;

    @Schema(description = "认领人ID")
    private Long claimantId;

    @Schema(description = "发帖人ID")
    private Long posterId;

    @Schema(description = "佐证说明")
    private String proofText;

    @TableField(typeHandler = JacksonTypeHandler.class)
    @Schema(description = "佐证图片JSON数组")
    private List<String> proofImagesJson;

    @TableField(typeHandler = JacksonTypeHandler.class)
    @Schema(description = "失主补充的特征信息")
    private List<String> featureAnswers;

    @Schema(description = "自动匹配得分")
    private Integer autoMatchScore;

    @Schema(description = "悬赏发放时间（如有）")
    private LocalDateTime rewardPayAt;

    @Schema(description = "状态")
    private ClaimStatusEnum status;

    @Schema(description = "审核人")
    private Long reviewBy;

    @Schema(description = "审核时间")
    private LocalDateTime reviewAt;

    @Schema(description = "审核原因")
    private String reviewReason;

    @Schema(description = "完成时间")
    private LocalDateTime completedAt;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

    @Schema(description = "更新时间")
    private LocalDateTime updateTime;

    // ========== 非数据库字段 ==========

    @TableField(exist = false)
    @Schema(description = "帖子标题")
    private String postTitle;

    @TableField(exist = false)
    @Schema(description = "帖子类型")
    private String postType;

    @TableField(exist = false)
    @Schema(description = "认领人用户名")
    private String claimantName;

    @TableField(exist = false)
    @Schema(description = "发布者用户名")
    private String posterName;
}
