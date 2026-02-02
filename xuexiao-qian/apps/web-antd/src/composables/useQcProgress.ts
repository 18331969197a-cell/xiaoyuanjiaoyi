/**
 * QC任务进度监听Hook
 * Requirements: AC-004.2, AC-004.3
 */
import { onUnmounted, ref } from 'vue';

import { notification } from 'ant-design-vue';

import { getWebSocketService } from '#/realtime/connection';

/**
 * QC进度消息接口
 */
export interface QcProgressMessage {
  /** 任务ID */
  taskId: number;
  /** 任务状态：running-运行中, completed-已完成, failed-失败 */
  status: 'completed' | 'failed' | 'running';
  /** 进度百分比 (0-100) */
  progress: number;
  /** 已处理数量 */
  processedCount: number;
  /** 总数量 */
  totalCount: number;
  /** 发现的异常数量 */
  abnormalCount: number;
  /** 消息（用于显示状态或错误信息） */
  message?: string;
}

/**
 * QC进度监听选项
 */
export interface UseQcProgressOptions {
  /** 任务ID，用于过滤特定任务的进度 */
  taskId?: number;
  /** 进度更新回调 */
  onProgress?: (message: QcProgressMessage) => void;
  /** 任务完成回调 */
  onComplete?: (message: QcProgressMessage) => void;
  /** 任务失败回调 */
  onFailed?: (message: QcProgressMessage) => void;
  /** 是否显示通知 */
  showNotification?: boolean;
}

/**
 * QC任务进度监听Hook
 */
export function useQcProgress(options: UseQcProgressOptions = {}) {
  const {
    taskId,
    onProgress,
    onComplete,
    onFailed,
    showNotification = true,
  } = options;

  const progress = ref<null | QcProgressMessage>(null);
  const isSubscribed = ref(false);

  // WebSocket 目的地
  const PROGRESS_DESTINATION = '/user/queue/qc/progress';
  const COMPLETE_DESTINATION = '/user/queue/qc/complete';

  /**
   * 处理进度消息
   */
  function handleProgressMessage(message: QcProgressMessage) {
    // 如果指定了 taskId，只处理该任务的消息
    if (taskId && message.taskId !== taskId) {
      return;
    }

    progress.value = message;
    onProgress?.(message);
  }

  /**
   * 处理完成消息
   */
  function handleCompleteMessage(message: QcProgressMessage) {
    // 如果指定了 taskId，只处理该任务的消息
    if (taskId && message.taskId !== taskId) {
      return;
    }

    progress.value = message;

    if (message.status === 'completed') {
      onComplete?.(message);
      if (showNotification) {
        notification.success({
          message: 'QC任务完成',
          description: `任务已完成，共处理 ${message.processedCount} 条数据，发现 ${message.abnormalCount} 个异常点`,
        });
      }
    } else if (message.status === 'failed') {
      onFailed?.(message);
      if (showNotification) {
        notification.error({
          message: 'QC任务失败',
          description: message.message || '任务执行过程中发生错误',
        });
      }
    }
  }

  /**
   * 订阅QC进度
   */
  function subscribe() {
    const service = getWebSocketService();
    if (!service || !service.isConnected) {
      console.warn('[QcProgress] WebSocket未连接，无法订阅QC进度');
      return;
    }

    if (isSubscribed.value) {
      return;
    }

    try {
      // 订阅进度更新
      service.subscribe(PROGRESS_DESTINATION, handleProgressMessage);
      // 订阅完成通知
      service.subscribe(COMPLETE_DESTINATION, handleCompleteMessage);
      isSubscribed.value = true;
      console.log('[QcProgress] 已订阅QC进度通知');
    } catch (error) {
      console.error('[QcProgress] 订阅失败:', error);
    }
  }

  /**
   * 取消订阅
   */
  function unsubscribe() {
    const service = getWebSocketService();
    if (!service) {
      return;
    }

    try {
      service.unsubscribe(PROGRESS_DESTINATION);
      service.unsubscribe(COMPLETE_DESTINATION);
      isSubscribed.value = false;
      console.log('[QcProgress] 已取消订阅QC进度通知');
    } catch (error) {
      console.error('[QcProgress] 取消订阅失败:', error);
    }
  }

  /**
   * 重置进度状态
   */
  function reset() {
    progress.value = null;
  }

  // 监听 WebSocket 连接状态，自动订阅
  const service = getWebSocketService();
  if (service) {
    service.on('connected', () => {
      subscribe();
    });

    service.on('disconnected', () => {
      isSubscribed.value = false;
    });

    // 如果已经连接，立即订阅
    if (service.isConnected) {
      subscribe();
    }
  }

  // 组件卸载时取消订阅
  onUnmounted(() => {
    unsubscribe();
  });

  return {
    /** 当前进度信息 */
    progress,
    /** 是否已订阅 */
    isSubscribed,
    /** 手动订阅 */
    subscribe,
    /** 手动取消订阅 */
    unsubscribe,
    /** 重置进度状态 */
    reset,
  };
}

export default useQcProgress;
