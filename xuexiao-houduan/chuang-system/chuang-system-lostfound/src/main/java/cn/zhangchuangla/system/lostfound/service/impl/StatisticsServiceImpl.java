package cn.zhangchuangla.system.lostfound.service.impl;

import cn.zhangchuangla.system.lostfound.enums.ClaimStatusEnum;
import cn.zhangchuangla.system.lostfound.enums.PostStatusEnum;
import cn.zhangchuangla.system.lostfound.enums.PostTypeEnum;
import cn.zhangchuangla.system.lostfound.enums.ReportStatusEnum;
import cn.zhangchuangla.system.lostfound.mapper.*;
import cn.zhangchuangla.system.lostfound.model.entity.*;
import cn.zhangchuangla.system.lostfound.service.StatisticsService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.*;

/**
 * 统计服务实现类
 *
 * @author Chuang
 */
@Service
@RequiredArgsConstructor
public class StatisticsServiceImpl implements StatisticsService {

    private final BizPostMapper postMapper;
    private final BizClaimMapper claimMapper;
    private final BizCategoryMapper categoryMapper;
    private final BizLocationMapper locationMapper;
    private final BizHandoverMapper handoverMapper;
    private final BizPointsLogMapper pointsLogMapper;
    private final BizReportMapper reportMapper;
    private final BizCommentMapper commentMapper;

    @Override
    public Map<String, Object> getHomeStatistics() {
        Map<String, Object> stats = new HashMap<>();
        
        // 总帖子数（统计所有状态）
        long totalPosts = postMapper.selectCount(null);
        stats.put("totalPosts", totalPosts);
        
        // 寻物启事数（统计所有状态）
        long lostCount = postMapper.selectCount(new LambdaQueryWrapper<BizPost>()
                .eq(BizPost::getPostType, PostTypeEnum.LOST.name()));
        stats.put("lostCount", lostCount);
        
        // 失物招领数（统计所有状态）
        long foundCount = postMapper.selectCount(new LambdaQueryWrapper<BizPost>()
                .eq(BizPost::getPostType, PostTypeEnum.FOUND.name()));
        stats.put("foundCount", foundCount);
        
        // 成功认领数
        long successCount = claimMapper.selectCount(new LambdaQueryWrapper<BizClaim>()
                .eq(BizClaim::getStatus, ClaimStatusEnum.COMPLETED.name()));
        stats.put("successCount", successCount);
        
        // 今日新增
        LocalDateTime todayStart = LocalDateTime.of(LocalDate.now(), LocalTime.MIN);
        long todayPosts = postMapper.selectCount(new LambdaQueryWrapper<BizPost>()
                .ge(BizPost::getCreateTime, todayStart));
        stats.put("todayPosts", todayPosts);
        
        // 本月新增
        LocalDateTime monthStart = LocalDateTime.of(LocalDate.now().withDayOfMonth(1), LocalTime.MIN);
        long monthPosts = postMapper.selectCount(new LambdaQueryWrapper<BizPost>()
                .ge(BizPost::getCreateTime, monthStart));
        stats.put("monthPosts", monthPosts);
        
        return stats;
    }

    @Override
    public Map<String, Object> getUserStatistics(Long userId) {
        Map<String, Object> stats = new HashMap<>();
        
        // 我发布的帖子数
        long myPosts = postMapper.selectCount(new LambdaQueryWrapper<BizPost>()
                .eq(BizPost::getCreatedBy, userId));
        stats.put("myPosts", myPosts);
        
        // 我发起的认领数
        long myClaims = claimMapper.selectCount(new LambdaQueryWrapper<BizClaim>()
                .eq(BizClaim::getClaimantId, userId));
        stats.put("myClaims", myClaims);
        
        // 成功认领数
        long successClaims = claimMapper.selectCount(new LambdaQueryWrapper<BizClaim>()
                .eq(BizClaim::getClaimantId, userId)
                .eq(BizClaim::getStatus, ClaimStatusEnum.COMPLETED.name()));
        stats.put("successClaims", successClaims);
        
        // 帮助他人数（我发布的帖子被成功认领）
        long helpOthers = claimMapper.selectCount(new LambdaQueryWrapper<BizClaim>()
                .eq(BizClaim::getPosterId, userId)
                .eq(BizClaim::getStatus, ClaimStatusEnum.COMPLETED.name()));
        stats.put("helpOthers", helpOthers);
        
        return stats;
    }

