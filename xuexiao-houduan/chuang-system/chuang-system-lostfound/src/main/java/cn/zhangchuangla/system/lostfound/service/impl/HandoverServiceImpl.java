package cn.zhangchuangla.system.lostfound.service.impl;

import cn.zhangchuangla.system.lostfound.enums.ClaimStatusEnum;
import cn.zhangchuangla.system.lostfound.enums.HandoverStatusEnum;
import cn.zhangchuangla.system.lostfound.enums.NotificationTypeEnum;
import cn.zhangchuangla.common.core.exception.BusinessException;
import cn.zhangchuangla.common.core.exception.ErrorCode;
import cn.zhangchuangla.system.lostfound.mapper.BizHandoverMapper;
import cn.zhangchuangla.system.lostfound.model.entity.BizClaim;
import cn.zhangchuangla.system.lostfound.model.entity.BizHandover;
import cn.zhangchuangla.system.lostfound.service.ClaimService;
import cn.zhangchuangla.system.lostfound.service.HandoverService;
import cn.zhangchuangla.system.lostfound.service.NotificationService;
import cn.zhangchuangla.system.lostfound.service.PointsService;
import cn.zhangchuangla.system.lostfound.service.RiskEventService;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;

/**
 * 交接服务实现
 *
 * @author Chuang
 */
@Service
@RequiredArgsConstructor
public class HandoverServiceImpl implements HandoverService {

