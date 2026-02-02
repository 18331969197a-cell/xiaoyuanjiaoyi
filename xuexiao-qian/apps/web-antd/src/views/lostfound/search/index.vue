<script lang="ts" setup>
import { onMounted, ref } from 'vue';
import { useRoute, useRouter } from 'vue-router';

import { Page } from '@vben/common-ui';
import { useAppConfig } from '@vben/hooks';

import {
  Button,
  Card,
  Col,
  DatePicker,
  Empty,
  Form,
  FormItem,
  Input,
  Pagination,
  Radio,
  RadioGroup,
  Row,
  Select,
  Space,
  Spin,
  Tag,
} from 'ant-design-vue';
import {
  CloseOutlined,
  DeleteOutlined,
  FireOutlined,
  HistoryOutlined,
} from '@ant-design/icons-vue';

import { getCategoryTree, getLocationTree } from '#/api/lostfound/base';
import { getHotSearchKeywords, searchPosts } from '#/api/lostfound/post';
import type { PostListItem, PostSearchParams } from '#/api/lostfound/post';

// 搜索历史存储key
const SEARCH_HISTORY_KEY = 'lostfound_search_history';
const MAX_HISTORY_COUNT = 10;

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

const route = useRoute();
const router = useRouter();
const loading = ref(false);
const postList = ref<PostListItem[]>([]);
const total = ref(0);
const currentPage = ref(1);
const pageSize = ref(12);

// 搜索历史
const searchHistory = ref<string[]>([]);

// 热门搜索
const hotSearchKeywords = ref<string[]>([]);

// 筛选表单
const searchForm = ref<PostSearchParams>({
  keyword: '',
  type: undefined,
  categoryId: undefined,
  locationId: undefined,
  startTime: undefined,
  endTime: undefined,
  sortBy: 'createTime',
  sortOrder: 'desc',
});

const categoryOptions = ref<any[]>([]);
const locationOptions = ref<any[]>([]);

// 排序选项
const sortOptions = [
  { value: 'createTime', label: '发布时间' },
  { value: 'eventTime', label: '事件时间' },
  { value: 'viewCount', label: '浏览量' },
];

// 状态标签
const statusColors: Record<string, string> = {
  pending: 'orange',
  approved: 'blue',
  matched: 'green',
  closed: 'default',
};

const statusLabels: Record<string, string> = {
  pending: '待审核',
  approved: '已发布',
  matched: '已匹配',
  closed: '已结案',
};

// 搜索帖子
async function doSearch() {
  loading.value = true;
  try {
    // 保存搜索历史
    if (searchForm.value.keyword?.trim()) {
      addSearchHistory(searchForm.value.keyword.trim());
    }

    const params: PostSearchParams = {
      ...searchForm.value,
      pageNum: currentPage.value,
      pageSize: pageSize.value,
      status: 'approved',
    };
    const res = await searchPosts(params);
    // 兼容 records 和 rows 两种返回格式
    const rawList = res.records || res.rows || [];
    // 处理图片字段
    postList.value = rawList.map((post: any) => {
      let images: string[] = [];
      if (Array.isArray(post.imagesJson)) {
        images = post.imagesJson
          .filter((url: string) => url)
          .map((url: string) => getFullImageUrl(url));
      } else if (typeof post.imagesJson === 'string' && post.imagesJson) {
        try {
          const parsed = JSON.parse(post.imagesJson);
          images = parsed
            .filter((url: string) => url)
            .map((url: string) => getFullImageUrl(url));
        } catch {
          images = [];
        }
      }
      return {
        ...post,
        images,
        type: post.postType === 'LOST' ? 'lost' : 'found',
        itemName: post.title,
        eventTime: post.occurTime || post.lostTime || post.foundTime,
        status: post.status?.toLowerCase() || 'pending',
      };
    });
    total.value = res.total || 0;
  } catch (error) {
    console.error('搜索失败:', error);
  } finally {
    loading.value = false;
  }
}

// 加载选项
async function loadOptions() {
  try {
    const [categories, locations] = await Promise.all([
      getCategoryTree(),
      getLocationTree(),
    ]);
    categoryOptions.value = flattenTree(categories, 'categoryName');
    locationOptions.value = flattenTree(locations, 'locationName');
  } catch (error) {
    console.error('加载选项失败:', error);
  }
}

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

