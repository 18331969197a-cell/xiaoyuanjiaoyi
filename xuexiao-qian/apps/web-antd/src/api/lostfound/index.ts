// 失物招领模块 API 统一导出

export * from './base';
export * from './claim';
export * from './comment';
export * from './evaluation';
export * from './favorite';
export * from './handover';
export * from './points';
export * from './report';
export * from './riskEvent';
export * from './statistics';
export * from './post';
export {
  getOrCreateThread,
  getThreadDetail,
  getThreadList,
  getThreadMessages,
  getThreads,
  getUnreadCount as getMessageUnreadCount,
  markAsRead as markMessageAsRead,
  sendMessage,
} from './message';
export {
  deleteNotification,
  getNotificationList,
  getNotificationRoute,
  getNotificationTypeConfig,
  getUnreadCount as getNotificationUnreadCount,
  getUnreadNotificationCount,
  markAllAsRead,
  markAsRead as markNotificationAsRead,
  NotificationType,
  NotificationTypeConfig,
  toNotificationItem,
} from './notification';
