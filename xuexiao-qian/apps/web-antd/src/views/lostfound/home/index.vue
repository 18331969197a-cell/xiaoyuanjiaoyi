<script lang="ts" setup>
import type { BizComment } from '#/api/lostfound/comment';
import type { Notice } from '#/api/lostfound/notice';
import type { BizPost, PostQueryParams } from '#/api/lostfound/post';

import { computed, onMounted, ref } from 'vue';
import { useRouter } from 'vue-router';

import { Page } from '@vben/common-ui';
import { useAppConfig } from '@vben/hooks';
import { Plus } from '@vben/icons';

import {
  AppstoreOutlined,
  CheckCircleOutlined,
  CommentOutlined,
  CompassOutlined,
  EllipsisOutlined,
  EnvironmentOutlined,
  FilterOutlined,
  FireOutlined,
  NotificationOutlined,
  ShareAltOutlined,
  StarFilled,
  StarOutlined,
  TagOutlined,
} from '@ant-design/icons-vue';
import {
  Avatar,
  Badge,
  Button,
  Card,
  Col,
  Divider,
  Drawer,
  Dropdown,
  Empty,
  Image,
  ImagePreviewGroup,
  Input,
  List,
  ListItem,
  ListItemMeta,
  Menu,
  MenuItem,
  message,
  Pagination,
  Popover,
  Row,
  Select,
  Space,
  Spin,
  Tabs,
  Tag,
  Tooltip,
} from 'ant-design-vue';

import { getCategoryTree, getLocationTree } from '#/api/lostfound/base';
import { createComment, getCommentsByPostId } from '#/api/lostfound/comment';
import {
  addFavorite,
  batchCheckFavorited,
  removeFavorite,
} from '#/api/lostfound/favorite';
import { getNoticeList } from '#/api/lostfound/notice';
import { getPostList } from '#/api/lostfound/post';

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

const router = useRouter();
const activeTab = ref<string>('all');
const loading = ref(false);
const postList = ref<BizPost[]>([]);
const total = ref(0);
const currentPage = ref(1);
const pageSize = ref(10);

// 筛选条件
const searchKeyword = ref('');
const selectedCategory = ref<number | undefined>();
const selectedLocation = ref<number | undefined>();
const selectedStatus = ref<string | undefined>();
const selectedTime = ref<string | undefined>();
const categoryOptions = ref<any[]>([]);
const locationOptions = ref<any[]>([]);
const showFilter = ref(false);

// 评论抽屉
const commentDrawerVisible = ref(false);
const currentPost = ref<BizPost | null>(null);
const comments = ref<BizComment[]>([]);
const commentLoading = ref(false);
const newComment = ref('');
const submittingComment = ref(false);

// 收藏状态缓存
const favoriteMap = ref<Record<number, boolean>>({});

// 公告列表
const notices = ref<Notice[]>([]);

// Tab 配置
const tabItems = [
  { key: 'all', label: '全部' },
  { key: 'LOST', label: '寻物启事' },
  { key: 'FOUND', label: '招领信息' },
];

// 时间筛选选项
const timeOptions = [
  { value: 'today', label: '今天' },
  { value: '3days', label: '3天内' },
  { value: '7days', label: '7天内' },
  { value: '30days', label: '30天内' },
];

// 状态筛选选项
const statusOptions = [
  { value: 'PUBLISHED', label: '未解决' },
  { value: 'CLOSED', label: '已解决' },
];

// 状态配置
const statusConfig: Record<string, { color: string; label: string }> = {
  DRAFT: { color: 'default', label: '草稿' },
  PENDING: { color: 'orange', label: '待审核' },
  PUBLISHED: { color: 'processing', label: '未解决' },
  CLAIMING: { color: 'cyan', label: '认领中' },
  CLOSED: { color: 'success', label: '已解决' },
  REJECTED: { color: 'error', label: '已拒绝' },
};