    @Override
    public Map<String, Object> getAdminOverview() {
        Map<String, Object> stats = new HashMap<>();
        LocalDate today = LocalDate.now();
        LocalDateTime todayStart = LocalDateTime.of(today, LocalTime.MIN);
        LocalDateTime weekStart = LocalDateTime.of(today.minusDays(7), LocalTime.MIN);
        LocalDateTime monthStart = LocalDateTime.of(today.withDayOfMonth(1), LocalTime.MIN);
        
        // ========== 顶部统计卡片 ==========
        // 今日发布
        long todayPosts = postMapper.selectCount(new LambdaQueryWrapper<BizPost>()
                .ge(BizPost::getCreateTime, todayStart));
        stats.put("todayPosts", todayPosts);
        
        // 待审核帖子数
        long pendingPosts = postMapper.selectCount(new LambdaQueryWrapper<BizPost>()
                .eq(BizPost::getStatus, PostStatusEnum.PENDING.name()));
        stats.put("pendingPosts", pendingPosts);
        
        // 本周找回（本周状态变为CLOSED的帖子）
        long weeklyRecovered = postMapper.selectCount(new LambdaQueryWrapper<BizPost>()
                .eq(BizPost::getStatus, PostStatusEnum.CLOSED.name())
                .ge(BizPost::getUpdateTime, weekStart));
        stats.put("weeklyRecovered", weeklyRecovered);
        
        // 总帖子数（已发布）
        long totalPosts = postMapper.selectCount(new LambdaQueryWrapper<BizPost>()
                .eq(BizPost::getStatus, PostStatusEnum.PUBLISHED.name()));
        stats.put("totalPosts", totalPosts);
        
        // 已找回总数
        long totalRecovered = postMapper.selectCount(new LambdaQueryWrapper<BizPost>()
                .eq(BizPost::getStatus, PostStatusEnum.CLOSED.name()));
        
        // 找回率
        long allPosts = totalPosts + totalRecovered;
        double recoveryRate = allPosts > 0 ? (double) totalRecovered / allPosts * 100 : 0;
        stats.put("recoveryRate", Math.round(recoveryRate));
        
        // ========== 第二行统计卡片 ==========
        // 寻物启事数
        long lostPosts = postMapper.selectCount(new LambdaQueryWrapper<BizPost>()
                .eq(BizPost::getPostType, PostTypeEnum.LOST.name())
                .in(BizPost::getStatus, PostStatusEnum.PUBLISHED.name(), PostStatusEnum.CLOSED.name()));
        stats.put("lostPosts", lostPosts);
        
        // 招领信息数
        long foundPosts = postMapper.selectCount(new LambdaQueryWrapper<BizPost>()
                .eq(BizPost::getPostType, PostTypeEnum.FOUND.name())
                .in(BizPost::getStatus, PostStatusEnum.PUBLISHED.name(), PostStatusEnum.CLOSED.name()));
        stats.put("foundPosts", foundPosts);
        
        // 活跃用户数（本周有发帖或认领的用户）
        // 简化实现：统计本周发帖的不同用户数
        List<BizPost> weekPosts = postMapper.selectList(new LambdaQueryWrapper<BizPost>()
                .ge(BizPost::getCreateTime, weekStart)
                .select(BizPost::getCreatedBy));
        long activeUsers = weekPosts.stream()
                .map(BizPost::getCreatedBy)
                .filter(Objects::nonNull)
                .distinct()
                .count();
        stats.put("activeUsers", activeUsers);
        
        // ========== 待处理事项 ==========
        // 待处理认领（状态为APPLIED的认领）
        long pendingClaims = claimMapper.selectCount(new LambdaQueryWrapper<BizClaim>()
                .eq(BizClaim::getStatus, ClaimStatusEnum.APPLIED.name()));
        stats.put("pendingClaims", pendingClaims);
        
        // 待处理举报（状态为PENDING的举报）
        long pendingReports = reportMapper.selectCount(new LambdaQueryWrapper<BizReport>()
                .eq(BizReport::getStatus, ReportStatusEnum.PENDING));
        stats.put("pendingReports", pendingReports);
        
        // 待审核评论（状态为PENDING的评论）
        long pendingComments = commentMapper.selectCount(new LambdaQueryWrapper<BizComment>()
                .eq(BizComment::getStatus, "PENDING"));
        stats.put("pendingComments", pendingComments);
        
        // ========== 本月数据 ==========
        // 本月新增帖子
        long monthlyPosts = postMapper.selectCount(new LambdaQueryWrapper<BizPost>()
                .ge(BizPost::getCreateTime, monthStart));
        stats.put("monthlyPosts", monthlyPosts);
        
        // 本月成功找回
        long monthlyRecovered = postMapper.selectCount(new LambdaQueryWrapper<BizPost>()
                .eq(BizPost::getStatus, PostStatusEnum.CLOSED.name())
                .ge(BizPost::getUpdateTime, monthStart));
        stats.put("monthlyRecovered", monthlyRecovered);
        
        // 本月新增用户（统计本月有发帖或认领的不同用户数）
        Set<Long> monthlyUserIds = new HashSet<>();
        // 本月发帖用户
        List<BizPost> monthPostUsers = postMapper.selectList(new LambdaQueryWrapper<BizPost>()
                .ge(BizPost::getCreateTime, monthStart)
                .select(BizPost::getCreatedBy));
        monthPostUsers.stream()
                .map(BizPost::getCreatedBy)
                .filter(Objects::nonNull)
                .forEach(monthlyUserIds::add);
        // 本月认领用户
        List<BizClaim> monthClaimUsers = claimMapper.selectList(new LambdaQueryWrapper<BizClaim>()
                .ge(BizClaim::getCreateTime, monthStart)
                .select(BizClaim::getClaimantId));
        monthClaimUsers.stream()
                .map(BizClaim::getClaimantId)
                .filter(Objects::nonNull)
                .forEach(monthlyUserIds::add);
        stats.put("monthlyUsers", monthlyUserIds.size());
        
        // 本月发放积分（统计本月增加的积分总数）
        List<BizPointsLog> monthPointsLogs = pointsLogMapper.selectList(new LambdaQueryWrapper<BizPointsLog>()
                .gt(BizPointsLog::getDelta, 0)
                .ge(BizPointsLog::getCreateTime, monthStart));
        long monthlyPoints = monthPointsLogs.stream()
                .mapToLong(log -> log.getDelta() != null ? log.getDelta() : 0)
                .sum();
        stats.put("monthlyPoints", monthlyPoints);
        
        // ========== 图表相关 ==========
        // 计算近7天最大日发帖数（用于图表缩放）
        long maxDailyPosts = 1;
        for (int i = 0; i < 7; i++) {
            LocalDate date = today.minusDays(i);
            LocalDateTime dayStart = LocalDateTime.of(date, LocalTime.MIN);
            LocalDateTime dayEnd = LocalDateTime.of(date, LocalTime.MAX);
            long dayCount = postMapper.selectCount(new LambdaQueryWrapper<BizPost>()
                    .ge(BizPost::getCreateTime, dayStart)
                    .le(BizPost::getCreateTime, dayEnd));
            if (dayCount > maxDailyPosts) {
                maxDailyPosts = dayCount;
            }
        }
        stats.put("maxDailyPosts", maxDailyPosts);
        
        return stats;
    }

