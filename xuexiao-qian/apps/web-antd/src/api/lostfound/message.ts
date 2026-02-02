import type { PageResult } from '@vben/types';

import { requestClient } from '#/api/request';

// 消息会话类型
export interface BizMsgThread {
  id?: number;
  user1Id?: number;
  user2Id?: number;
  postId?: number;
  lastMessageId?: number;
  lastMessageContent?: string;
  lastMessageTime?: string;
  user1Unread?: number;
  user2Unread?: number;
  createTime?: string;
  // 扩展字段
  targetUserId?: number;
  targetUserName?: string;
  targetUserAvatar?: string;
  unreadCount?: number;
}

// 消息会话类型（别名）
export type MessageThread = BizMsgThread;

// 消息类型
export interface BizMessage {
  id?: number;
  threadId?: number;
  senderId?: number;
  senderName?: string;
  receiverId?: number;
  content?: string;
  messageType?: string;
  isRead?: number;
  createTime?: string;
}

/**
 * 发送私信
 */
async function sendMessage(data: BizMessage) {
  return requestClient.post<number>('/lostfound/message', data);
}

/**
 * 获取会话列表
 */
async function getThreads(params?: { pageNum?: number; pageSize?: number }) {
  return requestClient.get<PageResult<BizMsgThread>>(
    '/lostfound/message/threads',
    { params },
  );
}

/**
 * 获取会话列表（别名）
 */
const getThreadList = getThreads;

/**
 * 获取会话消息
 */
async function getThreadMessages(threadId: number) {
  return requestClient.get<BizMessage[]>(
    `/lostfound/message/thread/${threadId}`,
  );
}

/**
 * 标记消息已读
 */
async function markAsRead(threadId: number) {
  return requestClient.post(`/lostfound/message/thread/${threadId}/read`);
}

/**
 * 获取未读消息数
 */
async function getUnreadCount() {
  return requestClient.get<number>('/lostfound/message/unread-count');
}

/**
 * 创建或获取会话
 */
async function getOrCreateThread(targetUserId: number, postId?: number) {
  return requestClient.post<number>('/lostfound/message/thread', null, {
    params: { targetUserId, postId },
  });
}

/**
 * 获取会话详情
 */
async function getThreadDetail(threadId: number) {
  return requestClient.get<BizMsgThread>(
    `/lostfound/message/thread/${threadId}/detail`,
  );
}

export {
  getOrCreateThread,
  getThreadDetail,
  getThreadList,
  getThreadMessages,
  getThreads,
  getUnreadCount,
  markAsRead,
  sendMessage,
};