// 计算查询参数
const queryParams = computed<PostQueryParams>(() => ({
  pageNum: currentPage.value,
  pageSize: pageSize.value,
  postType: activeTab.value === 'all' ? undefined : activeTab.value,
  keyword: searchKeyword.value || undefined,
  categoryId: selectedCategory.value,
  locationId: selectedLocation.value,
  status: selectedStatus.value || 'PUBLISHED',
}));

// 加载帖子列表
async function loadPosts() {
  loading.value = true;
  try {
    const res = (await getPostList(queryParams.value)) as any;
    // 兼容两种返回格式: MyBatis-Plus的records和标准的rows
    postList.value = res.records || res.rows || [];
    total.value = res.total || 0;

    // 批量获取收藏状态
    await loadFavoriteStatus();
  } catch (error) {
    console.error('加载帖子列表失败:', error);
  } finally {
    loading.value = false;
  }
}

// 加载收藏状态
async function loadFavoriteStatus() {
  if (postList.value.length === 0) return;
  try {
    const postIds = postList.value.map((p) => p.id!).filter(Boolean);
    const statusMap = await batchCheckFavorited(postIds);
    if (statusMap) {
      Object.assign(favoriteMap.value, statusMap);
    }
  } catch (error) {
    console.error('加载收藏状态失败:', error);
  }
}

// 加载分类和地点选项
async function loadOptions() {
  try {
    const [categories, locations] = await Promise.all([
      getCategoryTree(),
      getLocationTree(),
    ]);
    // API 返回的字段是 name，不是 categoryName/locationName
    categoryOptions.value = flattenTree(categories, 'name');
    locationOptions.value = flattenTree(locations, 'name');
  } catch (error) {
    console.error('加载选项失败:', error);
  }
}

// 加载公告列表
async function loadNotices() {
  try {
    notices.value = await getNoticeList();
  } catch (error) {
    console.error('加载公告失败:', error);
    // 加载失败时使用默认公告
    notices.value = [
      {
        id: 1,
        noticeTitle: '请勿轻信陌生人，谨防诈骗',
        noticeContent: '',
        noticeType: '1',
        createTime: '',
      },
      {
        id: 2,
        noticeTitle: '认领物品请携带有效证件',
        noticeContent: '',
        noticeType: '1',
        createTime: '',
      },
      {
        id: 3,
        noticeTitle: '贵重物品建议当面交接',
        noticeContent: '',
        noticeType: '1',
        createTime: '',
      },
    ];
  }
}

// 扁平化树形结构
function flattenTree(
  tree: any[],
  labelField: string,
  result: any[] = [],
): any[] {
  for (const node of tree) {
    result.push({ value: node.id, label: node[labelField] });
    if (node.children?.length) {
      flattenTree(node.children, labelField, result);
    }
  }
  return result;
}

// Tab 切换
function onTabChange(key: number | string) {
  activeTab.value = String(key);
  currentPage.value = 1;
  loadPosts();
}

// 搜索
function onSearch() {
  currentPage.value = 1;
  loadPosts();
}

// 重置筛选
function resetFilter() {
  selectedCategory.value = undefined;
  selectedLocation.value = undefined;
  selectedStatus.value = undefined;
  selectedTime.value = undefined;
  searchKeyword.value = '';
  currentPage.value = 1;
  loadPosts();
}

// 分页变化
function onPageChange(page: number, size: number) {
  currentPage.value = page;
  pageSize.value = size;
  loadPosts();
}

// 查看详情
function viewDetail(id: number) {
  router.push(`/lostfound/posts/${id}`);
}

// 发布帖子
function goPublish(type: 'found' | 'lost') {
  router.push(`/lostfound/publish/${type}`);
}

// 格式化相对时间
function formatRelativeTime(time: string) {
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
  if (days === 1) return '昨天';
  if (days < 7) return `${days}天前`;
  return time.slice(0, 10);
}

// 格式化绝对时间
function formatAbsoluteTime(time: string) {
  if (!time) return '';
  return time.replace('T', ' ').slice(0, 16);
}