    @Override
    public List<Map<String, Object>> getPostTrend(Integer days) {
        List<Map<String, Object>> trend = new ArrayList<>();
        LocalDate today = LocalDate.now();
        
        for (int i = days - 1; i >= 0; i--) {
            LocalDate date = today.minusDays(i);
            LocalDateTime dayStart = LocalDateTime.of(date, LocalTime.MIN);
            LocalDateTime dayEnd = LocalDateTime.of(date, LocalTime.MAX);
            
            long count = postMapper.selectCount(new LambdaQueryWrapper<BizPost>()
                    .ge(BizPost::getCreateTime, dayStart)
                    .le(BizPost::getCreateTime, dayEnd));
            
            Map<String, Object> item = new HashMap<>();
            item.put("date", date.toString());
            item.put("count", count);
            trend.add(item);
        }
        
        return trend;
    }

    @Override
    public List<Map<String, Object>> getCategoryStats() {
        List<Map<String, Object>> stats = new ArrayList<>();
        
        // 获取所有分类
        var categories = categoryMapper.selectList(null);
        
        for (var category : categories) {
            // 统计所有状态的帖子
            long count = postMapper.selectCount(new LambdaQueryWrapper<BizPost>()
                    .eq(BizPost::getCategoryId, category.getId()));
            
            if (count > 0) {
                Map<String, Object> item = new HashMap<>();
                item.put("categoryId", category.getId());
                item.put("categoryName", category.getName());
                item.put("count", count);
                stats.add(item);
            }
        }
        
        // 按数量降序排序
        stats.sort((a, b) -> Long.compare((Long) b.get("count"), (Long) a.get("count")));
        
        return stats;
    }

