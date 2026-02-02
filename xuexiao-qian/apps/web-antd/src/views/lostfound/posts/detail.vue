<script lang="ts" setup>
import type { BizComment } from '#/api/lostfound/comment';
import type { BizPost } from '#/api/lostfound/post';

import { computed, onMounted, ref } from 'vue';
import { useRoute, useRouter } from 'vue-router';

import { Page } from '@vben/common-ui';
import { useAppConfig } from '@vben/hooks';

import {
  Avatar,
  Button,
  Card,
  Descriptions,
  DescriptionsItem,
  Divider,
  Empty,
  Image,
  ImagePreviewGroup,
  Input,
  List,
  ListItem,
  ListItemMeta,
  message,
  Modal,
  Select,
  SelectOption,
  Spin,
  Tag,
  Timeline,
  TimelineItem,
} from 'ant-design-vue';

import { createComment, getCommentsByPostId } from '#/api/lostfound/comment';
import { addFavorite, removeFavorite } from '#/api/lostfound/favorite';
import { getPostById } from '#/api/lostfound/post';
import { createReport } from '#/api/lostfound/report';

// 获取API基础URL用于图片路径
const { apiURL } = useAppConfig(import.meta.env, import.meta.env.PROD);

// 处理图片URL，将相对路径转换为完整URL
function getFullImageUrl(url: string | undefined): string {
  if (!url) return '';
  // 如果已经是完整URL，直接返回
  if (
    url.startsWith('http://') ||
    url.startsWith('https://') ||
    url.startsWith('data:')
  ) {
    return url;
  }
  // 相对路径，将 /uploads/ 转换为 /file/uploads/ 以绕过Spring Security
  if (url.startsWith('/uploads/')) {
    return `${apiURL}/file${url}`;
  }
  // 其他相对路径，添加API基础URL
  return `${apiURL}${url}`;
}

// 扩展帖子详情类型
interface PostDetail extends BizPost {
  type?: string;
  itemName?: string;
  images?: string[];
  eventTime?: string;
  isFavorited?: boolean;
  userAvatar?: string;
  userLevel?: number;
  auditTime?: string;
  matchTime?: string;
  closeTime?: string;
}

// 评论项类型
type CommentItem = BizComment;

const route = useRoute();
const router = useRouter();
const loading = ref(false);
const post = ref<null | PostDetail>(null);
const comments = ref<CommentItem[]>([]);
const commentLoading = ref(false);
const newComment = ref('');
const submitting = ref(false);

// 图片画廊相关
const currentImageIndex = ref(0);
const defaultImage =
  'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAwIiBoZWlnaHQ9IjMwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSIjZjBmMGYwIi8+PHRleHQgeD0iNTAlIiB5PSI1MCUiIGZvbnQtZmFtaWx5PSJBcmlhbCIgZm9udC1zaXplPSIxOCIgZmlsbD0iIzk5OSIgdGV4dC1hbmNob3I9Im1pZGRsZSIgZHk9Ii4zZW0iPuaaguaXoOWbvueJhzwvdGV4dD48L3N2Zz4=';

// 当前显示的主图
const currentImage = computed(() => {
  if (post.value?.images?.length) {
    const imgUrl = post.value.images[currentImageIndex.value];
    return imgUrl ? getFullImageUrl(imgUrl) : defaultImage;
  }
  return defaultImage;
});

// 是否有图片
const hasImages = computed(
  () => post.value?.images && post.value.images.length > 0,
);

// 获取缩略图URL
function getThumbnailUrl(index: number): string {
  if (post.value?.images && post.value.images[index]) {
    return getFullImageUrl(post.value.images[index]);
  }
  return '';
}

// 切换图片
function selectImage(index: number) {
  currentImageIndex.value = index;
}

// 举报弹窗
const reportVisible = ref(false);
const reportReason = ref('');
const reportReasonType = ref('OTHER'); // 默认举报类型
const reportSubmitting = ref(false);

