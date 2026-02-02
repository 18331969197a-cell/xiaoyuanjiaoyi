package cn.zhangchuangla.system.lostfound.model.entity;

import cn.zhangchuangla.common.core.entity.base.BaseEntity;
import cn.zhangchuangla.system.lostfound.enums.PostStatusEnum;
import cn.zhangchuangla.system.lostfound.enums.PostTypeEnum;
import cn.zhangchuangla.system.lostfound.enums.RewardStatusEnum;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler;
import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 帖子实体
 *
 * @author Chuang
 */
@EqualsAndHashCode(callSuper = true)
@TableName(value = "biz_post", autoResultMap = true)
@Data
@Schema(name = "帖子实体")
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BizPost extends BaseEntity {

    @TableId(type = IdType.AUTO)
    @Schema(description = "帖子ID")
    private Long id;

    @Schema(description = "类型：LOST-寻物，FOUND-招领")
    private PostTypeEnum postType;

    @Schema(description = "标题")
    private String title;

    @Schema(description = "描述")
    private String description;

    @Schema(description = "分类ID")
    private Long categoryId;

    @Schema(description = "地点ID")
    private Long locationId;

    @Schema(description = "详细地点描述")
    private String locationDetail;

    @Schema(description = "丢失/拾到时间")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm")
    private LocalDateTime occurTime;

    @Schema(description = "暂存地点（招领）")
    private String storagePlace;

    @Schema(description = "领取截止时间（招领）")
    private LocalDateTime deadlineTime;

    @TableField(typeHandler = JacksonTypeHandler.class)
    @Schema(description = "图片JSON数组")
    private List<String> imagesJson;

    @Schema(description = "悬赏金额（托管）")
    private BigDecimal rewardAmount;

    @Schema(description = "悬赏状态")
    private RewardStatusEnum rewardStatus;

    @Schema(description = "悬赏备注/说明")
    private String rewardDesc;

    @TableField(typeHandler = JacksonTypeHandler.class)
    @Schema(description = "拾得者提供的部分特征")
    private List<String> featureTokens;

    @Schema(description = "状态")
    private PostStatusEnum status;

    @Schema(description = "浏览量")
    private Integer viewCount;

    @Schema(description = "收藏数")
    private Integer favCount;

    @Schema(description = "评论数")
    private Integer commentCount;

    @Schema(description = "是否置顶")
    private Boolean isTop;

    @Schema(description = "是否推荐")
    private Boolean isRecommend;

    @Schema(description = "审核人")
    private Long auditBy;

    @Schema(description = "审核时间")
    private LocalDateTime auditAt;

    @Schema(description = "审核原因")
    private String auditReason;

    @Schema(description = "联系方式")
    private String contactInfo;

    @Schema(description = "发布人")
    private Long createdBy;

    @TableLogic
    @Schema(description = "逻辑删除")
    private String isDeleted;

    // ========== 非数据库字段 ==========

    @TableField(exist = false)
    @Schema(description = "分类名称")
    private String categoryName;

    @TableField(exist = false)
    @Schema(description = "地点名称")
    private String locationName;

    @TableField(exist = false)
    @Schema(description = "发布人名称")
    private String createdByName;
}
