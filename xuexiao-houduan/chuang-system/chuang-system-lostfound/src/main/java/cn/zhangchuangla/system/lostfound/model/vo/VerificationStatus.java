package cn.zhangchuangla.system.lostfound.model.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 认证状态响应
 *
 * @author Chuang
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(name = "认证状态响应")
public class VerificationStatus {

    @Schema(description = "是否已认证")
    private Boolean verified;

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

    @Schema(description = "认证时间")
    private LocalDateTime verifiedTime;

    @Schema(description = "提示信息")
    private String message;
}
