package cn.zhangchuangla.api.controller.lostfound;

import cn.zhangchuangla.common.core.base.BaseController;
import cn.zhangchuangla.common.core.entity.base.AjaxResult;
import cn.zhangchuangla.framework.annotation.OperationLog;
import cn.zhangchuangla.system.lostfound.model.entity.BizGift;
import cn.zhangchuangla.system.lostfound.service.GiftService;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

/**
 * 礼品管理控制器（管理端）
 *
 * @author Chuang
 */
@Tag(name = "礼品管理")
@RestController
@RequestMapping("/lostfound/admin/gifts")
@RequiredArgsConstructor
public class GiftAdminController extends BaseController {

    private final GiftService giftService;

    @Operation(summary = "获取礼品列表")
    @GetMapping
    @PreAuthorize("@ss.hasPermission('lostfound:gift:list')")
    public AjaxResult<Page<BizGift>> listGifts(
            @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize,
            @RequestParam(value = "categoryId", required = false) Long categoryId,
            @RequestParam(value = "status", required = false) String status,
            @RequestParam(value = "keyword", required = false) String keyword) {
        Page<BizGift> page = new Page<>(pageNum, pageSize);
        return AjaxResult.success(giftService.listGiftsForAdmin(page, categoryId, status, keyword));
    }

    @Operation(summary = "获取礼品详情")
    @GetMapping("/{id}")
    @PreAuthorize("@ss.hasPermission('lostfound:gift:list')")
    public AjaxResult<BizGift> getGiftById(@PathVariable("id") Long id) {
        return AjaxResult.success(giftService.getGiftById(id));
    }

    @Operation(summary = "新增礼品")
    @PostMapping
    @PreAuthorize("@ss.hasPermission('lostfound:gift:add')")
    @OperationLog(title = "新增礼品")
    public AjaxResult<Long> createGift(@RequestBody BizGift gift) {
        return AjaxResult.success(giftService.createGift(gift, getUserId()));
    }

    @Operation(summary = "编辑礼品")
    @PutMapping("/{id}")
    @PreAuthorize("@ss.hasPermission('lostfound:gift:edit')")
    @OperationLog(title = "编辑礼品")
    public AjaxResult<Void> updateGift(@PathVariable("id") Long id, @RequestBody BizGift gift) {
        gift.setId(id);
        giftService.updateGift(gift);
        return AjaxResult.success();
    }

    @Operation(summary = "上架/下架礼品")
    @PutMapping("/{id}/status")
    @PreAuthorize("@ss.hasPermission('lostfound:gift:edit')")
    @OperationLog(title = "更新礼品状态")
    public AjaxResult<Void> updateGiftStatus(
            @PathVariable("id") Long id,
            @RequestParam("status") String status) {
        giftService.updateStatus(id, status);
        return AjaxResult.success();
    }

    @Operation(summary = "删除礼品")
    @DeleteMapping("/{id}")
    @PreAuthorize("@ss.hasPermission('lostfound:gift:delete')")
    @OperationLog(title = "删除礼品")
    public AjaxResult<Void> deleteGift(@PathVariable("id") Long id) {
        giftService.deleteGift(id);
        return AjaxResult.success();
    }
}
