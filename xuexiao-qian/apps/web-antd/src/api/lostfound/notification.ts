import type { PageResult } from '@vben/types';

import { requestClient } from '#/api/request';

// 通知类型枚举
export const NotificationType = {
  SYSTEM: 'SYSTEM',
  AUDIT: 'AUDIT',
  CLAIM: 'CLAIM',
  REPORT: 'REPORT',
  POINTS: 'POINTS',
  VERIFICATION: 'VERIFICATION',
  ANNOUNCEMENT: 'ANNOUNCEMENT',
  COMMENT: 'COMMENT',
  POST: 'POST',
} as const;

// 通知类型配置（标签和颜色）
export const NotificationTypeConfig: Record<
  string,
  { color: string; icon: string; label: string }
> = {
  SYSTEM: { label: '系统通知', color: 'blue', icon: 'mdi:bell' },
  AUDIT: { label: '审核通知', color: 'orange', icon: 'mdi:file-check' },
  CLAIM: { label: '认领通知', color: 'green', icon: 'mdi:hand-extended' },
  REPORT: { label: '举报通知', color: 'red', icon: 'mdi:alert' },
  POINTS: { label: '积分通知', color: 'gold', icon: 'mdi:star' },
  VERIFICATION: {
    label: '认证通知',
    color: 'purple',
    icon: 'mdi:shield-check',
  },
  ANNOUNCEMENT: { label: '公告通知', color: 'cyan', icon: 'mdi:bullhorn' },
  COMMENT: { label: '评论通知', color: 'geekblue', icon: 'mdi:comment' },
  POST: { label: '帖子通知', color: 'lime', icon: 'mdi:post' },
};

// 通知类型
export interface BizNotification {
  id?: number;
  userId?: number;
  type?: string;
  title?: string;
  content?: string;
  relatedType?: string;
  relatedId?: number;
  isRead?: number;
  createTime?: string;
}

// 通知列表项（用于前端展示）
export interface NotificationItem extends BizNotification {
  typeLabel?: string;
  typeColor?: string;
  typeIcon?: string;
  targetType?: string;
  targetId?: number;
}

/**
 * 获取通知类型配置
 */
export function getNotificationTypeConfig(type?: string) {
  if (!type) return NotificationTypeConfig.SYSTEM;
  return NotificationTypeConfig[type] || NotificationTypeConfig.SYSTEM;
}

/**
 * 转换通知为展示项
 */
export function toNotificationItem(
  notification: BizNotification,
): NotificationItem {
  const config = getNotificationTypeConfig(notification.type);
  return {
    ...notification,
    typeLabel: config.label,
    typeColor: config.color,
    typeIcon: config.icon,
    targetType: notification.relatedType,
    targetId: notification.relatedId,
  };
}

/**
 * 根据通知类型和关联信息获取跳转路由
 */
export function getNotificationRoute(
  notification: BizNotification,
): null | string {
  const { relatedType, relatedId } = notification;
  if (!relatedType) return '/lostfound/notifications';

  switch (relatedType) {
    case 'ANNOUNCEMENT': {
      return '/lostfound/notifications';
    }
    case 'CLAIM': {
      return '/lostfound/me/claims';
    }
    case 'COMMENT': {
      return relatedId
        ? `/lostfound/posts/${relatedId}`
        : '/lostfound/me/posts';
    }
    case 'ORDER': {
      return relatedId
        ? `/lostfound/me/exchange?orderId=${relatedId}`
        : '/lostfound/me/exchange';
    }
    case 'POINTS': {
      return '/lostfound/me/points';
    }
    case 'POST': {
      return relatedId
        ? `/lostfound/posts/${relatedId}`
        : '/lostfound/me/posts';
    }
    case 'VERIFICATION': {
      return '/lostfound/me/verification';
    }
    default: {
      return '/lostfound/notifications';
    }
  }
}

/**
 * 获取通知列表
 */
async function getNotificationList(params?: {
  pageNum?: number;
  pageSize?: number;
  type?: string;
}) {
  return requestClient.get<PageResult<BizNotification>>(
    '/lostfound/notification/list',
    { params },
  );
}

/**
 * 标记通知已读
 */
async function markAsRead(id: number) {
  return requestClient.post(`/lostfound/notification/${id}/read`);
}

/**
 * 标记所有通知已读
 */
async function markAllAsRead() {
  return requestClient.post('/lostfound/notification/read-all');
}

/**
 * 获取未读通知数
 */
async function getUnreadNotificationCount() {
  return requestClient.get<number>('/lostfound/notification/unread-count');
}

/**
 * 删除通知
 */
async function deleteNotification(id: number) {
  return requestClient.delete(`/lostfound/notification/${id}`);
}

export {
  deleteNotification,
  getNotificationList,
  getUnreadNotificationCount as getUnreadCount,
  getUnreadNotificationCount,
  markAllAsRead,
  markAsRead,
};
