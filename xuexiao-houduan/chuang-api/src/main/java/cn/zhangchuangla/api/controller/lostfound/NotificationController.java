package cn.zhangchuangla.api.controller.lostfound;

import cn.zhangchuangla.common.core.base.BaseController;
import cn.zhangchuangla.common.core.entity.base.AjaxResult;
import cn.zhangchuangla.system.lostfound.enums.NotificationTypeEnum;
import cn.zhangchuangla.system.lostfound.model.entity.BizNotification;
import cn.zhangchuangla.system.lostfound.service.NotificationService;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

/**
 * 通知控制器
 *
 * @author Chuang
 */
@Tag(name = "通知管理")
@RestController
@RequestMapping("/lostfound/notification")
@RequiredArgsConstructor
public class NotificationController extends BaseController {

    private final NotificationService notificationService;

    @Operation(summary = "获取通知列表")
    @GetMapping("/list")
    public AjaxResult<Page<BizNotification>> list(
            @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize,
            @RequestParam(value = "type", required = false) String type,
            @RequestParam(value = "isRead", required = false) Integer isRead) {
        Page<BizNotification> page = new Page<>(pageNum, pageSize);
        NotificationTypeEnum typeEnum = null;
        if (type != null && !type.isEmpty()) {
            try {
                typeEnum = NotificationTypeEnum.valueOf(type.toUpperCase());
            } catch (IllegalArgumentException e) {
                // 忽略无效的类型参数
            }
        }
        return AjaxResult.success(notificationService.getUserNotifications(page, getUserId(), typeEnum, isRead));
    }

    @Operation(summary = "标记通知已读")
    @PostMapping("/{id}/read")
    public AjaxResult<Void> markAsRead(@PathVariable("id") Long id) {
        notificationService.markAsRead(id, getUserId());
        return AjaxResult.success();
    }

    @Operation(summary = "标记所有通知已读")
    @PostMapping("/read-all")
    public AjaxResult<Void> markAllAsRead() {
        notificationService.markAllAsRead(getUserId());
        return AjaxResult.success();
    }

    @Operation(summary = "获取未读通知数")
    @GetMapping("/unread-count")
    public AjaxResult<Integer> getUnreadCount() {
        return AjaxResult.success(notificationService.getUnreadCount(getUserId()));
    }

    @Operation(summary = "删除通知")
    @DeleteMapping("/{id}")
    public AjaxResult<Void> deleteNotification(@PathVariable("id") Long id) {
        notificationService.deleteNotification(id, getUserId());
        return AjaxResult.success();
    }
}
