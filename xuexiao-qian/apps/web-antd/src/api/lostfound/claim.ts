import type { PageResult } from '@vben/types';

import { requestClient } from '#/api/request';
import { normalizePageResult } from '#/api/utils/page';

// 认领类型
export interface BizClaim {
  id?: number;
  postId?: number;
  claimantId?: number; // 认领人ID
  claimerId?: number; // 兼容旧字段
  claimerName?: string;
  claimantName?: string; // 认领人用户名
  posterId?: number; // 发布者ID
  ownerId?: number; // 兼容旧字段
  ownerName?: string;
  posterName?: string; // 发布者用户名
  proofText?: string;
  proofImagesJson?: string | string[];
  featureAnswers?: string[]; // 失主补充特征
  autoMatchScore?: number;
  rewardPayAt?: string;
  status?: string;
  rejectReason?: string;
  reviewReason?: string;
  reviewBy?: number;
  reviewAt?: string;
  completedAt?: string;
  createTime?: string;
  updateTime?: string;
  // 关联帖子信息
  postTitle?: string;
  postType?: string;
}

// 认领列表项（兼容旧格式）
export interface ClaimListItem extends BizClaim {
  post?: {
    itemName?: string;
    type?: string;
  };
}

// 认领查询参数
export interface ClaimQueryParams {
  pageNum?: number;
  pageSize?: number;
  status?: string;
}

/**
 * 发起认领
 */
async function createClaim(data: BizClaim) {
  return requestClient.post<number>('/lostfound/claim', data);
}

/**
 * 补充佐证
 */
async function appendProof(
  id: number,
  data: { proofImagesJson?: string; proofText?: string },
) {
  return requestClient.put(`/lostfound/claim/${id}/proof`, data);
}

/**
 * 取消认领
 */
async function cancelClaim(id: number) {
  return requestClient.post(`/lostfound/claim/${id}/cancel`);
}

/**
 * 同意认领
 */
async function approveClaim(id: number) {
  return requestClient.post(`/lostfound/claim/${id}/approve`);
}

/**
 * 拒绝认领
 */
async function rejectClaim(id: number, reason: string) {
  return requestClient.post(`/lostfound/claim/${id}/reject`, null, {
    params: { reason },
  });
}

/**
 * 获取认领详情
 */
async function getClaimById(id: number) {
  return requestClient.get<BizClaim>(`/lostfound/claim/${id}`);
}

/**
 * 获取我发起的认领
 */
async function getMyClaims(params?: ClaimQueryParams) {
  const res = await requestClient.get<PageResult<ClaimListItem>>(
    '/lostfound/claim/my',
    {
      params,
    },
  );
  return normalizePageResult(res, params);
}

/**
 * 获取我收到的认领
 */
async function getReceivedClaims(params?: ClaimQueryParams) {
  const res = await requestClient.get<PageResult<ClaimListItem>>(
    '/lostfound/claim/received',
    { params },
  );
  return normalizePageResult(res, params);
}

/**
 * 获取帖子的认领列表
 */
async function getClaimsByPostId(postId: number) {
  return requestClient.get<BizClaim[]>(`/lostfound/claim/post/${postId}`);
}

// ========== 管理端接口 ==========

/**
 * 管理员获取认领列表
 */
async function adminGetClaimList(params?: ClaimQueryParams) {
  return requestClient.get<any>('/lostfound/claim/admin/list', { params });
}

/**
 * 管理员审核通过认领
 */
async function adminApproveClaim(id: number) {
  return requestClient.post(`/lostfound/claim/admin/${id}/approve`);
}

/**
 * 管理员拒绝认领
 */
async function adminRejectClaim(id: number, reason?: string) {
  return requestClient.post(`/lostfound/claim/admin/${id}/reject`, null, {
    params: { reason },
  });
}

/**
 * 管理员完成认领
 */
async function adminCompleteClaim(id: number) {
  return requestClient.post(`/lostfound/claim/admin/${id}/complete`);
}

/**
 * 线下确认悬赏发放
 */
async function confirmRewardPaid(id: number) {
  return requestClient.post(`/lostfound/claim/${id}/reward/paid`);
}

/**
 * 线下悬赏退款（撤销托管）
 */
async function refundReward(id: number) {
  return requestClient.post(`/lostfound/claim/${id}/reward/refund`);
}

export {
  adminApproveClaim,
  adminCompleteClaim,
  adminGetClaimList,
  adminRejectClaim,
  appendProof,
  approveClaim,
  cancelClaim,
  confirmRewardPaid,
  createClaim,
  getClaimById,
  getClaimsByPostId,
  getMyClaims,
  getReceivedClaims,
  refundReward,
  rejectClaim,
};
