<script lang="ts" setup>
import type { BizNotification } from '#/api/lostfound/notification';

import { onMounted, ref } from 'vue';
import { useRouter } from 'vue-router';

import { Bell } from '@vben/icons';

import {
  Badge,
  Button,
  Empty,
  List,
  ListItem,
  ListItemMeta,
  Popover,
  Spin,
  Tag,
} from 'ant-design-vue';

import {
  getNotificationList,
  getNotificationRoute,
  getNotificationTypeConfig,
  getUnreadNotificationCount,
  markAllAsRead,
  markAsRead,
} from '#/api/lostfound/notification';

function getTypeConfig(type?: string) {
  return getNotificationTypeConfig(type);
}

defineOptions({ name: 'LostfoundNotification' });

const router = useRouter();
const open = ref(false);
const loading = ref(false);
const notifications = ref<BizNotification[]>([]);
const unreadCount = ref(0);

// 格式化时间
function formatTime(time?: string) {
  if (!time) return '';
  const date = new Date(time);
  const now = new Date();
  const diff = now.getTime() - date.getTime();
  const minutes = Math.floor(diff / (1000 * 60));
  const hours = Math.floor(diff / (1000 * 60 * 60));
  const days = Math.floor(diff / (1000 * 60 * 60 * 24));

  if (minutes < 1) return '刚刚';
  if (minutes < 60) return `${minutes}分钟前`;
  if (hours < 24) return `${hours}小时前`;
  if (days < 7) return `${days}天前`;
  return time.slice(0, 10);
}

// 获取未读数
async function fetchUnreadCount() {
  try {
    const count = await getUnreadNotificationCount();
    unreadCount.value = count || 0;
  } catch (error) {
    console.error('获取未读数失败:', error);
  }
}

// 获取通知列表
async function fetchNotifications() {
  loading.value = true;
  try {
    const res = await getNotificationList({
      pageNum: 1,
      pageSize: 10,
    });
    notifications.value = res.rows || [];
  } catch (error) {
    console.error('获取通知列表失败:', error);
  } finally {
    loading.value = false;
  }
}

// 弹窗打开时加载数据
async function handleOpenChange(visible: boolean) {
  open.value = visible;
  if (visible) {
    await fetchNotifications();
    await fetchUnreadCount();
  }
}

// 标记已读
async function handleMarkAsRead(item: BizNotification) {
  if (item.isRead) return;
  try {
    if (item.id) {
      await markAsRead(item.id);
      item.isRead = 1;
      unreadCount.value = Math.max(0, unreadCount.value - 1);
    }
  } catch (error) {
    console.error('标记已读失败:', error);
  }
}

// 全部标记已读
async function handleMarkAllAsRead() {
  try {
    await markAllAsRead();
    notifications.value.forEach((n) => (n.isRead = 1));
    unreadCount.value = 0;
  } catch (error) {
    console.error('全部标记已读失败:', error);
  }
}

// 点击通知
async function handleClick(item: BizNotification) {
  await handleMarkAsRead(item);
  open.value = false;
  const route = getNotificationRoute(item);
  if (route) {
    router.push(route);
  }
}

// 查看全部
function handleViewAll() {
  open.value = false;
  router.push('/lostfound/notifications');
}

// 组件挂载时获取未读数
onMounted(() => {
  fetchUnreadCount();
});
</script>

<template>
  <Popover
    v-model:open="open"
    trigger="click"
    placement="bottomRight"
    overlay-class-name="lostfound-notification-popover"
    @open-change="handleOpenChange"
  >
    <template #content>
      <div class="w-[360px]">
        <!-- 头部 -->
        <div class="flex items-center justify-between border-b px-4 py-3">
          <span class="font-medium">通知</span>
          <Button
            v-if="unreadCount > 0"
            type="link"
            size="small"
            @click="handleMarkAllAsRead"
          >
            全部已读
          </Button>
        </div>

        <!-- 列表 -->
        <Spin :spinning="loading">
          <div class="max-h-[360px] overflow-y-auto">
            <List
              v-if="notifications.length > 0"
              :data-source="notifications"
              size="small"
            >
              <template #renderItem="{ item }">
                <ListItem
                  class="cursor-pointer transition-colors hover:bg-gray-50"
                  :class="{ 'bg-blue-50': !item.isRead }"
                  @click="handleClick(item)"
                >
                  <ListItemMeta>
                    <template #title>
                      <div class="flex items-center gap-2">
                        <Tag
                          :color="getTypeConfig(item.type).color"
                          size="small"
                        >
                          {{ getTypeConfig(item.type).label }}
                        </Tag>
                        <span
                          class="flex-1 truncate text-sm"
                          :class="{ 'font-medium': !item.isRead }"
                        >
                          {{ item.title || '无标题' }}
                        </span>
                        <Badge v-if="!item.isRead" status="processing" />
                      </div>
                    </template>
                    <template #description>
                      <div class="line-clamp-2 text-xs text-gray-500">
                        {{ item.content || '' }}
                      </div>
                      <div class="mt-1 text-xs text-gray-400">
                        {{ formatTime(item.createTime) }}
                      </div>
                    </template>
                  </ListItemMeta>
                </ListItem>
              </template>
            </List>
            <Empty v-else description="暂无通知" class="py-8" />
          </div>
        </Spin>

        <!-- 底部 -->
        <div class="flex justify-center border-t px-4 py-3">
          <Button type="primary" size="small" @click="handleViewAll">
            查看全部消息
          </Button>
        </div>
      </div>
    </template>

    <!-- 触发器 -->
    <div class="flex-center relative mr-2 h-full cursor-pointer">
      <div
        class="flex size-8 items-center justify-center rounded-md transition-colors hover:bg-gray-100"
      >
        <Bell class="size-4" />
      </div>
      <span
        v-if="unreadCount > 0"
        class="pointer-events-none absolute -right-1 -top-1 z-50 flex h-5 min-w-[20px] items-center justify-center rounded-full bg-red-500 px-1 text-xs font-medium text-white"
      >
        {{ unreadCount > 99 ? '99+' : unreadCount }}
      </span>
    </div>
  </Popover>
</template>

<style>
.lostfound-notification-popover .ant-popover-inner {
  padding: 0;
}
</style>
