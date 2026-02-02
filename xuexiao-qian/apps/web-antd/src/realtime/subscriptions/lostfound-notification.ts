import type { createWebSocketService } from '@vben/websocket';

import { notification } from 'ant-design-vue';

import { useLostfoundStore } from '#/store/lostfound';

/**
 * 失物招领通知消息类型
 */
interface LostfoundNotification {
  id: number;
  type: string;
  title: string;
  content: string;
  relatedType?: string;
  relatedId?: number;
  createTime: string;
}

/**
 * 通知数量消息类型
 */
interface NotificationCount {
  unreadCount: number;
}

/**
 * 注册失物招领通知订阅
 */
export function registerLostfoundNotificationSubscription(
  service: ReturnType<typeof createWebSocketService>,
) {
  // 订阅新通知
  const notificationUnsubscribe = service.subscribe<LostfoundNotification>(
    '/user/queue/lostfound/notification',
    (data) => {
      console.log('[LostFound] 收到新通知:', data);

      // 显示通知弹窗
      notification.info({
        message: data.title,
        description: data.content,
        duration: 5,
        placement: 'topRight',
        onClick: () => {
          // 点击通知跳转到相关页面
          if (data.relatedType && data.relatedId) {
            handleNotificationClick(data.relatedType, data.relatedId);
          }
        },
      });

      // 更新store中的未读数量
      const store = useLostfoundStore();
      store.incrementUnreadNotifications();
    },
  );

  // 订阅未读数量更新
  const countUnsubscribe = service.subscribe<NotificationCount>(
    '/user/queue/lostfound/notification/count',
    (data) => {
      console.log('[LostFound] 未读通知数量更新:', data.unreadCount);

      // 更新store中的未读数量
      const store = useLostfoundStore();
      store.setUnreadNotifications(data.unreadCount);
    },
  );

  // 返回清理函数
  return () => {
    notificationUnsubscribe();
    countUnsubscribe();
  };
}

/**
 * 处理通知点击
 */
function handleNotificationClick(relatedType: string, relatedId: number) {
  const router = window.__APP_ROUTER__;
  if (!router) return;

  switch (relatedType) {
    case 'CLAIM': {
      router.push(`/lostfound/me/claims`);
      break;
    }
    case 'COMMENT': {
      router.push(`/lostfound/posts/${relatedId}`);
      break;
    }
    case 'POINTS': {
      router.push(`/lostfound/me/points`);
      break;
    }
    case 'POST': {
      router.push(`/lostfound/posts/${relatedId}`);
      break;
    }
    default: {
      router.push('/lostfound/me/notifications');
    }
  }
}
