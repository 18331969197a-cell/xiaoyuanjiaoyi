package cn.zhangchuangla.system.lostfound.task;

import cn.zhangchuangla.system.core.model.entity.SysSecurityLog;
import cn.zhangchuangla.system.core.service.SysSecurityLogService;
import cn.zhangchuangla.system.lostfound.enums.HandoverStatusEnum;
import cn.zhangchuangla.system.lostfound.enums.NotificationTypeEnum;
import cn.zhangchuangla.system.lostfound.mapper.BizHandoverMapper;
import cn.zhangchuangla.system.lostfound.mapper.BizNotificationMapper;
import cn.zhangchuangla.system.lostfound.model.entity.BizHandover;
import cn.zhangchuangla.system.lostfound.model.entity.BizNotification;
import cn.zhangchuangla.system.lostfound.service.NotificationService;
import cn.zhangchuangla.system.lostfound.service.RiskEventService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;
import java.util.Objects;

/**
 * 交接流程超时催办任务
 *
 * <p>规则：
 * 1. 单边确认后24小时未完成，自动催办未确认一方；
 * 2. 单边确认后72小时未完成，升级为人工关注并通知双方。
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class HandoverScheduleTask {

    private static final String REMIND_RELATED_TYPE = "HANDOVER_REMIND_24H";
    private static final String ESCALATE_RELATED_TYPE = "HANDOVER_ESCALATE_72H";

    private final BizHandoverMapper handoverMapper;
    private final BizNotificationMapper notificationMapper;
    private final NotificationService notificationService;
    private final SysSecurityLogService sysSecurityLogService;
    private final RiskEventService riskEventService;

    @Scheduled(cron = "0 0 * * * ?")
    @Transactional(rollbackFor = Exception.class)
    public void remindPendingHandovers() {
        LocalDateTime now = LocalDateTime.now();
        List<BizHandover> pendingHandovers = handoverMapper.selectList(new LambdaQueryWrapper<BizHandover>()
                .in(BizHandover::getStatus,
                        HandoverStatusEnum.PENDING,
                        HandoverStatusEnum.RESCHEDULED,
                        HandoverStatusEnum.NO_SHOW));

        if (pendingHandovers.isEmpty()) {
            return;
        }

        int remindCount = 0;
        int escalateCount = 0;
        for (BizHandover handover : pendingHandovers) {
            Long pendingUserId = getPendingUserId(handover);
            if (pendingUserId == null) {
                continue;
            }
            LocalDateTime baseline = getReminderBaseline(handover);
            if (baseline == null) {
                continue;
            }
            long hours = Duration.between(baseline, now).toHours();
            if (hours >= 72) {
                if (sendEscalationOnce(handover)) {
                    escalateCount++;
                }
                continue;
            }
            if (hours >= 24 && sendReminderOnce(handover, pendingUserId)) {
                remindCount++;
            }
        }

        if (remindCount > 0 || escalateCount > 0) {
            log.info("交接催办任务完成，24h催办={}，72h升级={}", remindCount, escalateCount);
        }
    }

    private boolean sendReminderOnce(BizHandover handover, Long pendingUserId) {
        if (existsNotification(pendingUserId, REMIND_RELATED_TYPE, handover.getId())) {
            return false;
        }
        notificationService.createNotification(
                pendingUserId,
                NotificationTypeEnum.CLAIM,
                "交接待确认提醒（24小时）",
                "线下交接已超过24小时仍未双方确认，请尽快完成确认，避免流程超时升级。",
                REMIND_RELATED_TYPE,
                handover.getId()
        );
        return true;
    }

    private boolean sendEscalationOnce(BizHandover handover) {
        Long pendingUserId = getPendingUserId(handover);
        if (pendingUserId == null || existsNotification(pendingUserId, ESCALATE_RELATED_TYPE, handover.getId())) {
            return false;
        }

        Long otherUserId = Objects.equals(pendingUserId, handover.getFromUserId())
                ? handover.getToUserId()
                : handover.getFromUserId();

        notificationService.createNotification(
                pendingUserId,
                NotificationTypeEnum.CLAIM,
                "交接超时升级（72小时）",
                "线下交接已超过72小时仍未完成双方确认，已升级人工关注，请尽快处理。",
                ESCALATE_RELATED_TYPE,
                handover.getId()
        );

        if (otherUserId != null && !existsNotification(otherUserId, ESCALATE_RELATED_TYPE, handover.getId())) {
            notificationService.createNotification(
                    otherUserId,
                    NotificationTypeEnum.CLAIM,
                    "交接超时升级（72小时）",
                    "当前交接已超时并升级人工关注，请与对方尽快完成确认。",
                    ESCALATE_RELATED_TYPE,
                    handover.getId()
            );
        }

        SysSecurityLog securityLog = new SysSecurityLog();
        securityLog.setUserId(pendingUserId);
        securityLog.setTitle("交接超时升级-交接#" + handover.getId());
        securityLog.setOperationType("HANDOVER_TIMEOUT");
        securityLog.setOperationRegion("LOSTFOUND");
        securityLog.setOperationIp("SYSTEM");
        securityLog.setOperationTime(new Date());
        sysSecurityLogService.save(securityLog);
        if (riskEventService != null) {
            riskEventService.createHandoverTimeoutEvent(
                    handover.getId(),
                    handover.getClaimId(),
                    pendingUserId,
                    "交接超过72小时未完成双方确认，已升级人工关注"
            );
        }

        return true;
    }

    private boolean existsNotification(Long userId, String relatedType, Long relatedId) {
        return notificationMapper.selectCount(new LambdaQueryWrapper<BizNotification>()
                .eq(BizNotification::getUserId, userId)
                .eq(BizNotification::getRelatedType, relatedType)
                .eq(BizNotification::getRelatedId, relatedId)) > 0;
    }

    private Long getPendingUserId(BizHandover handover) {
        boolean fromConfirmed = handover.getConfirmedByFromAt() != null;
        boolean toConfirmed = handover.getConfirmedByToAt() != null;
        if (fromConfirmed == toConfirmed) {
            return null;
        }
        return fromConfirmed ? handover.getToUserId() : handover.getFromUserId();
    }

    private LocalDateTime getReminderBaseline(BizHandover handover) {
        LocalDateTime from = handover.getConfirmedByFromAt();
        LocalDateTime to = handover.getConfirmedByToAt();
        if (from == null) {
            return to;
        }
        if (to == null) {
            return from;
        }
        return from.isAfter(to) ? from : to;
    }
}
