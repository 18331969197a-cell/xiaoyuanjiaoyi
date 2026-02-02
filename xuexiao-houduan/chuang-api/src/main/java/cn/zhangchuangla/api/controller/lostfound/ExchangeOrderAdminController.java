package cn.zhangchuangla.api.controller.lostfound;

import cn.zhangchuangla.common.core.base.BaseController;
import cn.zhangchuangla.common.core.entity.base.AjaxResult;
import cn.zhangchuangla.framework.annotation.OperationLog;
import cn.zhangchuangla.system.lostfound.model.entity.BizExchangeOrder;
import cn.zhangchuangla.system.lostfound.service.ExchangeOrderService;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 兑换订单管理控制器（管理端）
 *
 * @author Chuang
 */
@Tag(name = "兑换订单管理")
@RestController
@RequestMapping("/lostfound/admin/exchange/orders")
@RequiredArgsConstructor
public class ExchangeOrderAdminController extends BaseController {

    private final ExchangeOrderService exchangeOrderService;

    @Operation(summary = "获取订单列表")
    @GetMapping
    @PreAuthorize("@ss.hasPermission('lostfound:exchange:list')")
    public AjaxResult<Page<BizExchangeOrder>> listOrders(
            @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize,
            @RequestParam(value = "orderNo", required = false) String orderNo,
            @RequestParam(value = "status", required = false) String status,
            @RequestParam(value = "userId", required = false) Long userId) {
        Page<BizExchangeOrder> page = new Page<>(pageNum, pageSize);
        return AjaxResult.success(exchangeOrderService.listOrdersForAdmin(page, orderNo, status, userId));
    }

    @Operation(summary = "获取订单详情")
    @GetMapping("/{id}")
    @PreAuthorize("@ss.hasPermission('lostfound:exchange:list')")
    public AjaxResult<BizExchangeOrder> getOrderById(@PathVariable("id") Long id) {
        return AjaxResult.success(exchangeOrderService.getOrderById(id, null));
    }

    @Operation(summary = "发货")
    @PutMapping("/{id}/ship")
    @PreAuthorize("@ss.hasPermission('lostfound:exchange:ship')")
    @OperationLog(title = "订单发货")
    public AjaxResult<Void> shipOrder(
            @PathVariable("id") Long id,
            @RequestBody Map<String, String> params) {
        String trackingNo = params.get("trackingNo");
        exchangeOrderService.shipOrder(id, trackingNo);
        return AjaxResult.success();
    }

    @Operation(summary = "取消订单")
    @PutMapping("/{id}/cancel")
    @PreAuthorize("@ss.hasPermission('lostfound:exchange:cancel')")
    @OperationLog(title = "取消订单")
    public AjaxResult<Void> cancelOrder(
            @PathVariable("id") Long id,
            @RequestBody Map<String, String> params) {
        String cancelReason = params.get("cancelReason");
        exchangeOrderService.cancelOrder(id, cancelReason);
        return AjaxResult.success();
    }
}
