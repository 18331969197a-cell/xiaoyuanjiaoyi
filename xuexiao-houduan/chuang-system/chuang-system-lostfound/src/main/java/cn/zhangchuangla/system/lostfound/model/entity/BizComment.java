package cn.zhangchuangla.system.lostfound.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

import java.time.LocalDateTime;

/**
 * 评论实体
 *
 * @author Chuang
 */
@TableName("biz_comment")
@Data
@Schema(name = "评论实体")
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BizComment {

    @TableId(type = IdType.AUTO)
    @Schema(description = "评论ID")
    private Long id;

    @Schema(description = "帖子ID")
    private Long postId;

    @Schema(description = "评论人ID")
    private Long userId;

    @Schema(description = "评论内容")
    private String content;

    @Schema(description = "状态：PENDING-待审核，PUBLISHED-已发布，REJECTED-已拒绝")
    private String status;

    @Schema(description = "评论时间")
    private LocalDateTime createTime;

    @Schema(description = "更新时间")
    private LocalDateTime updateTime;

    @TableLogic
    @Schema(description = "逻辑删除")
    private String isDeleted;

    // ========== 非数据库字段 ==========

    @TableField(exist = false)
    @Schema(description = "评论人用户名")
    private String userName;

    @TableField(exist = false)
    @Schema(description = "帖子标题")
    private String postTitle;
}
