package cn.zhangchuangla.system.lostfound.mapper;

import cn.zhangchuangla.system.lostfound.model.entity.BizReport;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;
import java.time.LocalDateTime;

/**
 * 举报 Mapper
 *
 * @author Chuang
 */
public interface BizReportMapper extends BaseMapper<BizReport> {

    /**
     * 管理员查询举报列表（带关联信息）
     */
    Page<BizReport> selectAdminReportsWithDetail(Page<BizReport> page, @Param("targetType") String targetType, @Param("status") String status,
                                                 @Param("targetId") Long targetId,
                                                 @Param("resolveAction") String resolveAction,
                                                 @Param("startTime") LocalDateTime startTime,
                                                 @Param("endTime") LocalDateTime endTime);
}
