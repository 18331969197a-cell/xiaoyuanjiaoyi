package cn.zhangchuangla.system.lostfound.model.entity;

import cn.zhangchuangla.common.core.entity.base.BaseEntity;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

import java.math.BigDecimal;
import java.util.List;

/**
 * 校园地点实体
 *
 * @author Chuang
 */
@EqualsAndHashCode(callSuper = true)
@TableName("biz_location")
@Data
@Schema(name = "校园地点实体")
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BizLocation extends BaseEntity {

    @TableId(type = IdType.AUTO)
    @Schema(description = "地点ID")
    private Long id;

    @Schema(description = "地点名称")
    private String name;

    @Schema(description = "父级ID")
    private Long parentId;

    @Schema(description = "类型：building-建筑，floor-楼层，room-房间，area-区域")
    private String type;

    @Schema(description = "经度")
    private BigDecimal lng;

    @Schema(description = "纬度")
    private BigDecimal lat;

    @Schema(description = "是否招领点：0-否，1-是")
    private Integer isPickupPoint;

    @Schema(description = "开放时间")
    private String openTime;

    @Schema(description = "联系方式")
    private String contact;

    @Schema(description = "详细地址")
    private String address;

    @Schema(description = "排序")
    private Integer sort;

    @Schema(description = "状态：0-禁用，1-启用")
    private Integer status;

    @TableLogic
    @Schema(description = "逻辑删除")
    private String isDeleted;

    @TableField(exist = false)
    @Schema(description = "子地点列表")
    private List<BizLocation> children;
}
