package cn.zhangchuangla.system.lostfound.model.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.util.Date;

/**
 * 用户积分VO（管理员查看）
 *
 * @author Chuang
 */
@Data
@Schema(description = "用户积分VO")
public class UserPointsVO {

    @Schema(description = "用户ID")
    private Long userId;

    @Schema(description = "用户名")
    private String userName;

    @Schema(description = "昵称")
    private String nickname;

    @Schema(description = "总积分")
    private Integer totalPoints;

    @Schema(description = "可用积分")
    private Integer availablePoints;

    @Schema(description = "已使用积分")
    private Integer usedPoints;

    @Schema(description = "等级")
    private Integer level;

    @Schema(description = "注册时间")
    private Date createTime;
}