// 解析图片并转换为完整URL
// 后端返回的 imagesJson 可能是数组或JSON字符串
function parseImages(imagesJson: string | string[] | undefined): string[] {
  if (!imagesJson) return [];
  try {
    let images: string[];
    // 如果已经是数组，直接使用
    if (Array.isArray(imagesJson)) {
      images = imagesJson;
    } else if (typeof imagesJson === 'string') {
      // 如果是字符串，尝试解析
      images = JSON.parse(imagesJson);
    } else {
      return [];
    }
    // 过滤空值并转换为完整URL
    return images.filter(Boolean).map((url: string) => getFullImageUrl(url));
  } catch {
    return [];
  }
}

// 打开评论抽屉
async function openCommentDrawer(post: BizPost) {
  currentPost.value = post;
  commentDrawerVisible.value = true;
  await loadComments(post.id!);
}

// 加载评论
async function loadComments(postId: number) {
  commentLoading.value = true;
  try {
    comments.value = await getCommentsByPostId(postId);
  } catch (error) {
    console.error('加载评论失败:', error);
    comments.value = [];
  } finally {
    commentLoading.value = false;
  }
}

// 提交评论
async function submitComment() {
  if (!newComment.value.trim()) {
    message.warning('请输入评论内容');
    return;
  }
  if (!currentPost.value) return;

  submittingComment.value = true;
  try {
    await createComment({
      postId: currentPost.value.id,
      content: newComment.value.trim(),
    });
    message.success('评论成功');
    newComment.value = '';
    await loadComments(currentPost.value.id!);
    // 更新评论数
    const post = postList.value.find((p) => p.id === currentPost.value?.id);
    if (post) {
      post.commentCount = (post.commentCount || 0) + 1;
    }
  } catch {
    message.error('评论失败');
  } finally {
    submittingComment.value = false;
  }
}

// 收藏/取消收藏
async function toggleFavorite(post: BizPost, e: Event) {
  e.stopPropagation();
  try {
    const isFavorited = favoriteMap.value[post.id!];
    if (isFavorited) {
      await removeFavorite(post.id!);
      favoriteMap.value[post.id!] = false;
      post.favoriteCount = Math.max((post.favoriteCount || 1) - 1, 0);
      message.success('已取消收藏');
    } else {
      await addFavorite(post.id!);
      favoriteMap.value[post.id!] = true;
      post.favoriteCount = (post.favoriteCount || 0) + 1;
      message.success('收藏成功');
    }
  } catch {
    message.error('操作失败');
  }
}

// 分享
function sharePost(post: BizPost, e: Event) {
  e.stopPropagation();
  const url = `${window.location.origin}/lostfound/posts/${post.id}`;
  navigator.clipboard
    .writeText(url)
    .then(() => {
      message.success('链接已复制到剪贴板');
    })
    .catch(() => {
      message.info('请手动复制链接');
    });
}

// 举报
function reportPost(post: BizPost) {
  router.push(`/lostfound/posts/${post.id}?action=report`);
}

// 联系发布者
function contactPublisher(post: BizPost, e: Event) {
  e.stopPropagation();
  router.push(`/lostfound/messages?userId=${post.userId}`);
}

// 初始化加载状态
const initialLoading = ref(true);

onMounted(async () => {
  // 使用 Promise.all 并行加载所有初始数据
  try {
    await Promise.all([loadOptions(), loadPosts(), loadNotices()]);
  } catch (error) {
    console.error('初始化加载失败:', error);
  } finally {
    initialLoading.value = false;
  }
});
</script>

