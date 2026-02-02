package cn.zhangchuangla.system.lostfound.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

import java.time.LocalDateTime;

/**
 * 互评实体
 *
 * @author Chuang
 */
@TableName("biz_evaluation")
@Data
@Schema(name = "互评实体")
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BizEvaluation {

    @TableId(type = IdType.AUTO)
    @Schema(description = "评价ID")
    private Long id;

    @Schema(description = "认领单ID")
    private Long claimId;

    @Schema(description = "交接记录ID（可选，用于前端传参）")
    @com.baomidou.mybatisplus.annotation.TableField(exist = false)
    private Long handoverId;

    @Schema(description = "评价人ID")
    private Long fromUserId;

    @Schema(description = "被评价人ID")
    private Long toUserId;

    @Schema(description = "评分：1-5")
    private Integer score;

    @Schema(description = "评价内容")
    private String content;

    @Schema(description = "评价时间")
    private LocalDateTime createTime;
}
