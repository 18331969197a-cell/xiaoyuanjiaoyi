import type { PageResult } from '@vben/types';

import type { BizPost } from './post';

import { requestClient } from '#/api/request';

/**
 * 添加收藏
 */
async function addFavorite(postId: number) {
  return requestClient.post(`/lostfound/favorite/${postId}`);
}

/**
 * 取消收藏
 */
async function removeFavorite(postId: number) {
  return requestClient.delete(`/lostfound/favorite/${postId}`);
}

/**
 * 检查是否已收藏
 */
async function isFavorited(postId: number) {
  return requestClient.get<boolean>(`/lostfound/favorite/${postId}/check`);
}

/**
 * 批量检查收藏状态
 * @param postIds 帖子ID数组
 * @returns 收藏状态映射 { postId: boolean }
 */
async function batchCheckFavorited(postIds: number[]) {
  if (!postIds || postIds.length === 0) {
    return {};
  }
  return requestClient.post<Record<number, boolean>>(
    '/lostfound/favorite/batch-check',
    postIds,
  );
}

/**
 * 获取我的收藏列表
 */
async function getMyFavorites(params?: {
  pageNum?: number;
  pageSize?: number;
}) {
  return requestClient.get<PageResult<BizPost[]>>('/lostfound/favorite/my', {
    params,
  });
}

export {
  addFavorite,
  batchCheckFavorited,
  getMyFavorites,
  isFavorited,
  removeFavorite,
};
