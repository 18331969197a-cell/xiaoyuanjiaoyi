import { requestClient } from '#/api/request';

// 评论类型
export interface BizComment {
  id?: number;
  postId?: number;
  userId?: number;
  userName?: string;
  userAvatar?: string;
  parentId?: number;
  replyToUserId?: number;
  replyToUserName?: string;
  content?: string;
  likeCount?: number;
  createTime?: string;
  // 子评论
  children?: BizComment[];
}

/**
 * 发表评论
 */
async function createComment(data: BizComment) {
  return requestClient.post<number>('/lostfound/comment', data);
}

/**
 * 删除评论
 */
async function deleteComment(id: number) {
  return requestClient.delete(`/lostfound/comment/${id}`);
}

/**
 * 获取帖子评论列表
 */
async function getCommentsByPostId(postId: number) {
  const res = await requestClient.get<any>(`/lostfound/comment/post/${postId}`);
  // 兼容分页格式和数组格式
  if (res && res.records) {
    return res.records as BizComment[];
  }
  return (res || []) as BizComment[];
}

/**
 * 点赞评论
 */
async function likeComment(id: number) {
  return requestClient.post(`/lostfound/comment/${id}/like`);
}

// ========== 管理端接口 ==========

/**
 * 管理员获取评论列表
 */
async function adminGetCommentList(params?: {
  pageNum?: number;
  pageSize?: number;
  status?: string;
}) {
  return requestClient.get<any>('/lostfound/comment/admin/list', { params });
}

/**
 * 管理员审核通过评论
 */
async function adminApproveComment(id: number) {
  return requestClient.post(`/lostfound/comment/admin/${id}/approve`);
}

/**
 * 管理员拒绝评论
 */
async function adminRejectComment(id: number, reason?: string) {
  return requestClient.post(`/lostfound/comment/admin/${id}/reject`, null, {
    params: { reason },
  });
}

/**
 * 管理员删除评论
 */
async function adminDeleteComment(id: number) {
  return requestClient.delete(`/lostfound/comment/admin/${id}`);
}

export {
  adminApproveComment,
  adminDeleteComment,
  adminGetCommentList,
  adminRejectComment,
  createComment,
  deleteComment,
  getCommentsByPostId,
  likeComment,
};
