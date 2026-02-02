package cn.zhangchuangla.api.controller.lostfound;

import cn.zhangchuangla.common.core.base.BaseController;
import cn.zhangchuangla.common.core.entity.base.AjaxResult;
import cn.zhangchuangla.framework.annotation.OperationLog;
import cn.zhangchuangla.system.lostfound.model.entity.BizEvaluation;
import cn.zhangchuangla.system.lostfound.service.EvaluationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 评价控制器
 *
 * @author Chuang
 */
@Tag(name = "评价管理")
@RestController
@RequestMapping("/lostfound/evaluation")
@RequiredArgsConstructor
public class EvaluationController extends BaseController {

    private final EvaluationService evaluationService;

    @Operation(summary = "提交评价")
    @PostMapping
    @OperationLog(title = "提交评价")
    public AjaxResult<Long> create(@RequestBody BizEvaluation evaluation) {
        return AjaxResult.success(evaluationService.createEvaluation(evaluation, getUserId()));
    }

    @Operation(summary = "获取认领单的评价")
    @GetMapping("/claim/{claimId}")
    public AjaxResult<List<BizEvaluation>> getByClaimId(@PathVariable Long claimId) {
        return AjaxResult.success(evaluationService.getEvaluationsByClaimId(claimId));
    }

    @Operation(summary = "检查是否已评价")
    @GetMapping("/claim/{claimId}/check")
    public AjaxResult<Boolean> hasEvaluated(@PathVariable Long claimId) {
        return AjaxResult.success(evaluationService.hasEvaluated(claimId, getUserId()));
    }
}
