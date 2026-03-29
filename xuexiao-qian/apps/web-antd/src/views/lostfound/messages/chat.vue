<script lang="ts" setup>
import type {
  BizMessage,
  BizMsgThread,
  ChatRiskSummary,
} from '#/api/lostfound/message';

import { nextTick, onMounted, onUnmounted, ref } from 'vue';
import { useRoute, useRouter } from 'vue-router';

import { Page } from '@vben/common-ui';
import { useUserStore } from '@vben/stores';

import {
  Alert,
  Avatar,
  Button,
  Card,
  Empty,
  Input,
  message,
  Spin,
} from 'ant-design-vue';

import {
  getThreadDetail,
  getThreadMessages,
  getThreadRiskSummary,
  markAsRead,
  sendMessage,
} from '#/api/lostfound/message';

// 类型别名
type Message = BizMessage & {
  senderAvatar?: string;
};
type MessageThread = BizMsgThread & {
  otherUser?: {
    avatar?: string;
    nickname?: string;
  };
  postTitle?: string;
};

const route = useRoute();
const router = useRouter();
const userStore = useUserStore();
const loading = ref(false);
const sending = ref(false);
const thread = ref<MessageThread | null>(null);
const messages = ref<Message[]>([]);
const newMessage = ref('');
const messageListRef = ref<HTMLElement | null>(null);
const riskSummary = ref<ChatRiskSummary | null>(null);

// 当前用户ID（从用户状态获取）
const currentUserId = ref<number>(0);

// 加载会话详情
async function loadThreadDetail() {
  const threadId = Number(route.params.threadId);
  if (!threadId) return;

  try {
    const res = await getThreadDetail(threadId);
    if (res) {
      thread.value = res;
      // 计算对方用户信息
      const userId = currentUserId.value;
      const isUser1 = res.user1Id === userId;
      thread.value.otherUser = {
        nickname: isUser1 ? res.targetUserName : res.targetUserName,
        avatar: isUser1 ? res.targetUserAvatar : res.targetUserAvatar,
      };
      // 如果有targetUserName，直接使用
      if (res.targetUserName) {
        thread.value.otherUser.nickname = res.targetUserName;
      }
      if (res.targetUserAvatar) {
        thread.value.otherUser.avatar = res.targetUserAvatar;
      }
    }
  } catch (error) {
    console.error('加载会话详情失败:', error);
  }
}

// 加载消息
async function loadMessages() {
  const threadId = Number(route.params.threadId);
  if (!threadId) return;

  loading.value = true;
  try {
    const res = await getThreadMessages(threadId);
    messages.value = Array.isArray(res) ? res : [];
    // 标记已读
    await markAsRead(threadId);
    // 滚动到底部
    scrollToBottom();
  } catch (error) {
    console.error('加载消息失败:', error);
  } finally {
    loading.value = false;
  }
}

async function loadRiskSummary() {
  const threadId = Number(route.params.threadId);
  if (!threadId) return;
  try {
    riskSummary.value = await getThreadRiskSummary(threadId);
  } catch (error) {
    console.error('加载风险摘要失败:', error);
    riskSummary.value = null;
  }
}

// 发送消息
async function handleSend() {
  if (!newMessage.value.trim()) return;
  const threadId = Number(route.params.threadId);
  if (!threadId) return;

  sending.value = true;
  try {
    await sendMessage({ threadId, content: newMessage.value.trim() });
    newMessage.value = '';
    // 重新加载消息
    await loadMessages();
  } catch {
    message.error('发送失败');
  } finally {
    sending.value = false;
  }
}

// 滚动到底部
function scrollToBottom() {
  nextTick(() => {
    if (messageListRef.value) {
      messageListRef.value.scrollTop = messageListRef.value.scrollHeight;
    }
  });
}

// 判断是否是自己发的消息
function isMyMessage(msg: Message) {
  // 确保类型一致进行比较（后端返回的 senderId 可能是字符串）
  return Number(msg.senderId) === currentUserId.value;
}

// 格式化时间
function formatTime(time?: string) {
  if (!time) return '';
  return time.replace('T', ' ').slice(11, 16);
}

// 格式化日期
function formatDate(time?: string) {
  if (!time) return '';
  const date = new Date(time);
  const today = new Date();
  const yesterday = new Date(today);
  yesterday.setDate(yesterday.getDate() - 1);

  if (date.toDateString() === today.toDateString()) {
    return '今天';
  }
  if (date.toDateString() === yesterday.toDateString()) {
    return '昨天';
  }
  return time.slice(0, 10);
}

