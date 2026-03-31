package cn.zhangchuangla.system.lostfound.service.impl;

import cn.zhangchuangla.common.core.utils.Assert;
import cn.zhangchuangla.system.lostfound.mapper.BizRiskEventMapper;
import cn.zhangchuangla.system.lostfound.model.entity.BizReport;
import cn.zhangchuangla.system.lostfound.model.entity.BizRiskEvent;
import cn.zhangchuangla.system.lostfound.model.vo.ChatRiskSummaryVO;
import cn.zhangchuangla.system.lostfound.service.RiskEventService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 风险事件服务实现
 */
@Service
@RequiredArgsConstructor
public class RiskEventServiceImpl implements RiskEventService {

    private final BizRiskEventMapper riskEventMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void upsertFromReport(BizReport report, String action, Long adminId) {
        if (report == null || report.getId() == null || action == null || action.isBlank()) {
            return;
        }
        BizRiskEvent event = riskEventMapper.selectBySource("REPORT", report.getId());
        LocalDateTime now = LocalDateTime.now();
        if (event == null) {
            event = BizRiskEvent.builder()
                    .sourceType("REPORT")
                    .sourceId(report.getId())
                    .createTime(now)
                    .build();
        }
        event.setReportId(report.getId());
        event.setTargetType(report.getTargetType());
        event.setTargetId(report.getTargetId());
        event.setRiskType(resolveRiskType(report.getTargetType(), action));
        event.setActionType(action);
        event.setEventStatus("RESOLVED");
        event.setScopeType("GLOBAL");
        event.setScopeId(null);
        event.setRemark(report.getResolveResult());
        event.setResolvedBy(adminId);
        event.setResolvedAt(report.getResolveAt() != null ? report.getResolveAt() : now);
        event.setUpdateTime(now);

        if (event.getId() == null) {
            riskEventMapper.insert(event);
        } else {
            riskEventMapper.updateById(event);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void createHandoverTimeoutEvent(Long handoverId, Long claimId, Long userId, String remark) {
        upsertHandoverRiskEvent(
                handoverId,
                claimId,
                "HANDOVER_TIMEOUT",
                "ESCALATE_MANUAL",
                userId,
                remark
        );
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void upsertHandoverRiskEvent(Long handoverId,
                                        Long claimId,
                                        String riskType,
                                        String actionType,
                                        Long operatorUserId,
                                        String remark) {
        if (handoverId == null || riskType == null || riskType.isBlank()) {
            return;
        }
        BizRiskEvent event = riskEventMapper.selectBySource("HANDOVER", handoverId);
        LocalDateTime now = LocalDateTime.now();
        if (event == null) {
            event = BizRiskEvent.builder()
                    .sourceType("HANDOVER")
                    .sourceId(handoverId)
                    .createTime(now)
                    .build();
        }
        event.setReportId(null);
        event.setTargetType("CLAIM");
        event.setTargetId(claimId);
        event.setRiskType(riskType);
        event.setActionType(actionType);
        event.setEventStatus("OPEN");
        event.setScopeType("GLOBAL");
        event.setScopeId(null);
        event.setRemark(remark);
        event.setResolvedBy(null);
        event.setResolvedAt(null);
        event.setUpdateTime(now);

        if (event.getId() == null) {
            riskEventMapper.insert(event);
            return;
        }
        riskEventMapper.updateById(event);
    }

    @Override
    public ChatRiskSummaryVO buildChatRiskSummary(Long targetUserId) {
        if (targetUserId == null) {
            return ChatRiskSummaryVO.builder()
                    .targetUserId(null)
                    .risky(false)
                    .riskLevel("LOW")
                    .riskLevelText("低")
                    .totalCount(0)
                    .openCount(0)
                    .hint("未检测到风险记录，请保持正常沟通并注意隐私保护。")
                    .build();
        }
        List<BizRiskEvent> events = riskEventMapper.selectList(new LambdaQueryWrapper<BizRiskEvent>()
                .eq(BizRiskEvent::getTargetType, "USER")
                .eq(BizRiskEvent::getTargetId, targetUserId)
                .orderByDesc(BizRiskEvent::getCreateTime)
                .last("LIMIT 20"));
        if (events == null || events.isEmpty()) {
            return ChatRiskSummaryVO.builder()
                    .targetUserId(targetUserId)
                    .risky(false)
                    .riskLevel("LOW")
                    .riskLevelText("低")
                    .totalCount(0)
                    .openCount(0)
                    .hint("未检测到风险记录，请保持正常沟通并注意隐私保护。")
                    .build();
        }
        int openCount = (int) events.stream()
                .filter(e -> "OPEN".equalsIgnoreCase(e.getEventStatus()))
                .count();
        BizRiskEvent latest = events.get(0);
        boolean high = openCount > 0
                || "ban_user".equalsIgnoreCase(latest.getActionType())
                || "ACCOUNT_RISK".equalsIgnoreCase(latest.getRiskType());
        String riskLevel = high ? "HIGH" : "MEDIUM";
        String riskLevelText = high ? "高" : "中";
        String latestRiskTypeText = mapRiskTypeText(latest.getRiskType());
        String latestActionTypeText = mapActionTypeText(latest.getActionType());
        String latestEventStatusText = mapEventStatusText(latest.getEventStatus());
        String hint = buildFriendlyHint(events.size(), openCount, latest, latestRiskTypeText, latestActionTypeText);
        return ChatRiskSummaryVO.builder()
                .targetUserId(targetUserId)
                .risky(true)
                .riskLevel(riskLevel)
                .riskLevelText(riskLevelText)
                .totalCount(events.size())
                .openCount(openCount)
                .latestRiskType(latest.getRiskType())
                .latestRiskTypeText(latestRiskTypeText)
                .latestActionType(latest.getActionType())
                .latestActionTypeText(latestActionTypeText)
                .latestEventStatus(latest.getEventStatus())
                .latestEventStatusText(latestEventStatusText)
                .latestEventTime(latest.getCreateTime())
                .hint(hint)
                .build();
    }

    @Override
    public Page<BizRiskEvent> listAdminEvents(Page<BizRiskEvent> page, String targetType, Long targetId, String eventStatus,
                                              String actionType, LocalDateTime startTime, LocalDateTime endTime) {
        return riskEventMapper.selectAdminRiskEvents(page, targetType, targetId, eventStatus, actionType, startTime, endTime);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void resolveAdminEvent(Long id, String actionType, String remark, Long adminId) {
        Assert.isTrue(id != null && id > 0, "风险事件ID不能为空");
        BizRiskEvent event = riskEventMapper.selectById(id);
        Assert.isTrue(event != null, "风险事件不存在");

        LocalDateTime now = LocalDateTime.now();
        if (actionType != null && !actionType.isBlank()) {
            event.setActionType(actionType);
        }
        event.setRemark(remark);
        event.setEventStatus("RESOLVED");
        event.setResolvedBy(adminId);
        event.setResolvedAt(now);
        event.setUpdateTime(now);
        riskEventMapper.updateById(event);
    }

    private String resolveRiskType(String targetType, String action) {
        if ("HANDOVER_TIMEOUT".equals(action)) {
            return "HANDOVER_TIMEOUT";
        }
        if ("USER".equals(targetType)) {
            return "ACCOUNT_RISK";
        }
        return "CONTENT_RISK";
    }

    private String mapRiskTypeText(String riskType) {
        if (riskType == null || riskType.isBlank()) {
            return "风险事件";
        }
        return switch (riskType) {
            case "ACCOUNT_RISK" -> "账号风险";
            case "CONTENT_RISK" -> "内容风险";
            case "HANDOVER_TIMEOUT" -> "交接超时";
            case "HANDOVER_DISPUTE" -> "交接争议";
            case "HANDOVER_NO_SHOW" -> "交接爽约";
            default -> "风险事件";
        };
    }

    private String mapActionTypeText(String actionType) {
        if (actionType == null || actionType.isBlank()) {
            return "已记录";
        }
        return switch (actionType) {
            case "ban_user" -> "限制账号使用";
            case "offline_post" -> "下架内容";
            case "mute" -> "禁言处理";
            case "warning" -> "警示提醒";
            case "ESCALATE_MANUAL" -> "升级人工处理";
            case "RAISE_DISPUTE" -> "上报交接争议";
            case "MARK_NO_SHOW" -> "上报交接爽约";
            default -> "已记录";
        };
    }

    private String mapEventStatusText(String eventStatus) {
        if (eventStatus == null || eventStatus.isBlank()) {
            return "未知";
        }
        return switch (eventStatus) {
            case "OPEN" -> "待处理";
            case "RESOLVED" -> "已处理";
            default -> "未知";
        };
    }

    private String buildFriendlyHint(int totalCount,
                                     int openCount,
                                     BizRiskEvent latest,
                                     String latestRiskTypeText,
                                     String latestActionTypeText) {
        String action = latest.getActionType();
        if ("ban_user".equalsIgnoreCase(action)) {
            return String.format("风险提醒：该用户最近因举报核实被限制账号使用（共%d条风险记录，未处理%d条）。请仅在平台内沟通，避免私下转账。", totalCount, openCount);
        }
        if ("RAISE_DISPUTE".equalsIgnoreCase(action)) {
            return String.format("风险提醒：该用户最近被上报交接争议（共%d条风险记录，未处理%d条）。建议先核验凭证，再决定是否继续交接。", totalCount, openCount);
        }
        if ("MARK_NO_SHOW".equalsIgnoreCase(action)) {
            return String.format("风险提醒：该用户最近被上报交接爽约（共%d条风险记录，未处理%d条）。建议明确时间地点并保留沟通记录。", totalCount, openCount);
        }
        if ("ESCALATE_MANUAL".equalsIgnoreCase(action) && "HANDOVER_TIMEOUT".equalsIgnoreCase(latest.getRiskType())) {
            return String.format("风险提醒：该用户最近出现交接超时并已升级人工（共%d条风险记录，未处理%d条）。建议优先选择公开地点并及时线上确认。", totalCount, openCount);
        }
        return String.format("风险提醒：该用户最近涉及“%s / %s”（共%d条风险记录，未处理%d条）。请在平台内留痕沟通，谨慎交易。", latestRiskTypeText, latestActionTypeText, totalCount, openCount);
    }
}
