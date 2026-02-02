package cn.zhangchuangla.api.controller.lostfound;

import cn.zhangchuangla.common.core.base.BaseController;
import cn.zhangchuangla.common.core.entity.base.AjaxResult;
import cn.zhangchuangla.system.lostfound.model.entity.BizStudentRoster;
import cn.zhangchuangla.system.lostfound.model.vo.StudentRosterDTO;
import cn.zhangchuangla.system.lostfound.model.vo.VerificationRecordVO;
import cn.zhangchuangla.system.lostfound.service.VerificationService;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 身份认证管理控制器
 *
 * @author Chuang
 */
@Tag(name = "身份认证管理")
@RestController
@RequestMapping("/lostfound/admin/verification")
@RequiredArgsConstructor
public class VerificationAdminController extends BaseController {

    private final VerificationService verificationService;

    @Operation(summary = "查询学生名单列表")
    @GetMapping("/roster")
    @PreAuthorize("@ss.hasPermission('lostfound:verification:list')")
    public AjaxResult<Page<BizStudentRoster>> listRoster(
            @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize,
            @RequestParam(value = "keyword", required = false) String keyword) {
        Page<BizStudentRoster> page = new Page<>(pageNum, pageSize);
        return AjaxResult.success(verificationService.listStudentRoster(page, keyword));
    }

    @Operation(summary = "导入学生名单(Excel)")
    @PostMapping("/import")
    @PreAuthorize("@ss.hasPermission('lostfound:verification:import')")
    public AjaxResult<Map<String, Integer>> importStudentRoster(@RequestParam("file") MultipartFile file) {
        Map<String, Integer> result = verificationService.importStudentRosterFromExcel(file);
        return AjaxResult.success("导入成功", result);
    }

    @Operation(summary = "批量导入学生名单(JSON)")
    @PostMapping("/import/json")
    @PreAuthorize("@ss.hasPermission('lostfound:verification:import')")
    public AjaxResult<Integer> importStudentRosterJson(@RequestBody List<StudentRosterDTO> students) {
        int count = verificationService.importStudentRoster(students);
        return AjaxResult.success("成功导入 " + count + " 条学生数据", count);
    }

    @Operation(summary = "删除学生名单")
    @DeleteMapping("/roster/{id}")
    @PreAuthorize("@ss.hasPermission('lostfound:verification:delete')")
    public AjaxResult<?> deleteRoster(@PathVariable Long id) {
        verificationService.deleteStudentRoster(id);
        return AjaxResult.success("删除成功");
    }

    @Operation(summary = "查询认证记录")
    @GetMapping("/records")
    @PreAuthorize("@ss.hasPermission('lostfound:verification:list')")
    public AjaxResult<Page<VerificationRecordVO>> listRecords(
            @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize,
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "verified", required = false) Integer verified) {
        Page<VerificationRecordVO> page = new Page<>(pageNum, pageSize);
        return AjaxResult.success(verificationService.listVerificationRecords(page, keyword, verified));
    }

    @Operation(summary = "撤销用户认证")
    @PostMapping("/revoke/{userId}")
    @PreAuthorize("@ss.hasPermission('lostfound:verification:revoke')")
    public AjaxResult<?> revokeVerification(@PathVariable Long userId) {
        verificationService.revokeVerification(userId);
        return AjaxResult.success("撤销认证成功");
    }
}