// 是否显示日期分隔
function showDateDivider(index: number) {
  if (index === 0) return true;
  const current = messages.value[index];
  const prev = messages.value[index - 1];
  if (!current || !prev) return false;
  return formatDate(current.createTime) !== formatDate(prev.createTime);
}

// 返回
function goBack() {
  router.push('/lostfound/messages');
}

// 定时刷新
let refreshTimer: null | ReturnType<typeof setInterval> = null;

onMounted(async () => {
  // 获取当前用户ID
  const userInfo = userStore.userInfo;
  if (userInfo?.userId) {
    currentUserId.value = Number(userInfo.userId);
  }
  // 加载会话详情
  await loadThreadDetail();
  await loadRiskSummary();
  // 加载消息
  loadMessages();
  // 每10秒刷新一次
  refreshTimer = setInterval(loadMessages, 10_000);
});

onUnmounted(() => {
  if (refreshTimer) {
    clearInterval(refreshTimer);
  }
});
</script>

<template>
  <Page auto-content-height>
    <div class="flex h-full flex-col">
      <!-- 头部 -->
      <Card class="shrink-0">
        <div class="flex items-center gap-3">
          <Button type="text" @click="goBack">← 返回</Button>
          <Avatar :src="thread?.otherUser?.avatar" :size="40">
            {{ thread?.otherUser?.nickname?.charAt(0) }}
          </Avatar>
          <div>
            <div class="font-medium">
              {{ thread?.otherUser?.nickname || '加载中...' }}
            </div>
            <div v-if="thread?.postTitle" class="text-sm text-gray-500">
              关于：{{ thread.postTitle }}
            </div>
          </div>
        </div>
        <Alert
          v-if="riskSummary?.risky"
          class="mt-3"
          :type="riskSummary.riskLevel === 'HIGH' ? 'error' : 'warning'"
          show-icon
          :message="riskSummary.riskLevel === 'HIGH' ? '风险提醒（高）' : '风险提醒'"
          :description="
            riskSummary.hint ||
            `该用户有 ${riskSummary.totalCount || 0} 条风险记录，请谨慎沟通。`
          "
        />
      </Card>

      <!-- 消息列表 -->
      <div ref="messageListRef" class="flex-1 overflow-y-auto bg-gray-50 p-4">
        <Spin :spinning="loading">
          <div v-if="messages.length > 0" class="space-y-4">
            <template v-for="(msg, index) in messages" :key="msg.id">
              <!-- 日期分隔 -->
              <div
                v-if="showDateDivider(index)"
                class="py-2 text-center text-sm text-gray-400"
              >
                {{ formatDate(msg.createTime) }}
              </div>

              <!-- 消息气泡 -->
              <div
                class="flex gap-2"
                :class="[isMyMessage(msg) ? 'flex-row-reverse' : 'flex-row']"
              >
                <Avatar :src="msg.senderAvatar" :size="36">
                  {{ msg.senderName?.charAt(0) }}
                </Avatar>
                <div
                  class="max-w-[70%] rounded-lg px-3 py-2"
                  :class="[
                    isMyMessage(msg)
                      ? 'bg-blue-500 text-white'
                      : 'bg-white text-gray-800',
                  ]"
                >
                  <div class="break-words">{{ msg.content }}</div>
                  <div
                    class="mt-1 text-xs"
                    :class="[
                      isMyMessage(msg) ? 'text-blue-100' : 'text-gray-400',
                    ]"
                  >
                    {{ formatTime(msg.createTime) }}
                    <span v-if="isMyMessage(msg) && msg.isRead" class="ml-1">
                      已读
                    </span>
                  </div>
                </div>
              </div>
            </template>
          </div>
          <Empty
            v-else
            description="暂无消息，发送第一条消息吧"
            class="py-10"
          />
        </Spin>
      </div>

      <!-- 输入框 -->
      <Card class="shrink-0">
        <div class="flex gap-2">
          <Input.TextArea
            v-model:value="newMessage"
            placeholder="输入消息..."
            :rows="2"
            :maxlength="500"
            @press-enter.prevent="handleSend"
          />
          <Button
            type="primary"
            :loading="sending"
            :disabled="!newMessage.trim()"
            @click="handleSend"
          >
            发送
          </Button>
        </div>
      </Card>
    </div>
  </Page>
</template>
