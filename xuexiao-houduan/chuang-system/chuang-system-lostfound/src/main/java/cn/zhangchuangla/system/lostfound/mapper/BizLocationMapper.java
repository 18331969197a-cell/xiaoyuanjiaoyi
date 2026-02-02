package cn.zhangchuangla.system.lostfound.mapper;

import cn.zhangchuangla.system.lostfound.model.entity.BizLocation;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;

/**
 * 校园地点 Mapper
 *
 * @author Chuang
 */
public interface BizLocationMapper extends BaseMapper<BizLocation> {

    /**
     * 统计地点下的帖子数量
     *
     * @param locationId 地点ID
     * @return 帖子数量
     */
    Integer countPostsByLocationId(@Param("locationId") Long locationId);
}
