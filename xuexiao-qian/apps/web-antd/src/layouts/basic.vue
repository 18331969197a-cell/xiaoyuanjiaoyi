<script lang="ts" setup>
import type { NotificationItem } from '@vben/layouts';

import { computed, onMounted, ref, watch } from 'vue';
import { useRoute, useRouter } from 'vue-router';

import { AuthenticationLoginExpiredModal } from '@vben/common-ui';
import { useWatermark } from '@vben/hooks';
import { Mail, User } from '@vben/icons';
import {
  BasicLayout,
  LockScreen,
  Notification,
  UserDropdown,
} from '@vben/layouts';
import { preferences } from '@vben/preferences';
import { useAccessStore, useUserStore } from '@vben/stores';

import {
  DashBoardMessageType,
  listUserMessageList,
} from '#/api/personal/message';
import { LostfoundNotification } from '#/components/LostfoundNotification';
import { useMessageStore } from '#/composables/useMessageStore';
import { useAuthStore } from '#/store';
import LoginForm from '#/views/_core/authentication/login.vue';

const router = useRouter();
const route = useRoute();

// 判断是否在失物招领平台页面
const isLostfoundPage = computed(() => {
  return route.path.startsWith('/lostfound');
});

// 消息相关状态
const notifications = ref<NotificationItem[]>([]);
const messageList = ref<DashBoardMessageType.UserMessageListVo[]>([]);
const notificationLoading = ref(false);
const { unreadCount, fetchUnreadCount, setLayoutRefreshCallback } =
  useMessageStore();

// 消息类型映射
const MESSAGE_TYPES = {
  [DashBoardMessageType.MessageType.SYSTEM]: {
    label: '系统消息',
    color: 'blue',
  },
  [DashBoardMessageType.MessageType.NOTICE]: {
    label: '通知消息',
    color: 'green',
  },
  [DashBoardMessageType.MessageType.ANNOUNCEMENT]: {
    label: '公告消息',
    color: 'orange',
  },
} as const;

const userStore = useUserStore();
const authStore = useAuthStore();
const accessStore = useAccessStore();
const { destroyWatermark, updateWatermark } = useWatermark();

const showDot = computed(() => unreadCount.value > 0);

// 获取消息列表 - 只获取前10条未读消息用于顶部导航显示
const fetchMessageList = async (showLoading = false) => {
  try {
    if (showLoading) {
      notificationLoading.value = true;
    }
    const response = await listUserMessageList({
      pageNum: 1,
      pageSize: 10, // 只获取10条消息用于通知显示
      isRead: 0, // 只获取未读消息
    });

    messageList.value = response.rows || [];

    // 转换为通知格式 - 只显示未读消息
    notifications.value = messageList.value.map((msg) => ({
      id: msg.id?.toString(),
      title: msg.title || '无标题',
      message: (msg.type && MESSAGE_TYPES[msg.type])?.label || '消息',
      date: msg.createTime || '',
      isRead: false, // 因为我们只获取未读消息，所以都是未读状态
      // 移除avatar字段，不再显示头像
    }));
  } catch (error) {
    console.error('获取消息列表失败:', error);
  } finally {
    if (showLoading) {
      notificationLoading.value = false;
    }
  }
};

const menus = computed(() => [
  {
    handler: () => {
      router.push('/personal/profile');
    },
    icon: User,
    text: '个人资料',
  },
  {
    handler: () => {
      router.push('/lostfound/notifications');
    },
    icon: Mail,
    text: '站内消息',
  },
]);

const avatar = computed(() => {
  return userStore.userInfo?.avatar ?? preferences.app.defaultAvatar;
});

async function handleLogout() {
  await authStore.logout(true);
}

// 移除清空功能，按要求不显示清空按钮
function handleNoticeClear() {
  // 不执行任何操作，因为要求移除清空按钮
}

function handleMakeAll() {}

// 处理通知点击，导航到消息详情
function handleNotificationClick(notification: NotificationItem) {
  if (notification.id) {
    router.push(`/personal/message/detail?id=${notification.id}`);
  }
}

// 处理查看所有消息
function handleViewAllMessages() {
  router.push('/personal/message');
}

// 处理通知下拉框打开事件 - 用户主动点击时才请求数据
async function handleNotificationOpen() {
  // 立即显示加载状态，清空之前的消息列表
  notificationLoading.value = true;
  notifications.value = []; // 清空旧数据，避免显示过期内容

  try {
    // 为了数据一致性，用户点击通知时主动请求消息数量接口进行更新
    await fetchUnreadCount(); // 确保数据一致性
    // 然后获取消息列表用于显示
    await fetchMessageList(false);
  } finally {
    notificationLoading.value = false;
  }
}

// 组件挂载时获取数据
onMounted(() => {
  // 使用 requestIdleCallback 延迟非关键数据加载，避免阻塞页面渲染
  if ('requestIdleCallback' in window) {
    (window as any).requestIdleCallback(async () => {
      await fetchUnreadCount();
    });
  } else {
    // 降级方案：使用 setTimeout
    setTimeout(async () => {
      await fetchUnreadCount();
    }, 100);
  }

  // 注册布局消息刷新回调 - WebSocket只更新徽标数量，不发起HTTP请求
  setLayoutRefreshCallback(() => {
    // WebSocket更新时什么都不做，直接使用WebSocket数据更新徽标
    // 消息列表只在用户主动点击通知时刷新
  });
});
watch(
  () => preferences.app.watermark,
  async (enable) => {
    if (enable) {
      await updateWatermark({
        content: `${userStore.userInfo?.username} - ${userStore.userInfo?.nickname}`,
      });
    } else {
      destroyWatermark();
    }
  },
  {
    immediate: true,
  },
);
</script>

<template>
  <BasicLayout @clear-preferences-and-logout="handleLogout">
    <template #user-dropdown>
      <UserDropdown
        :avatar
        :menus
        :text="userStore.userInfo?.nickname"
        :description="userStore.userInfo?.email"
        tag-text="Pro"
        @logout="handleLogout"
      />
    </template>
    <template #notification>
      <!-- 失物招领平台使用专用通知组件 -->
      <LostfoundNotification v-if="isLostfoundPage" />
      <!-- 其他页面使用默认通知组件 -->
      <Notification
        v-else
        :dot="showDot"
        :notifications="notifications"
        :unread-count="unreadCount"
        :loading="notificationLoading"
        @clear="handleNoticeClear"
        @make-all="handleMakeAll"
        @notification-click="handleNotificationClick"
        @view-all="handleViewAllMessages"
        @open="handleNotificationOpen"
      />
    </template>
    <template #extra>
      <AuthenticationLoginExpiredModal
        v-model:open="accessStore.loginExpired"
        :avatar
      >
        <LoginForm />
      </AuthenticationLoginExpiredModal>
    </template>
    <template #lock-screen>
      <LockScreen :avatar @to-login="handleLogout" />
    </template>
  </BasicLayout>
</template>