    @Override
    public List<Map<String, Object>> getLocationStats() {
        List<Map<String, Object>> stats = new ArrayList<>();
        
        // 获取所有地点
        var locations = locationMapper.selectList(null);
        
        for (var location : locations) {
            // 统计所有状态的帖子
            long count = postMapper.selectCount(new LambdaQueryWrapper<BizPost>()
                    .eq(BizPost::getLocationId, location.getId()));
            
            if (count > 0) {
                Map<String, Object> item = new HashMap<>();
                item.put("locationId", location.getId());
                item.put("locationName", location.getName());
                item.put("count", count);
                stats.add(item);
            }
        }
        
        // 按数量降序排序
        stats.sort((a, b) -> Long.compare((Long) b.get("count"), (Long) a.get("count")));
        
        return stats;
    }

    @Override
    public Map<String, Object> getClaimSuccessRate() {
        Map<String, Object> stats = new HashMap<>();
        
        long totalClaims = claimMapper.selectCount(null);
        long approvedClaims = claimMapper.selectCount(new LambdaQueryWrapper<BizClaim>()
                .in(BizClaim::getStatus,
                        ClaimStatusEnum.APPROVED.name(),
                        ClaimStatusEnum.IN_HANDOVER.name(),
                        ClaimStatusEnum.COMPLETED.name()));
        long successClaims = claimMapper.selectCount(new LambdaQueryWrapper<BizClaim>()
                .eq(BizClaim::getStatus, ClaimStatusEnum.COMPLETED.name()));
        
        double approvedRate = totalClaims > 0 ? (double) approvedClaims / totalClaims * 100 : 0;
        double successRate = totalClaims > 0 ? (double) successClaims / totalClaims * 100 : 0;
        double handoverCompletionRate = approvedClaims > 0 ? (double) successClaims / approvedClaims * 100 : 0;

        stats.put("totalClaims", totalClaims);
        stats.put("approvedClaims", approvedClaims);
        stats.put("successClaims", successClaims);
        stats.put("approvedRate", Math.round(approvedRate * 10) / 10.0);
        stats.put("successRate", Math.round(successRate * 10) / 10.0);
        stats.put("handoverCompletionRate", Math.round(handoverCompletionRate * 10) / 10.0);
        
        return stats;
    }

