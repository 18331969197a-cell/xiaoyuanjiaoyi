package cn.zhangchuangla.api.controller.lostfound;

import cn.zhangchuangla.common.core.base.BaseController;
import cn.zhangchuangla.common.core.entity.base.AjaxResult;
import cn.zhangchuangla.framework.annotation.OperationLog;
import cn.zhangchuangla.system.lostfound.model.entity.BizRiskEvent;
import cn.zhangchuangla.system.lostfound.service.RiskEventService;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;

/**
 * 风险事件控制器
 */
@Tag(name = "风险事件管理")
@RestController
@RequestMapping("/lostfound/risk-event")
@RequiredArgsConstructor
public class RiskEventController extends BaseController {

    private final RiskEventService riskEventService;

    @Operation(summary = "获取风险事件列表")
    @GetMapping("/admin/list")
    @PreAuthorize("@ss.hasPermission('lostfound:risk-alert:list')")
    public AjaxResult<Page<BizRiskEvent>> adminList(
            @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize,
            @RequestParam(value = "targetType", required = false) String targetType,
            @RequestParam(value = "targetId", required = false) Long targetId,
            @RequestParam(value = "eventStatus", required = false) String eventStatus,
            @RequestParam(value = "actionType", required = false) String actionType,
            @RequestParam(value = "startTime", required = false)
            @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime startTime,
            @RequestParam(value = "endTime", required = false)
            @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime endTime) {
        Page<BizRiskEvent> page = new Page<>(pageNum, pageSize);
        return AjaxResult.success(
                riskEventService.listAdminEvents(page, targetType, targetId, eventStatus, actionType, startTime, endTime)
        );
    }

    @Operation(summary = "处理风险事件")
    @PostMapping("/admin/{id}/resolve")
    @PreAuthorize("@ss.hasPermission('lostfound:risk-alert:list')")
    @OperationLog(title = "处理风险告警")
    public AjaxResult<Void> resolve(@PathVariable("id") Long id,
                                    @RequestParam(value = "actionType", required = false) String actionType,
                                    @RequestParam(value = "remark", required = false) String remark) {
        riskEventService.resolveAdminEvent(id, actionType, remark, getUserId());
        return AjaxResult.success();
    }
}

