/**
 * 轮询服务 - 替代WebSocket实现实时通知
 * 每30秒轮询一次未读消息和通知数量
 */

import { notification } from 'ant-design-vue';

import { getUnreadCount } from '#/api/lostfound/notification';
import { useMessageStore } from '#/composables/useMessageStore';
import { useLostfoundStore } from '#/store/lostfound';

// 轮询间隔（毫秒）
const POLLING_INTERVAL = 30_000; // 30秒

// 轮询定时器
let pollingTimer: null | ReturnType<typeof setInterval> = null;

// 上次的未读数量，用于检测新消息
let lastNotificationCount = -1;
let lastMessageCount = -1;

/**
 * 执行一次轮询
 */
async function poll() {
  try {
    // 获取失物招领通知未读数量
    const notificationCount = await getUnreadCount();
    const lostfoundStore = useLostfoundStore();

    // 如果有新通知，显示提示
    if (
      lastNotificationCount >= 0 &&
      notificationCount > lastNotificationCount
    ) {
      notification.info({
        message: '新通知',
        description: `您有 ${notificationCount - lastNotificationCount} 条新的失物招领通知`,
        duration: 5,
        placement: 'topRight',
      });
    }

    lastNotificationCount = notificationCount;
    lostfoundStore.setUnreadNotifications(notificationCount);

    // 获取消息未读数量
    const messageStore = useMessageStore();
    await messageStore.fetchUnreadCount();

    const currentMessageCount = messageStore.unreadCount;
    if (lastMessageCount >= 0 && currentMessageCount > lastMessageCount) {
      notification.info({
        message: '新消息',
        description: `您有 ${currentMessageCount - lastMessageCount} 条新消息`,
        duration: 5,
        placement: 'topRight',
      });
    }
    lastMessageCount = currentMessageCount;
  } catch (error) {
    // 静默处理错误，不影响用户体验
    console.warn('[Polling] 轮询失败:', error);
  }
}

/**
 * 启动轮询服务
 */
export function startPolling() {
  if (pollingTimer) {
    return; // 已经在运行
  }

  console.log('[Polling] 启动轮询服务，间隔:', POLLING_INTERVAL, 'ms');

  // 立即执行一次
  poll();

  // 设置定时轮询
  pollingTimer = setInterval(poll, POLLING_INTERVAL);
}

/**
 * 停止轮询服务
 */
export function stopPolling() {
  if (pollingTimer) {
    console.log('[Polling] 停止轮询服务');
    clearInterval(pollingTimer);
    pollingTimer = null;
    lastNotificationCount = -1;
    lastMessageCount = -1;
  }
}

/**
 * 手动触发一次轮询（用于用户主动刷新）
 */
export function triggerPoll() {
  poll();
}