    @Override
    public Map<String, Object> getOverviewStats(String startDate, String endDate, String type) {
        Map<String, Object> stats = new HashMap<>();
        LocalDateTime startDateTime = startDate != null && !startDate.isEmpty()
                ? LocalDate.parse(startDate).atStartOfDay() : null;
        LocalDateTime endDateTime = endDate != null && !endDate.isEmpty()
                ? LocalDate.parse(endDate).atTime(LocalTime.MAX) : null;
        
        LambdaQueryWrapper<BizPost> postQuery = new LambdaQueryWrapper<>();
        LambdaQueryWrapper<BizClaim> claimQuery = new LambdaQueryWrapper<>();
        
        // 时间范围过滤
        if (startDateTime != null) {
            postQuery.ge(BizPost::getCreateTime, startDateTime);
            claimQuery.ge(BizClaim::getCreateTime, startDateTime);
        }
        if (endDateTime != null) {
            postQuery.le(BizPost::getCreateTime, endDateTime);
            claimQuery.le(BizClaim::getCreateTime, endDateTime);
        }
        
        // 总帖子数
        long totalPosts = postMapper.selectCount(postQuery);
        stats.put("totalPosts", totalPosts);
        
        // 寻物启事数
        long lostPosts = postMapper.selectCount(new LambdaQueryWrapper<BizPost>()
                .eq(BizPost::getPostType, PostTypeEnum.LOST.name())
                .ge(startDateTime != null, BizPost::getCreateTime, startDateTime)
                .le(endDateTime != null, BizPost::getCreateTime, endDateTime));
        stats.put("lostPosts", lostPosts);
        
        // 招领信息数
        long foundPosts = postMapper.selectCount(new LambdaQueryWrapper<BizPost>()
                .eq(BizPost::getPostType, PostTypeEnum.FOUND.name())
                .ge(startDateTime != null, BizPost::getCreateTime, startDateTime)
                .le(endDateTime != null, BizPost::getCreateTime, endDateTime));
        stats.put("foundPosts", foundPosts);
        
        // 审核通过数（包含后续已进入交接/已完成）
        long approvedClaims = claimMapper.selectCount(new LambdaQueryWrapper<BizClaim>()
                .in(BizClaim::getStatus,
                        ClaimStatusEnum.APPROVED.name(),
                        ClaimStatusEnum.IN_HANDOVER.name(),
                        ClaimStatusEnum.COMPLETED.name())
                .ge(startDateTime != null, BizClaim::getCreateTime, startDateTime)
                .le(endDateTime != null, BizClaim::getCreateTime, endDateTime));
        stats.put("approvedClaims", approvedClaims);

        // 交接完成数（兼容历史字段 recoveredCount）
        long completedClaims = claimMapper.selectCount(new LambdaQueryWrapper<BizClaim>()
                .eq(BizClaim::getStatus, ClaimStatusEnum.COMPLETED.name())
                .ge(startDateTime != null, BizClaim::getCreateTime, startDateTime)
                .le(endDateTime != null, BizClaim::getCreateTime, endDateTime));
        stats.put("completedClaims", completedClaims);
        stats.put("recoveredCount", completedClaims);
        
        // 找回率
        double recoveryRate = totalPosts > 0 ? (double) completedClaims / totalPosts * 100 : 0;
        stats.put("recoveryRate", Math.round(recoveryRate * 10) / 10.0);
        
        // 双层口径：审核通过率 + 交接完成率
        long totalClaims = claimMapper.selectCount(claimQuery);
        double approvedRate = totalClaims > 0 ? (double) approvedClaims / totalClaims * 100 : 0;
        double handoverCompletionRate = approvedClaims > 0 ? (double) completedClaims / approvedClaims * 100 : 0;
        stats.put("approvedRate", Math.round(approvedRate * 10) / 10.0);
        stats.put("handoverCompletionRate", Math.round(handoverCompletionRate * 10) / 10.0);

        // 活跃用户数（在时间范围内发帖或认领的用户）
        Set<Long> activeUserIds = new HashSet<>();
        // 统计发帖用户
        LambdaQueryWrapper<BizPost> postUserQuery = new LambdaQueryWrapper<BizPost>()
                .select(BizPost::getCreatedBy)
                .ge(startDateTime != null, BizPost::getCreateTime, startDateTime)
                .le(endDateTime != null, BizPost::getCreateTime, endDateTime);
        List<BizPost> postUsers = postMapper.selectList(postUserQuery);
        postUsers.stream()
                .map(BizPost::getCreatedBy)
                .filter(Objects::nonNull)
                .forEach(activeUserIds::add);
        // 统计认领用户
        LambdaQueryWrapper<BizClaim> claimUserQuery = new LambdaQueryWrapper<BizClaim>()
                .select(BizClaim::getClaimantId)
                .ge(startDateTime != null, BizClaim::getCreateTime, startDateTime)
                .le(endDateTime != null, BizClaim::getCreateTime, endDateTime);
        List<BizClaim> claimUsers = claimMapper.selectList(claimUserQuery);
        claimUsers.stream()
                .map(BizClaim::getClaimantId)
                .filter(Objects::nonNull)
                .forEach(activeUserIds::add);
        stats.put("activeUsers", activeUserIds.size());
        
        // 总认领数
        stats.put("totalClaims", totalClaims);
        
        // 发放积分（统计时间范围内增加的积分总数）
        LambdaQueryWrapper<BizPointsLog> pointsQuery = new LambdaQueryWrapper<BizPointsLog>()
                .gt(BizPointsLog::getDelta, 0)  // 只统计增加的积分
                .ge(startDateTime != null, BizPointsLog::getCreateTime, startDateTime)
                .le(endDateTime != null, BizPointsLog::getCreateTime, endDateTime);
        List<BizPointsLog> pointsLogs = pointsLogMapper.selectList(pointsQuery);
        long totalPoints = pointsLogs.stream()
                .mapToLong(log -> log.getDelta() != null ? log.getDelta() : 0)
                .sum();
        stats.put("totalPoints", totalPoints);
        
        // 最大日发帖数（用于图表缩放）
        stats.put("maxDailyCount", Math.max(10, Math.max(lostPosts, foundPosts) / 7 + 5));
        
        return stats;
    }

