package cn.zhangchuangla.system.core.service;

import cn.zhangchuangla.common.core.entity.base.BasePageRequest;
import cn.zhangchuangla.system.core.model.entity.SysSecurityLog;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * @author Chuang
 */
public interface SysSecurityLogService extends IService<SysSecurityLog> {

    /**
     * 获取用户安全日志
     *
     * @param userId 用户ID
     * @return 用户安全日志列表
     */
    Page<SysSecurityLog> getUserSecurityLog(Long userId, BasePageRequest request);

    /**
     * 管理端获取安全日志
     *
     * @param request 请求参数
     * @param operationType 操作类型
     * @param userId 用户ID
     * @return 安全日志列表
     */
    Page<SysSecurityLog> listSecurityLogs(BasePageRequest request, String operationType, Long userId,
                                          java.time.LocalDateTime startTime, java.time.LocalDateTime endTime);
}
