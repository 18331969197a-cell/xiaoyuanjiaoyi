package cn.zhangchuangla.api.controller.lostfound;

import cn.zhangchuangla.common.core.base.BaseController;
import cn.zhangchuangla.common.core.entity.base.AjaxResult;
import cn.zhangchuangla.framework.annotation.OperationLog;
import cn.zhangchuangla.system.lostfound.model.entity.BizMessage;
import cn.zhangchuangla.system.lostfound.model.entity.BizMsgThread;
import cn.zhangchuangla.system.lostfound.model.vo.ChatRiskSummaryVO;
import cn.zhangchuangla.system.lostfound.service.MessageThreadService;
import cn.zhangchuangla.system.lostfound.service.RiskEventService;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 私信控制器
 *
 * @author Chuang
 */
@Tag(name = "私信管理")
@RestController("lostfoundMessageController")
@RequestMapping("/lostfound/message")
@RequiredArgsConstructor
public class MessageController extends BaseController {

    private final MessageThreadService messageThreadService;
    private final RiskEventService riskEventService;

    @Operation(summary = "发送私信")
    @PostMapping
    @OperationLog(title = "发送私信")
    public AjaxResult<Long> sendMessage(@RequestBody BizMessage message) {
        return AjaxResult.success(messageThreadService.sendMessage(message, getUserId()));
    }

    @Operation(summary = "获取会话列表")
    @GetMapping("/threads")
    public AjaxResult<List<BizMsgThread>> getThreads() {
        return AjaxResult.success(messageThreadService.getUserThreads(getUserId()));
    }

    @Operation(summary = "获取会话消息")
    @GetMapping("/thread/{threadId}")
    public AjaxResult<Page<BizMessage>> getThreadMessages(
            @PathVariable("threadId") Long threadId,
            @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize", defaultValue = "20") Integer pageSize) {
        Page<BizMessage> page = new Page<>(pageNum, pageSize);
        return AjaxResult.success(messageThreadService.getThreadMessages(page, threadId, getUserId()));
    }

    @Operation(summary = "获取会话详情")
    @GetMapping("/thread/{threadId}/detail")
    public AjaxResult<BizMsgThread> getThreadDetail(@PathVariable("threadId") Long threadId) {
        return AjaxResult.success(messageThreadService.getThreadDetail(threadId, getUserId()));
    }

    @Operation(summary = "获取会话风险提示")
    @GetMapping("/thread/{threadId}/risk-summary")
    public AjaxResult<ChatRiskSummaryVO> getThreadRiskSummary(@PathVariable("threadId") Long threadId) {
        Long targetUserId = messageThreadService.getCounterpartyUserId(threadId, getUserId());
        return AjaxResult.success(riskEventService.buildChatRiskSummary(targetUserId));
    }

    @Operation(summary = "标记消息已读")
    @PostMapping("/thread/{threadId}/read")
    public AjaxResult<Void> markAsRead(@PathVariable("threadId") Long threadId) {
        messageThreadService.markAsRead(threadId, getUserId());
        return AjaxResult.success();
    }

    @Operation(summary = "获取未读消息数")
    @GetMapping("/unread-count")
    public AjaxResult<Integer> getUnreadCount() {
        return AjaxResult.success(messageThreadService.getUnreadCount(getUserId()));
    }

    @Operation(summary = "创建或获取会话")
    @PostMapping("/thread")
    public AjaxResult<Long> getOrCreateThread(
            @RequestParam(value = "targetUserId") Long targetUserId,
            @RequestParam(value = "postId", required = false) Long postId,
            @RequestParam(value = "claimId", required = false) Long claimId) {
        return AjaxResult.success(messageThreadService.getOrCreateThread(postId, claimId, getUserId(), targetUserId));
    }
}