// 举报类型选项
const reportTypeOptions = [
  { value: 'SPAM', label: '垃圾信息' },
  { value: 'FRAUD', label: '虚假信息' },
  { value: 'INAPPROPRIATE', label: '不当内容' },
  { value: 'OTHER', label: '其他' },
];

// 状态配置
const statusConfig: Record<string, { color: string; label: string }> = {
  draft: { color: 'default', label: '草稿' },
  pending: { color: 'orange', label: '待审核' },
  approved: { color: 'blue', label: '已发布' },
  matched: { color: 'green', label: '已匹配' },
  closed: { color: 'default', label: '已结案' },
  rejected: { color: 'red', label: '已拒绝' },
};

// 状态时间轴
const statusTimeline = computed(() => {
  if (!post.value) return [];
  const timeline = [];
  if (post.value.createTime) {
    timeline.push({ time: post.value.createTime, label: '发布' });
  }
  if (post.value.auditTime) {
    timeline.push({ time: post.value.auditTime, label: '审核通过' });
  }
  if (post.value.matchTime) {
    timeline.push({ time: post.value.matchTime, label: '匹配成功' });
  }
  if (post.value.closeTime) {
    timeline.push({ time: post.value.closeTime, label: '结案' });
  }
  return timeline;
});

// 加载帖子详情
async function loadPost() {
  const id = Number(route.params.id);
  if (!id) return;

  loading.value = true;
  try {
    const data = await getPostById(id);
    // 转换数据格式
    // 兼容imagesJson为数组或字符串的情况
    let images: string[] = [];
    if (Array.isArray(data.imagesJson)) {
      images = data.imagesJson as unknown as string[];
    } else if (typeof data.imagesJson === 'string' && data.imagesJson) {
      try {
        images = JSON.parse(data.imagesJson);
      } catch {
        images = [];
      }
    }
    post.value = {
      ...data,
      type: data.postType === 'LOST' ? 'lost' : 'found',
      itemName: data.title,
      images,
      eventTime: data.occurTime || data.lostTime || data.foundTime,
      status: data.status?.toLowerCase() || 'pending',
      auditTime: data.auditAt, // 映射后端字段名
    } as PostDetail;
    loadComments();
  } catch (error) {
    console.error('加载帖子详情失败:', error);
    message.error('加载失败');
  } finally {
    loading.value = false;
  }
}

// 加载评论
async function loadComments() {
  if (!post.value?.id) return;
  commentLoading.value = true;
  try {
    const res = await getCommentsByPostId(post.value.id);
    comments.value = res || [];
  } catch (error) {
    console.error('加载评论失败:', error);
  } finally {
    commentLoading.value = false;
  }
}

// 收藏/取消收藏
async function toggleFavorite() {
  if (!post.value?.id) return;
  try {
    if (post.value.isFavorited) {
      await removeFavorite(post.value.id);
      post.value.isFavorited = false;
      post.value.favoriteCount = (post.value.favoriteCount || 1) - 1;
      message.success('已取消收藏');
    } else {
      await addFavorite(post.value.id);
      post.value.isFavorited = true;
      post.value.favoriteCount = (post.value.favoriteCount || 0) + 1;
      message.success('收藏成功');
    }
  } catch {
    message.error('操作失败');
  }
}

// 发起认领
function goClaim() {
  if (!post.value) return;
  router.push(`/lostfound/claims/create?postId=${post.value.id}`);
}

// 联系发布者
function contactPublisher() {
  if (!post.value) return;
  // 使用 createdBy 字段（后端返回的发布者ID）
  router.push(`/lostfound/messages?userId=${post.value.createdBy}`);
}

// 提交评论
async function submitComment() {
  if (!newComment.value.trim()) {
    message.warning('请输入评论内容');
    return;
  }
  if (!post.value) return;

  submitting.value = true;
  try {
    await createComment({
      postId: post.value.id,
      content: newComment.value.trim(),
    });
    message.success('评论成功');
    newComment.value = '';
    loadComments();
  } catch {
    message.error('评论失败');
  } finally {
    submitting.value = false;
  }
}

// 举报
function showReportModal() {
  reportVisible.value = true;
  reportReason.value = '';
  reportReasonType.value = 'OTHER';
}

