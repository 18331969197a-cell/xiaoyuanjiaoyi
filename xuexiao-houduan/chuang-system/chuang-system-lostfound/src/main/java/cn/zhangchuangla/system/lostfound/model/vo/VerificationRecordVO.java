package cn.zhangchuangla.system.lostfound.model.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 认证记录VO
 *
 * @author Chuang
 */
@Data
@Schema(name = "认证记录VO")
public class VerificationRecordVO {

    @Schema(description = "用户ID")
    private Long userId;

    @Schema(description = "用户名")
    private String username;

    @Schema(description = "昵称")
    private String nickname;

    @Schema(description = "认证的学号")
    private String studentNo;

    @Schema(description = "真实姓名")
    private String realName;

    @Schema(description = "学院")
    private String college;

    @Schema(description = "专业")
    private String major;

    @Schema(description = "班级")
    private String className;

    @Schema(description = "认证状态(0未认证 1已认证)")
    private Integer verified;

    @Schema(description = "认证时间")
    private LocalDateTime verifiedTime;
}
