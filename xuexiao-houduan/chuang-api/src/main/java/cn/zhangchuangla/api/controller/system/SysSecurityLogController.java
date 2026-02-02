package cn.zhangchuangla.api.controller.system;

import cn.zhangchuangla.common.core.base.BaseController;
import cn.zhangchuangla.common.core.entity.base.AjaxResult;
import cn.zhangchuangla.common.core.entity.base.BasePageRequest;
import cn.zhangchuangla.system.core.model.entity.SysSecurityLog;
import cn.zhangchuangla.system.core.service.SysSecurityLogService;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springdoc.core.annotations.ParameterObject;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;

/**
 * 安全日志管理
 *
 * @author Chuang
 */
@Tag(name = "安全日志管理", description = "管理端安全日志查询")
@RestController
@RequiredArgsConstructor
@RequestMapping("/system/security-log")
public class SysSecurityLogController extends BaseController {

    private final SysSecurityLogService sysSecurityLogService;

    @Operation(summary = "获取安全日志列表")
    @GetMapping("/admin/list")
    @PreAuthorize("@ss.hasPermission('system:security-log:list')")
    public AjaxResult<Page<SysSecurityLog>> listSecurityLogs(
            @ParameterObject BasePageRequest request,
            @Parameter(description = "操作类型") @RequestParam(value = "operationType", required = false) String operationType,
            @Parameter(description = "用户ID") @RequestParam(value = "userId", required = false) Long userId,
            @Parameter(description = "开始时间") @RequestParam(value = "startTime", required = false)
            @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime startTime,
            @Parameter(description = "结束时间") @RequestParam(value = "endTime", required = false)
            @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime endTime) {
        Page<SysSecurityLog> page = sysSecurityLogService.listSecurityLogs(request, operationType, userId, startTime, endTime);
        return AjaxResult.success(page);
    }
}
