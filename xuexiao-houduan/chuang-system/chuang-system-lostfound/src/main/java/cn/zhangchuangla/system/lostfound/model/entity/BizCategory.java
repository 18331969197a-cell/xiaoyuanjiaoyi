package cn.zhangchuangla.system.lostfound.model.entity;

import cn.zhangchuangla.common.core.entity.base.BaseEntity;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

import java.util.List;

/**
 * 物品分类实体
 *
 * @author Chuang
 */
@EqualsAndHashCode(callSuper = true)
@TableName("biz_category")
@Data
@Schema(name = "物品分类实体")
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BizCategory extends BaseEntity {

    @TableId(type = IdType.AUTO)
    @Schema(description = "分类ID")
    private Long id;

    @Schema(description = "分类名称")
    private String name;

    @Schema(description = "父级ID")
    private Long parentId;

    @Schema(description = "图标")
    private String icon;

    @Schema(description = "排序")
    private Integer sort;

    @Schema(description = "状态：0-禁用，1-启用")
    private Integer status;

    @TableLogic
    @Schema(description = "逻辑删除")
    private String isDeleted;

    @TableField(exist = false)
    @Schema(description = "子分类列表")
    private List<BizCategory> children;
}
