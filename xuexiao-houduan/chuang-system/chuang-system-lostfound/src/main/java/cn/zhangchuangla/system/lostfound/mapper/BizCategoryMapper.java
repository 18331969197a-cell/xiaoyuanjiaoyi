package cn.zhangchuangla.system.lostfound.mapper;

import cn.zhangchuangla.system.lostfound.model.entity.BizCategory;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;

/**
 * 物品分类 Mapper
 *
 * @author Chuang
 */
public interface BizCategoryMapper extends BaseMapper<BizCategory> {

    /**
     * 统计分类下的帖子数量
     *
     * @param categoryId 分类ID
     * @return 帖子数量
     */
    Integer countPostsByCategoryId(@Param("categoryId") Long categoryId);
}
