<script lang="ts" setup>
import type { MessageThread } from '#/api/lostfound/message';

import { onMounted, ref } from 'vue';
import { useRoute, useRouter } from 'vue-router';

import { Page } from '@vben/common-ui';

import {
  Avatar,
  Badge,
  Card,
  Empty,
  List,
  ListItem,
  ListItemMeta,
  message,
  Spin,
} from 'ant-design-vue';

import { getOrCreateThread, getThreadList } from '#/api/lostfound/message';

const route = useRoute();
const router = useRouter();
const loading = ref(false);
const threads = ref<MessageThread[]>([]);

// 处理 userId 参数，自动创建或获取会话并跳转到聊天页面
async function handleUserIdParam() {
  const userId = route.query.userId;
  const postId = route.query.postId;

  if (userId) {
    loading.value = true;
    try {
      // 创建或获取与该用户的会话
      const threadId = await getOrCreateThread(
        Number(userId),
        postId ? Number(postId) : undefined,
      );
      // 跳转到聊天页面
      router.replace(`/lostfound/messages/${threadId}`);
      return true; // 表示已处理，不需要加载会话列表
    } catch (error) {
      console.error('创建会话失败:', error);
      message.error('创建会话失败，请重试');
      loading.value = false;
    }
  }
  return false;
}

// 加载会话列表
async function loadThreads() {
  loading.value = true;
  try {
    const res = await getThreadList({ pageNum: 1, pageSize: 100 });
    // 兼容分页格式和数组格式
    if (Array.isArray(res)) {
      threads.value = res;
    } else if (res && res.records) {
      threads.value = res.records;
    } else if (res && res.rows) {
      threads.value = res.rows;
    } else {
      threads.value = [];
    }
  } catch (error) {
    console.error('加载会话列表失败:', error);
  } finally {
    loading.value = false;
  }
}

// 进入聊天
function enterChat(thread: MessageThread) {
  router.push(`/lostfound/messages/${thread.id}`);
}

// 格式化时间
function formatTime(time: string) {
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

onMounted(async () => {
  // 先检查是否有 userId 参数
  const handled = await handleUserIdParam();
  // 如果没有处理 userId 参数，则加载会话列表
  if (!handled) {
    loadThreads();
  }
});
</script>

<template>
  <Page auto-content-height>
    <div class="mx-auto max-w-2xl p-4">
      <Card title="消息列表">
        <Spin :spinning="loading">
          <List v-if="threads.length > 0" :data-source="threads">
            <template #renderItem="{ item }">
              <ListItem
                class="cursor-pointer hover:bg-gray-50"
                @click="enterChat(item)"
              >
                <ListItemMeta>
                  <template #avatar>
                    <Badge :count="item.unreadCount" :offset="[-5, 5]">
                      <Avatar :src="item.targetUserAvatar" :size="48">
                        {{ item.targetUserName?.charAt(0) }}
                      </Avatar>
                    </Badge>
                  </template>
                  <template #title>
                    <div class="flex items-center justify-between">
                      <span class="font-medium">
                        {{ item.targetUserName || '未知用户' }}
                      </span>
                      <span class="text-sm text-gray-400">
                        {{ formatTime(item.lastMessageTime) }}
                      </span>
                    </div>
                  </template>
                  <template #description>
                    <div class="truncate text-gray-500">
                      {{ item.lastMessageContent || '暂无消息' }}
                    </div>
                    <div
                      v-if="item.postTitle"
                      class="mt-1 text-xs text-gray-400"
                    >
                      关于：{{ item.postTitle }}
                    </div>
                  </template>
                </ListItemMeta>
              </ListItem>
            </template>
          </List>
          <Empty v-else description="暂无消息" class="py-10" />
        </Spin>
      </Card>
    </div>
  </Page>
</template>
