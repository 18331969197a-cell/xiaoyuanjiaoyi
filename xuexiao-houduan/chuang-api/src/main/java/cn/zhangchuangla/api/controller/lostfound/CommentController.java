package cn.zhangchuangla.api.controller.lostfound;

import cn.zhangchuangla.common.core.base.BaseController;
import cn.zhangchuangla.common.core.entity.base.AjaxResult;
import cn.zhangchuangla.framework.annotation.OperationLog;
import cn.zhangchuangla.system.lostfound.model.entity.BizComment;
import cn.zhangchuangla.system.lostfound.service.CommentService;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

/**
 * 评论控制器
 *
 * @author Chuang
 */
@Tag(name = "评论管理")
@RestController
@RequestMapping("/lostfound/comment")
@RequiredArgsConstructor
public class CommentController extends BaseController {

    private final CommentService commentService;

    @Operation(summary = "发表评论")
    @PostMapping
    @OperationLog(title = "发表评论")
    public AjaxResult<Long> create(@RequestBody BizComment comment) {
        return AjaxResult.success(commentService.createComment(comment, getUserId()));
    }

    @Operation(summary = "删除评论")
    @DeleteMapping("/{id}")
    @OperationLog(title = "删除评论")
    public AjaxResult<Void> delete(@PathVariable("id") Long id) {
        commentService.deleteComment(id, getUserId());
        return AjaxResult.success();
    }

    @Operation(summary = "获取帖子评论列表")
    @GetMapping("/post/{postId}")
    public AjaxResult<Page<BizComment>> getPostComments(
            @PathVariable("postId") Long postId,
            @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "20") Integer pageSize) {
        Page<BizComment> page = new Page<>(pageNum, pageSize);
        return AjaxResult.success(commentService.getPostComments(page, postId));
    }

    // ========== 管理端接口 ==========

    @Operation(summary = "管理员获取评论列表")
    @GetMapping("/admin/list")
    @PreAuthorize("@ss.hasPermission('lostfound:comment:list')")
    public AjaxResult<Page<BizComment>> adminList(
            @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize,
            @RequestParam(value = "status", required = false) Integer status) {
        Page<BizComment> page = new Page<>(pageNum, pageSize);
        return AjaxResult.success(commentService.adminList(page, status));
    }

    @Operation(summary = "管理员删除评论")
    @DeleteMapping("/admin/{id}")
    @PreAuthorize("@ss.hasPermission('lostfound:comment:delete')")
    @OperationLog(title = "管理员删除评论")
    public AjaxResult<Void> adminDelete(@PathVariable("id") Long id) {
        commentService.adminDelete(id);
        return AjaxResult.success();
    }

    @Operation(summary = "审核通过评论")
    @PostMapping("/admin/{id}/approve")
    @PreAuthorize("@ss.hasPermission('lostfound:comment:audit')")
    @OperationLog(title = "审核通过评论")
    public AjaxResult<Void> approve(@PathVariable("id") Long id) {
        commentService.approve(id);
        return AjaxResult.success();
    }

    @Operation(summary = "审核拒绝评论")
    @PostMapping("/admin/{id}/reject")
    @PreAuthorize("@ss.hasPermission('lostfound:comment:audit')")
    @OperationLog(title = "审核拒绝评论")
    public AjaxResult<Void> reject(@PathVariable("id") Long id) {
        commentService.reject(id);
        return AjaxResult.success();
    }
}
