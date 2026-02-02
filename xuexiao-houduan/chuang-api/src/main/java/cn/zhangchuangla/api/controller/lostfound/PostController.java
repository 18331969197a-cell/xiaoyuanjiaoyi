package cn.zhangchuangla.api.controller.lostfound;

import cn.zhangchuangla.common.core.base.BaseController;
import cn.zhangchuangla.common.core.entity.base.AjaxResult;
import cn.zhangchuangla.framework.annotation.OperationLog;
import cn.zhangchuangla.system.lostfound.enums.PostStatusEnum;
import cn.zhangchuangla.system.lostfound.enums.PostTypeEnum;
import cn.zhangchuangla.system.lostfound.model.entity.BizPost;
import cn.zhangchuangla.system.lostfound.service.PostService;
import cn.zhangchuangla.system.lostfound.service.SearchService;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 帖子控制器
 *
 * @author Chuang
 */
@Tag(name = "帖子管理")
@RestController("lostfoundPostController")
@RequestMapping("/lostfound/post")
@RequiredArgsConstructor
public class PostController extends BaseController {

    private final PostService postService;
    private final SearchService searchService;

    @Operation(summary = "发布帖子")
    @PostMapping
    @OperationLog(title = "发布帖子")
    public AjaxResult<Long> create(@RequestBody BizPost post) {
        return AjaxResult.success(postService.createPost(post, getUserId()));
    }

    @Operation(summary = "更新帖子")
    @PutMapping
    @OperationLog(title = "更新帖子")
    public AjaxResult<Void> update(@RequestBody BizPost post) {
        postService.updatePost(post, getUserId());
        return AjaxResult.success();
    }

    @Operation(summary = "保存草稿")
    @PostMapping("/draft")
    @OperationLog(title = "保存草稿")
    public AjaxResult<Long> saveDraft(@RequestBody BizPost post) {
        return AjaxResult.success(postService.saveDraft(post, getUserId()));
    }

    @Operation(summary = "提交草稿审核")
    @PostMapping("/draft/{id}/submit")
    @OperationLog(title = "提交草稿审核")
    public AjaxResult<Void> submitDraft(@PathVariable("id") Long id) {
        postService.submitDraft(id, getUserId());
        return AjaxResult.success();
    }

    @Operation(summary = "删除帖子")
    @DeleteMapping("/{id}")
    @OperationLog(title = "删除帖子")
    public AjaxResult<Void> delete(@PathVariable("id") Long id) {
        postService.deletePost(id, getUserId());
        return AjaxResult.success();
    }

    @Operation(summary = "获取帖子详情")
    @GetMapping("/{id}")
    public AjaxResult<BizPost> getById(@PathVariable("id") Long id) {
        postService.incrementViewCount(id);
        return AjaxResult.success(postService.getPostById(id));
    }

    @Operation(summary = "分页查询帖子列表")
    @GetMapping("/list")
    public AjaxResult<Page<BizPost>> list(
            @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize,
            @RequestParam(value = "postType", required = false) String postType,
            @RequestParam(value = "categoryId", required = false) Long categoryId,
            @RequestParam(value = "locationId", required = false) Long locationId,
            @RequestParam(value = "keyword", required = false) String keyword) {
        Page<BizPost> page = new Page<>(pageNum, pageSize);
        PostTypeEnum type = null;
        if (postType != null && !postType.isEmpty()) {
            try {
                type = PostTypeEnum.valueOf(postType.toUpperCase());
            } catch (IllegalArgumentException e) {
                // 忽略无效的类型参数
            }
        }
        return AjaxResult.success(postService.queryPostList(page, type, PostStatusEnum.PUBLISHED, categoryId, locationId, keyword));
    }

    @Operation(summary = "搜索帖子")
    @GetMapping("/search")
    public AjaxResult<Page<BizPost>> search(
            @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize,
            @RequestParam(value = "keyword") String keyword) {
        Page<BizPost> page = new Page<>(pageNum, pageSize);
        // 记录搜索关键词
        searchService.recordSearch(keyword);
        return AjaxResult.success(postService.searchPosts(page, keyword));
    }

    @Operation(summary = "获取热门搜索词")
    @GetMapping("/hot-search")
    public AjaxResult<List<String>> getHotSearch(
            @RequestParam(value = "limit", defaultValue = "10") Integer limit) {
        return AjaxResult.success(searchService.getHotSearchKeywords(limit));
    }

