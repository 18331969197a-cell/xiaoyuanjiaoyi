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
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 兑换订单控制器（用户端）
 *
 * @author Chuang
 */
@Tag(name = "积分兑换")
@RestController
@RequestMapping("/lostfound/exchange")
@RequiredArgsConstructor
public class ExchangeOrderController extends BaseController {

    private final ExchangeOrderService exchangeOrderService;

    @Operation(summary = "兑换礼品")
    @PostMapping
    @OperationLog(title = "兑换礼品")
    public AjaxResult<Long> exchangeGift(@RequestBody Map<String, Object> params) {
        Long giftId = Long.valueOf(params.get("giftId").toString());
        Integer quantity = params.get("quantity") != null ? Integer.valueOf(params.get("quantity").toString()) : 1;
        String receiverName = params.get("receiverName") != null ? params.get("receiverName").toString() : null;
        String receiverPhone = params.get("receiverPhone") != null ? params.get("receiverPhone").toString() : null;
        String receiverAddress = params.get("receiverAddress") != null ? params.get("receiverAddress").toString() : null;

        Long orderId = exchangeOrderService.exchangeGift(
                getUserId(), giftId, quantity, receiverName, receiverPhone, receiverAddress);
        return AjaxResult.success(orderId);
    }

    @Operation(summary = "获取我的兑换记录")
    @GetMapping("/my")
    public AjaxResult<Page<BizExchangeOrder>> listMyOrders(
            @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize,
            @RequestParam(value = "status", required = false) String status) {
        Page<BizExchangeOrder> page = new Page<>(pageNum, pageSize);
        return AjaxResult.success(exchangeOrderService.listUserOrders(page, getUserId(), status));
    }

    @Operation(summary = "获取订单详情")
    @GetMapping("/{id}")
    public AjaxResult<BizExchangeOrder> getOrderById(@PathVariable("id") Long id) {
        return AjaxResult.success(exchangeOrderService.getOrderById(id, getUserId()));
    }

    @Operation(summary = "确认收货")
    @PutMapping("/{id}/confirm")
    @OperationLog(title = "确认收货")
    public AjaxResult<Void> confirmReceive(@PathVariable("id") Long id) {
        exchangeOrderService.confirmReceive(id, getUserId());
        return AjaxResult.success();
    }
}