    @Override
    public List<Map<String, Object>> getRecoveryStats(String startDate, String endDate, String type) {
        List<Map<String, Object>> stats = new ArrayList<>();
        
        // 默认最近7天
        int days = 7;
        if ("weekly".equals(type)) {
            days = 4; // 4周
        } else if ("monthly".equals(type)) {
            days = 6; // 6个月
        }
        
        LocalDate today = LocalDate.now();
        LocalDate start = startDate != null && !startDate.isEmpty() ? LocalDate.parse(startDate) : today.minusDays(days - 1);
        LocalDate end = endDate != null && !endDate.isEmpty() ? LocalDate.parse(endDate) : today;
        
        for (LocalDate date = start; !date.isAfter(end); date = date.plusDays(1)) {
            LocalDateTime dayStart = date.atStartOfDay();
            LocalDateTime dayEnd = date.atTime(LocalTime.MAX);
            
            // 统计所有状态的帖子
            long lostCount = postMapper.selectCount(new LambdaQueryWrapper<BizPost>()
                    .eq(BizPost::getPostType, PostTypeEnum.LOST.name())
                    .ge(BizPost::getCreateTime, dayStart)
                    .le(BizPost::getCreateTime, dayEnd));
            
            long foundCount = postMapper.selectCount(new LambdaQueryWrapper<BizPost>()
                    .eq(BizPost::getPostType, PostTypeEnum.FOUND.name())
                    .ge(BizPost::getCreateTime, dayStart)
                    .le(BizPost::getCreateTime, dayEnd));
            
            long recoveredCount = claimMapper.selectCount(new LambdaQueryWrapper<BizClaim>()
                    .eq(BizClaim::getStatus, ClaimStatusEnum.COMPLETED.name())
                    .ge(BizClaim::getCreateTime, dayStart)
                    .le(BizClaim::getCreateTime, dayEnd));
            
            Map<String, Object> item = new HashMap<>();
            item.put("date", date.toString());
            item.put("lostCount", lostCount);
            item.put("foundCount", foundCount);
            item.put("recoveredCount", recoveredCount);
            stats.add(item);
        }
        
        return stats;
    }

