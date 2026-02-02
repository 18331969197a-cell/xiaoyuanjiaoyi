import { requestClient } from '#/api/request';

// 统计数据类型
export interface HomeStatistics {
  totalPosts?: number;
  lostCount?: number;
  foundCount?: number;
  successCount?: number;
  todayPosts?: number;
}

export interface UserStatistics {
  myPosts?: number;
  myClaims?: number;
  successClaims?: number;
  helpOthers?: number;
}

export interface AdminOverview extends HomeStatistics {
  pendingPosts?: number;
  weekPosts?: number;
  monthPosts?: number;
}

export interface TrendItem {
  date?: string;
  count?: number;
}

export interface CategoryStat {
  categoryId?: number;
  categoryName?: string;
  count?: number;
}

export interface LocationStat {
  locationId?: number;
  locationName?: string;
  count?: number;
}

export interface ClaimSuccessRate {
  totalClaims?: number;
  successClaims?: number;
  successRate?: number;
}

export interface StatsParams {
  startDate?: string;
  endDate?: string;
  type?: string;
}

export interface OverviewStats {
  totalPosts?: number;
  lostPosts?: number;
  foundPosts?: number;
  recoveredCount?: number;
  recoveryRate?: number;
  activeUsers?: number;
  totalClaims?: number;
  totalPoints?: number;
  maxDailyCount?: number;
}

export interface RecoveryStatItem {
  date?: string;
  lostCount?: number;
  foundCount?: number;
  recoveredCount?: number;
}

/**
 * 获取首页统计数据
 */
async function getHomeStatistics() {
  return requestClient.get<HomeStatistics>('/lostfound/statistics/home');
}

/**
 * 获取我的统计数据
 */
async function getMyStatistics() {
  return requestClient.get<UserStatistics>('/lostfound/statistics/my');
}

// ========== 管理端接口 ==========

/**
 * 获取管理端统计概览
 */
async function getAdminOverview() {
  return requestClient.get<AdminOverview>(
    '/lostfound/statistics/admin/overview',
  );
}

/**
 * 获取帖子趋势统计
 */
async function getPostTrend(days?: number) {
  return requestClient.get<TrendItem[]>(
    '/lostfound/statistics/admin/post-trend',
    {
      params: { days },
    },
  );
}

/**
 * 获取分类统计
 */
async function getCategoryStats(params?: StatsParams) {
  return requestClient.get<CategoryStat[]>(
    '/lostfound/statistics/admin/category-stats',
    { params },
  );
}

/**
 * 获取地点统计
 */
async function getLocationStats(params?: StatsParams) {
  return requestClient.get<LocationStat[]>(
    '/lostfound/statistics/admin/location-stats',
    { params },
  );
}

/**
 * 获取分类统计（带时间范围）
 */
async function getCategoryStatsDetail(params?: StatsParams) {
  return requestClient.get<CategoryStat[]>(
    '/lostfound/statistics/admin/category-stats-detail',
    { params },
  );
}

/**
 * 获取地点统计（带时间范围）
 */
async function getLocationStatsDetail(params?: StatsParams) {
  return requestClient.get<LocationStat[]>(
    '/lostfound/statistics/admin/location-stats-detail',
    { params },
  );
}

/**
 * 获取认领成功率统计
 */
async function getClaimSuccessRate() {
  return requestClient.get<ClaimSuccessRate>(
    '/lostfound/statistics/admin/claim-success-rate',
  );
}

/**
 * 获取统计概览
 */
async function getOverviewStats(params?: StatsParams) {
  return requestClient.get<OverviewStats>(
    '/lostfound/statistics/admin/overview-stats',
    { params },
  );
}

/**
 * 获取找回趋势统计
 */
async function getRecoveryStats(params?: StatsParams) {
  return requestClient.get<RecoveryStatItem[]>(
    '/lostfound/statistics/admin/recovery-stats',
    { params },
  );
}

/**
 * 导出统计报表
 */
async function exportStats(params?: StatsParams) {
  return requestClient.get('/lostfound/statistics/admin/export', {
    params,
  });
}

export {
  exportStats,
  getAdminOverview,
  getCategoryStats,
  getCategoryStatsDetail,
  getClaimSuccessRate,
  getHomeStatistics,
  getLocationStats,
  getLocationStatsDetail,
  getMyStatistics,
  getOverviewStats,
  getPostTrend,
  getRecoveryStats,
};
