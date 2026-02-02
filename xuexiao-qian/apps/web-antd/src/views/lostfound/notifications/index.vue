<script lang="ts" setup>
import type { Key } from 'ant-design-vue/es/_util/type';

import type { BizNotification } from '#/api/lostfound/notification';

import { onMounted, ref } from 'vue';
import { useRouter } from 'vue-router';

import { Page } from '@vben/common-ui';

import {
  Badge,
  Button,
  Card,
  Empty,
  List,
  ListItem,
  ListItemMeta,
  message,
  Pagination,
  Spin,
  Tabs,
  Tag,
} from 'ant-design-vue';

import {
  deleteNotification,
  getNotificationList,
  getNotificationRoute,
  getNotificationTypeConfig,
  markAllAsRead,
  markAsRead,
  NotificationType,
} from '#/api/lostfound/notification';

const router = useRouter();
const loading = ref(false);
const activeTab = ref<string>('all');
const notifications = ref<BizNotification[]>([]);
const total = ref(0);
const unreadCount = ref(0);
const currentPage = ref(1);
const pageSize = ref(20);

// Tab 配置
const tabItems = [
  { key: 'all', label: '全部' },
  { key: NotificationType.SYSTEM, label: '系统通知' },
  { key: NotificationType.CLAIM, label: '认领通知' },
  { key: NotificationType.COMMENT, label: '评论通知' },
  { key: NotificationType.POINTS, label: '积分通知' },
  { key: NotificationType.VERIFICATION, label: '认证通知' },
  { key: NotificationType.ANNOUNCEMENT, label: '公告通知' },
];

// 加载通知列表
async function loadNotifications() {
  loading.value = true;
  try {
    const res = await getNotificationList({
      pageNum: currentPage.value,
      pageSize: pageSize.value,
      type: activeTab.value === 'all' ? undefined : activeTab.value,
    });
    notifications.value = (res.records || res.rows || []) as BizNotification[];
    total.value = res.total || 0;
    // 计算未读数
    unreadCount.value = notifications.value.filter((n) => !n.isRead).length;
  } catch (error) {
    console.error('加载通知列表失败:', error);
  } finally {
    loading.value = false;
  }
}

// Tab 切换
function onTabChange(key: Key) {
  activeTab.value = String(key);
  currentPage.value = 1;
  loadNotifications();
}

// 分页变化
function onPageChange(page: number, size: number) {
  currentPage.value = page;
  pageSize.value = size;
  loadNotifications();
}

// 标记已读
async function handleMarkAsRead(item: BizNotification) {
  if (item.isRead) return;
  try {
    await markAsRead(item.id!);
    item.isRead = 1;
    unreadCount.value = Math.max(0, unreadCount.value - 1);
  } catch (error) {
    console.error('标记已读失败:', error);
  }
}

// 全部标记已读
async function handleMarkAllAsRead() {
  try {
    await markAllAsRead();
    notifications.value.forEach((n: BizNotification) => (n.isRead = 1));
    unreadCount.value = 0;
    message.success('已全部标记为已读');
  } catch {
    message.error('操作失败');
  }
}

// 删除通知
async function handleDelete(item: BizNotification, e: Event) {
  e.stopPropagation();
  try {
    await deleteNotification(item.id!);
    notifications.value = notifications.value.filter((n) => n.id !== item.id);
    total.value = Math.max(0, total.value - 1);
    if (!item.isRead) {
      unreadCount.value = Math.max(0, unreadCount.value - 1);
    }
    message.success('删除成功');
  } catch {
    message.error('删除失败');
  }
}

// 点击通知
function handleClick(item: BizNotification) {
  handleMarkAsRead(item);
  const route = getNotificationRoute(item);
  if (route) {
    router.push(route);
  }
}

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

onMounted(() => {
  loadNotifications();
});
</script>

<template>
  <Page auto-content-height>
    <div class="p-4">
      <Card>
        <template #title>
          <div class="flex items-center justify-between">
            <span>
              通知中心
              <Badge v-if="unreadCount > 0" :count="unreadCount" class="ml-2" />
            </span>
            <Button
              v-if="unreadCount > 0"
              type="link"
              size="small"
              @click="handleMarkAllAsRead"
            >
              全部已读
            </Button>
          </div>
        </template>

        <Tabs :active-key="activeTab" @change="onTabChange">
          <Tabs.TabPane
            v-for="tab in tabItems"
            :key="tab.key"
            :tab="tab.label"
          />
        </Tabs>

        <Spin :spinning="loading">
          <List v-if="notifications.length > 0" :data-source="notifications">
            <template #renderItem="{ item }">
              <ListItem
                class="cursor-pointer transition-colors"
                :class="[item.isRead ? 'bg-white' : 'bg-blue-50']"
                @click="handleClick(item)"
              >
                <ListItemMeta>
                  <template #avatar>
                    <Tag
                      :color="getNotificationTypeConfig(item.type).color"
                      class="flex items-center justify-center"
                    >
                      {{ getNotificationTypeConfig(item.type).label }}
                    </Tag>
                  </template>
                  <template #title>
                    <div class="flex items-center gap-2">
                      <span :class="{ 'font-medium': !item.isRead }">
                        {{ item.title }}
                      </span>
                      <Badge v-if="!item.isRead" status="processing" />
                    </div>
                  </template>
                  <template #description>
                    <div class="text-gray-500">{{ item.content }}</div>
                    <div class="mt-1 text-sm text-gray-400">
                      {{ formatTime(item.createTime) }}
                    </div>
                  </template>
                </ListItemMeta>
                <template #actions>
                  <Button
                    type="link"
                    danger
                    size="small"
                    @click="(e) => handleDelete(item, e)"
                  >
                    删除
                  </Button>
                </template>
              </ListItem>
            </template>
          </List>

          <Empty v-else description="暂无通知" class="py-10" />

          <div v-if="notifications.length > 0" class="mt-4 flex justify-center">
            <Pagination
              :current="currentPage"
              :page-size="pageSize"
              :total="total"
              show-quick-jumper
              :show-total="(t) => `共 ${t} 条`"
              @change="onPageChange"
            />
          </div>
        </Spin>
      </Card>
    </div>
  </Page>
</template>
