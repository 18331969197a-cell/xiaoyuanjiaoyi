package cn.zhangchuangla.system.lostfound.service.impl;

import cn.zhangchuangla.system.lostfound.enums.ClaimStatusEnum;
import cn.zhangchuangla.system.lostfound.enums.NotificationTypeEnum;
import cn.zhangchuangla.system.lostfound.enums.PostStatusEnum;
import cn.zhangchuangla.system.lostfound.enums.RewardStatusEnum;
import cn.zhangchuangla.system.lostfound.mapper.BizClaimMapper;
import cn.zhangchuangla.system.lostfound.mapper.BizPostMapper;
import cn.zhangchuangla.system.lostfound.model.entity.BizClaim;
import cn.zhangchuangla.system.lostfound.model.entity.BizPost;
import cn.zhangchuangla.system.lostfound.service.ClaimService;
import cn.zhangchuangla.system.lostfound.service.NotificationService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Objects;
import java.util.Collections;
import java.util.List;

/**
 * 认领服务实现
 *
 * @author Chuang
 */
@Service
@RequiredArgsConstructor
public class ClaimServiceImpl implements ClaimService {

    private final BizClaimMapper claimMapper;
    private final BizPostMapper postMapper;
    @Lazy
    private final NotificationService notificationService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createClaim(BizClaim claim, Long claimantId) {
        // 获取帖子信息
        BizPost post = postMapper.selectById(claim.getPostId());
        if (post == null) {
            throw new RuntimeException("帖子不存在");
        }
        if (post.getStatus() != PostStatusEnum.PUBLISHED && post.getStatus() != PostStatusEnum.CLAIMING) {
            throw new RuntimeException("该帖子当前状态不允许认领");
        }
        // 设置认领信息
        claim.setClaimantId(claimantId);
        claim.setPosterId(post.getCreatedBy());
        // 自动匹配评分：如果存在拾得者特征与认领人答案，计算简单重合度
        int matchScore = computeMatchScore(post.getFeatureTokens(), claim.getFeatureAnswers());
        claim.setAutoMatchScore(matchScore);
        LocalDateTime now = LocalDateTime.now();
        claim.setStatus(ClaimStatusEnum.APPROVED);
        claim.setReviewBy(post.getCreatedBy());
        claim.setReviewAt(now);
        claim.setReviewReason("系统自动通过");
        claim.setCreateTime(now);
        claimMapper.insert(claim);

        // 自动通过后，帖子进入认领中
        post.setStatus(PostStatusEnum.CLAIMING);
        postMapper.updateById(post);

        // 自动通过后通知双方
        if (notificationService != null) {
            notificationService.createNotification(
                    post.getCreatedBy(),
                    NotificationTypeEnum.CLAIM,
                    "收到新的认领申请（已自动通过）",
                    "您发布的「" + post.getTitle() + "」有新的认领，系统已自动通过，请尽快发起交接。",
                    "CLAIM",
                    claim.getId()
            );
            notificationService.createNotification(
                    claimantId,
                    NotificationTypeEnum.CLAIM,
                    "认领申请已自动通过",
                    "您对「" + post.getTitle() + "」的认领申请已自动通过，请与发布者沟通交接。",
                    "CLAIM",
                    claim.getId()
            );
        }
        
        return claim.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void appendProof(Long claimId, String proofText, List<String> proofImagesJson, Long userId) {
        BizClaim claim = claimMapper.selectById(claimId);
        if (claim == null) {
            throw new RuntimeException("认领单不存在");
        }
        if (!claim.getClaimantId().equals(userId)) {
            throw new RuntimeException("无权操作此认领单");
        }
        claim.setProofText(proofText);
        claim.setProofImagesJson(proofImagesJson);
        claim.setStatus(ClaimStatusEnum.APPROVED);
        claim.setReviewBy(claim.getPosterId());
        claim.setReviewAt(LocalDateTime.now());
        claim.setReviewReason("补充佐证后系统自动通过");
        claimMapper.updateById(claim);

        BizPost post = postMapper.selectById(claim.getPostId());
        if (post != null) {
            post.setStatus(PostStatusEnum.CLAIMING);
            postMapper.updateById(post);
            if (notificationService != null) {
                notificationService.createNotification(
                        claim.getPosterId(),
                        NotificationTypeEnum.CLAIM,
                        "认领补充材料已自动通过",
                        "认领人已补充佐证并自动通过，请尽快发起交接。",
                        "CLAIM",
                        claimId
                );
                notificationService.createNotification(
                        claim.getClaimantId(),
                        NotificationTypeEnum.CLAIM,
                        "补充佐证已通过",
                        "您补充的佐证已自动通过，请与发布者沟通交接。",
                        "CLAIM",
                        claimId
                );
            }
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void cancelClaim(Long claimId, Long userId) {
        BizClaim claim = claimMapper.selectById(claimId);
        if (claim == null) {
            throw new RuntimeException("认领单不存在");
        }
        if (!claim.getClaimantId().equals(userId)) {
            throw new RuntimeException("无权操作此认领单");
        }
        if (claim.getStatus() == ClaimStatusEnum.COMPLETED) {
            throw new RuntimeException("已完成的认领单无法取消");
        }
        claim.setStatus(ClaimStatusEnum.CANCELLED);
        claimMapper.updateById(claim);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void approveClaim(Long claimId, Long posterId) {
        BizClaim claim = claimMapper.selectById(claimId);
        if (claim == null) {
            throw new RuntimeException("认领单不存在");
        }
        if (!claim.getPosterId().equals(posterId)) {
            throw new RuntimeException("无权操作此认领单");
        }
        // 更新认领状态
        claim.setStatus(ClaimStatusEnum.APPROVED);
        claim.setReviewBy(posterId);
        claim.setReviewAt(LocalDateTime.now());
        claimMapper.updateById(claim);
        // 更新帖子状态为认领中
        BizPost post = postMapper.selectById(claim.getPostId());
        if (post != null) {
            post.setStatus(PostStatusEnum.CLAIMING);
            postMapper.updateById(post);
            
            // 发送通知给认领人
            if (notificationService != null) {
                notificationService.createNotification(
                    claim.getClaimantId(),
                    NotificationTypeEnum.CLAIM,
                    "认领申请已通过",
                    "您对「" + post.getTitle() + "」的认领申请已通过，请与发布者联系进行交接。",
                    "CLAIM",
                    claimId
                );
            }
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void rejectClaim(Long claimId, String reason, Long posterId) {
        BizClaim claim = claimMapper.selectById(claimId);
        if (claim == null) {
            throw new RuntimeException("认领单不存在");
        }
        if (!claim.getPosterId().equals(posterId)) {
            throw new RuntimeException("无权操作此认领单");
        }
        claim.setStatus(ClaimStatusEnum.REJECTED);
        claim.setReviewBy(posterId);
        claim.setReviewAt(LocalDateTime.now());
        claim.setReviewReason(reason);
        claimMapper.updateById(claim);
        
        // 发送通知给认领人
        BizPost post = postMapper.selectById(claim.getPostId());
        if (notificationService != null && post != null) {
            notificationService.createNotification(
                claim.getClaimantId(),
                NotificationTypeEnum.CLAIM,
                "认领申请未通过",
                "您对「" + post.getTitle() + "」的认领申请未通过，原因：" + reason,
                "CLAIM",
                claimId
            );
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void completeClaim(Long claimId) {
        BizClaim claim = claimMapper.selectById(claimId);
        if (claim == null) {
            throw new RuntimeException("认领单不存在");
        }
        // 更新认领状态
        claim.setStatus(ClaimStatusEnum.COMPLETED);
        claim.setCompletedAt(LocalDateTime.now());
        claimMapper.updateById(claim);
        // 更新帖子状态为已结案
        BizPost post = postMapper.selectById(claim.getPostId());
        if (post == null) {
            post = new BizPost();
            post.setId(claim.getPostId());
        }
        post.setStatus(PostStatusEnum.CLOSED);
        postMapper.updateById(post);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void confirmRewardPaid(Long claimId, Long userId) {
        BizClaim claim = claimMapper.selectById(claimId);
        if (claim == null) {
            throw new RuntimeException("认领单不存在");
        }
        if (!Objects.equals(claim.getPosterId(), userId)) {
            throw new RuntimeException("无权确认悬赏发放");
        }
        if (claim.getStatus() != ClaimStatusEnum.COMPLETED) {
            throw new RuntimeException("认领未完成，无法确认悬赏发放");
        }
        BizPost post = postMapper.selectById(claim.getPostId());
        if (post == null) {
            throw new RuntimeException("帖子不存在");
        }
        BigDecimal rewardAmount = post.getRewardAmount();
        if (rewardAmount == null || rewardAmount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new RuntimeException("该帖子未设置悬赏");
        }
        if (post.getRewardStatus() == RewardStatusEnum.PAID) {
            return;
        }
        if (post.getRewardStatus() == RewardStatusEnum.REFUND) {
            throw new RuntimeException("悬赏已退款，无法发放");
        }
        post.setRewardStatus(RewardStatusEnum.PAID);
        postMapper.updateById(post);
        claim.setRewardPayAt(LocalDateTime.now());
        claimMapper.updateById(claim);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void refundReward(Long claimId, Long userId) {
        BizClaim claim = claimMapper.selectById(claimId);
        if (claim == null) {
            throw new RuntimeException("认领单不存在");
        }
        if (!Objects.equals(claim.getPosterId(), userId)) {
            throw new RuntimeException("无权处理悬赏退款");
        }
        BizPost post = postMapper.selectById(claim.getPostId());
        if (post == null) {
            throw new RuntimeException("帖子不存在");
        }
        BigDecimal rewardAmount = post.getRewardAmount();
        if (rewardAmount == null || rewardAmount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new RuntimeException("该帖子未设置悬赏");
        }
        if (post.getRewardStatus() == RewardStatusEnum.PAID) {
            throw new RuntimeException("悬赏已发放，无法退款");
        }
        if (post.getRewardStatus() == RewardStatusEnum.REFUND) {
            return;
        }
        post.setRewardStatus(RewardStatusEnum.REFUND);
        postMapper.updateById(post);
    }

    @Override
    public BizClaim getClaimById(Long claimId) {
        return claimMapper.selectClaimDetailById(claimId);
    }

    @Override
    public Page<BizClaim> getUserClaims(Page<BizClaim> page, Long userId, ClaimStatusEnum status) {
        String statusStr = status != null ? status.name() : null;
        return claimMapper.selectUserClaimsWithPost(page, userId, statusStr);
    }

    @Override
    public Page<BizClaim> getReceivedClaims(Page<BizClaim> page, Long userId, ClaimStatusEnum status) {
        String statusStr = status != null ? status.name() : null;
        return claimMapper.selectReceivedClaimsWithPost(page, userId, statusStr);
    }

    @Override
    public List<BizClaim> getClaimsByPostId(Long postId) {
        LambdaQueryWrapper<BizClaim> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(BizClaim::getPostId, postId);
        wrapper.orderByDesc(BizClaim::getCreateTime);
        return claimMapper.selectList(wrapper);
    }

    @Override
    public Page<BizClaim> adminList(Page<BizClaim> page, ClaimStatusEnum status) {
        String statusStr = status != null ? status.name() : null;
        return claimMapper.selectAdminClaimsWithPost(page, statusStr);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void startHandover(Long claimId) {
        BizClaim claim = claimMapper.selectById(claimId);
        if (claim == null) {
            throw new RuntimeException("认领单不存在");
        }
        if (claim.getStatus() != ClaimStatusEnum.APPROVED) {
            throw new RuntimeException("当前认领状态不允许发起交接");
        }
        claim.setStatus(ClaimStatusEnum.IN_HANDOVER);
        claimMapper.updateById(claim);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void reopenFromHandover(Long claimId) {
        BizClaim claim = claimMapper.selectById(claimId);
        if (claim == null) {
            throw new RuntimeException("认领单不存在");
        }
        if (claim.getStatus() != ClaimStatusEnum.IN_HANDOVER) {
            return;
        }
        claim.setStatus(ClaimStatusEnum.APPROVED);
        claimMapper.updateById(claim);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void adminApproveClaim(Long claimId, Long adminId) {
        BizClaim claim = claimMapper.selectById(claimId);
        if (claim == null) {
            throw new RuntimeException("认领单不存在");
        }
        // 更新认领状态
        claim.setStatus(ClaimStatusEnum.APPROVED);
        claim.setReviewBy(adminId);
        claim.setReviewAt(LocalDateTime.now());
        claimMapper.updateById(claim);
        // 更新帖子状态为认领中
        BizPost post = postMapper.selectById(claim.getPostId());
        if (post != null) {
            post.setStatus(PostStatusEnum.CLAIMING);
            postMapper.updateById(post);
            
            // 发送通知给认领人
            if (notificationService != null) {
                notificationService.createNotification(
                    claim.getClaimantId(),
                    NotificationTypeEnum.CLAIM,
                    "认领申请已通过",
                    "您对「" + post.getTitle() + "」的认领申请已通过，请与发布者联系进行交接。",
                    "CLAIM",
                    claimId
                );
            }
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void adminRejectClaim(Long claimId, String reason, Long adminId) {
        BizClaim claim = claimMapper.selectById(claimId);
        if (claim == null) {
            throw new RuntimeException("认领单不存在");
        }
        claim.setStatus(ClaimStatusEnum.REJECTED);
        claim.setReviewBy(adminId);
        claim.setReviewAt(LocalDateTime.now());
        claim.setReviewReason(reason);
        claimMapper.updateById(claim);
        
        // 发送通知给认领人
        BizPost post = postMapper.selectById(claim.getPostId());
        if (notificationService != null && post != null) {
            notificationService.createNotification(
                claim.getClaimantId(),
                NotificationTypeEnum.CLAIM,
                "认领申请未通过",
                "您对「" + post.getTitle() + "」的认领申请未通过" + (reason != null ? "，原因：" + reason : ""),
                "CLAIM",
                claimId
            );
        }
    }

    /**
     * 计算认领信息与拾得者特征的简单匹配得分（0-100）
     */
    private int computeMatchScore(List<String> featureTokens, List<String> featureAnswers) {
        List<String> tokens = featureTokens != null ? featureTokens : Collections.emptyList();
        List<String> answers = featureAnswers != null ? featureAnswers : Collections.emptyList();
        if (tokens.isEmpty() || answers.isEmpty()) {
            return 0;
        }
        int matched = 0;
        for (String token : tokens) {
            for (String answer : answers) {
                if (answer != null && token != null && answer.toLowerCase().contains(token.toLowerCase())) {
                    matched++;
                    break;
                }
            }
        }
        int score = (int) Math.round((matched * 1.0 / tokens.size()) * 100);
        return Math.min(100, Math.max(0, score));
    }
}