    @Operation(summary = "获取我的帖子")
    @GetMapping("/my")
    public AjaxResult<Page<BizPost>> getMyPosts(
            @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize,
            @RequestParam(value = "status", required = false) String status,
            @RequestParam(value = "postType", required = false) String postType) {
        Page<BizPost> page = new Page<>(pageNum, pageSize);
        PostStatusEnum statusEnum = null;
        if (status != null && !status.isEmpty()) {
            try {
                statusEnum = PostStatusEnum.valueOf(status.toUpperCase());
            } catch (IllegalArgumentException e) {
                // 忽略无效的状态参数
            }
        }
        PostTypeEnum typeEnum = null;
        if (postType != null && !postType.isEmpty()) {
            try {
                typeEnum = PostTypeEnum.valueOf(postType.toUpperCase());
            } catch (IllegalArgumentException e) {
                // 忽略无效的类型参数
            }
        }
        return AjaxResult.success(postService.getUserPosts(page, getUserId(), statusEnum, typeEnum));
    }

    @Operation(summary = "获取我的草稿")
    @GetMapping("/my/drafts")
    public AjaxResult<List<BizPost>> getMyDrafts() {
        return AjaxResult.success(postService.getUserDrafts(getUserId()));
    }

    // ========== 管理端接口 ==========

    @Operation(summary = "审核通过")
    @PostMapping("/{id}/approve")
    @PreAuthorize("@ss.hasPermission('lostfound:post:audit')")
    @OperationLog(title = "审核通过帖子")
    public AjaxResult<Void> approve(@PathVariable("id") Long id) {
        postService.approve(id, getUserId());
        return AjaxResult.success();
    }

    @Operation(summary = "审核拒绝")
    @PostMapping("/{id}/reject")
    @PreAuthorize("@ss.hasPermission('lostfound:post:audit')")
    @OperationLog(title = "审核拒绝帖子")
    public AjaxResult<Void> reject(@PathVariable("id") Long id, @RequestParam(value = "reason") String reason) {
        postService.reject(id, reason, getUserId());
        return AjaxResult.success();
    }

    @Operation(summary = "下架帖子")
    @PostMapping("/{id}/offline")
    @PreAuthorize("@ss.hasPermission('lostfound:post:audit')")
    @OperationLog(title = "下架帖子")
    public AjaxResult<Void> offline(@PathVariable("id") Long id) {
        postService.offline(id, getUserId());
        return AjaxResult.success();
    }

    @Operation(summary = "设置置顶")
    @PutMapping("/{id}/top/{isTop}")
    @PreAuthorize("@ss.hasPermission('lostfound:post:audit')")
    @OperationLog(title = "设置帖子置顶")
    public AjaxResult<Void> setTop(@PathVariable("id") Long id, @PathVariable("isTop") Boolean isTop) {
        postService.setTop(id, isTop);
        return AjaxResult.success();
    }

    @Operation(summary = "设置推荐")
    @PutMapping("/{id}/recommend/{isRecommend}")
    @PreAuthorize("@ss.hasPermission('lostfound:post:audit')")
    @OperationLog(title = "设置帖子推荐")
    public AjaxResult<Void> setRecommend(@PathVariable("id") Long id, @PathVariable("isRecommend") Boolean isRecommend) {
        postService.setRecommend(id, isRecommend);
        return AjaxResult.success();
    }

    @Operation(summary = "管理端分页查询帖子")
    @GetMapping("/admin/list")
    @PreAuthorize("@ss.hasPermission('lostfound:post:audit')")
    public AjaxResult<Page<BizPost>> adminList(
            @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize,
            @RequestParam(value = "postType", required = false) String postType,
            @RequestParam(value = "status", required = false) String status,
            @RequestParam(value = "categoryId", required = false) Long categoryId,
            @RequestParam(value = "locationId", required = false) Long locationId,
            @RequestParam(value = "keyword", required = false) String keyword) {
        Page<BizPost> page = new Page<>(pageNum, pageSize);
        PostTypeEnum type = null;
        if (postType != null && !postType.isEmpty()) {
            try {
                type = PostTypeEnum.valueOf(postType.toUpperCase());
            } catch (IllegalArgumentException e) {
                // 忽略无效的类型参数
            }
        }
        PostStatusEnum statusEnum = null;
        if (status != null && !status.isEmpty()) {
            try {
                statusEnum = PostStatusEnum.valueOf(status.toUpperCase());
            } catch (IllegalArgumentException e) {
                // 忽略无效的状态参数
            }
        }
        return AjaxResult.success(postService.queryPostList(page, type, statusEnum, categoryId, locationId, keyword));
    }
}
