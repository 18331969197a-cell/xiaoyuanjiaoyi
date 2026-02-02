package cn.zhangchuangla.system.lostfound.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

import java.time.LocalDateTime;

/**
 * 收藏实体
 *
 * @author Chuang
 */
@TableName("biz_favorite")
@Data
@Schema(name = "收藏实体")
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BizFavorite {

    @TableId(type = IdType.AUTO)
    @Schema(description = "收藏ID")
    private Long id;

    @Schema(description = "用户ID")
    private Long userId;

    @Schema(description = "帖子ID")
    private Long postId;

    @Schema(description = "收藏时间")
    private LocalDateTime createTime;
}
