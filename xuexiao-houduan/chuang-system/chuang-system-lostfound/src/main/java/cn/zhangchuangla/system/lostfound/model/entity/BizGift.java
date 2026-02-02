package cn.zhangchuangla.system.lostfound.model.entity;

import com.baomidou.mybatisplus.annotation.*;
import com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 礼品实体
 *
 * @author Chuang
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName(value = "biz_gift", autoResultMap = true)
public class BizGift {

    /**
     * 主键ID
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 分类ID
     */
    private Long categoryId;

    /**
     * 礼品名称
     */
    private String name;

    /**
     * 礼品描述
     */
    private String description;

    /**
     * 礼品图片
     */
    @TableField(typeHandler = JacksonTypeHandler.class)
    private List<String> imagesJson;

    /**
     * 所需积分
     */
    private Integer pointsCost;

    /**
     * 库存数量
     */
    private Integer stock;

    /**
     * 礼品类型 PHYSICAL实物 VIRTUAL虚拟
     */
    private String giftType;

    /**
     * 虚拟礼品内容
     */
    private String virtualContent;

    /**
     * 上架状态 ON上架 OFF下架
     */
    private String status;

    /**
     * 已兑换数量
     */
    private Integer exchangeCount;

    /**
     * 排序
     */
    private Integer sort;

    /**
     * 创建人
     */
    private Long createdBy;

    /**
     * 创建时间
     */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    /**
     * 更新时间
     */
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;

    /**
     * 逻辑删除 0未删除 1已删除
     */
    @TableLogic
    private Integer deleted;
    
    /**
     * 乐观锁版本号
     */
    @Version
    private Integer version;
}
