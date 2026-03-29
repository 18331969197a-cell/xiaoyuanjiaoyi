import { computed, ref } from 'vue';

import { defineStore } from 'pinia';

import { getUnreadCount } from '#/api/lostfound/notification';
import { getUserPoints } from '#/api/lostfound/points';

/**
 * 失物招领模块状态管理
 * 管理用户积分、未读消息数等全局状态
 */
export const useLostfoundStore = defineStore('lostfound', () => {
  // 用户积分
  const userPoints = ref<number>(0);
  // 未读通知数
  const unreadNotificationCount = ref<number>(0);
  // 未读消息数
  const unreadMessageCount = ref<number>(0);
  // 加载状态
  const loading = ref<boolean>(false);

  // 总未读数
  const totalUnreadCount = computed(() => {
    return unreadNotificationCount.value + unreadMessageCount.value;
  });

  /**
   * 获取用户积分
   */
  async function fetchUserPoints() {
    try {
      const res = await getUserPoints();
      userPoints.value = res?.points || 0;
    } catch (error) {
      console.error('获取用户积分失败:', error);
    }
  }

  /**
   * 获取未读通知数
   */
  async function fetchUnreadNotificationCount() {
    try {
      const count = await getUnreadCount();
      unreadNotificationCount.value = count || 0;
    } catch (error) {
      console.error('获取未读通知数失败:', error);
    }
  }

  /**
   * 更新用户积分（本地更新，用于兑换后立即反馈）
   */
  function updatePoints(delta: number) {
    userPoints.value = Math.max(0, userPoints.value + delta);
  }

  /**
   * 设置未读通知数
   */
  function setUnreadNotificationCount(count: number) {
    unreadNotificationCount.value = count;
  }

  /**
   * 设置未读通知数（别名，用于WebSocket订阅）
   */
  function setUnreadNotifications(count: number) {
    unreadNotificationCount.value = count;
  }

  /**
   * 增加未读通知数
   */
  function incrementUnreadNotifications(count: number = 1) {
    unreadNotificationCount.value += count;
  }

  /**
   * 设置未读消息数
   */
  function setUnreadMessageCount(count: number) {
    unreadMessageCount.value = count;
  }

  /**
   * 减少未读通知数
   */
  function decreaseUnreadNotification(count: number = 1) {
    unreadNotificationCount.value = Math.max(
      0,
      unreadNotificationCount.value - count,
    );
  }

  /**
   * 清空未读通知
   */
  function clearUnreadNotification() {
    unreadNotificationCount.value = 0;
  }

  /**
   * 初始化加载所有状态
   */
  async function initializeState() {
    if (loading.value) return;
    loading.value = true;
    try {
      await Promise.all([fetchUserPoints(), fetchUnreadNotificationCount()]);
    } finally {
      loading.value = false;
    }
  }

  /**
   * 重置状态（用于登出）
   */
  function resetState() {
    userPoints.value = 0;
    unreadNotificationCount.value = 0;
    unreadMessageCount.value = 0;
  }

  /**
   * Pinia setup store: provide $reset for global resetAllStores
   */
  function $reset() {
    resetState();
  }

  return {
    // 状态
    userPoints,
    unreadNotificationCount,
    unreadMessageCount,
    totalUnreadCount,
    loading,
    // 方法
    fetchUserPoints,
    fetchUnreadNotificationCount,
    updatePoints,
    setUnreadNotificationCount,
    setUnreadNotifications,
    incrementUnreadNotifications,
    setUnreadMessageCount,
    decreaseUnreadNotification,
    clearUnreadNotification,
    initializeState,
    resetState,
    $reset,
  };
});
