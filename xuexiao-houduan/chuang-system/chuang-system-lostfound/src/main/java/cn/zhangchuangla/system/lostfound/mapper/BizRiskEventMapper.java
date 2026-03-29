package cn.zhangchuangla.system.lostfound.mapper;

import cn.zhangchuangla.system.lostfound.model.entity.BizRiskEvent;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;

/**
 * 风险事件 Mapper
 */
public interface BizRiskEventMapper extends BaseMapper<BizRiskEvent> {

    BizRiskEvent selectBySource(@Param("sourceType") String sourceType, @Param("sourceId") Long sourceId);

    Page<BizRiskEvent> selectAdminRiskEvents(Page<BizRiskEvent> page,
                                             @Param("targetType") String targetType,
                                             @Param("targetId") Long targetId,
                                             @Param("eventStatus") String eventStatus,
                                             @Param("actionType") String actionType,
                                             @Param("startTime") LocalDateTime startTime,
                                             @Param("endTime") LocalDateTime endTime);
}