<template>
  <Page auto-content-height content-class="!p-0">
    <div class="home-container h-full bg-gray-50">
      <Row :gutter="24" class="h-full p-4">
        <!-- 左侧信息流 -->
        <Col :xs="24" :lg="17" :xl="18" class="h-full overflow-y-auto">
          <!-- 顶部操作栏 -->
          <div
            class="mb-4 flex flex-wrap items-center justify-between gap-3 rounded-lg bg-white p-4 shadow-sm"
          >
            <div class="flex flex-wrap items-center gap-3">
              <Input.Search
                v-model:value="searchKeyword"
                placeholder="搜索物品名称、描述、地点..."
                style="width: 280px"
                allow-clear
                @search="onSearch"
              />
              <Popover
                v-model:open="showFilter"
                trigger="click"
                placement="bottomLeft"
              >
                <template #content>
                  <div class="w-64 space-y-3">
                    <div>
                      <div class="mb-1 text-sm text-gray-500">分类</div>
                      <Select
                        v-model:value="selectedCategory"
                        placeholder="选择分类"
                        style="width: 100%"
                        allow-clear
                        :options="categoryOptions"
                      />
                    </div>
                    <div>
                      <div class="mb-1 text-sm text-gray-500">地点</div>
                      <Select
                        v-model:value="selectedLocation"
                        placeholder="选择地点"
                        style="width: 100%"
                        allow-clear
                        :options="locationOptions"
                      />
                    </div>
                    <div>
                      <div class="mb-1 text-sm text-gray-500">时间</div>
                      <Select
                        v-model:value="selectedTime"
                        placeholder="选择时间"
                        style="width: 100%"
                        allow-clear
                        :options="timeOptions"
                      />
                    </div>
                    <div>
                      <div class="mb-1 text-sm text-gray-500">状态</div>
                      <Select
                        v-model:value="selectedStatus"
                        placeholder="选择状态"
                        style="width: 100%"
                        allow-clear
                        :options="statusOptions"
                      />
                    </div>
                    <div class="flex justify-end gap-2 pt-2">
                      <Button size="small" @click="resetFilter">重置</Button>
                      <Button
                        type="primary"
                        size="small"
                        @click="
                          showFilter = false;
                          onSearch();
                        "
                      >
                        确定
                      </Button>
                    </div>
                  </div>
                </template>
                <Button>
                  <FilterOutlined />
                  筛选
                </Button>
              </Popover>
            </div>
            <div class="flex gap-2">
              <Button type="primary" @click="goPublish('lost')">
                <Plus class="mr-1 size-4" />
                发布寻物
              </Button>
              <Button @click="goPublish('found')">
                <Plus class="mr-1 size-4" />
                发布招领
              </Button>
            </div>
          </div>

          <!-- Tab 切换 -->
          <div class="mb-4 rounded-lg bg-white px-4 shadow-sm">
            <Tabs :active-key="activeTab" @change="onTabChange">
              <Tabs.TabPane
                v-for="tab in tabItems"
                :key="tab.key"
                :tab="tab.label"
              />
            </Tabs>
          </div>

          <!-- 信息流卡片列表 -->
          <Spin :spinning="loading">
            <div v-if="postList.length > 0" class="space-y-4">
              <Card
                v-for="post in postList"
                :key="post.id"
                class="post-card cursor-pointer transition-shadow hover:shadow-md"
                :body-style="{ padding: '16px' }"
                @click="viewDetail(post.id!)"
              >
                <!-- 卡片头部 -->
                <div class="mb-3 flex items-center justify-between">
                  <div class="flex items-center gap-3">
                    <Avatar :size="40" class="bg-blue-500">
                      {{
                        (post.createdByName || post.userName)?.charAt(0) || '匿'
                      }}
                    </Avatar>
                    <div>
                      <div class="flex items-center gap-2">
                        <span class="font-medium">{{
                          post.createdByName || post.userName || '匿名用户'
                        }}</span>
                        <Tag v-if="post.isTop" color="red" size="small">
                          置顶
                        </Tag>
                      </div>
                      <Tooltip
                        :title="formatAbsoluteTime(post.createTime || '')"
                      >
                        <span class="text-xs text-gray-400">
                          {{ formatRelativeTime(post.createTime || '') }}
                        </span>
                      </Tooltip>
                    </div>
                  </div>
                  <Dropdown placement="bottomRight" @click.stop>
                    <Button type="text" size="small">
                      <EllipsisOutlined />
                    </Button>
                    <template #overlay>
                      <Menu>
                        <MenuItem key="report" @click="reportPost(post)">
                          举报
                        </MenuItem>
                        <MenuItem
                          key="contact"
                          @click="contactPublisher(post, $event)"
                        >
                          联系TA
                        </MenuItem>
                      </Menu>
                    </template>
                  </Dropdown>
                </div>

                <!-- 内容区：左右布局 -->
                <div class="mb-3 flex gap-4">
                  <!-- 左侧文字内容 -->
                  <div class="min-w-0 flex-1">
                    <!-- 标题 -->
                    <div class="mb-2 flex items-center gap-2">
                      <Tag
                        :color="post.postType === 'LOST' ? 'error' : 'success'"
                        class="mr-0"
                      >
                        {{ post.postType === 'LOST' ? '寻物' : '招领' }}
                      </Tag>
                      <span class="text-base font-medium">{{
                        post.title
                      }}</span>
                    </div>

                    <!-- 描述 -->
                    <p class="mb-3 line-clamp-3 text-sm text-gray-600">
                      {{ post.description || '暂无描述' }}
                    </p>

                    <!-- 标签Chips -->
                    <div class="flex flex-wrap gap-2">
                      <Tag
                        v-if="post.locationName"
                        class="flex items-center gap-1"
                      >
                        <EnvironmentOutlined />
                        {{ post.locationName }}
                      </Tag>
                      <Tag
                        v-if="post.categoryName"
                        class="flex items-center gap-1"
                      >
                        <TagOutlined />
                        {{ post.categoryName }}
                      </Tag>
                      <Tag
                        v-if="post.rewardAmount && post.rewardAmount > 0"
                        color="gold"
                      >
                        悬赏 ¥{{ post.rewardAmount }}
                      </Tag>
                      <Tag
                        :color="statusConfig[post.status || 'PUBLISHED']?.color"
                        class="flex items-center gap-1"
                      >
                        <FireOutlined v-if="post.status === 'PUBLISHED'" />
                        <CheckCircleOutlined
                          v-else-if="post.status === 'CLOSED'"
                        />
                        {{ statusConfig[post.status || 'PUBLISHED']?.label }}
                      </Tag>
                    </div>
                  </div>

                  <!-- 右侧图片展示区 -->
                  <div
                    v-if="parseImages(post.imagesJson).length > 0"
                    class="post-image-area flex-shrink-0"
                    @click.stop
                  >
                    <ImagePreviewGroup>
                      <div class="relative">
                        <Image
                          :src="parseImages(post.imagesJson)[0]"
                          :width="120"
                          :height="120"
                          class="rounded-lg object-cover"
                        />
                        <!-- 多图角标 -->
                        <div
                          v-if="parseImages(post.imagesJson).length > 1"
                          class="image-count-badge"
                        >
                          +{{ parseImages(post.imagesJson).length - 1 }}
                        </div>
                        <!-- 隐藏的其他图片用于预览 -->
                        <Image
                          v-for="(img, idx) in parseImages(
                            post.imagesJson,
                          ).slice(1)"
                          :key="idx"
                          :src="img"
                          style="display: none"
                        />
                      </div>
                    </ImagePreviewGroup>
                  </div>

                  <!-- 无图片时的占位 -->
                  <div v-else class="post-image-placeholder flex-shrink-0">
                    <div
                      class="flex h-full w-full items-center justify-center rounded-lg bg-gray-100 text-gray-300"
                    >
                      <TagOutlined style="font-size: 32px" />
                    </div>
                  </div>
                </div>

                <!-- 互动栏 -->
                <Divider class="my-3" />
                <div class="flex items-center justify-between text-gray-500">
                  <Space :size="24">
                    <Button
                      type="text"
                      size="small"
                      class="flex items-center gap-1"
                      @click.stop="openCommentDrawer(post)"
                    >
                      <CommentOutlined />
                      <span>{{ post.commentCount || 0 }}</span>
                    </Button>
                    <Button
                      type="text"
                      size="small"
                      class="flex items-center gap-1"
                      @click="sharePost(post, $event)"
                    >
                      <ShareAltOutlined />
                      <span>分享</span>
                    </Button>
                    <Button
                      type="text"
                      size="small"
                      class="flex items-center gap-1"
                      :class="{ 'text-yellow-500': favoriteMap[post.id!] }"
                      @click="toggleFavorite(post, $event)"
                    >
                      <StarFilled v-if="favoriteMap[post.id!]" />
                      <StarOutlined v-else />
                      <span>{{ post.favoriteCount || 0 }}</span>
                    </Button>
                  </Space>
                </div>
              </Card>

              <!-- 分页 -->
              <div class="flex justify-center py-4">
                <Pagination
                  :current="currentPage"
                  :page-size="pageSize"
                  :total="total"
                  show-size-changer
                  show-quick-jumper
                  :show-total="(t) => `共 ${t} 条`"
                  @change="onPageChange"
                />
              </div>
            </div>

            <Empty
              v-else
              description="暂无数据"
              class="rounded-lg bg-white py-20"
            />
          </Spin>
        </Col>

        <!-- 右侧边栏 -->
        <Col :xs="0" :lg="7" :xl="6">
          <div class="sticky top-4 space-y-4">
            <!-- 置顶公告 -->
            <Card title="公告" size="small" class="sidebar-card">
              <template #extra>
                <div class="card-corner-badge badge-notice">
                  <NotificationOutlined />
                </div>
              </template>
              <div class="space-y-2 text-sm">
                <div
                  v-for="notice in notices.slice(0, 5)"
                  :key="notice.id"
                  class="flex items-start gap-2"
                >
                  <Badge
                    :status="
                      notice.noticeType === '1'
                        ? 'error'
                        : notice.noticeType === '2'
                          ? 'warning'
                          : 'processing'
                    "
                  />
                  <span>{{ notice.noticeTitle }}</span>
                </div>
                <div v-if="notices.length === 0" class="text-gray-400">
                  暂无公告
                </div>
              </div>
            </Card>

            <!-- 热门分类 -->
            <Card title="热门分类" size="small" class="sidebar-card">
              <template #extra>
                <div class="card-corner-badge badge-category">
                  <AppstoreOutlined />
                </div>
              </template>
              <div class="flex flex-wrap gap-2">
                <Tag
                  v-for="cat in categoryOptions.slice(0, 8)"
                  :key="cat.value"
                  class="cursor-pointer"
                  @click="
                    selectedCategory = cat.value;
                    onSearch();
                  "
                >
                  {{ cat.label }}
                </Tag>
              </div>
            </Card>

            <!-- 常用地点 -->
            <Card title="常用地点" size="small" class="sidebar-card">
              <template #extra>
                <div class="card-corner-badge badge-location">
                  <CompassOutlined />
                </div>
              </template>
              <div class="flex flex-wrap gap-2">
                <Tag
                  v-for="loc in locationOptions.slice(0, 8)"
                  :key="loc.value"
                  class="cursor-pointer"
                  @click="
                    selectedLocation = loc.value;
                    onSearch();
                  "
                >
                  {{ loc.label }}
                </Tag>
              </div>
            </Card>
          </div>
        </Col>
      </Row>
    </div>

    <!-- 评论抽屉 -->
    <Drawer
      v-model:open="commentDrawerVisible"
      title="评论"
      placement="right"
      :width="400"
    >
      <template v-if="currentPost">
        <div class="mb-4 border-b pb-4">
          <div class="flex items-center gap-2">
            <Tag :color="currentPost.postType === 'LOST' ? 'error' : 'success'">
              {{ currentPost.postType === 'LOST' ? '寻物' : '招领' }}
            </Tag>
            <span class="font-medium">{{ currentPost.title }}</span>
          </div>
        </div>

        <!-- 评论输入 -->
        <div class="mb-4">
          <Input.TextArea
            v-model:value="newComment"
            placeholder="补充线索、确认特征、约定归还时间..."
            :rows="3"
            :maxlength="500"
            show-count
          />
          <div class="mt-2 flex items-center justify-between">
            <Space>
              <Button
                size="small"
                @click="newComment = '我可能是失主，我的特征是...'"
              >
                我是失主
              </Button>
              <Button
                size="small"
                @click="newComment = '我捡到了，联系方式...'"
              >
                我捡到了
              </Button>
            </Space>
            <Button
              type="primary"
              :loading="submittingComment"
              @click="submitComment"
            >
              发表
            </Button>
          </div>
        </div>

        <Divider />

        <!-- 评论列表 -->
        <Spin :spinning="commentLoading">
          <List
            v-if="comments.length > 0"
            :data-source="comments"
            item-layout="horizontal"
          >
            <template #renderItem="{ item }">
              <ListItem>
                <ListItemMeta>
                  <template #avatar>
                    <Avatar>{{ item.userName?.charAt(0) }}</Avatar>
                  </template>
                  <template #title>
                    <div class="flex items-center justify-between">
                      <span>{{ item.userName }}</span>
                      <span class="text-xs text-gray-400">
                        {{ formatRelativeTime(item.createTime || '') }}
                      </span>
                    </div>
                  </template>
                  <template #description>
                    <p class="text-gray-600">{{ item.content }}</p>
                  </template>
                </ListItemMeta>
              </ListItem>
            </template>
          </List>
          <Empty v-else description="暂无评论，快来抢沙发~" />
        </Spin>
      </template>
    </Drawer>
  </Page>