    private final BizHandoverMapper handoverMapper;
    @Lazy
    private final ClaimService claimService;
    @Lazy
    private final PointsService pointsService;
    @Lazy
    private final NotificationService notificationService;
    @Lazy
    private final RiskEventService riskEventService;
    private static final List<HandoverStatusEnum> ACTIVE_STATUSES = List.of(
            HandoverStatusEnum.PENDING,
            HandoverStatusEnum.RESCHEDULED,
            HandoverStatusEnum.NO_SHOW
    );

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createHandover(BizHandover handover, Long userId) {
        if (handover == null || handover.getClaimId() == null) {
            throw new BusinessException(ErrorCode.PARAM_ERROR, "认领单ID不能为空");
        }
        // 获取认领单信息
        BizClaim claim = claimService.getClaimById(handover.getClaimId());
        if (claim == null) {
            throw new BusinessException(ErrorCode.CLAIM_NOT_FOUND);
        }
        if (!Objects.equals(claim.getPosterId(), userId)) {
            throw new BusinessException(ErrorCode.OPERATION_NOT_ALLOWED, "仅发布者可发起交接");
        }
        if (claim.getStatus() != ClaimStatusEnum.APPROVED) {
            throw new BusinessException(ErrorCode.OPERATION_NOT_ALLOWED, "当前认领状态不允许发起交接");
        }
        // 检查是否已有交接记录
        BizHandover existing = getHandoverByClaimId(handover.getClaimId());
        if (existing != null) {
            throw new BusinessException(ErrorCode.DATA_ALREADY_EXISTS, "该认领单已有交接记录");
        }
        // 设置交接双方
        handover.setFromUserId(claim.getPosterId());
        handover.setToUserId(claim.getClaimantId());
        handover.setStatus(HandoverStatusEnum.PENDING);
        handover.setCreateTime(LocalDateTime.now());
        handoverMapper.insert(handover);
        
        // 更新认领状态为交接中
        claimService.startHandover(handover.getClaimId());

        // 通知认领方线下交接安排
        if (notificationService != null) {
            notificationService.createNotification(
                    claim.getClaimantId(),
                    NotificationTypeEnum.CLAIM,
                    "交接已发起，请确认时间地点",
                    "发布者已发起线下交接，请尽快确认并按约定完成交接。",
                    "CLAIM",
                    claim.getId()
            );
        }

        return handover.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void confirmHandover(Long handoverId, Long userId) {
        BizHandover handover = handoverMapper.selectById(handoverId);
        if (handover == null) {
            throw new BusinessException(ErrorCode.DATA_NOT_FOUND, "交接记录不存在");
        }
        if (handover.getStatus() == HandoverStatusEnum.CONFIRMED) {
            return;
        }
        ensureStatusForProceed(handover);
        markConfirmedByUser(handover, userId, LocalDateTime.now());
        if (handover.getStatus() == HandoverStatusEnum.RESCHEDULED || handover.getStatus() == HandoverStatusEnum.NO_SHOW) {
            handover.setStatus(HandoverStatusEnum.PENDING);
        }
        completeIfBothConfirmed(handover);
        handoverMapper.updateById(handover);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void cancelHandover(Long handoverId, String reason, Long userId) {
        BizHandover handover = handoverMapper.selectById(handoverId);
        if (handover == null) {
            throw new BusinessException(ErrorCode.DATA_NOT_FOUND, "交接记录不存在");
        }
        if (handover.getStatus() == HandoverStatusEnum.CONFIRMED) {
            throw new BusinessException(ErrorCode.OPERATION_NOT_ALLOWED, "已确认交接不可取消");
        }
        if (!Objects.equals(handover.getFromUserId(), userId) && !Objects.equals(handover.getToUserId(), userId)) {
            throw new BusinessException(ErrorCode.OPERATION_NOT_ALLOWED, "无权取消该交接");
        }
        handover.setStatus(HandoverStatusEnum.CANCELLED);
        handover.setRemark(reason != null && !reason.isBlank() ? reason : "用户取消交接");
        handoverMapper.updateById(handover);

        // 取消交接后，认领回退至“已通过”，等待重新发起
        claimService.reopenFromHandover(handover.getClaimId());

        BizClaim claim = claimService.getClaimById(handover.getClaimId());
        if (claim != null && notificationService != null) {
            Long otherUserId = Objects.equals(userId, handover.getFromUserId())
                    ? handover.getToUserId()
                    : handover.getFromUserId();
            notificationService.createNotification(
                    otherUserId,
                    NotificationTypeEnum.CLAIM,
                    "交接已取消",
                    "当前交接安排已取消，请重新协商时间地点。",
                    "CLAIM",
                    claim.getId()
            );
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void submitReceipt(Long handoverId, BizHandover handover, Long userId) {
        BizHandover existing = handoverMapper.selectById(handoverId);
        if (existing == null) {
            throw new BusinessException(ErrorCode.DATA_NOT_FOUND, "交接记录不存在");
        }
        ensureStatusForProceed(existing);
        ensureParticipant(existing, userId);

        LocalDateTime now = LocalDateTime.now();
        existing.setReceiptSubmittedBy(userId);
        existing.setReceiptSubmittedAt(now);
        existing.setReceiptActualTime(handover != null && handover.getReceiptActualTime() != null ? handover.getReceiptActualTime() : now);
        existing.setReceiptLocation(resolveReceiptLocation(existing, handover));
        existing.setReceiptEvidenceJson(handover != null ? handover.getReceiptEvidenceJson() : null);
        existing.setReceiptRemark(resolveReceiptRemark(handover));
        markConfirmedByUser(existing, userId, now);
        if (existing.getStatus() == HandoverStatusEnum.RESCHEDULED || existing.getStatus() == HandoverStatusEnum.NO_SHOW) {
            existing.setStatus(HandoverStatusEnum.PENDING);
        }

        Long otherUserId = Objects.equals(userId, existing.getFromUserId()) ? existing.getToUserId() : existing.getFromUserId();
        if (notificationService != null && otherUserId != null) {
            notificationService.createNotification(
                    otherUserId,
                    NotificationTypeEnum.CLAIM,
                    "线下交接回传待确认",
                    "对方已提交线下交接回传，请尽快确认完成。",
                    "HANDOVER",
                    existing.getId()
            );
        }

        completeIfBothConfirmed(existing);
        handoverMapper.updateById(existing);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void confirmReceipt(Long handoverId, Long userId) {
        BizHandover handover = handoverMapper.selectById(handoverId);
        if (handover == null) {
            throw new BusinessException(ErrorCode.DATA_NOT_FOUND, "交接记录不存在");
        }
        ensureStatusForProceed(handover);
        ensureParticipant(handover, userId);
        if (handover.getReceiptSubmittedBy() == null) {
            throw new BusinessException(ErrorCode.OPERATION_NOT_ALLOWED, "对方尚未提交线下回传");
        }
        if (Objects.equals(handover.getReceiptSubmittedBy(), userId)) {
            throw new BusinessException(ErrorCode.OPERATION_NOT_ALLOWED, "提交方无需再次确认回传");
        }

        LocalDateTime now = LocalDateTime.now();
        handover.setReceiptConfirmedBy(userId);
        handover.setReceiptConfirmedAt(now);
        markConfirmedByUser(handover, userId, now);

        if (notificationService != null) {
            notificationService.createNotification(
                    handover.getReceiptSubmittedBy(),
                    NotificationTypeEnum.CLAIM,
                    "线下交接回传已确认",
                    "对方已确认您提交的线下回传，交接流程将进入完成。",
                    "HANDOVER",
                    handover.getId()
            );
        }

        completeIfBothConfirmed(handover);
        handoverMapper.updateById(handover);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void reschedule(Long handoverId, BizHandover handover, String reason, Long userId) {
        BizHandover existing = handoverMapper.selectById(handoverId);
        if (existing == null) {
            throw new BusinessException(ErrorCode.DATA_NOT_FOUND, "交接记录不存在");
        }
        if (existing.getStatus() == HandoverStatusEnum.CANCELLED || existing.getStatus() == HandoverStatusEnum.CONFIRMED) {
            throw new BusinessException(ErrorCode.OPERATION_NOT_ALLOWED, "当前状态不允许改约");
        }
        ensureParticipant(existing, userId);
        if (handover == null || (handover.getHandoverTime() == null && (handover.getLocation() == null || handover.getLocation().isBlank()))) {
            throw new BusinessException(ErrorCode.PARAM_ERROR, "请提供新的时间或地点");
        }
        if (handover.getHandoverTime() != null) {
            existing.setHandoverTime(handover.getHandoverTime());
        }
        if (handover.getLocation() != null && !handover.getLocation().isBlank()) {
            existing.setLocation(handover.getLocation().trim());
        }
        existing.setStatus(HandoverStatusEnum.RESCHEDULED);
        existing.setRemark((reason == null || reason.isBlank()) ? "用户发起改约" : "改约原因：" + reason.trim());
        clearConfirmAndReceipt(existing);
        handoverMapper.updateById(existing);

        Long otherUserId = Objects.equals(userId, existing.getFromUserId()) ? existing.getToUserId() : existing.getFromUserId();
        if (notificationService != null && otherUserId != null) {
            notificationService.createNotification(
                    otherUserId,
                    NotificationTypeEnum.CLAIM,
                    "交接已改约",
                    "对方已发起改约，请查看新的交接时间地点并确认。",
                    "HANDOVER",
                    existing.getId()
            );
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void raiseDispute(Long handoverId, String reason, Long userId) {
        BizHandover handover = handoverMapper.selectById(handoverId);
        if (handover == null) {
            throw new BusinessException(ErrorCode.DATA_NOT_FOUND, "交接记录不存在");
        }
        if (handover.getStatus() == HandoverStatusEnum.CANCELLED || handover.getStatus() == HandoverStatusEnum.CONFIRMED) {
            throw new BusinessException(ErrorCode.OPERATION_NOT_ALLOWED, "当前状态不允许上报争议");
        }
        ensureParticipant(handover, userId);
        handover.setStatus(HandoverStatusEnum.DISPUTED);
        handover.setRemark((reason == null || reason.isBlank()) ? "交接争议待人工介入" : "争议原因：" + reason.trim());
        handoverMapper.updateById(handover);
        if (riskEventService != null) {
            riskEventService.upsertHandoverRiskEvent(
                    handover.getId(),
                    handover.getClaimId(),
                    "HANDOVER_DISPUTE",
                    "RAISE_DISPUTE",
                    userId,
                    handover.getRemark()
            );
        }

        Long otherUserId = Objects.equals(userId, handover.getFromUserId()) ? handover.getToUserId() : handover.getFromUserId();
        if (notificationService != null && otherUserId != null) {
            notificationService.createNotification(
                    otherUserId,
                    NotificationTypeEnum.CLAIM,
                    "交接已上报争议",
                    "当前交接进入争议状态，等待人工处理。",
                    "HANDOVER",
                    handover.getId()
            );
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void markNoShow(Long handoverId, String reason, Long userId) {
        BizHandover handover = handoverMapper.selectById(handoverId);
        if (handover == null) {
            throw new BusinessException(ErrorCode.DATA_NOT_FOUND, "交接记录不存在");
        }
        if (handover.getStatus() == HandoverStatusEnum.CANCELLED || handover.getStatus() == HandoverStatusEnum.CONFIRMED) {
            throw new BusinessException(ErrorCode.OPERATION_NOT_ALLOWED, "当前状态不允许上报爽约");
        }
        ensureParticipant(handover, userId);
        handover.setStatus(HandoverStatusEnum.NO_SHOW);
        handover.setRemark((reason == null || reason.isBlank()) ? "交接爽约待重新协商" : "爽约说明：" + reason.trim());
        handoverMapper.updateById(handover);
        if (riskEventService != null) {
            riskEventService.upsertHandoverRiskEvent(
                    handover.getId(),
                    handover.getClaimId(),
                    "HANDOVER_NO_SHOW",
                    "MARK_NO_SHOW",
                    userId,
                    handover.getRemark()
            );
        }

        Long otherUserId = Objects.equals(userId, handover.getFromUserId()) ? handover.getToUserId() : handover.getFromUserId();
        if (notificationService != null && otherUserId != null) {
            notificationService.createNotification(
                    otherUserId,
                    NotificationTypeEnum.CLAIM,
                    "交接爽约提醒",
                    "对方上报了交接爽约，请尽快改约或发起争议处理。",
                    "HANDOVER",
                    handover.getId()
            );
        }
    }

    @Override
    public BizHandover getHandoverById(Long handoverId) {
        return handoverMapper.selectById(handoverId);
    }

    @Override
    public BizHandover getHandoverByClaimId(Long claimId) {
        // 使用带用户名的查询方法
        return handoverMapper.selectHandoverDetailByClaimId(claimId);
    }

    @Override
    public Page<BizHandover> getMyHandovers(Page<BizHandover> page, Long userId, String status) {
        return handoverMapper.selectUserHandoversWithDetail(page, userId, status);
    }

    private void ensureParticipant(BizHandover handover, Long userId) {
        if (!Objects.equals(handover.getFromUserId(), userId) && !Objects.equals(handover.getToUserId(), userId)) {
            throw new BusinessException(ErrorCode.OPERATION_NOT_ALLOWED, "无权操作该交接记录");
        }
    }

    private void ensureStatusForProceed(BizHandover handover) {
        if (handover.getStatus() == HandoverStatusEnum.CANCELLED) {
            throw new BusinessException(ErrorCode.OPERATION_NOT_ALLOWED, "该交接已取消");
        }
        if (handover.getStatus() == HandoverStatusEnum.DISPUTED) {
            throw new BusinessException(ErrorCode.OPERATION_NOT_ALLOWED, "该交接存在争议，需人工处理后继续");
        }
        if (!ACTIVE_STATUSES.contains(handover.getStatus()) && handover.getStatus() != HandoverStatusEnum.CONFIRMED) {
            throw new BusinessException(ErrorCode.OPERATION_NOT_ALLOWED, "当前交接状态不允许执行此操作");
        }
    }

    private void markConfirmedByUser(BizHandover handover, Long userId, LocalDateTime time) {
        if (Objects.equals(handover.getFromUserId(), userId)) {
            if (handover.getConfirmedByFromAt() == null) {
                handover.setConfirmedByFromAt(time);
            }
            return;
        }
        if (Objects.equals(handover.getToUserId(), userId)) {
            if (handover.getConfirmedByToAt() == null) {
                handover.setConfirmedByToAt(time);
            }
            return;
        }
        throw new BusinessException(ErrorCode.OPERATION_NOT_ALLOWED, "无权确认此交接");
    }

    private void clearConfirmAndReceipt(BizHandover handover) {
        handover.setConfirmedByFromAt(null);
        handover.setConfirmedByToAt(null);
        handover.setReceiptSubmittedBy(null);
        handover.setReceiptSubmittedAt(null);
        handover.setReceiptActualTime(null);
        handover.setReceiptLocation(null);
        handover.setReceiptEvidenceJson(null);
        handover.setReceiptRemark(null);
        handover.setReceiptConfirmedBy(null);
        handover.setReceiptConfirmedAt(null);
    }

    private String resolveReceiptLocation(BizHandover existing, BizHandover incoming) {
        if (incoming == null) {
            return existing.getLocation();
        }
        if (incoming.getReceiptLocation() != null && !incoming.getReceiptLocation().isBlank()) {
            return incoming.getReceiptLocation().trim();
        }
        if (incoming.getLocation() != null && !incoming.getLocation().isBlank()) {
            return incoming.getLocation().trim();
        }
        return existing.getLocation();
    }

    private String resolveReceiptRemark(BizHandover incoming) {
        if (incoming == null) {
            return null;
        }
        if (incoming.getReceiptRemark() != null && !incoming.getReceiptRemark().isBlank()) {
            return incoming.getReceiptRemark().trim();
        }
        if (incoming.getRemark() != null && !incoming.getRemark().isBlank()) {
            return incoming.getRemark().trim();
        }
        return null;
    }

    private void completeIfBothConfirmed(BizHandover handover) {
        if (handover.getStatus() == HandoverStatusEnum.CONFIRMED) {
            return;
        }
        if (handover.getConfirmedByFromAt() == null || handover.getConfirmedByToAt() == null) {
            return;
        }
        handover.setStatus(HandoverStatusEnum.CONFIRMED);
        claimService.completeClaim(handover.getClaimId());
        BizClaim claim = claimService.getClaimById(handover.getClaimId());
        if (claim == null || pointsService == null) {
            return;
        }
        pointsService.awardPoints(claim.getPosterId(), "CLAIM_FINDER", 10, "CLAIM", claim.getId());
        pointsService.awardPoints(claim.getClaimantId(), "CLAIM_OWNER", 5, "CLAIM", claim.getId());
        if (notificationService != null) {
            notificationService.createNotification(
                    claim.getPosterId(),
                    NotificationTypeEnum.CLAIM,
                    "交接已完成",
                    "双方已确认线下交接完成，认领流程已结案。",
                    "CLAIM",
                    claim.getId()
            );
            notificationService.createNotification(
                    claim.getClaimantId(),
                    NotificationTypeEnum.CLAIM,
                    "交接已完成",
                    "双方已确认线下交接完成，认领流程已结案。",
                    "CLAIM",
                    claim.getId()
            );
        }
    }
}
