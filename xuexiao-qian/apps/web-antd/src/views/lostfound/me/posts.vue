<script lang="ts" setup>
import type { Key } from 'ant-design-vue/es/_util/type';

import type { BizPost } from '#/api/lostfound/post';

import { onMounted, ref } from 'vue';
import { useRouter } from 'vue-router';

import { Page } from '@vben/common-ui';

import {
  Button,
  Card,
  Empty,
  message,
  Modal,
  Pagination,
  Radio,
  Spin,
  Table,
  Tabs,
  Tag,
} from 'ant-design-vue';

import { deletePost, getMyPosts, submitDraft } from '#/api/lostfound/post';

const router = useRouter();
const loading = ref(false);
const activeTab = ref<string>('all');
const postTypeFilter = ref<string>('all'); // 类型筛选：all | LOST | FOUND
const postList = ref<BizPost[]>([]);
const total = ref(0);
const currentPage = ref(1);
const pageSize = ref(10);

// 类型筛选配置
const typeOptions = [
  { label: '全部', value: 'all' },
  { label: '招领', value: 'FOUND' },
  { label: '寻物', value: 'LOST' },
];

// Tab 配置 - 使用后端枚举值（大写）
const tabItems = [
  { key: 'all', label: '全部' },
  { key: 'DRAFT', label: '草稿' },
  { key: 'PENDING', label: '待审核' },
  { key: 'PUBLISHED', label: '已发布' },
  { key: 'CLAIMING', label: '认领中' },
  { key: 'CLOSED', label: '已结案' },
];

// 状态配置 - 使用后端枚举值（大写）
const statusConfig: Record<string, { color: string; label: string }> = {
  DRAFT: { color: 'default', label: '草稿' },
  PENDING: { color: 'orange', label: '待审核' },
  PUBLISHED: { color: 'blue', label: '已发布' },
  CLAIMING: { color: 'green', label: '认领中' },
  CLOSED: { color: 'default', label: '已结案' },
  REJECTED: { color: 'red', label: '已拒绝' },
  OFFLINE: { color: 'default', label: '已下线' },
};

// 表格列
const columns = [
  {
    title: '类型',
    dataIndex: 'postType',
    width: 80,
  },
  {
    title: '标题',
    dataIndex: 'title',
    ellipsis: true,
  },
  {
    title: '分类',
    dataIndex: 'categoryName',
    width: 100,
  },
  {
    title: '地点',
    dataIndex: 'locationName',
    width: 120,
    ellipsis: true,
  },
  {
    title: '状态',
    dataIndex: 'status',
    width: 100,
  },
  {
    title: '浏览量',
    dataIndex: 'viewCount',
    width: 80,
  },
  {
    title: '发布时间',
    dataIndex: 'createTime',
    width: 160,
  },
  {
    title: '操作',
    key: 'action',
    width: 180,
    fixed: 'right' as const,
  },
];

// 加载帖子列表
async function loadPosts() {
  loading.value = true;
  try {
    const res = await getMyPosts({
      pageNum: currentPage.value,
      pageSize: pageSize.value,
      status: activeTab.value === 'all' ? undefined : activeTab.value,
      postType:
        postTypeFilter.value === 'all' ? undefined : postTypeFilter.value,
    });
    postList.value = res.records || [];
    total.value = res.total || 0;
  } catch (error) {
    console.error('加载帖子列表失败:', error);
  } finally {
    loading.value = false;
  }
}

// 类型筛选变化
function onTypeChange() {
  currentPage.value = 1;
  loadPosts();
}

// Tab 切换
function onTabChange(key: Key) {
  activeTab.value = String(key);
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

// 编辑
function editPost(post: BizPost) {
  const type = post.postType === 'LOST' ? 'lost' : 'found';
  router.push(`/lostfound/publish/${type}?id=${post.id}`);
}

// 提交草稿
async function handleSubmitDraft(post: BizPost) {
  Modal.confirm({
    title: '提交审核',
    content: '确定提交该草稿进行审核吗？',
    async onOk() {
      try {
        await submitDraft(post.id!);
        message.success('已提交审核');
        loadPosts();
      } catch {
        message.error('提交失败');
      }
    },
  });
}

// 删除
async function handleDelete(post: BizPost) {
  Modal.confirm({
    title: '删除确认',
    content: `确定删除「${post.title}」吗？`,
    okType: 'danger',
    async onOk() {
      try {
        await deletePost(post.id!);
        message.success('删除成功');
        loadPosts();
      } catch {
        message.error('删除失败');
      }
    },
  });
}

// 格式化时间
function formatTime(time: string) {
  if (!time) return '';
  return time.replace('T', ' ').slice(0, 16);
}

onMounted(() => {
  loadPosts();
});
</script>

<template>
  <Page auto-content-height>
    <div class="p-4">
      <Card title="我的发布">
        <!-- 类型筛选 -->
        <div class="mb-4">
          <span class="mr-2 text-gray-600">类型筛选：</span>
          <Radio.Group
            v-model:value="postTypeFilter"
            button-style="solid"
            @change="onTypeChange"
          >
            <Radio.Button
              v-for="opt in typeOptions"
              :key="opt.value"
              :value="opt.value"
            >
              {{ opt.label }}
            </Radio.Button>
          </Radio.Group>
        </div>

        <!-- 状态 Tab -->
        <Tabs :active-key="activeTab" @change="onTabChange">
          <Tabs.TabPane
            v-for="tab in tabItems"
            :key="tab.key"
            :tab="tab.label"
          />
        </Tabs>

        <Spin :spinning="loading">
          <Table
            :columns="columns"
            :data-source="postList"
            :pagination="false"
            :scroll="{ x: 900 }"
            row-key="id"
          >
            <template #bodyCell="{ column, record }">
              <template v-if="column.dataIndex === 'postType'">
                <Tag :color="record.postType === 'LOST' ? 'red' : 'green'">
                  {{ record.postType === 'LOST' ? '寻物' : '招领' }}
                </Tag>
              </template>
              <template v-else-if="column.dataIndex === 'status'">
                <Tag :color="statusConfig[record.status]?.color">
                  {{ statusConfig[record.status]?.label }}
                </Tag>
              </template>
              <template v-else-if="column.dataIndex === 'createTime'">
                {{ formatTime(record.createTime) }}
              </template>
              <template v-else-if="column.key === 'action'">
                <Button type="link" size="small" @click="viewDetail(record.id)">
                  查看
                </Button>
                <Button
                  v-if="record.status === 'DRAFT'"
                  type="link"
                  size="small"
                  @click="editPost(record)"
                >
                  编辑
                </Button>
                <Button
                  v-if="record.status === 'DRAFT'"
                  type="link"
                  size="small"
                  @click="handleSubmitDraft(record)"
                >
                  提交
                </Button>
                <Button
                  v-if="['DRAFT', 'REJECTED'].includes(record.status)"
                  type="link"
                  size="small"
                  danger
                  @click="handleDelete(record)"
                >
                  删除
                </Button>
              </template>
            </template>
          </Table>

          <div v-if="postList.length > 0" class="mt-4 flex justify-end">
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

          <Empty
            v-if="!loading && postList.length === 0"
            description="暂无数据"
          />
        </Spin>
      </Card>
    </div>
  </Page>
</template>