async function submitReport() {
  if (!reportReason.value.trim()) {
    message.warning('请输入举报原因');
    return;
  }
  if (!post.value) return;

  reportSubmitting.value = true;
  try {
    await createReport({
      targetType: 'POST',
      targetId: post.value.id,
      reasonType: reportReasonType.value,
      reasonDetail: reportReason.value.trim(),
    });
    message.success('举报已提交');
    reportVisible.value = false;
  } catch {
    message.error('举报失败');
  } finally {
    reportSubmitting.value = false;
  }
}

// 格式化时间
function formatTime(time?: string) {
  if (!time) return '';
  return time.replace('T', ' ').slice(0, 16);
}

onMounted(() => {
  loadPost();
});
</script>

<template>
  <Page auto-content-height>
    <Spin :spinning="loading">
      <div v-if="post" class="mx-auto max-w-4xl p-4">
        <!-- 基本信息 -->
        <Card>
          <div class="mb-4 flex items-start justify-between">
            <div>
              <Tag :color="post.type === 'lost' ? 'red' : 'green'" class="mb-2">
                {{ post.type === 'lost' ? '寻物启事' : '招领信息' }}
              </Tag>
              <h1 class="text-2xl font-bold">{{ post.itemName }}</h1>
            </div>
            <Tag :color="statusConfig[post.status || 'pending']?.color">
              {{ statusConfig[post.status || 'pending']?.label }}
            </Tag>
          </div>

          <!-- 图片画廊展示 - 毛玻璃动效版 -->
          <div class="image-gallery-glass mb-4">
            <div class="gallery-glow"></div>
            <div class="gallery-content">
              <ImagePreviewGroup>
                <!-- 主图展示区域 -->
                <div class="main-image-glass">
                  <div class="main-image-inner">
                    <Image
                      :src="currentImage"
                      class="main-image"
                      :preview="hasImages"
                      :fallback="defaultImage"
                    />
                    <div v-if="!hasImages" class="image-placeholder-glass">
                      <div class="placeholder-icon">📷</div>
                      <span>暂无图片</span>
                    </div>
                  </div>
                </div>

                <!-- 缩略图列表 -->
                <div class="thumbnail-glass-container">
                  <div
                    v-for="idx in 6"
                    :key="idx"
                    class="thumbnail-glass-item"
                    :class="{
                      active:
                        currentImageIndex === idx - 1 &&
                        hasImages &&
                        post.images &&
                        post.images[idx - 1],
                      'has-image': post.images && post.images[idx - 1],
                    }"
                    @click="
                      post.images &&
                      post.images[idx - 1] &&
                      selectImage(idx - 1)
                    "
                  >
                    <div class="thumbnail-inner">
                      <Image
                        v-if="post.images && post.images[idx - 1]"
                        :src="getThumbnailUrl(idx - 1)"
                        class="thumbnail-image"
                        :preview="false"
                        :fallback="defaultImage"
                      />
                      <div v-else class="thumbnail-placeholder-glass">
                        <span>{{ idx }}</span>
                      </div>
                    </div>
                  </div>
                </div>
              </ImagePreviewGroup>
            </div>
          </div>

          <!-- 详细信息 -->
          <Descriptions :column="2" bordered>
            <DescriptionsItem label="物品分类">
              {{ post.categoryName || '-' }}
            </DescriptionsItem>
            <DescriptionsItem label="事发地点">
              {{ post.locationName || '-' }}
            </DescriptionsItem>
            <DescriptionsItem label="事发时间">
              {{ formatTime(post.eventTime) || '-' }}
            </DescriptionsItem>
            <DescriptionsItem label="发布时间">
              {{ formatTime(post.createTime) }}
            </DescriptionsItem>
            <DescriptionsItem
              v-if="post.rewardAmount && post.rewardAmount > 0"
              label="悬赏金额"
            >
              {{ post.rewardAmount }}
            </DescriptionsItem>
            <DescriptionsItem
              v-if="post.rewardDesc && post.rewardDesc.trim()"
              label="悬赏说明"
            >
              {{ post.rewardDesc }}
            </DescriptionsItem>
            <DescriptionsItem v-if="post.type === 'found'" label="暂存地点">
              {{ post.storagePlace || '-' }}
            </DescriptionsItem>
            <DescriptionsItem label="浏览量">
              {{ post.viewCount || 0 }}
            </DescriptionsItem>
            <DescriptionsItem label="描述" :span="2">
              {{ post.description || '暂无描述' }}
            </DescriptionsItem>
          </Descriptions>

          <!-- 操作按钮 -->
          <div class="mt-4 flex flex-wrap gap-2">
            <Button
              :type="post.isFavorited ? 'default' : 'primary'"
              @click="toggleFavorite"
            >
              {{ post.isFavorited ? '取消收藏' : '收藏' }}
              ({{ post.favoriteCount || 0 }})
            </Button>
            <Button
              v-if="
                post.type === 'found' &&
                (post.status === 'approved' || post.status === 'published')
              "
              type="primary"
              @click="goClaim"
            >
              发起认领
            </Button>
            <Button @click="contactPublisher">联系发布者</Button>
            <Button danger @click="showReportModal">举报</Button>
          </div>
        </Card>

        <!-- 状态时间轴 -->
        <Card v-if="statusTimeline.length > 0" title="状态记录" class="mt-4">
          <Timeline>
            <TimelineItem v-for="(item, idx) in statusTimeline" :key="idx">
              <p class="font-medium">{{ item.label }}</p>
              <p class="text-gray-500">{{ formatTime(item.time) }}</p>
            </TimelineItem>
          </Timeline>
        </Card>

        <!-- 发布者信息 -->
        <Card title="发布者" class="mt-4">
          <div class="flex items-center gap-4">
            <Avatar :src="post.userAvatar" :size="48">
              {{ (post.createdByName || post.userName)?.charAt(0) }}
            </Avatar>
            <div>
              <div class="font-medium">
                {{ post.createdByName || post.userName || '匿名用户' }}
              </div>
              <div class="text-sm text-gray-500">
                信誉等级: {{ post.userLevel || 1 }}
              </div>
            </div>
          </div>
        </Card>

        <!-- 评论区 -->
        <Card title="评论" class="mt-4">
          <div class="mb-4">
            <Input.TextArea
              v-model:value="newComment"
              placeholder="写下你的评论..."
              :rows="3"
              :maxlength="500"
              show-count
            />
            <div class="mt-2 text-right">
              <Button
                type="primary"
                :loading="submitting"
                @click="submitComment"
              >
                发表评论
              </Button>
            </div>
          </div>

          <Divider />

          <Spin :spinning="commentLoading">
            <List v-if="comments.length > 0" :data-source="comments">
              <template #renderItem="{ item }">
                <ListItem>
                  <ListItemMeta>
                    <template #avatar>
                      <Avatar :src="item.userAvatar">
                        {{ item.userName?.charAt(0) }}
                      </Avatar>
                    </template>
                    <template #title>
                      <span>{{ item.userName }}</span>
                      <span class="ml-2 text-sm text-gray-400">
                        {{ formatTime(item.createTime) }}
                      </span>
                    </template>
                    <template #description>
                      {{ item.content }}
                    </template>
                  </ListItemMeta>
                </ListItem>
              </template>
            </List>
            <Empty v-else description="暂无评论" />
          </Spin>
        </Card>
      </div>

      <Empty v-else-if="!loading" description="帖子不存在" class="py-20" />
    </Spin>

    <!-- 举报弹窗 -->
    <Modal
      v-model:open="reportVisible"
      title="举报"
      :confirm-loading="reportSubmitting"
      @ok="submitReport"
    >
      <div class="mb-4">
        <div class="mb-2">举报类型</div>
        <Select v-model:value="reportReasonType" style="width: 100%">
          <SelectOption
            v-for="opt in reportTypeOptions"
            :key="opt.value"
            :value="opt.value"
          >
            {{ opt.label }}
          </SelectOption>
        </Select>
      </div>
      <div>
        <div class="mb-2">举报原因</div>
        <Input.TextArea
          v-model:value="reportReason"
          placeholder="请输入举报原因..."
          :rows="4"
          :maxlength="500"
          show-count
        />
      </div>
    </Modal>
  </Page>
