package cn.zhangchuangla.system.lostfound.model.entity;

import cn.zhangchuangla.system.lostfound.enums.HandoverStatusEnum;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

import java.time.LocalDateTime;

/**
 * 交接记录实体
 *
 * @author Chuang
 */
@TableName("biz_handover")
@Data
@Schema(name = "交接记录实体")
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BizHandover {

    @TableId(type = IdType.AUTO)
    @Schema(description = "交接ID")
    private Long id;

    @Schema(description = "认领单ID")
    private Long claimId;

    @Schema(description = "交出方用户ID")
    private Long fromUserId;

    @Schema(description = "接收方用户ID")
    private Long toUserId;

    @Schema(description = "交接地点")
    private String location;

    @Schema(description = "约定交接时间")
    private LocalDateTime handoverTime;

    @Schema(description = "状态")
    private HandoverStatusEnum status;

    @Schema(description = "交出方确认时间")
    private LocalDateTime confirmedByFromAt;

    @Schema(description = "接收方确认时间")
    private LocalDateTime confirmedByToAt;

    @Schema(description = "备注")
    private String remark;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

    @Schema(description = "更新时间")
    private LocalDateTime updateTime;

    // ========== 非数据库字段 ==========

    @TableField(exist = false)
    @Schema(description = "交出方用户名")
    private String fromUserName;

    @TableField(exist = false)
    @Schema(description = "接收方用户名")
    private String toUserName;
}
