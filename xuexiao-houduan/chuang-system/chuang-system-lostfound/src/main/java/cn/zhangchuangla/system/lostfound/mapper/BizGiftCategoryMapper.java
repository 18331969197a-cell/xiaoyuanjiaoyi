package cn.zhangchuangla.system.lostfound.mapper;

import cn.zhangchuangla.system.lostfound.model.entity.BizGiftCategory;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;

/**
 * 礼品分类 Mapper
 *
 * @author Chuang
 */
public interface BizGiftCategoryMapper extends BaseMapper<BizGiftCategory> {

    /**
     * 统计分类下的礼品数量
     *
     * @param categoryId 分类ID
     * @return 礼品数量
     */
    Integer countGiftsByCategoryId(@Param("categoryId") Long categoryId);
}