// 重置筛选
function resetForm() {
  searchForm.value = {
    keyword: '',
    type: undefined,
    categoryId: undefined,
    locationId: undefined,
    startTime: undefined,
    endTime: undefined,
    sortBy: 'createTime',
    sortOrder: 'desc',
  };
  currentPage.value = 1;
  doSearch();
}

// 分页变化
function onPageChange(page: number, size: number) {
  currentPage.value = page;
  pageSize.value = size;
  doSearch();
}

// 查看详情
function viewDetail(id: number) {
  router.push(`/lostfound/posts/${id}`);
}

// 日期范围变化
function onDateChange(dates: any) {
  if (dates && dates.length === 2) {
    searchForm.value.startTime = dates[0]?.format('YYYY-MM-DD');
    searchForm.value.endTime = dates[1]?.format('YYYY-MM-DD');
  } else {
    searchForm.value.startTime = undefined;
    searchForm.value.endTime = undefined;
  }
}

// 格式化时间
function formatTime(time: string) {
  if (!time) return '';
  return time.slice(0, 10);
}

// 搜索历史相关函数
function loadSearchHistory() {
  try {
    const history = localStorage.getItem(SEARCH_HISTORY_KEY);
    searchHistory.value = history ? JSON.parse(history) : [];
  } catch {
    searchHistory.value = [];
  }
}

function addSearchHistory(keyword: string) {
  if (!keyword.trim()) return;
  // 移除重复项
  const filtered = searchHistory.value.filter((h) => h !== keyword);
  // 添加到开头
  filtered.unshift(keyword);
  // 限制数量
  searchHistory.value = filtered.slice(0, MAX_HISTORY_COUNT);
  // 保存到localStorage
  localStorage.setItem(SEARCH_HISTORY_KEY, JSON.stringify(searchHistory.value));
}

function removeSearchHistory(keyword: string) {
  searchHistory.value = searchHistory.value.filter((h) => h !== keyword);
  localStorage.setItem(SEARCH_HISTORY_KEY, JSON.stringify(searchHistory.value));
}

function clearSearchHistory() {
  searchHistory.value = [];
  localStorage.removeItem(SEARCH_HISTORY_KEY);
}

function useHistoryKeyword(keyword: string) {
  searchForm.value.keyword = keyword;
  doSearch();
}

// 加载热门搜索
async function loadHotSearch() {
  try {
    hotSearchKeywords.value = await getHotSearchKeywords(10);
  } catch (error) {
    console.error('加载热门搜索失败:', error);
  }
}

onMounted(() => {
  // 加载搜索历史
  loadSearchHistory();
  // 加载热门搜索
  loadHotSearch();
  // 从路由参数获取初始搜索关键词
  if (route.query.keyword) {
    searchForm.value.keyword = route.query.keyword as string;
  }
  if (route.query.type) {
    searchForm.value.type = route.query.type as string;
  }
  loadOptions();
  doSearch();
});
</script>

