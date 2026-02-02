package cn.zhangchuangla.system.lostfound.service;

import java.util.List;
import java.util.Map;

/**
 * 统计服务接口
 *
 * @author Chuang
 */
public interface StatisticsService {

    /**
     * 获取首页统计数据
     */
    Map<String, Object> getHomeStatistics();

    /**
     * 获取用户统计数据
     */
    Map<String, Object> getUserStatistics(Long userId);

    /**
     * 获取管理端统计概览
     */
    Map<String, Object> getAdminOverview();

    /**
     * 获取帖子趋势统计
     */
    List<Map<String, Object>> getPostTrend(Integer days);

    /**
     * 获取分类统计
     */
    List<Map<String, Object>> getCategoryStats();

    /**
     * 获取地点统计
     */
    List<Map<String, Object>> getLocationStats();

    /**
     * 获取认领成功率统计
     */
    Map<String, Object> getClaimSuccessRate();

    /**
     * 获取统计概览（带时间范围）
     */
    Map<String, Object> getOverviewStats(String startDate, String endDate, String type);

    /**
     * 获取找回趋势统计
     */
    List<Map<String, Object>> getRecoveryStats(String startDate, String endDate, String type);

    /**
     * 获取分类统计（带时间范围）
     */
    List<Map<String, Object>> getCategoryStatsWithParams(String startDate, String endDate);

    /**
     * 获取地点统计（带时间范围）
     */
    List<Map<String, Object>> getLocationStatsWithParams(String startDate, String endDate);

    /**
     * 导出统计报表数据
     */
    Map<String, Object> exportStatsData(String startDate, String endDate, String type);
}
