package cn.zhangchuangla.system.lostfound.service.impl;

import cn.zhangchuangla.common.core.entity.security.SysUser;
import cn.zhangchuangla.system.lostfound.enums.NotificationTypeEnum;
import cn.zhangchuangla.system.lostfound.mapper.BizPointsLogMapper;
import cn.zhangchuangla.system.lostfound.model.entity.BizPointsLog;
import cn.zhangchuangla.system.lostfound.model.vo.PointsInfoVO;
import cn.zhangchuangla.system.lostfound.model.vo.UserPointsVO;
import cn.zhangchuangla.system.lostfound.service.NotificationService;
import cn.zhangchuangla.system.lostfound.service.PointsService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * 积分服务实现
 *
 * @author Chuang
 */
@Service
@RequiredArgsConstructor
public class PointsServiceImpl implements PointsService {

    private final BizPointsLogMapper pointsLogMapper;
    
    @Autowired(required = false)
    private BaseMapper<SysUser> sysUserMapper;
    
    @Lazy
    @Autowired(required = false)
    private NotificationService notificationService;

    // 等级积分阈值
    private static final int[] LEVEL_THRESHOLDS = {0, 100, 500, 1000, 2000};

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void awardPoints(Long userId, String action, int delta, String relatedType, Long relatedId) {
        // 获取当前积分
        int currentPoints = getUserPoints(userId);
        int newPoints = currentPoints + delta;
        
        // 更新用户积分
        updateUserPoints(userId, newPoints);
        
        // 记录积分流水
        BizPointsLog log = new BizPointsLog();
        log.setUserId(userId);
        log.setAction(action);
        log.setDelta(delta);
        log.setBalance(newPoints);
        log.setRelatedType(relatedType);
        log.setRelatedId(relatedId);
        log.setCreateTime(LocalDateTime.now());
        pointsLogMapper.insert(log);
        
        // 发送积分获得通知（排除兑换退款，因为兑换服务会单独发通知）
        if (!"EXCHANGE".equals(action) && !"REFUND".equals(action)) {
            sendPointsNotification(userId, action, delta, newPoints);
        }
    }

    /**
     * 发送积分变动通知
     */
    private void sendPointsNotification(Long userId, String action, int delta, int balance) {
        if (notificationService == null) {
            return;
        }
        try {
            String title;
            String content;
            if (delta > 0) {
                title = "积分获得";
                String reason = getActionDescription(action);
                content = "您通过" + reason + "获得了" + delta + "积分，当前积分：" + balance;
            } else {
                title = "积分扣除";
                String reason = getActionDescription(action);
                content = "您因" + reason + "扣除了" + Math.abs(delta) + "积分，当前积分：" + balance;
            }
            notificationService.createNotification(userId, NotificationTypeEnum.POINTS, title, content, "POINTS", null);
        } catch (Exception e) {
            // 通知发送失败不影响主流程
        }
    }

