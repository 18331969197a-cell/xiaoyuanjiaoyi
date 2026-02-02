import type { PageResult } from '@vben/types';

import type { ExchangeOrder, Gift, GiftCategory } from './gifts';

import { requestClient } from '#/api/request';

// ==================== 管理端礼品接口 ====================

/**
 * 获取礼品列表（管理端）
 */
async function adminGetGiftList(params?: {
  categoryId?: number;
  keyword?: string;
  pageNum?: number;
  pageSize?: number;
  status?: string;
}): Promise<PageResult<Gift>> {
  const res = await requestClient.get<PageResult<Gift>>(
    '/lostfound/admin/gifts',
    { params },
  );
  return {
    rows: (res as any).records || res.rows || [],
    total: res.total || 0,
  };
}

/**
 * 获取礼品详情（管理端）
 */
async function adminGetGiftDetail(id: number): Promise<Gift> {
  return requestClient.get<Gift>(`/lostfound/admin/gifts/${id}`);
}

/**
 * 新增礼品
 */
async function adminCreateGift(data: Gift): Promise<number> {
  return requestClient.post<number>('/lostfound/admin/gifts', data);
}

/**
 * 编辑礼品
 */
async function adminUpdateGift(id: number, data: Gift): Promise<void> {
  return requestClient.put(`/lostfound/admin/gifts/${id}`, data);
}

/**
 * 上架/下架礼品
 */
async function adminUpdateGiftStatus(
  id: number,
  status: string,
): Promise<void> {
  return requestClient.put(`/lostfound/admin/gifts/${id}/status`, null, {
    params: { status },
  });
}

/**
 * 删除礼品
 */
async function adminDeleteGift(id: number): Promise<void> {
  return requestClient.delete(`/lostfound/admin/gifts/${id}`);
}

// ==================== 管理端分类接口 ====================

/**
 * 获取分类列表（管理端）
 */
async function adminGetCategoryList(params?: {
  pageNum?: number;
  pageSize?: number;
}): Promise<PageResult<GiftCategory>> {
  const res = await requestClient.get<any>(
    '/lostfound/admin/gifts/categories',
    { params },
  );
  // 后端直接返回数组或分页对象
  const data = Array.isArray(res)
    ? res
    : res.records || res.rows || res.data || [];
  return {
    rows: data,
    total: Array.isArray(res) ? data.length : res.total || data.length,
  };
}

/**
 * 新增分类
 */
async function adminCreateCategory(data: GiftCategory): Promise<number> {
  return requestClient.post<number>('/lostfound/admin/gifts/categories', data);
}

/**
 * 编辑分类
 */
async function adminUpdateCategory(
  id: number,
  data: GiftCategory,
): Promise<void> {
  return requestClient.put(`/lostfound/admin/gifts/categories/${id}`, data);
}

/**
 * 删除分类
 */
async function adminDeleteCategory(id: number): Promise<void> {
  return requestClient.delete(`/lostfound/admin/gifts/categories/${id}`);
}

// ==================== 管理端订单接口 ====================

/**
 * 获取订单列表（管理端）
 */
async function adminGetOrderList(params?: {
  orderNo?: string;
  pageNum?: number;
  pageSize?: number;
  status?: string;
  userId?: number;
}): Promise<PageResult<ExchangeOrder>> {
  const res = await requestClient.get<PageResult<ExchangeOrder>>(
    '/lostfound/admin/exchange/orders',
    { params },
  );
  return {
    rows: (res as any).records || res.rows || [],
    total: res.total || 0,
  };
}

/**
 * 获取订单详情（管理端）
 */
async function adminGetOrderDetail(id: number): Promise<ExchangeOrder> {
  return requestClient.get<ExchangeOrder>(
    `/lostfound/admin/exchange/orders/${id}`,
  );
}

/**
 * 发货
 */
async function adminShipOrder(id: number, trackingNo: string): Promise<void> {
  return requestClient.put(`/lostfound/admin/exchange/orders/${id}/ship`, {
    trackingNo,
  });
}

/**
 * 取消订单
 */
async function adminCancelOrder(
  id: number,
  cancelReason: string,
): Promise<void> {
  return requestClient.put(`/lostfound/admin/exchange/orders/${id}/cancel`, {
    cancelReason,
  });
}

export {
  adminCancelOrder,
  adminCreateCategory,
  adminCreateGift,
  adminDeleteCategory,
  adminDeleteGift,
  adminGetCategoryList,
  adminGetGiftDetail,
  adminGetGiftList,
  adminGetOrderDetail,
  adminGetOrderList,
  adminShipOrder,
  adminUpdateCategory,
  adminUpdateGift,
  adminUpdateGiftStatus,
};