<template>
  <Page auto-content-height>
    <div class="p-4">
      <!-- 搜索历史 -->
      <Card v-if="searchHistory.length > 0" class="mb-4" size="small">
        <div class="flex items-center justify-between">
          <div class="flex flex-wrap items-center gap-2">
            <HistoryOutlined class="text-gray-400" />
            <span class="mr-2 text-sm text-gray-500">搜索历史：</span>
            <Tag
              v-for="keyword in searchHistory"
              :key="keyword"
              class="cursor-pointer"
              closable
              @click="useHistoryKeyword(keyword)"
              @close="removeSearchHistory(keyword)"
            >
              {{ keyword }}
            </Tag>
          </div>
          <Button type="link" size="small" danger @click="clearSearchHistory">
            <DeleteOutlined />
            清空
          </Button>
        </div>
      </Card>

      <!-- 热门搜索 -->
      <Card v-if="hotSearchKeywords.length > 0" class="mb-4" size="small">
        <div class="flex flex-wrap items-center gap-2">
          <FireOutlined class="text-orange-500" />
          <span class="mr-2 text-sm text-gray-500">热门搜索：</span>
          <Tag
            v-for="(keyword, index) in hotSearchKeywords"
            :key="keyword"
            :color="index < 3 ? 'red' : 'default'"
            class="cursor-pointer"
            @click="useHistoryKeyword(keyword)"
          >
            {{ keyword }}
          </Tag>
        </div>
      </Card>

      <!-- 搜索表单 -->
      <Card class="mb-4">
        <Form layout="inline" class="flex flex-wrap gap-4">
          <FormItem label="关键词">
            <Input
              v-model:value="searchForm.keyword"
              placeholder="物品名称、描述..."
              style="width: 200px"
              allow-clear
              @press-enter="doSearch"
            />
          </FormItem>

          <FormItem label="类型">
            <RadioGroup v-model:value="searchForm.type" @change="doSearch">
              <Radio :value="undefined">全部</Radio>
              <Radio value="lost">寻物</Radio>
              <Radio value="found">招领</Radio>
            </RadioGroup>
          </FormItem>

          <FormItem label="分类">
            <Select
              v-model:value="searchForm.categoryId"
              placeholder="选择分类"
              style="width: 150px"
              allow-clear
              :options="categoryOptions"
              @change="doSearch"
            />
          </FormItem>

          <FormItem label="地点">
            <Select
              v-model:value="searchForm.locationId"
              placeholder="选择地点"
              style="width: 150px"
              allow-clear
              :options="locationOptions"
              @change="doSearch"
            />
          </FormItem>

          <FormItem label="时间范围">
            <DatePicker.RangePicker
              style="width: 240px"
              @change="onDateChange"
            />
          </FormItem>

          <FormItem label="排序">
            <Select
              v-model:value="searchForm.sortBy"
              style="width: 120px"
              :options="sortOptions"
              @change="doSearch"
            />
          </FormItem>

          <FormItem label="顺序">
            <RadioGroup v-model:value="searchForm.sortOrder" @change="doSearch">
              <Radio value="desc">降序</Radio>
              <Radio value="asc">升序</Radio>
            </RadioGroup>
          </FormItem>

          <FormItem>
            <Button type="primary" @click="doSearch">搜索</Button>
            <Button class="ml-2" @click="resetForm">重置</Button>
          </FormItem>
        </Form>
      </Card>

      <!-- 搜索结果 -->
      <Spin :spinning="loading">
        <div v-if="postList.length > 0">
          <div class="mb-4 text-gray-500">
            共找到
            <span class="font-medium text-blue-600">{{ total }}</span> 条结果
          </div>

          <Row :gutter="[16, 16]">
            <Col
              v-for="post in postList"
              :key="post.id"
              :xs="24"
              :sm="12"
              :md="8"
              :lg="6"
            >
              <Card
                hoverable
                class="h-full cursor-pointer"
                @click="viewDetail(post.id!)"
              >
                <template #cover>
                  <div class="relative h-40 overflow-hidden bg-gray-100">
                    <img
                      v-if="post.images?.[0]"
                      :src="post.images[0]"
                      :alt="post.itemName || post.title"
                      class="size-full object-cover"
                      loading="lazy"
                    />
                    <div
                      v-else
                      class="flex size-full items-center justify-center text-gray-400"
                    >
                      暂无图片
                    </div>
                    <Tag
                      :color="
                        (post.type || post.postType) === 'lost'
                          ? 'red'
                          : 'green'
                      "
                      class="absolute left-2 top-2"
                    >
                      {{
                        (post.type || post.postType) === 'lost'
                          ? '寻物'
                          : '招领'
                      }}
                    </Tag>
                  </div>
                </template>

                <Card.Meta>
                  <template #title>
                    <div class="truncate text-base">
                      {{ post.itemName || post.title }}
                    </div>
                  </template>
                  <template #description>
                    <div class="space-y-1 text-sm">
                      <div class="truncate text-gray-500">
                        {{ post.description || '暂无描述' }}
                      </div>
                      <div class="flex items-center justify-between">
                        <span class="text-gray-400">
                          {{ post.locationName || '未知地点' }}
                        </span>
                        <Tag
                          v-if="post.status"
                          :color="statusColors[post.status]"
                          size="small"
                        >
                          {{ statusLabels[post.status] }}
                        </Tag>
                      </div>
                      <div
                        class="flex items-center justify-between text-gray-400"
                      >
                        <span>{{
                          formatTime(post.eventTime || post.createTime || '')
                        }}</span>
                        <span>浏览 {{ post.viewCount || 0 }}</span>
                      </div>
                    </div>
                  </template>
                </Card.Meta>
              </Card>
            </Col>
          </Row>

          <div class="mt-6 flex justify-center">
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

        <Empty v-else description="暂无搜索结果" class="py-20" />
      </Spin>
    </div>
  </Page>
</template>
