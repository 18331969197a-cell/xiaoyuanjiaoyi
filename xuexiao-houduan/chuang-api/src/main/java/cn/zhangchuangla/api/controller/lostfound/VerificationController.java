package cn.zhangchuangla.api.controller.lostfound;

import cn.zhangchuangla.common.core.base.BaseController;
import cn.zhangchuangla.common.core.entity.base.AjaxResult;
import cn.zhangchuangla.system.lostfound.model.vo.VerificationRequest;
import cn.zhangchuangla.system.lostfound.model.vo.VerificationStatus;
import cn.zhangchuangla.system.lostfound.service.VerificationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

/**
 * 身份认证控制器
 *
 * @author Chuang
 */
@Tag(name = "身份认证")
@RestController
@RequestMapping("/lostfound/verification")
@RequiredArgsConstructor
public class VerificationController extends BaseController {

    private final VerificationService verificationService;

    @Operation(summary = "提交身份认证")
    @PostMapping("/verify")
    public AjaxResult<VerificationStatus> verify(@RequestBody @Validated VerificationRequest request) {
        VerificationStatus result = verificationService.verify(getUserId(), request);
        if (result.getVerified()) {
            return AjaxResult.success("认证成功", result);
        } else {
            return AjaxResult.error(result.getMessage());
        }
    }

    @Operation(summary = "获取认证状态")
    @GetMapping("/status")
    public AjaxResult<VerificationStatus> getStatus() {
        return AjaxResult.success(verificationService.getVerificationStatus(getUserId()));
    }

    @Operation(summary = "检查是否已认证")
    @GetMapping("/check")
    public AjaxResult<Boolean> checkVerified() {
        return AjaxResult.success(verificationService.isVerified(getUserId()));
    }
}
