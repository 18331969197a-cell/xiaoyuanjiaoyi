package cn.zhangchuangla.api.controller.lostfound;

import cn.zhangchuangla.common.core.base.BaseController;
import cn.zhangchuangla.common.core.entity.base.AjaxResult;
import cn.zhangchuangla.system.lostfound.model.entity.BizGift;
import cn.zhangchuangla.system.lostfound.model.entity.BizGiftCategory;
import cn.zhangchuangla.system.lostfound.service.GiftCategoryService;
import cn.zhangchuangla.system.lostfound.service.GiftService;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 礼品控制器（用户端）
 *
 * @author Chuang
 */
@Tag(name = "礼品商城")
@RestController
@RequestMapping("/lostfound/gifts")
@RequiredArgsConstructor
public class GiftController extends BaseController {

    private final GiftService giftService;
    private final GiftCategoryService giftCategoryService;

    @Operation(summary = "获取礼品列表")
    @GetMapping
    public AjaxResult<Page<BizGift>> listGifts(
            @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize,
            @RequestParam(value = "categoryId", required = false) Long categoryId,
            @RequestParam(value = "keyword", required = false) String keyword) {
        Page<BizGift> page = new Page<>(pageNum, pageSize);
        return AjaxResult.success(giftService.listGiftsForUser(page, categoryId, keyword));
    }

    @Operation(summary = "获取礼品详情")
    @GetMapping("/{id}")
    public AjaxResult<BizGift> getGiftById(@PathVariable("id") Long id) {
        BizGift gift = giftService.getGiftById(id);
        if (gift == null || !"ON".equals(gift.getStatus())) {
            return AjaxResult.error("礼品不存在或已下架");
        }
        return AjaxResult.success(gift);
    }

    @Operation(summary = "获取礼品分类列表")
    @GetMapping("/categories")
    public AjaxResult<List<BizGiftCategory>> listCategories() {
        return AjaxResult.success(giftCategoryService.listEnabledCategories());
    }
}