    /**
     * 获取积分操作描述
     */
    private String getActionDescription(String action) {
        if (action == null) return "其他操作";
        switch (action) {
            case "SIGN_IN": return "每日签到";
            case "POST_RESOLVED": return "帖子被解决";
            case "CLAIM_SUCCESS": return "成功认领";
            case "HELP_OTHERS": return "帮助他人";
            case "ADMIN_ADJUST": return "管理员调整";
            case "REFUND": return "订单退款";
            default: return "其他操作";
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deductPoints(Long userId, String action, int delta, String reason) {
        int currentPoints = getUserPoints(userId);
        int newPoints = Math.max(0, currentPoints - delta);
        
        updateUserPoints(userId, newPoints);
        
        BizPointsLog log = new BizPointsLog();
        log.setUserId(userId);
        log.setAction(action);
        log.setDelta(-delta);
        log.setBalance(newPoints);
        log.setRemark(reason);
        log.setCreateTime(LocalDateTime.now());
        pointsLogMapper.insert(log);
    }

    @Override
    public int getUserPoints(Long userId) {
        if (sysUserMapper == null) {
            return 0;
        }
        SysUser user = sysUserMapper.selectById(userId);
        return user != null && user.getPoints() != null ? user.getPoints() : 0;
    }

    @Override
    public PointsInfoVO getUserPointsInfo(Long userId) {
        PointsInfoVO vo = new PointsInfoVO();
        
        // 获取当前积分
        int points = getUserPoints(userId);
        vo.setPoints(points);
        
        // 计算等级
        int level = calculateLevel(points);
        vo.setLevel(level);
        
        // 下一等级所需积分
        vo.setNextLevelPoints(getNextLevelPoints(level));
        
        // 统计累计获得和消耗
        Integer totalEarned = pointsLogMapper.sumEarnedPoints(userId);
        Integer totalSpent = pointsLogMapper.sumSpentPoints(userId);
        vo.setTotalEarned(totalEarned != null ? totalEarned : 0);
        vo.setTotalSpent(totalSpent != null ? totalSpent : 0);
        
        return vo;
    }

    @Override
    public Page<BizPointsLog> getPointsLogs(Page<BizPointsLog> page, Long userId) {
        LambdaQueryWrapper<BizPointsLog> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(BizPointsLog::getUserId, userId);
        wrapper.orderByDesc(BizPointsLog::getCreateTime);
        return pointsLogMapper.selectPage(page, wrapper);
    }

    @Override
    public int calculateLevel(int points) {
        for (int i = LEVEL_THRESHOLDS.length - 1; i >= 0; i--) {
            if (points >= LEVEL_THRESHOLDS[i]) {
                return i + 1;
            }
        }
        return 1;
    }

    @Override
    public int getNextLevelPoints(int level) {
        if (level >= LEVEL_THRESHOLDS.length) {
            return LEVEL_THRESHOLDS[LEVEL_THRESHOLDS.length - 1];
        }
        return LEVEL_THRESHOLDS[level];
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void adminAdjustPoints(Long userId, int delta, String reason, Long adminId) {
        int currentPoints = getUserPoints(userId);
        int newPoints = Math.max(0, currentPoints + delta);
        
        updateUserPoints(userId, newPoints);
        
        BizPointsLog log = new BizPointsLog();
        log.setUserId(userId);
        log.setAction("ADMIN_ADJUST");
        log.setDelta(delta);
        log.setBalance(newPoints);
        log.setRemark(reason);
        log.setCreateBy(adminId);
        log.setCreateTime(LocalDateTime.now());
        pointsLogMapper.insert(log);
    }

    private void updateUserPoints(Long userId, int newPoints) {
        if (sysUserMapper == null) {
            return;
        }
        SysUser user = new SysUser();
        user.setUserId(userId);
        user.setPoints(newPoints);
        user.setLevel(calculateLevel(newPoints));
        sysUserMapper.updateById(user);
    }

    @Override
    public java.util.List<java.util.Map<String, Object>> getPointsRanking(Integer limit) {
        // 简化实现，实际应该通过 SQL 查询用户积分排行
        java.util.List<java.util.Map<String, Object>> ranking = new java.util.ArrayList<>();
        // TODO: 实现积分排行榜查询
        return ranking;
    }

    @Override
    public Page<UserPointsVO> adminGetUserPointsList(Page<UserPointsVO> page, String userName) {
        if (sysUserMapper == null) {
            return page;
        }
        
        // 查询用户列表
        LambdaQueryWrapper<SysUser> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SysUser::getIsDeleted, "0");
        if (StringUtils.hasText(userName)) {
            wrapper.like(SysUser::getUsername, userName);
        }
        wrapper.orderByDesc(SysUser::getPoints);
        
        // 分页查询用户
        Page<SysUser> userPage = new Page<>(page.getCurrent(), page.getSize());
        Page<SysUser> userResult = sysUserMapper.selectPage(userPage, wrapper);
        
        // 转换为VO
        List<UserPointsVO> voList = new ArrayList<>();
        for (SysUser user : userResult.getRecords()) {
            UserPointsVO vo = new UserPointsVO();
            vo.setUserId(user.getUserId());
            vo.setUserName(user.getUsername());
            vo.setNickname(user.getNickname());
            vo.setTotalPoints(user.getPoints() != null ? user.getPoints() : 0);
            vo.setAvailablePoints(user.getPoints() != null ? user.getPoints() : 0);
            vo.setUsedPoints(0); // 可以通过积分日志计算
            vo.setLevel(user.getLevel() != null ? user.getLevel() : 1);
            vo.setCreateTime(user.getCreateTime());
            
            // 计算已使用积分
            Integer spent = pointsLogMapper.sumSpentPoints(user.getUserId());
            vo.setUsedPoints(spent != null ? spent : 0);
            
            voList.add(vo);
        }
        
        // 设置返回结果
        page.setRecords(voList);
        page.setTotal(userResult.getTotal());
        
        return page;
    }
}
