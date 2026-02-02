package cn.zhangchuangla.api.controller.lostfound;

import cn.zhangchuangla.common.core.base.BaseController;
import cn.zhangchuangla.common.core.entity.base.AjaxResult;
import cn.zhangchuangla.framework.annotation.OperationLog;
import cn.zhangchuangla.system.lostfound.model.entity.BizHandover;
import cn.zhangchuangla.system.lostfound.service.HandoverService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

/**
 * 交接控制器
 *
 * @author Chuang
 */
@Tag(name = "交接管理")
@RestController
@RequestMapping("/lostfound/handover")
@RequiredArgsConstructor
public class HandoverController extends BaseController {

    private final HandoverService handoverService;

    @Operation(summary = "创建交接")
    @PostMapping
    @OperationLog(title = "创建交接")
    public AjaxResult<Long> create(@RequestBody BizHandover handover) {
        return AjaxResult.success(handoverService.createHandover(handover, getUserId()));
    }

    @Operation(summary = "确认交接")
    @PostMapping("/{id}/confirm")
    @OperationLog(title = "确认交接")
    public AjaxResult<Void> confirm(@PathVariable("id") Long id) {
        handoverService.confirmHandover(id, getUserId());
        return AjaxResult.success();
    }

    @Operation(summary = "获取交接详情")
    @GetMapping("/{id}")
    public AjaxResult<BizHandover> getById(@PathVariable("id") Long id) {
        return AjaxResult.success(handoverService.getHandoverById(id));
    }

    @Operation(summary = "根据认领ID获取交接")
    @GetMapping("/claim/{claimId}")
    public AjaxResult<BizHandover> getByClaimId(@PathVariable("claimId") Long claimId) {
        return AjaxResult.success(handoverService.getHandoverByClaimId(claimId));
    }
}
