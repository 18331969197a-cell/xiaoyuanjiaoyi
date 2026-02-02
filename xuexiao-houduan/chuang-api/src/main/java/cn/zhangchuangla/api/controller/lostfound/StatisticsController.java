package cn.zhangchuangla.api.controller.lostfound;

import cn.zhangchuangla.common.core.base.BaseController;
import cn.zhangchuangla.common.core.entity.base.AjaxResult;
import cn.zhangchuangla.system.lostfound.service.StatisticsService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 统计控制器
 *
 * @author Chuang
 */
@Tag(name = "统计管理")
@RestController
@RequestMapping("/lostfound/statistics")
@RequiredArgsConstructor
public class StatisticsController extends BaseController {

    private final StatisticsService statisticsService;

    @Operation(summary = "获取首页统计数据")
    @GetMapping("/home")
    public AjaxResult<Map<String, Object>> getHomeStatistics() {
        return AjaxResult.success(statisticsService.getHomeStatistics());
    }

    @Operation(summary = "获取我的统计数据")
    @GetMapping("/my")
    public AjaxResult<Map<String, Object>> getMyStatistics() {
        return AjaxResult.success(statisticsService.getUserStatistics(getUserId()));
    }

    // ========== 管理端接口 ==========
    // TODO: 生产环境需要添加权限校验 @PreAuthorize("hasAuthority('lostfound:statistics:view')")
    // 权限SQL脚本见: sql/lostfound_menu_permission.sql

    @Operation(summary = "获取管理端统计概览")
    @GetMapping("/admin/overview")
    @PreAuthorize("@ss.hasPermission('lostfound:stats:view') or @ss.hasPermission('lostfound:statistics:view')")
    public AjaxResult<Map<String, Object>> getAdminOverview() {
        return AjaxResult.success(statisticsService.getAdminOverview());
    }

    @Operation(summary = "获取帖子趋势统计")
    @GetMapping("/admin/post-trend")
    @PreAuthorize("@ss.hasPermission('lostfound:stats:view') or @ss.hasPermission('lostfound:statistics:view')")
    public AjaxResult<?> getPostTrend(
            @RequestParam(value = "days", defaultValue = "7") Integer days) {
        return AjaxResult.success(statisticsService.getPostTrend(days));
    }

    @Operation(summary = "获取分类统计")
    @GetMapping("/admin/category-stats")
    @PreAuthorize("@ss.hasPermission('lostfound:stats:view') or @ss.hasPermission('lostfound:statistics:view')")
    public AjaxResult<?> getCategoryStats() {
        return AjaxResult.success(statisticsService.getCategoryStats());
    }

    @Operation(summary = "获取地点统计")
    @GetMapping("/admin/location-stats")
    @PreAuthorize("@ss.hasPermission('lostfound:stats:view') or @ss.hasPermission('lostfound:statistics:view')")
    public AjaxResult<?> getLocationStats() {
        return AjaxResult.success(statisticsService.getLocationStats());
    }

    @Operation(summary = "获取认领成功率统计")
    @GetMapping("/admin/claim-success-rate")
    @PreAuthorize("@ss.hasPermission('lostfound:stats:view') or @ss.hasPermission('lostfound:statistics:view')")
    public AjaxResult<?> getClaimSuccessRate() {
        return AjaxResult.success(statisticsService.getClaimSuccessRate());
    }

    @Operation(summary = "获取统计概览（带时间范围）")
    @GetMapping("/admin/overview-stats")
    @PreAuthorize("@ss.hasPermission('lostfound:stats:view') or @ss.hasPermission('lostfound:statistics:view')")
    public AjaxResult<?> getOverviewStats(
            @RequestParam(value = "startDate", required = false) String startDate,
            @RequestParam(value = "endDate", required = false) String endDate,
            @RequestParam(value = "type", required = false) String type) {
        return AjaxResult.success(statisticsService.getOverviewStats(startDate, endDate, type));
    }

    @Operation(summary = "获取找回趋势统计")
    @GetMapping("/admin/recovery-stats")
    @PreAuthorize("@ss.hasPermission('lostfound:stats:view') or @ss.hasPermission('lostfound:statistics:view')")
    public AjaxResult<?> getRecoveryStats(
            @RequestParam(value = "startDate", required = false) String startDate,
            @RequestParam(value = "endDate", required = false) String endDate,
            @RequestParam(value = "type", required = false) String type) {
        return AjaxResult.success(statisticsService.getRecoveryStats(startDate, endDate, type));
    }

    @Operation(summary = "获取分类统计（带时间范围）")
    @GetMapping("/admin/category-stats-detail")
    @PreAuthorize("@ss.hasPermission('lostfound:stats:view') or @ss.hasPermission('lostfound:statistics:view')")
    public AjaxResult<?> getCategoryStatsWithParams(
            @RequestParam(value = "startDate", required = false) String startDate,
            @RequestParam(value = "endDate", required = false) String endDate) {
        return AjaxResult.success(statisticsService.getCategoryStatsWithParams(startDate, endDate));
    }

    @Operation(summary = "获取地点统计（带时间范围）")
    @GetMapping("/admin/location-stats-detail")
    @PreAuthorize("@ss.hasPermission('lostfound:stats:view') or @ss.hasPermission('lostfound:statistics:view')")
    public AjaxResult<?> getLocationStatsWithParams(
            @RequestParam(value = "startDate", required = false) String startDate,
            @RequestParam(value = "endDate", required = false) String endDate) {
        return AjaxResult.success(statisticsService.getLocationStatsWithParams(startDate, endDate));
    }

    @Operation(summary = "导出统计报表")
    @GetMapping("/admin/export")
    @PreAuthorize("@ss.hasPermission('lostfound:stats:view') or @ss.hasPermission('lostfound:statistics:view')")
    public AjaxResult<?> exportStats(
            @RequestParam(value = "startDate", required = false) String startDate,
            @RequestParam(value = "endDate", required = false) String endDate,
            @RequestParam(value = "type", required = false) String type) {
        return AjaxResult.success(statisticsService.exportStatsData(startDate, endDate, type));
    }
}
