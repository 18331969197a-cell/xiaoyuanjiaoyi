package cn.zhangchuangla.system.lostfound.service.impl;

import cn.zhangchuangla.system.lostfound.enums.ClaimStatusEnum;
import cn.zhangchuangla.common.core.exception.BusinessException;
import cn.zhangchuangla.common.core.exception.ErrorCode;
import cn.zhangchuangla.system.lostfound.mapper.BizEvaluationMapper;
import cn.zhangchuangla.system.lostfound.model.entity.BizClaim;
import cn.zhangchuangla.system.lostfound.model.entity.BizEvaluation;
import cn.zhangchuangla.system.lostfound.model.entity.BizHandover;
import cn.zhangchuangla.system.lostfound.service.ClaimService;
import cn.zhangchuangla.system.lostfound.service.EvaluationService;
import cn.zhangchuangla.system.lostfound.service.HandoverService;
import cn.zhangchuangla.system.lostfound.service.PointsService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 评价服务实现
 *
 * @author Chuang
 */
@Service
@RequiredArgsConstructor
public class EvaluationServiceImpl implements EvaluationService {

    private final BizEvaluationMapper evaluationMapper;
    @Lazy
    private final ClaimService claimService;
    @Lazy
    private final PointsService pointsService;
    @Lazy
    private final HandoverService handoverService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createEvaluation(BizEvaluation evaluation, Long userId) {
        // 如果传入的是handoverId，需要先查找对应的claimId
        Long claimId = evaluation.getClaimId();
        if (claimId == null && evaluation.getHandoverId() != null) {
            BizHandover handover = handoverService.getHandoverById(evaluation.getHandoverId());
            if (handover == null) {
                throw new BusinessException(ErrorCode.DATA_NOT_FOUND, "交接记录不存在");
            }
            claimId = handover.getClaimId();
            evaluation.setClaimId(claimId);
        }
        
        if (claimId == null) {
            throw new BusinessException(ErrorCode.PARAM_ERROR, "认领单ID不能为空");
        }
        
        BizClaim claim = claimService.getClaimById(claimId);
        if (claim == null) {
            throw new BusinessException(ErrorCode.CLAIM_NOT_FOUND);
        }
        if (claim.getStatus() != ClaimStatusEnum.COMPLETED) {
            throw new BusinessException(ErrorCode.CLAIM_STATUS_ERROR, "只有已完成的认领单才能评价");
        }
        // 检查是否已评价
        if (hasEvaluated(claimId, userId)) {
            throw new BusinessException(ErrorCode.DATA_ALREADY_EXISTS, "您已评价过");
        }
        // 确定被评价人
        Long toUserId;
        if (claim.getPosterId().equals(userId)) {
            toUserId = claim.getClaimantId();
        } else if (claim.getClaimantId().equals(userId)) {
            toUserId = claim.getPosterId();
        } else {
            throw new BusinessException(ErrorCode.OPERATION_NOT_ALLOWED, "无权评价此认领单");
        }
        evaluation.setFromUserId(userId);
        evaluation.setToUserId(toUserId);
        evaluation.setCreateTime(LocalDateTime.now());
        evaluationMapper.insert(evaluation);
        // 好评奖励积分
        if (evaluation.getScore() >= 4 && pointsService != null) {
            pointsService.awardPoints(toUserId, "POSITIVE_EVAL", 2, "EVALUATION", evaluation.getId());
        }
        return evaluation.getId();
    }

    @Override
    public List<BizEvaluation> getEvaluationsByClaimId(Long claimId) {
        LambdaQueryWrapper<BizEvaluation> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(BizEvaluation::getClaimId, claimId);
        return evaluationMapper.selectList(wrapper);
    }

    @Override
    public boolean hasEvaluated(Long claimId, Long userId) {
        LambdaQueryWrapper<BizEvaluation> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(BizEvaluation::getClaimId, claimId);
        wrapper.eq(BizEvaluation::getFromUserId, userId);
        return evaluationMapper.selectCount(wrapper) > 0;
    }
}
