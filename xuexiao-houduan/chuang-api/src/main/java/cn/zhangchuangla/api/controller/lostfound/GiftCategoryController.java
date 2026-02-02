package cn.zhangchuangla.api.controller.lostfound;

import cn.zhangchuangla.common.core.base.BaseController;
import cn.zhangchuangla.common.core.entity.base.AjaxResult;
import cn.zhangchuangla.framework.annotation.OperationLog;
import cn.zhangchuangla.system.lostfound.model.entity.BizGiftCategory;
import cn.zhangchuangla.system.lostfound.service.GiftCategoryService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 礼品分类控制器
 *
 * @author Chuang
 */
@Tag(name = "礼品分类管理")
@RestController
@RequestMapping("/lostfound/admin/gifts/categories")
@RequiredArgsConstructor
public class GiftCategoryController extends BaseController {

    private final GiftCategoryService giftCategoryService;

    @Operation(summary = "获取所有分类列表")
    @GetMapping
    public AjaxResult<List<BizGiftCategory>> listAll() {
        return AjaxResult.success(giftCategoryService.listAllCategories());
    }

    @Operation(summary = "获取启用的分类列表")
    @GetMapping("/enabled")
    public AjaxResult<List<BizGiftCategory>> listEnabled() {
        return AjaxResult.success(giftCategoryService.listEnabledCategories());
    }

    @Operation(summary = "获取分类详情")
    @GetMapping("/{id}")
    public AjaxResult<BizGiftCategory> getById(@PathVariable("id") Long id) {
        return AjaxResult.success(giftCategoryService.getCategoryById(id));
    }

    @Operation(summary = "创建分类")
    @PostMapping
    @PreAuthorize("@ss.hasPermission('lostfound:gift:category:add')")
    @OperationLog(title = "创建礼品分类")
    public AjaxResult<Long> create(@RequestBody BizGiftCategory category) {
        return AjaxResult.success(giftCategoryService.createCategory(category));
    }

    @Operation(summary = "更新分类")
    @PutMapping("/{id}")
    @PreAuthorize("@ss.hasPermission('lostfound:gift:category:edit')")
    @OperationLog(title = "更新礼品分类")
    public AjaxResult<Void> update(@PathVariable("id") Long id, @RequestBody BizGiftCategory category) {
        category.setId(id);
        giftCategoryService.updateCategory(category);
        return AjaxResult.success();
    }

    @Operation(summary = "删除分类")
    @DeleteMapping("/{id}")
    @PreAuthorize("@ss.hasPermission('lostfound:gift:category:delete')")
    @OperationLog(title = "删除礼品分类")
    public AjaxResult<Void> delete(@PathVariable("id") Long id) {
        giftCategoryService.deleteCategory(id);
        return AjaxResult.success();
    }

    @Operation(summary = "更新分类状态")
    @PutMapping("/{id}/status/{status}")
    @PreAuthorize("@ss.hasPermission('lostfound:gift:category:edit')")
    @OperationLog(title = "更新礼品分类状态")
    public AjaxResult<Void> updateStatus(@PathVariable("id") Long id, @PathVariable("status") Integer status) {
        giftCategoryService.updateStatus(id, status);
        return AjaxResult.success();
    }

    @Operation(summary = "统计分类下礼品数量")
    @GetMapping("/{id}/gift-count")
    public AjaxResult<Integer> countGifts(@PathVariable("id") Long id) {
        return AjaxResult.success(giftCategoryService.countGiftsByCategoryId(id));
    }
}
