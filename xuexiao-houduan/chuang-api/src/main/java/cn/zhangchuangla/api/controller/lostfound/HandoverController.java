package cn.zhangchuangla.api.controller.lostfound;

import cn.zhangchuangla.common.core.base.BaseController;
import cn.zhangchuangla.common.core.entity.base.AjaxResult;
import cn.zhangchuangla.framework.annotation.OperationLog;
import cn.zhangchuangla.system.lostfound.model.entity.BizHandover;
import cn.zhangchuangla.system.lostfound.service.HandoverService;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
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

    @Operation(summary = "取消交接")
    @PostMapping("/{id}/cancel")
    @OperationLog(title = "取消交接")
    public AjaxResult<Void> cancel(@PathVariable("id") Long id,
                                   @RequestParam(value = "reason", required = false) String reason) {
        handoverService.cancelHandover(id, reason, getUserId());
        return AjaxResult.success();
    }

    @Operation(summary = "提交线下完成回传")
    @PostMapping("/{id}/receipt")
    @OperationLog(title = "提交线下回传")
    public AjaxResult<Void> submitReceipt(@PathVariable("id") Long id, @RequestBody BizHandover handover) {
        handoverService.submitReceipt(id, handover, getUserId());
        return AjaxResult.success();
    }

    @Operation(summary = "确认线下回传")
    @PostMapping("/{id}/receipt/confirm")
    @OperationLog(title = "确认线下回传")
    public AjaxResult<Void> confirmReceipt(@PathVariable("id") Long id) {
        handoverService.confirmReceipt(id, getUserId());
        return AjaxResult.success();
    }

    @Operation(summary = "改约")
    @PostMapping("/{id}/reschedule")
    @OperationLog(title = "交接改约")
    public AjaxResult<Void> reschedule(@PathVariable("id") Long id,
                                       @RequestBody BizHandover handover,
                                       @RequestParam(value = "reason", required = false) String reason) {
        handoverService.reschedule(id, handover, reason, getUserId());
        return AjaxResult.success();
    }

    @Operation(summary = "上报争议")
    @PostMapping("/{id}/dispute")
    @OperationLog(title = "交接争议上报")
    public AjaxResult<Void> dispute(@PathVariable("id") Long id,
                                    @RequestParam(value = "reason", required = false) String reason) {
        handoverService.raiseDispute(id, reason, getUserId());
        return AjaxResult.success();
    }

    @Operation(summary = "上报爽约")
    @PostMapping("/{id}/no-show")
    @OperationLog(title = "交接爽约上报")
    public AjaxResult<Void> noShow(@PathVariable("id") Long id,
                                   @RequestParam(value = "reason", required = false) String reason) {
        handoverService.markNoShow(id, reason, getUserId());
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

    @Operation(summary = "获取我的交接记录")
    @GetMapping("/my")
    public AjaxResult<Page<BizHandover>> myHandovers(
            @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize,
            @RequestParam(value = "status", required = false) String status) {
        Page<BizHandover> page = new Page<>(pageNum, pageSize);
        return AjaxResult.success(handoverService.getMyHandovers(page, getUserId(), status));
    }
}
