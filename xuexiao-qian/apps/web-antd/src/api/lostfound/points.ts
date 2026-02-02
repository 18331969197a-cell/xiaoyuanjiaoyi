import type { PageResult } from '@vben/types';

import { requestClient } from '#/api/request';

// 积分记录类型
export interface BizPointsLog {
  id?: number;
  userId?: number;
  action?: string;
  delta?: number;
  balance?: number;
  relatedType?: string;
  relatedId?: number;
  remark?: string;
  createBy?: number;
  createTime?: string;
}

// 积分记录类型（别名，兼容前端页面使用）
export interface PointsLog {
  id?: number;
  userId?: number;
  type?: string; // 对应后端 action
  points?: number; // 对应后端 delta
  description?: string; // 对应后端 remark
  createTime?: string;
}

// 积分信息类型（与后端 PointsInfoVO 对应）
export interface PointsInfo {
  points?: number;
  level?: number;
  totalEarned?: number;
  totalSpent?: number;
  nextLevelPoints?: number;
}

// 用户积分类型（管理员查看）
export interface UserPointsVO {
  userId?: number;
  userName?: string;
  nickname?: string;
  totalPoints?: number;
  availablePoints?: number;
  usedPoints?: number;
  level?: number;
  createTime?: string;
}

// 调整积分参数
export interface AdjustPointsParams {
  userId: number;
  points: number;
  reason: string;
}

/**
 * 获取我的积分信息
 */
async function getMyPoints(): Promise<PointsInfo> {
  return requestClient.get<PointsInfo>('/lostfound/points/my');
}

/**
 * 获取积分记录
 */
async function getPointsRecords(params?: {
  pageNum?: number;
  pageSize?: number;
}): Promise<PageResult<PointsLog>> {
  const res = await requestClient.get<PageResult<BizPointsLog>>(
    '/lostfound/points/records',
    { params },
  );
  // 兼容两种返回格式: MyBatis-Plus的records和标准的rows
  const records = (res as any).records || res.rows || [];
  // 转换字段名以匹配前端页面使用
  return {
    ...res,
    rows: records.map((item: BizPointsLog) => ({
      id: item.id,
      userId: item.userId,
      type: item.action,
      points: item.delta,
      description: item.remark,
      createTime: item.createTime,
    })),
  };
}

/**
 * 获取积分记录（别名）
 */
const getPointsLogs = getPointsRecords;

/**
 * 获取积分排行榜
 */
async function getPointsRanking(limit?: number) {
  return requestClient.get('/lostfound/points/ranking', { params: { limit } });
}

// ==================== 管理员接口 ====================

/**
 * 管理员-获取所有用户积分列表
 */
async function adminGetUserPointsList(params?: {
  pageNum?: number;
  pageSize?: number;
  userName?: string;
}) {
  const res = await requestClient.get<PageResult<UserPointsVO>>(
    '/lostfound/points/admin/list',
    { params },
  );
  // 转换为VxeGrid期望的格式
  return {
    rows: res.records || [],
    total: res.total || 0,
  };
}

/**
 * 管理员-调整用户积分
 */
async function adminAdjustPoints(data: AdjustPointsParams) {
  return requestClient.post('/lostfound/points/admin/adjust', data);
}

export {
  adminAdjustPoints,
  adminGetUserPointsList,
  getMyPoints,
  getPointsLogs,
  getPointsRanking,
  getPointsRecords,
  getMyPoints as getUserPoints,
};
