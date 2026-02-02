package cn.zhangchuangla.api.controller.lostfound;

import cn.zhangchuangla.common.core.base.BaseController;
import cn.zhangchuangla.common.core.entity.base.AjaxResult;
import cn.zhangchuangla.framework.annotation.OperationLog;
import cn.zhangchuangla.system.lostfound.model.entity.BizCategory;
import cn.zhangchuangla.system.lostfound.service.CategoryService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 物品分类控制器
 *
 * @author Chuang
 */
@Tag(name = "物品分类管理")
@RestController
@RequestMapping("/lostfound/category")
@RequiredArgsConstructor
public class CategoryController extends BaseController {

    private final CategoryService categoryService;

    @Operation(summary = "获取分类树")
    @GetMapping("/tree")
    public AjaxResult<List<BizCategory>> getCategoryTree(
            @RequestParam(value = "name", required = false) String name,
            @RequestParam(value = "status", required = false) Integer status) {
        List<BizCategory> categories = categoryService.listCategoriesWithFilter(name, status);
        List<BizCategory> tree = categoryService.buildCategoryTree(categories);
        return AjaxResult.success(tree);
    }

    @Operation(summary = "获取所有分类列表")
    @GetMapping("/list")
    public AjaxResult<List<BizCategory>> listAll() {
        return AjaxResult.success(categoryService.listAllCategories());
    }

    @Operation(summary = "获取分类详情")
    @GetMapping("/{id}")
    public AjaxResult<BizCategory> getById(@PathVariable("id") Long id) {
        return AjaxResult.success(categoryService.getCategoryById(id));
    }

    @Operation(summary = "创建分类")
    @PostMapping
    @PreAuthorize("@ss.hasPermission('lostfound:category:add')")
    @OperationLog(title = "创建分类")
    public AjaxResult<Long> create(@RequestBody BizCategory category) {
        return AjaxResult.success(categoryService.createCategory(category));
    }

    @Operation(summary = "更新分类")
    @PutMapping
    @PreAuthorize("@ss.hasPermission('lostfound:category:edit')")
    @OperationLog(title = "更新分类")
    public AjaxResult<Void> update(@RequestBody BizCategory category) {
        categoryService.updateCategory(category);
        return AjaxResult.success();
    }

    @Operation(summary = "删除分类")
    @DeleteMapping("/{id}")
    @PreAuthorize("@ss.hasPermission('lostfound:category:delete')")
    @OperationLog(title = "删除分类")
    public AjaxResult<Void> delete(@PathVariable("id") Long id) {
        categoryService.deleteCategory(id);
        return AjaxResult.success();
    }

    @Operation(summary = "更新分类状态")
    @PutMapping("/{id}/status/{status}")
    @PreAuthorize("@ss.hasPermission('lostfound:category:edit')")
    @OperationLog(title = "更新分类状态")
    public AjaxResult<Void> updateStatus(@PathVariable("id") Long id, @PathVariable("status") Integer status) {
        categoryService.updateStatus(id, status);
        return AjaxResult.success();
    }
}
