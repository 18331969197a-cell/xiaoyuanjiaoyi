package cn.zhangchuangla.system.lostfound.mapper;

import cn.zhangchuangla.system.lostfound.model.entity.BizPointsLog;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

/**
 * 积分流水 Mapper
 *
 * @author Chuang
 */
public interface BizPointsLogMapper extends BaseMapper<BizPointsLog> {

    /**
     * 统计用户累计获得积分
     */
    @Select("SELECT COALESCE(SUM(delta), 0) FROM biz_points_log WHERE user_id = #{userId} AND delta > 0")
    Integer sumEarnedPoints(@Param("userId") Long userId);

    /**
     * 统计用户累计消耗积分
     */
    @Select("SELECT COALESCE(ABS(SUM(delta)), 0) FROM biz_points_log WHERE user_id = #{userId} AND delta < 0")
    Integer sumSpentPoints(@Param("userId") Long userId);
}