    @Override
    public List<Map<String, Object>> getCategoryStatsWithParams(String startDate, String endDate) {
        List<Map<String, Object>> stats = new ArrayList<>();
        
        LocalDateTime startDateTime = startDate != null && !startDate.isEmpty() 
                ? LocalDate.parse(startDate).atStartOfDay() : null;
        LocalDateTime endDateTime = endDate != null && !endDate.isEmpty() 
                ? LocalDate.parse(endDate).atTime(LocalTime.MAX) : null;
        
        // 获取所有分类
        var categories = categoryMapper.selectList(null);
        
        for (var category : categories) {
            LambdaQueryWrapper<BizPost> query = new LambdaQueryWrapper<BizPost>()
                    .eq(BizPost::getCategoryId, category.getId());
            
            if (startDateTime != null) {
                query.ge(BizPost::getCreateTime, startDateTime);
            }
            if (endDateTime != null) {
                query.le(BizPost::getCreateTime, endDateTime);
            }
            
            long postCount = postMapper.selectCount(query);
            
            long lostCount = postMapper.selectCount(new LambdaQueryWrapper<BizPost>()
                    .eq(BizPost::getCategoryId, category.getId())
                    .eq(BizPost::getPostType, PostTypeEnum.LOST.name())
                    .ge(startDateTime != null, BizPost::getCreateTime, startDateTime)
                    .le(endDateTime != null, BizPost::getCreateTime, endDateTime));
            
            long foundCount = postMapper.selectCount(new LambdaQueryWrapper<BizPost>()
                    .eq(BizPost::getCategoryId, category.getId())
                    .eq(BizPost::getPostType, PostTypeEnum.FOUND.name())
                    .ge(startDateTime != null, BizPost::getCreateTime, startDateTime)
                    .le(endDateTime != null, BizPost::getCreateTime, endDateTime));
            
            // 统计该分类下成功找回的数量（通过关联帖子和认领表）
            // 先获取该分类下的所有帖子ID
            List<BizPost> categoryPosts = postMapper.selectList(new LambdaQueryWrapper<BizPost>()
                    .eq(BizPost::getCategoryId, category.getId())
                    .select(BizPost::getId)
                    .ge(startDateTime != null, BizPost::getCreateTime, startDateTime)
                    .le(endDateTime != null, BizPost::getCreateTime, endDateTime));
            List<Long> postIds = categoryPosts.stream().map(BizPost::getId).toList();
            
            long recoveredCount = 0;
            if (!postIds.isEmpty()) {
                recoveredCount = claimMapper.selectCount(new LambdaQueryWrapper<BizClaim>()
                        .in(BizClaim::getPostId, postIds)
                        .eq(BizClaim::getStatus, ClaimStatusEnum.COMPLETED.name()));
            }
            
            // 计算找回率
            double recoveryRate = postCount > 0 ? (double) recoveredCount / postCount : 0.0;
            
            Map<String, Object> item = new HashMap<>();
            item.put("categoryId", category.getId());
            item.put("categoryName", category.getName());
            item.put("postCount", postCount);
            item.put("lostCount", lostCount);
            item.put("foundCount", foundCount);
            item.put("recoveredCount", recoveredCount);
            item.put("recoveryRate", recoveryRate);
            stats.add(item);
        }
        
        return stats;
    }

