package cn.zhangchuangla.system.lostfound.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

import java.time.LocalDateTime;

/**
 * 学生名单实体
 *
 * @author Chuang
 */
@TableName("biz_student_roster")
@Data
@Schema(name = "学生名单实体")
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BizStudentRoster {

    @TableId(type = IdType.AUTO)
    @Schema(description = "主键ID")
    private Long id;

    @Schema(description = "学号")
    private String studentNo;

    @Schema(description = "真实姓名")
    private String realName;

    @Schema(description = "身份证后6位(加密存储)")
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

    @Schema(description = "已绑定的用户ID")
    private Long boundUserId;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

    @Schema(description = "更新时间")
    private LocalDateTime updateTime;
}
