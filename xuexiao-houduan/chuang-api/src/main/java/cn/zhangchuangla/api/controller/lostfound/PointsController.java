package cn.zhangchuangla.api.controller.lostfound;

import cn.zhangchuangla.common.core.base.BaseController;
import cn.zhangchuangla.common.core.entity.base.AjaxResult;
import cn.zhangchuangla.system.lostfound.model.entity.BizPointsLog;
import cn.zhangchuangla.system.lostfound.model.vo.PointsInfoVO;
import cn.zhangchuangla.system.lostfound.model.vo.UserPointsVO;
import cn.zhangchuangla.system.lostfound.service.PointsService;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 积分控制器
 *
 * @author Chuang
 */
@Tag(name = "积分管理")
@RestController
@RequestMapping("/lostfound/points")
@RequiredArgsConstructor
public class PointsController extends BaseController {

    private final PointsService pointsService;

    @Operation(summary = "获取我的积分信息")
    @GetMapping("/my")
    public AjaxResult<PointsInfoVO> getMyPoints() {
        return AjaxResult.success(pointsService.getUserPointsInfo(getUserId()));
    }

    @Operation(summary = "获取积分记录")
    @GetMapping("/records")
    public AjaxResult<Page<BizPointsLog>> getRecords(
            @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize) {
        Page<BizPointsLog> page = new Page<>(pageNum, pageSize);
        return AjaxResult.success(pointsService.getPointsLogs(page, getUserId()));
    }

    @Operation(summary = "获取积分排行榜")
    @GetMapping("/ranking")
    public AjaxResult<?> getRanking(@RequestParam(value = "limit", defaultValue = "10") Integer limit) {
        return AjaxResult.success(pointsService.getPointsRanking(limit));
    }

    // ==================== 管理员接口 ====================

    @Operation(summary = "管理员-获取所有用户积分列表")
    @GetMapping("/admin/list")
    @PreAuthorize("@ss.hasPermission('lostfound:points:adjust')")
    public AjaxResult<Page<UserPointsVO>> adminGetUserPointsList(
            @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize,
            @RequestParam(value = "userName", required = false) String userName) {
        Page<UserPointsVO> page = new Page<>(pageNum, pageSize);
        return AjaxResult.success(pointsService.adminGetUserPointsList(page, userName));
    }

    @Operation(summary = "管理员-调整用户积分")
    @PostMapping("/admin/adjust")
    @PreAuthorize("@ss.hasPermission('lostfound:points:adjust')")
    public AjaxResult<?> adminAdjustPoints(@RequestBody Map<String, Object> params) {
        Long userId = Long.valueOf(params.get("userId").toString());
        Integer points = Integer.valueOf(params.get("points").toString());
        String reason = (String) params.get("reason");
        
        pointsService.adminAdjustPoints(userId, points, reason, getUserId());
        return AjaxResult.success("积分调整成功");
    }
}