    @Override
    public List<Map<String, Object>> getLocationStatsWithParams(String startDate, String endDate) {
        List<Map<String, Object>> stats = new ArrayList<>();
        
        LocalDateTime startDateTime = startDate != null && !startDate.isEmpty() 
                ? LocalDate.parse(startDate).atStartOfDay() : null;
        LocalDateTime endDateTime = endDate != null && !endDate.isEmpty() 
                ? LocalDate.parse(endDate).atTime(LocalTime.MAX) : null;
        
        // 获取所有地点
        var locations = locationMapper.selectList(null);
        
        for (var location : locations) {
            LambdaQueryWrapper<BizPost> query = new LambdaQueryWrapper<BizPost>()
                    .eq(BizPost::getLocationId, location.getId());
            
            if (startDateTime != null) {
                query.ge(BizPost::getCreateTime, startDateTime);
            }
            if (endDateTime != null) {
                query.le(BizPost::getCreateTime, endDateTime);
            }
            
            long postCount = postMapper.selectCount(query);
            
            long lostCount = postMapper.selectCount(new LambdaQueryWrapper<BizPost>()
                    .eq(BizPost::getLocationId, location.getId())
                    .eq(BizPost::getPostType, PostTypeEnum.LOST.name())
                    .ge(startDateTime != null, BizPost::getCreateTime, startDateTime)
                    .le(endDateTime != null, BizPost::getCreateTime, endDateTime));
            
            long foundCount = postMapper.selectCount(new LambdaQueryWrapper<BizPost>()
                    .eq(BizPost::getLocationId, location.getId())
                    .eq(BizPost::getPostType, PostTypeEnum.FOUND.name())
                    .ge(startDateTime != null, BizPost::getCreateTime, startDateTime)
                    .le(endDateTime != null, BizPost::getCreateTime, endDateTime));
            
            // 统计该地点下成功找回的数量（通过关联帖子和认领表）
            List<BizPost> locationPosts = postMapper.selectList(new LambdaQueryWrapper<BizPost>()
                    .eq(BizPost::getLocationId, location.getId())
                    .select(BizPost::getId)
                    .ge(startDateTime != null, BizPost::getCreateTime, startDateTime)
                    .le(endDateTime != null, BizPost::getCreateTime, endDateTime));
            List<Long> postIds = locationPosts.stream().map(BizPost::getId).toList();
            
            long recoveredCount = 0;
            if (!postIds.isEmpty()) {
                recoveredCount = claimMapper.selectCount(new LambdaQueryWrapper<BizClaim>()
                        .in(BizClaim::getPostId, postIds)
                        .eq(BizClaim::getStatus, ClaimStatusEnum.COMPLETED.name()));
            }
            
            Map<String, Object> item = new HashMap<>();
            item.put("locationId", location.getId());
            item.put("locationName", location.getName());
            item.put("postCount", postCount);
            item.put("lostCount", lostCount);
            item.put("foundCount", foundCount);
            item.put("recoveredCount", recoveredCount);
            stats.add(item);
        }
        
        return stats;
    }

    @Override
    public Map<String, Object> exportStatsData(String startDate, String endDate, String type) {
        Map<String, Object> exportData = new HashMap<>();
        
        // 获取概览统计
        Map<String, Object> overview = getOverviewStats(startDate, endDate, type);
        exportData.put("overview", overview);
        
        // 获取趋势数据
        List<Map<String, Object>> trend = getRecoveryStats(startDate, endDate, type);
        exportData.put("trend", trend);
        
        // 获取分类统计
        List<Map<String, Object>> categoryStats = getCategoryStatsWithParams(startDate, endDate);
        exportData.put("categoryStats", categoryStats);
        
        // 获取地点统计
        List<Map<String, Object>> locationStats = getLocationStatsWithParams(startDate, endDate);
        exportData.put("locationStats", locationStats);
        
        // 添加导出时间和时间范围
        exportData.put("exportTime", LocalDateTime.now().toString());
        exportData.put("startDate", startDate);
        exportData.put("endDate", endDate);
        exportData.put("type", type);
        
        return exportData;
    }
}

