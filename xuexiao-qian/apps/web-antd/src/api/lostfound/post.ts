import type { PageResult } from '@vben/types';

import { requestClient } from '#/api/request';
import { normalizePageResult } from '#/api/utils/page';

// 帖子类型
export interface BizPost {
  id?: number;
  postType?: string;
  title?: string;
  description?: string;
  imagesJson?: string | string[];
  rewardAmount?: number;
  rewardStatus?: string;
  rewardDesc?: string;
  featureTokens?: string[];
  categoryId?: number;
  categoryName?: string;
  locationId?: number;
  locationName?: string;
  lostTime?: string;
  foundTime?: string;
  occurTime?: string;
  contactInfo?: string;
  storageLocation?: string;
  storagePlace?: string;
  status?: string;
  viewCount?: number;
  favoriteCount?: number;
  favCount?: number;
  commentCount?: number;
  isTop?: boolean | number;
  isRecommend?: boolean | number;
  userId?: number;
  createdBy?: number;
  userName?: string;
  createdByName?: string;
  createTime?: string;
  auditAt?: string;
  reviewAt?: string;
  updateTime?: string;
}

// 帖子查询参数
export interface PostQueryParams {
  pageNum?: number;
  pageSize?: number;
  postType?: string;
  status?: string;
  categoryId?: number;
  locationId?: number;
  keyword?: string;
}

// 帖子创建参数
export interface PostCreateParams {
  postType?: string;
  title?: string;
  description?: string;
  imagesJson?: string[];
  rewardAmount?: number;
  rewardDesc?: string;
  featureTokens?: string[];
  categoryId?: number;
  locationId?: number;
  occurTime?: string;
  storagePlace?: string;
  contactInfo?: string;
}

// 帖子列表项（用于前端展示）
export interface PostListItem extends BizPost {
  type?: string;
  images?: string[];
  itemName?: string;
  eventTime?: string; // 事件时间（丢失/拾取时间）
}

// 帖子搜索参数
export interface PostSearchParams {
  pageNum?: number;
  pageSize?: number;
  keyword?: string;
  postType?: string;
  type?: string;
  categoryId?: number;
  locationId?: number;
  status?: string;
  startDate?: string;
  endDate?: string;
  startTime?: string;
  endTime?: string;
  sortBy?: string;
  sortOrder?: string;
}

/**
 * 获取帖子列表
 */
async function getPostList(params?: PostQueryParams) {
  const res = await requestClient.get<PageResult<BizPost>>(
    '/lostfound/post/list',
    {
      params,
    },
  );
  return normalizePageResult(res, params);
}

/**
 * 搜索帖子
 */
async function searchPosts(params: PostSearchParams) {
  const res = await requestClient.get<PageResult<PostListItem>>(
    '/lostfound/post/search',
    {
      params,
    },
  );
  return normalizePageResult(res, params);
}

/**
 * 获取帖子详情
 */
async function getPostById(id: number) {
  return requestClient.get<BizPost>(`/lostfound/post/${id}`);
}

/**
 * 发布帖子
 */
async function createPost(data: PostCreateParams) {
  return requestClient.post<number>('/lostfound/post', data);
}

/**
 * 更新帖子
 */
async function updatePost(data: BizPost) {
  return requestClient.put('/lostfound/post', data);
}

/**
 * 删除帖子
 */
async function deletePost(id: number) {
  return requestClient.delete(`/lostfound/post/${id}`);
}

/**
 * 保存草稿
 */
async function saveDraft(data: PostCreateParams) {
  return requestClient.post<number>('/lostfound/post/draft', data);
}

/**
 * 提交草稿审核
 */
async function submitDraft(id: number) {
  return requestClient.post(`/lostfound/post/draft/${id}/submit`);
}

// MyBatis-Plus 分页结果类型
export interface MybatisPlusPage<T> {
  records: T[];
  total: number;
  size: number;
  current: number;
  pages: number;
}

/**
 * 获取我的帖子
 */
async function getMyPosts(params?: {
  pageNum?: number;
  pageSize?: number;
  postType?: string;
  status?: string;
}) {
  return requestClient.get<MybatisPlusPage<BizPost>>('/lostfound/post/my', {
    params,
  });
}

/**
 * 获取我的草稿
 */
async function getMyDrafts() {
  return requestClient.get<BizPost[]>('/lostfound/post/my/drafts');
}

// ========== 管理端接口 ==========

/**
 * 管理端获取帖子列表
 */
async function adminGetPostList(params?: PostQueryParams) {
  const res = await requestClient.get<PageResult<BizPost>>(
    '/lostfound/post/admin/list',
    {
      params,
    },
  );
  return normalizePageResult(res, params);
}

/**
 * 审核通过
 */
async function approvePost(id: number) {
  return requestClient.post(`/lostfound/post/${id}/approve`);
}

/**
 * 审核拒绝
 */
async function rejectPost(id: number, reason: string) {
  return requestClient.post(`/lostfound/post/${id}/reject`, null, {
    params: { reason },
  });
}

/**
 * 下架帖子
 */
async function offlinePost(id: number) {
  return requestClient.post(`/lostfound/post/${id}/offline`);
}

/**
 * 设置置顶
 */
async function setPostTop(id: number, isTop: boolean) {
  return requestClient.put(`/lostfound/post/${id}/top/${isTop}`);
}

/**
 * 设置推荐
 */
async function setPostRecommend(id: number, isRecommend: boolean) {
  return requestClient.put(`/lostfound/post/${id}/recommend/${isRecommend}`);
}

/**
 * 获取热门搜索词
 */
async function getHotSearchKeywords(limit: number = 10) {
  return requestClient.get<string[]>('/lostfound/post/hot-search', {
    params: { limit },
  });
}

export {
  adminGetPostList,
  approvePost,
  createPost,
  deletePost,
  getHotSearchKeywords,
  getMyDrafts,
  getMyPosts,
  getPostById,
  getPostList,
  offlinePost,
  rejectPost,
  saveDraft,
  searchPosts,
  setPostRecommend,
  setPostTop,
  submitDraft,
  updatePost,
};