</template>

<style scoped>
@keyframes pulse-glow {
  0%,
  100% {
    box-shadow: 0 0 5px rgb(100 120 200 / 30%);
  }

  50% {
    box-shadow: 0 0 15px rgb(100 120 200 / 50%);
  }
}

.image-gallery-glass {
  position: relative;
  padding: 1px;
  background: rgb(100 120 200 / 30%);
  border-radius: 16px;
}

.gallery-glow {
  position: absolute;
  inset: -2px;
  z-index: -1;
  background: rgb(100 120 200 / 20%);
  border-radius: 18px;
  opacity: 0.6;
  filter: blur(12px);
}

.gallery-content {
  padding: 20px;
  background: rgb(255 255 255 / 85%);
  border-radius: 15px;
  backdrop-filter: blur(20px);
  backdrop-filter: blur(20px);
}

/* 主图区域 */
.main-image-glass {
  position: relative;
  width: 100%;
  height: 320px;
  margin-bottom: 16px;
  overflow: hidden;
  background: rgb(255 255 255 / 90%);
  border-radius: 12px;
  box-shadow: 0 4px 15px rgb(100 120 200 / 12%);
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

.main-image-glass:hover {
  box-shadow: 0 8px 25px rgb(100 120 200 / 20%);
  transform: scale(1.01);
}

.main-image-inner {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 100%;
  padding: 12px;
}

.main-image {
  max-width: 100%;
  max-height: 100%;
  object-fit: contain;
  border-radius: 8px;
  transition: transform 0.3s ease;
}

.main-image-glass:hover .main-image {
  transform: scale(1.02);
}

.image-placeholder-glass {
  display: flex;
  flex-direction: column;
  gap: 8px;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  color: #8b8fa3;
}

.placeholder-icon {
  font-size: 48px;
  opacity: 0.6;
}

/* 缩略图容器 */
.thumbnail-glass-container {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  justify-content: flex-start;
}

.thumbnail-glass-item {
  position: relative;
  width: 72px;
  height: 72px;
  padding: 2px;
  cursor: pointer;
  background: #e0e5ec;
  border-radius: 10px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.thumbnail-glass-item::before {
  position: absolute;
  inset: 0;
  content: '';
  background: rgb(100 120 200 / 50%);
  border-radius: 10px;
  opacity: 0;
  transition: opacity 0.3s ease;
}

.thumbnail-glass-item:hover::before,
.thumbnail-glass-item.active::before {
  opacity: 1;
}

.thumbnail-glass-item.has-image:hover {
  box-shadow: 0 8px 20px rgb(100 120 200 / 25%);
  transform: translateY(-4px);
}

.thumbnail-glass-item.active {
  animation: pulse-glow 2s ease-in-out infinite;
}

.thumbnail-inner {
  position: relative;
  z-index: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 100%;
  overflow: hidden;
  background: rgb(255 255 255 / 90%);
  border-radius: 8px;
  backdrop-filter: blur(10px);
}

.thumbnail-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.thumbnail-glass-item:hover .thumbnail-image {
  transform: scale(1.1);
}

.thumbnail-placeholder-glass {
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 16px;
  font-weight: 500;
  color: #b0b5c0;
}

/* 深色模式适配 */
:root.dark .gallery-content {
  background: rgb(30 30 40 / 85%);
}

:root.dark .main-image-glass {
  background: rgb(40 40 50 / 90%);
}

:root.dark .thumbnail-glass-item {
  background: #2a2a3a;
}

:root.dark .thumbnail-inner {
  background: rgb(40 40 50 / 90%);
}

:root.dark .image-placeholder-glass,
:root.dark .thumbnail-placeholder-glass {
  color: #6b7080;
}

/* 毛玻璃图片画廊样式 */
</style>
