import type { PageResult } from '@vben/types';

import { requestClient } from '#/api/request';

// 礼品分类类型
export interface GiftCategory {
  id?: number;
  name?: string;
  sort?: number;
  status?: number;
  createdAt?: string;
  updatedAt?: string;
}

// 礼品类型
export interface Gift {
  id?: number;
  categoryId?: number;
  name?: string;
  description?: string;
  imagesJson?: string[];
  pointsCost?: number;
  stock?: number;
  giftType?: 'PHYSICAL' | 'VIRTUAL';
  virtualContent?: string;
  status?: 'OFF' | 'ON';
  exchangeCount?: number;
  sort?: number;
  createdBy?: number;
  createdAt?: string;
  updatedAt?: string;
}

// 兑换订单类型
export interface ExchangeOrder {
  id?: number;
  orderNo?: string;
  userId?: number;
  giftId?: number;
  giftName?: string;
  giftType?: 'PHYSICAL' | 'VIRTUAL';
  pointsCost?: number;
  quantity?: number;
  status?: 'CANCELLED' | 'COMPLETED' | 'PENDING' | 'SHIPPED';
  receiverName?: string;
  receiverPhone?: string;
  receiverAddress?: string;
  trackingNo?: string;
  shippedAt?: string;
  virtualContent?: string;
  completedAt?: string;
  cancelledAt?: string;
  cancelReason?: string;
  createdAt?: string;
  updatedAt?: string;
}

// 兑换参数
export interface ExchangeParams {
  giftId: number;
  quantity?: number;
  receiverName?: string;
  receiverPhone?: string;
  receiverAddress?: string;
}

// ==================== 用户端接口 ====================

/**
 * 获取礼品列表
 */
async function getGiftList(params?: {
  categoryId?: number;
  keyword?: string;
  pageNum?: number;
  pageSize?: number;
}): Promise<PageResult<Gift>> {
  const res = await requestClient.get<PageResult<Gift>>('/lostfound/gifts', {
    params,
  });
  return {
    rows: (res as any).records || res.rows || [],
    total: res.total || 0,
  };
}

/**
 * 获取礼品详情
 */
async function getGiftDetail(id: number): Promise<Gift> {
  return requestClient.get<Gift>(`/lostfound/gifts/${id}`);
}

/**
 * 获取礼品分类列表（用户端，仅启用的）
 */
async function getGiftCategories(): Promise<GiftCategory[]> {
  return requestClient.get<GiftCategory[]>('/lostfound/gifts/categories');
}

/**
 * 兑换礼品
 */
async function exchangeGift(data: ExchangeParams): Promise<number> {
  return requestClient.post<number>('/lostfound/exchange', data);
}

/**
 * 获取我的兑换记录
 */
async function getMyExchangeOrders(params?: {
  pageNum?: number;
  pageSize?: number;
  status?: string;
}): Promise<PageResult<ExchangeOrder>> {
  const res = await requestClient.get<PageResult<ExchangeOrder>>(
    '/lostfound/exchange/my',
    { params },
  );
  return {
    rows: (res as any).records || res.rows || [],
    total: res.total || 0,
  };
}

/**
 * 获取订单详情
 */
async function getExchangeOrderDetail(id: number): Promise<ExchangeOrder> {
  return requestClient.get<ExchangeOrder>(`/lostfound/exchange/${id}`);
}

/**
 * 确认收货
 */
async function confirmReceive(id: number): Promise<void> {
  return requestClient.put(`/lostfound/exchange/${id}/confirm`);
}

export {
  confirmReceive,
  exchangeGift,
  getExchangeOrderDetail,
  getGiftCategories,
  getGiftDetail,
  getGiftList,
  getMyExchangeOrders,
};

export type { ExchangeOrder, ExchangeParams, Gift, GiftCategory };
