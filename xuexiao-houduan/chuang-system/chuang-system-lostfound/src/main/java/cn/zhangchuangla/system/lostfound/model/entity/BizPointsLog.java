package cn.zhangchuangla.system.lostfound.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

import java.time.LocalDateTime;

/**
 * 积分流水实体
 *
 * @author Chuang
 */
@TableName("biz_points_log")
@Data
@Schema(name = "积分流水实体")
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BizPointsLog {

    @TableId(type = IdType.AUTO)
    @Schema(description = "流水ID")
    private Long id;

    @Schema(description = "用户ID")
    private Long userId;

    @Schema(description = "动作类型")
    private String action;

    @Schema(description = "积分变化")
    private Integer delta;

    @Schema(description = "变化后余额")
    private Integer balance;

    @Schema(description = "关联类型")
    private String relatedType;

    @Schema(description = "关联ID")
    private Long relatedId;

    @Schema(description = "备注")
    private String remark;

    @Schema(description = "操作人")
    private Long createBy;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;
}
