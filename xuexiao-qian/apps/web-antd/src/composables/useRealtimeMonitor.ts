/**
 * 实时数据监控Hook
 * Requirements: 16.1, 16.2, 16.3
 */
import { onMounted, onUnmounted, ref } from 'vue';

import { notification } from 'ant-design-vue';

export interface RealtimeEvent {
  type: 'alert' | 'error' | 'file_upload' | 'qc_complete' | 'qc_progress';
  data: any;
  timestamp: string;
}

export interface RealtimeStats {
  todayUploads: number;
  todayQcTasks: number;
  pendingRepairs: number;
  activeUsers: number;
}

export interface UseRealtimeMonitorOptions {
  /** WebSocket URL */
  wsUrl?: string;
  /** 是否自动连接 */
  autoConnect?: boolean;
  /** 重连间隔（毫秒） */
  reconnectInterval?: number;
  /** 最大重连次数 */
  maxReconnectAttempts?: number;
}

/**
 * 实时监控Hook
 */
export function useRealtimeMonitor(options: UseRealtimeMonitorOptions = {}) {
  const {
    wsUrl = `ws://${window.location.host}/ws/ocean/monitor`,
    autoConnect = true,
    reconnectInterval = 5000,
    maxReconnectAttempts = 10,
  } = options;

  const connected = ref(false);
  const connecting = ref(false);
  const stats = ref<RealtimeStats>({
    todayUploads: 0,
    todayQcTasks: 0,
    pendingRepairs: 0,
    activeUsers: 0,
  });
  const events = ref<RealtimeEvent[]>([]);
  const reconnectAttempts = ref(0);

  let ws: null | WebSocket = null;
  let reconnectTimer: null | ReturnType<typeof setTimeout> = null;

  // 连接WebSocket
  function connect() {
    if (ws?.readyState === WebSocket.OPEN || connecting.value) {
      return;
    }

    connecting.value = true;

    try {
      ws = new WebSocket(wsUrl);

      ws.addEventListener('open', () => {
        connected.value = true;
        connecting.value = false;
        reconnectAttempts.value = 0;
        console.log('[RealtimeMonitor] WebSocket connected');
      });

      ws.onmessage = (event) => {
        try {
          const message: RealtimeEvent = JSON.parse(event.data);
          handleMessage(message);
        } catch (error) {
          console.error('[RealtimeMonitor] Failed to parse message:', error);
        }
      };

      ws.addEventListener('close', () => {
        connected.value = false;
        connecting.value = false;
        console.log('[RealtimeMonitor] WebSocket disconnected');
        scheduleReconnect();
      });

      ws.onerror = (error) => {
        console.error('[RealtimeMonitor] WebSocket error:', error);
        connecting.value = false;
      };
    } catch (error) {
      console.error('[RealtimeMonitor] Failed to connect:', error);
      connecting.value = false;
      scheduleReconnect();
    }
  }

  // 断开连接
  function disconnect() {
    if (reconnectTimer) {
      clearTimeout(reconnectTimer);
      reconnectTimer = null;
    }
    if (ws) {
      ws.close();
      ws = null;
    }
    connected.value = false;
    connecting.value = false;
  }

  // 计划重连
  function scheduleReconnect() {
    if (reconnectAttempts.value >= maxReconnectAttempts) {
      console.log('[RealtimeMonitor] Max reconnect attempts reached');
      return;
    }

    reconnectTimer = setTimeout(() => {
      reconnectAttempts.value++;
      console.log(
        `[RealtimeMonitor] Reconnecting... (${reconnectAttempts.value}/${maxReconnectAttempts})`,
      );
      connect();
    }, reconnectInterval);
  }

  // 处理消息
  function handleMessage(message: RealtimeEvent) {
    // 添加到事件列表
    events.value.unshift(message);
    if (events.value.length > 100) {
      events.value.pop();
    }

    switch (message.type) {
      case 'alert':

      case 'error': {
        // 显示告警 - Requirements: 16.3
        notification.error({
          message: '系统告警',
          description: message.data.message || '发生未知错误',
          duration: 0,
        });
        break;
      }

      case 'file_upload': {
        stats.value.todayUploads++;
        break;
      }

      case 'qc_complete': {
        stats.value.todayQcTasks++;
        notification.success({
          message: 'QC任务完成',
          description: `任务 ${message.data.taskId} 已完成，发现 ${message.data.abnormalCount} 个异常点`,
        });
        break;
      }
      case 'qc_progress': {
        // 更新QC进度
        break;
      }
    }
  }

  // 更新统计数据
  function updateStats(newStats: Partial<RealtimeStats>) {
    stats.value = { ...stats.value, ...newStats };
  }

  // 清除事件
  function clearEvents() {
    events.value = [];
  }

  onMounted(() => {
    if (autoConnect) {
      connect();
    }
  });

  onUnmounted(() => {
    disconnect();
  });

  return {
    connected,
    connecting,
    stats,
    events,
    connect,
    disconnect,
    updateStats,
    clearEvents,
  };
}

export default useRealtimeMonitor;
