import type { PageResult } from '@vben/types';

import { requestClient } from '#/api/request';

// 交接类型
export interface BizHandover {
  id?: number;
  claimId?: number;
  giverId?: number;
  giverName?: string;
  receiverId?: number;
  receiverName?: string;
  fromUserId?: number;
  toUserId?: number;
  fromUserName?: string; // 交出方用户名
  toUserName?: string; // 接收方用户名
  handoverTime?: string;
  handoverLocation?: string;
  location?: string; // 交接地点
  confirmCode?: string;
  status?: string;
  giverConfirmed?: number;
  receiverConfirmed?: number;
  confirmedByFromAt?: string; // 交出方确认时间
  confirmedByToAt?: string; // 接收方确认时间
  cancelReason?: string;
  remark?: string;
  receiptSubmittedBy?: number;
  receiptSubmittedAt?: string;
  receiptActualTime?: string;
  receiptLocation?: string;
  receiptEvidenceJson?: string[];
  receiptRemark?: string;
  receiptConfirmedBy?: number;
  receiptConfirmedAt?: string;
  createTime?: string;
  updateTime?: string;
}

// 交接查询参数
export interface HandoverQueryParams {
  pageNum?: number;
  pageSize?: number;
  status?: string;
}

/**
 * 创建交接
 */
async function createHandover(data: BizHandover) {
  return requestClient.post<number>('/lostfound/handover', data);
}

/**
 * 确认交接
 */
async function confirmHandover(id: number, confirmCode?: string) {
  return requestClient.post(`/lostfound/handover/${id}/confirm`, null, {
    params: { confirmCode },
  });
}

/**
 * 提交线下完成回传
 */
async function submitHandoverReceipt(id: number, data: BizHandover) {
  return requestClient.post(`/lostfound/handover/${id}/receipt`, data);
}

/**
 * 确认线下回传
 */
async function confirmHandoverReceipt(id: number) {
  return requestClient.post(`/lostfound/handover/${id}/receipt/confirm`);
}

/**
 * 取消交接
 */
async function cancelHandover(id: number, reason: string) {
  return requestClient.post(`/lostfound/handover/${id}/cancel`, null, {
    params: { reason },
  });
}

/**
 * 改约
 */
async function rescheduleHandover(
  id: number,
  data: Pick<BizHandover, 'handoverTime' | 'location'>,
  reason?: string,
) {
  return requestClient.post(`/lostfound/handover/${id}/reschedule`, data, {
    params: { reason },
  });
}

/**
 * 上报争议
 */
async function disputeHandover(id: number, reason?: string) {
  return requestClient.post(`/lostfound/handover/${id}/dispute`, null, {
    params: { reason },
  });
}

/**
 * 上报爽约
 */
async function markHandoverNoShow(id: number, reason?: string) {
  return requestClient.post(`/lostfound/handover/${id}/no-show`, null, {
    params: { reason },
  });
}

/**
 * 获取交接详情
 */
async function getHandoverById(id: number) {
  return requestClient.get<BizHandover>(`/lostfound/handover/${id}`);
}

/**
 * 获取我的交接记录
 */
async function getMyHandovers(params?: HandoverQueryParams) {
  return requestClient.get<PageResult<BizHandover>>(
    '/lostfound/handover/my',
    { params },
  );
}

/**
 * 根据认领ID获取交接
 */
async function getHandoverByClaimId(claimId: number) {
  return requestClient.get<BizHandover>(`/lostfound/handover/claim/${claimId}`);
}

export {
  cancelHandover,
  confirmHandover,
  confirmHandoverReceipt,
  createHandover,
  disputeHandover,
  getHandoverByClaimId,
  getHandoverById,
  getMyHandovers,
  markHandoverNoShow,
  rescheduleHandover,
  submitHandoverReceipt,
};
