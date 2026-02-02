package cn.zhangchuangla.api.controller.lostfound;

import cn.zhangchuangla.common.core.base.BaseController;
import cn.zhangchuangla.common.core.entity.base.AjaxResult;
import cn.zhangchuangla.framework.annotation.OperationLog;
import cn.zhangchuangla.system.lostfound.model.entity.BizPost;
import cn.zhangchuangla.system.lostfound.service.FavoriteService;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

/**
 * 收藏控制器
 *
 * @author Chuang
 */
@Tag(name = "收藏管理")
@RestController
@RequestMapping("/lostfound/favorite")
@RequiredArgsConstructor
public class FavoriteController extends BaseController {

    private final FavoriteService favoriteService;

    @Operation(summary = "添加收藏")
    @PostMapping("/{postId}")
    @OperationLog(title = "添加收藏")
    public AjaxResult<Void> addFavorite(@PathVariable("postId") Long postId) {
        favoriteService.addFavorite(getUserId(), postId);
        return AjaxResult.success();
    }

    @Operation(summary = "取消收藏")
    @DeleteMapping("/{postId}")
    @OperationLog(title = "取消收藏")
    public AjaxResult<Void> removeFavorite(@PathVariable("postId") Long postId) {
        favoriteService.removeFavorite(getUserId(), postId);
        return AjaxResult.success();
    }

    @Operation(summary = "检查是否已收藏")
    @GetMapping("/{postId}/check")
    public AjaxResult<Boolean> isFavorited(@PathVariable("postId") Long postId) {
        return AjaxResult.success(favoriteService.isFavorited(getUserId(), postId));
    }

    @Operation(summary = "批量检查收藏状态")
    @PostMapping("/batch-check")
    public AjaxResult<java.util.Map<Long, Boolean>> batchCheckFavorited(@RequestBody java.util.List<Long> postIds) {
        if (postIds == null || postIds.isEmpty()) {
            return AjaxResult.success(new java.util.HashMap<>());
        }
        java.util.Map<Long, Boolean> result = new java.util.HashMap<>();
        Long userId = getUserId();
        for (Long postId : postIds) {
            result.put(postId, favoriteService.isFavorited(userId, postId));
        }
        return AjaxResult.success(result);
    }

    @Operation(summary = "获取我的收藏列表")
    @GetMapping("/my")
    public AjaxResult<Page<BizPost>> getMyFavorites(
            @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize) {
        Page<BizPost> page = new Page<>(pageNum, pageSize);
        return AjaxResult.success(favoriteService.getUserFavorites(page, getUserId()));
    }
}
