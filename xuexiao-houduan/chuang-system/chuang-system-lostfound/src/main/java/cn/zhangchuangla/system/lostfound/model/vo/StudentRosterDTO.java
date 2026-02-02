package cn.zhangchuangla.system.lostfound.model.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import jakarta.validation.constraints.NotBlank;

/**
 * 学生名单导入DTO
 *
 * @author Chuang
 */
@Data
@Schema(name = "学生名单导入DTO")
public class StudentRosterDTO {

    @NotBlank(message = "学号不能为空")
    @Schema(description = "学号")
    private String studentNo;

    @NotBlank(message = "姓名不能为空")
    @Schema(description = "真实姓名")
    private String realName;

    @NotBlank(message = "身份证后6位不能为空")
    @Schema(description = "身份证后6位")
    private String idCardSuffix;

    @Schema(description = "学院")
    private String college;

    @Schema(description = "专业")
    private String major;

    @Schema(description = "班级")
    private String className;

    @Schema(description = "入学年份")
    private Integer enrollmentYear;

    @Schema(description = "状态(1在校 2毕业 3休学)")
    private Integer status;
}
