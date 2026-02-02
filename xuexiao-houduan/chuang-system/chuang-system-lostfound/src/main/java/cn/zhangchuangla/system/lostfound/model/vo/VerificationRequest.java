package cn.zhangchuangla.system.lostfound.model.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

/**
 * 身份认证请求
 *
 * @author Chuang
 */
@Data
@Schema(name = "身份认证请求")
public class VerificationRequest {

    @NotBlank(message = "学号不能为空")
    @Schema(description = "学号")
    private String studentNo;

    @NotBlank(message = "姓名不能为空")
    @Schema(description = "真实姓名")
    private String realName;

    @NotBlank(message = "身份证后6位不能为空")
    @Size(min = 6, max = 6, message = "身份证后6位格式不正确")
    @Schema(description = "身份证后6位")
    private String idCardSuffix;
}
