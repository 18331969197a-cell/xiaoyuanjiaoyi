<script lang="ts" setup>
import type { ClaimListItem } from '#/api/lostfound/claim';
import type { Key } from 'ant-design-vue/es/_util/type';

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
  Spin,
  Table,
  Tabs,
  Tag,
} from 'ant-design-vue';

import {
  cancelClaim,
  getMyClaims,
  getReceivedClaims,
} from '#/api/lostfound/claim';

const router = useRouter();
const loading = ref(false);
const activeTab = ref<string>('sent');
const claimList = ref<ClaimListItem[]>([]);
const total = ref(0);
const currentPage = ref(1);
const pageSize = ref(10);

// Tab 配置
const tabItems = [
  { key: 'sent', label: '我发起的' },
  { key: 'received', label: '我收到的' },
];

// 状态配置 - 与后端 ClaimStatusEnum 保持一致
const statusConfig: Record<string, { color: string; label: string }> = {
  APPLIED: { color: 'orange', label: '已提交' },
  IN_CHAT: { color: 'blue', label: '沟通中' },
  NEED_PROOF: { color: 'purple', label: '需补充佐证' },
  APPROVED: { color: 'cyan', label: '已通过' },
  IN_HANDOVER: { color: 'geekblue', label: '交接中' },
  REJECTED: { color: 'red', label: '已拒绝' },
  CANCELLED: { color: 'default', label: '已取消' },
  COMPLETED: { color: 'green', label: '已完成' },
};

// 表格列
const columns = [
  {
    title: '物品名称',
    dataIndex: 'postTitle',
    ellipsis: true,
  },
  {
    title: '类型',
    dataIndex: 'postType',
    width: 80,
  },
  {
    title: '状态',
    dataIndex: 'status',
    width: 100,
  },
  {
    title: '申请时间',
    dataIndex: 'createTime',
    width: 160,
  },
  {
    title: '操作',
    key: 'action',
    width: 150,
    fixed: 'right' as const,
  },
];

// 加载认领列表
async function loadClaims() {
  loading.value = true;
  try {
    const api = activeTab.value === 'sent' ? getMyClaims : getReceivedClaims;
    const res = (await api({
      pageNum: currentPage.value,
      pageSize: pageSize.value,
    })) as any;
    // 兼容两种返回格式: MyBatis-Plus的records和标准的rows
    claimList.value = res.records || res.rows || [];
    total.value = res.total || 0;
  } catch (error) {
    console.error('加载认领列表失败:', error);
  } finally {
    loading.value = false;
  }
}

// Tab 切换
function onTabChange(key: Key) {
  activeTab.value = String(key);
  currentPage.value = 1;
  loadClaims();
}

// 分页变化
function onPageChange(page: number, size: number) {
  currentPage.value = page;
  pageSize.value = size;
  loadClaims();
}

// 查看详情
function viewDetail(id: number) {
  router.push(`/lostfound/claims/${id}`);
}

// 查看帖子
function viewPost(postId?: number) {
  if (!postId) return;
  router.push(`/lostfound/posts/${postId}`);
}

// 取消认领
async function handleCancel(claim: ClaimListItem) {
  Modal.confirm({
    title: '取消认领',
    content: '确定取消该认领申请吗？',
    async onOk() {
      if (!claim.id) return;
      try {
        await cancelClaim(claim.id);
        message.success('已取消');
        loadClaims();
      } catch {
        message.error('操作失败');
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
  loadClaims();
});
</script>

<template>
  <Page auto-content-height>
    <div class="p-4">
      <Card title="我的认领">
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
            :data-source="claimList"
            :pagination="false"
            :scroll="{ x: 700 }"
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
                  详情
                </Button>
                <Button
                  type="link"
                  size="small"
                  @click="viewPost(record.postId)"
                >
                  查看帖子
                </Button>
                <Button
                  v-if="activeTab === 'sent' && record.status === 'APPLIED'"
                  type="link"
                  size="small"
                  danger
                  @click="handleCancel(record)"
                >
                  取消
                </Button>
              </template>
            </template>
          </Table>

          <div v-if="claimList.length > 0" class="mt-4 flex justify-end">
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
            v-if="!loading && claimList.length === 0"
            description="暂无数据"
          />
        </Spin>
      </Card>
    </div>
  </Page>
</template>
