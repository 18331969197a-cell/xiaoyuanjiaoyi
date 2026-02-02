package cn.zhangchuangla.api.controller.lostfound;

import cn.zhangchuangla.common.core.base.BaseController;
import cn.zhangchuangla.common.core.entity.base.AjaxResult;
import cn.zhangchuangla.framework.annotation.OperationLog;
import cn.zhangchuangla.system.lostfound.enums.ClaimStatusEnum;
import cn.zhangchuangla.system.lostfound.model.entity.BizClaim;
import cn.zhangchuangla.system.lostfound.service.ClaimService;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 认领控制器
 *
 * @author Chuang
 */
@Tag(name = "认领管理")
@RestController
@RequestMapping("/lostfound/claim")
@RequiredArgsConstructor
public class ClaimController extends BaseController {

    private final ClaimService claimService;

    @Operation(summary = "发起认领")
    @PostMapping
    @OperationLog(title = "发起认领")
    public AjaxResult<Long> create(@RequestBody BizClaim claim) {
        return AjaxResult.success(claimService.createClaim(claim, getUserId()));
    }

    @Operation(summary = "补充佐证")
    @PutMapping("/{id}/proof")
    @OperationLog(title = "补充佐证")
    public AjaxResult<Void> appendProof(@PathVariable("id") Long id, @RequestBody BizClaim claim) {
        claimService.appendProof(id, claim.getProofText(), claim.getProofImagesJson(), getUserId());
        return AjaxResult.success();
    }

    @Operation(summary = "取消认领")
    @PostMapping("/{id}/cancel")
    @OperationLog(title = "取消认领")
    public AjaxResult<Void> cancel(@PathVariable("id") Long id) {
        claimService.cancelClaim(id, getUserId());
        return AjaxResult.success();
    }

    @Operation(summary = "同意认领")
    @PostMapping("/{id}/approve")
    @OperationLog(title = "同意认领")
    public AjaxResult<Void> approve(@PathVariable("id") Long id) {
        claimService.approveClaim(id, getUserId());
        return AjaxResult.success();
    }

    @Operation(summary = "拒绝认领")
    @PostMapping("/{id}/reject")
    @OperationLog(title = "拒绝认领")
    public AjaxResult<Void> reject(@PathVariable("id") Long id, @RequestParam(value = "reason") String reason) {
        claimService.rejectClaim(id, reason, getUserId());
        return AjaxResult.success();
    }

    @Operation(summary = "获取认领详情")
    @GetMapping("/{id}")
    public AjaxResult<BizClaim> getById(@PathVariable("id") Long id) {
        return AjaxResult.success(claimService.getClaimById(id));
    }

    @Operation(summary = "获取我发起的认领")
    @GetMapping("/my")
    public AjaxResult<Page<BizClaim>> getMyClaims(
            @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize,
            @RequestParam(value = "status", required = false) String status) {
        Page<BizClaim> page = new Page<>(pageNum, pageSize);
        ClaimStatusEnum statusEnum = status != null ? ClaimStatusEnum.valueOf(status) : null;
        return AjaxResult.success(claimService.getUserClaims(page, getUserId(), statusEnum));
    }

    @Operation(summary = "获取我收到的认领")
    @GetMapping("/received")
    public AjaxResult<Page<BizClaim>> getReceivedClaims(
            @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize,
            @RequestParam(value = "status", required = false) String status) {
        Page<BizClaim> page = new Page<>(pageNum, pageSize);
        ClaimStatusEnum statusEnum = status != null ? ClaimStatusEnum.valueOf(status) : null;
        return AjaxResult.success(claimService.getReceivedClaims(page, getUserId(), statusEnum));
    }

    @Operation(summary = "获取帖子的认领列表")
    @GetMapping("/post/{postId}")
    public AjaxResult<List<BizClaim>> getClaimsByPostId(@PathVariable("postId") Long postId) {
        return AjaxResult.success(claimService.getClaimsByPostId(postId));
    }

    // ========== 管理端接口 ==========

    @Operation(summary = "管理员获取认领列表")
    @GetMapping("/admin/list")
    @PreAuthorize("@ss.hasPermission('lostfound:claim:list')")
    public AjaxResult<Page<BizClaim>> adminList(
            @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize,
            @RequestParam(value = "status", required = false) String status) {
        Page<BizClaim> page = new Page<>(pageNum, pageSize);
        ClaimStatusEnum statusEnum = status != null && !status.isEmpty() ? ClaimStatusEnum.valueOf(status) : null;
        return AjaxResult.success(claimService.adminList(page, statusEnum));
    }

    @Operation(summary = "管理员审核通过认领")
    @PostMapping("/admin/{id}/approve")
    @PreAuthorize("@ss.hasPermission('lostfound:claim:audit')")
    @OperationLog(title = "管理员审核通过认领")
    public AjaxResult<Void> adminApprove(@PathVariable("id") Long id) {
        claimService.adminApproveClaim(id, getUserId());
        return AjaxResult.success();
    }

    @Operation(summary = "管理员拒绝认领")
    @PostMapping("/admin/{id}/reject")
    @PreAuthorize("@ss.hasPermission('lostfound:claim:audit')")
    @OperationLog(title = "管理员拒绝认领")
    public AjaxResult<Void> adminReject(@PathVariable("id") Long id, @RequestParam(value = "reason", required = false) String reason) {
        claimService.adminRejectClaim(id, reason, getUserId());
        return AjaxResult.success();
    }

    @Operation(summary = "管理员强制完成认领")
    @PostMapping("/admin/{id}/complete")
    @PreAuthorize("@ss.hasPermission('lostfound:claim:complete')")
    @OperationLog(title = "管理员强制完成认领")
    public AjaxResult<Void> adminComplete(@PathVariable("id") Long id) {
        claimService.completeClaim(id);
        return AjaxResult.success();
    }

    @Operation(summary = "线下确认悬赏发放")
    @PostMapping("/{id}/reward/paid")
    @OperationLog(title = "确认悬赏发放")
    public AjaxResult<Void> confirmRewardPaid(@PathVariable("id") Long id) {
        claimService.confirmRewardPaid(id, getUserId());
        return AjaxResult.success();
    }

    @Operation(summary = "线下悬赏退款（撤销托管）")
    @PostMapping("/{id}/reward/refund")
    @OperationLog(title = "悬赏退款")
    public AjaxResult<Void> refundReward(@PathVariable("id") Long id) {
        claimService.refundReward(id, getUserId());
        return AjaxResult.success();
    }
}
