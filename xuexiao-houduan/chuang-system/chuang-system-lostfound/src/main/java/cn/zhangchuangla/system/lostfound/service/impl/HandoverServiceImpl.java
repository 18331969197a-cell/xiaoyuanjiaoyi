package cn.zhangchuangla.system.lostfound.service.impl;

import cn.zhangchuangla.system.lostfound.enums.HandoverStatusEnum;
import cn.zhangchuangla.common.core.exception.BusinessException;
import cn.zhangchuangla.common.core.exception.ErrorCode;
import cn.zhangchuangla.system.lostfound.mapper.BizHandoverMapper;
import cn.zhangchuangla.system.lostfound.model.entity.BizClaim;
import cn.zhangchuangla.system.lostfound.model.entity.BizHandover;
import cn.zhangchuangla.system.lostfound.service.ClaimService;
import cn.zhangchuangla.system.lostfound.service.HandoverService;
import cn.zhangchuangla.system.lostfound.service.PointsService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

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

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createHandover(BizHandover handover, Long userId) {
        // 获取认领单信息
        BizClaim claim = claimService.getClaimById(handover.getClaimId());
        if (claim == null) {
            throw new BusinessException(ErrorCode.CLAIM_NOT_FOUND);
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
        
        return handover.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void confirmHandover(Long handoverId, Long userId) {
        BizHandover handover = handoverMapper.selectById(handoverId);
        if (handover == null) {
            throw new BusinessException(ErrorCode.DATA_NOT_FOUND, "交接记录不存在");
        }
        // 判断是交出方还是接收方确认
        if (handover.getFromUserId().equals(userId)) {
            handover.setConfirmedByFromAt(LocalDateTime.now());
        } else if (handover.getToUserId().equals(userId)) {
            handover.setConfirmedByToAt(LocalDateTime.now());
        } else {
            throw new BusinessException(ErrorCode.OPERATION_NOT_ALLOWED, "无权确认此交接");
        }
        // 检查是否双方都已确认
        if (handover.getConfirmedByFromAt() != null && handover.getConfirmedByToAt() != null) {
            handover.setStatus(HandoverStatusEnum.CONFIRMED);
            // 完成认领
            claimService.completeClaim(handover.getClaimId());
            // 奖励积分
            BizClaim claim = claimService.getClaimById(handover.getClaimId());
            if (claim != null && pointsService != null) {
                // 拾到者奖励
                pointsService.awardPoints(claim.getPosterId(), "CLAIM_FINDER", 10, "CLAIM", claim.getId());
                // 失主奖励
                pointsService.awardPoints(claim.getClaimantId(), "CLAIM_OWNER", 5, "CLAIM", claim.getId());
            }
        }
        handoverMapper.updateById(handover);
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
}
