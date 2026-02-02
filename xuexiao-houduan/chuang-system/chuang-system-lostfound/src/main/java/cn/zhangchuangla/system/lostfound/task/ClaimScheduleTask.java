package cn.zhangchuangla.system.lostfound.task;

import cn.zhangchuangla.system.lostfound.enums.ClaimStatusEnum;
import cn.zhangchuangla.system.lostfound.enums.NotificationTypeEnum;
import cn.zhangchuangla.system.lostfound.mapper.BizClaimMapper;
import cn.zhangchuangla.system.lostfound.model.entity.BizClaim;
import cn.zhangchuangla.system.lostfound.service.NotificationService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 认领单定时任务
 * 
 * @author Chuang
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class ClaimScheduleTask {

    private final BizClaimMapper claimMapper;
    private final NotificationService notificationService;
    
    /**
     * 认领单自动取消
     * 每天凌晨3点执行，将超过7天未处理的认领单自动取消
     */
    @Scheduled(cron = "0 0 3 * * ?")
    @Transactional(rollbackFor = Exception.class)
    public void autoCancelExpiredClaims() {
        log.info("开始执行认领单自动取消任务...");
        
        // 查询超过7天未处理的待审核认领单
        LocalDateTime expireTime = LocalDateTime.now().minusDays(7);
        
        LambdaQueryWrapper<BizClaim> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(BizClaim::getStatus, ClaimStatusEnum.APPLIED)
                .lt(BizClaim::getCreateTime, expireTime);
        
        List<BizClaim> expiredClaims = claimMapper.selectList(queryWrapper);
        
        if (expiredClaims.isEmpty()) {
            log.info("没有需要取消的过期认领单");
            return;
        }
        
        // 批量更新状态为已取消
        for (BizClaim claim : expiredClaims) {
            LambdaUpdateWrapper<BizClaim> updateWrapper = new LambdaUpdateWrapper<>();
            updateWrapper.eq(BizClaim::getId, claim.getId())
                    .set(BizClaim::getStatus, ClaimStatusEnum.CANCELLED)
                    .set(BizClaim::getReviewReason, "超时未处理，系统自动取消");
            claimMapper.update(null, updateWrapper);
            
            // 发送通知给认领申请人
            try {
                notificationService.createNotification(
                    claim.getClaimantId(),
                    NotificationTypeEnum.CLAIM,
                    "认领申请已自动取消",
                    "您的认领申请因超过7天未被处理，已自动取消。如需继续认领，请重新提交申请。",
                    "CLAIM",
                    claim.getId()
                );
            } catch (Exception e) {
                log.warn("发送取消通知失败: claimId={}", claim.getId(), e);
            }
        }
        
        log.info("认领单自动取消任务完成，共取消 {} 条认领单", expiredClaims.size());
    }
}
