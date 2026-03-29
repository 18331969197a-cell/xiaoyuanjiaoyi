package cn.zhangchuangla.api.controller.lostfound;

import cn.zhangchuangla.common.core.base.BaseController;
import cn.zhangchuangla.common.core.entity.base.AjaxResult;
import cn.zhangchuangla.framework.annotation.OperationLog;
import cn.zhangchuangla.system.lostfound.model.entity.BizReport;
import cn.zhangchuangla.system.lostfound.service.ReportService;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;

/**
 * 举报控制器
 *
 * @author Chuang
 */
@Tag(name = "举报管理")
@RestController
@RequestMapping("/lostfound/report")
@RequiredArgsConstructor
public class ReportController extends BaseController {

    private final ReportService reportService;

    @Operation(summary = "提交举报")
    @PostMapping
    @OperationLog(title = "提交举报")
    public AjaxResult<Long> create(@RequestBody BizReport report) {
        return AjaxResult.success(reportService.createReport(report, getUserId()));
    }

    @Operation(summary = "获取我的举报")
    @GetMapping("/my")
    public AjaxResult<Page<BizReport>> getMyReports(
            @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize) {
        Page<BizReport> page = new Page<>(pageNum, pageSize);
        return AjaxResult.success(reportService.getUserReports(page, getUserId()));
    }

    // ========== 管理端接口 ==========

    @Operation(summary = "获取举报列表")
    @GetMapping("/admin/list")
    @PreAuthorize("@ss.hasPermission('lostfound:report:list') || @ss.hasPermission('lostfound:risk-alert:list')")
    public AjaxResult<Page<BizReport>> adminList(
            @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize,
            @RequestParam(value = "targetType", required = false) String targetType,
            @RequestParam(value = "targetId", required = false) Long targetId,
            @RequestParam(value = "status", required = false) String status,
            @RequestParam(value = "resolveAction", required = false) String resolveAction,
            @RequestParam(value = "startTime", required = false)
            @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime startTime,
            @RequestParam(value = "endTime", required = false)
            @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime endTime) {
        Page<BizReport> page = new Page<>(pageNum, pageSize);
        return AjaxResult.success(reportService.listReports(page, targetType, targetId, status, resolveAction, startTime, endTime));
    }

    @Operation(summary = "处理举报")
    @PostMapping("/admin/{id}/handle")
    @PreAuthorize("@ss.hasPermission('lostfound:report:handle')")
    @OperationLog(title = "处理举报")
    public AjaxResult<Void> handle(@PathVariable("id") Long id,
                                   @RequestParam(value = "result") String result,
                                   @RequestParam(value = "action", required = false) String action) {
        reportService.handleReport(id, result, action, getUserId());
        return AjaxResult.success();
    }

    @Operation(summary = "处理举报（通过）")
    @PostMapping("/admin/{id}/resolve")
    @PreAuthorize("@ss.hasPermission('lostfound:report:handle')")
    @OperationLog(title = "处理举报")
    public AjaxResult<Void> resolve(@PathVariable("id") Long id,
                                    @RequestParam(value = "action", required = false) String action,
                                    @RequestParam(value = "remark", required = false) String remark) {
        reportService.resolveReport(id, remark, action, getUserId());
        return AjaxResult.success();
    }

    @Operation(summary = "驳回举报")
    @PostMapping("/admin/{id}/reject")
    @PreAuthorize("@ss.hasPermission('lostfound:report:handle')")
    @OperationLog(title = "驳回举报")
    public AjaxResult<Void> reject(@PathVariable("id") Long id,
                                   @RequestParam(value = "reason", required = false) String reason) {
        reportService.rejectReport(id, reason, getUserId());
        return AjaxResult.success();
    }

    @Operation(summary = "获取举报详情")
    @GetMapping("/admin/{id}")
    @PreAuthorize("@ss.hasPermission('lostfound:report:list')")
    public AjaxResult<BizReport> getById(@PathVariable("id") Long id) {
        return AjaxResult.success(reportService.getReportById(id));
    }
}