</template>

<style scoped>


/* 移动端响应式 */
@media screen and (max-width: 767px) {
  .home-container .p-4 {
    padding: 8px !important;
  }

  .post-image-area,
  .post-image-placeholder {
    width: 100% !important;
    height: 180px !important;
  }

  .post-image-area :deep(.ant-image) {
    width: 100% !important;
    height: 180px !important;
  }

  .post-image-area :deep(.ant-image img) {
    width: 100% !important;
    height: 180px !important;
    object-fit: cover;
  }

  .post-card .flex.gap-4 {
    flex-direction: column-reverse;
  }

  :deep(.ant-drawer-content-wrapper) {
    width: 100% !important;
  }
}

.home-container {
  height: 100%;
  min-height: 100%;
  overflow-y: auto;
}

.post-card {
  border-radius: 8px;
}

.line-clamp-3 {
  display: -webkit-box;
  overflow: hidden;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
}

/* 右侧图片展示区 */
.post-image-area {
  width: 120px;
  height: 120px;
}

.post-image-placeholder {
  width: 120px;
  height: 120px;
}

/* 多图角标 */
.image-count-badge {
  position: absolute;
  right: 6px;
  bottom: 6px;
  padding: 2px 6px;
  font-size: 12px;
  line-height: 1;
  color: #fff;
  background: rgb(0 0 0 / 60%);
  border-radius: 4px;
}

:deep(.ant-tabs-nav) {
  margin-bottom: 0;
}

:deep(.ant-card-head) {
  min-height: auto;
  padding: 12px 16px;
}

:deep(.ant-card-head-title) {
  padding: 0;
  font-size: 14px;
}

:deep(.ant-card-body) {
  padding: 12px 16px;
}

/* 侧边栏卡片样式 */
.sidebar-card {
  position: relative;
  overflow: visible;
}

.sidebar-card :deep(.ant-card-head) {
  border-bottom: 1px solid #f0f0f0;
}

/* 角标装饰 */
.card-corner-badge {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 28px;
  height: 28px;
  font-size: 14px;
  color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 6px rgb(0 0 0 / 15%);
}

.badge-notice {
  background: linear-gradient(135deg, #ff6b6b, #ee5a5a);
}

.badge-category {
  background: linear-gradient(135deg, #ffa940, #fa8c16);
}

.badge-location {
  background: linear-gradient(135deg, #36cfc9, #13c2c2);
}
</style>
