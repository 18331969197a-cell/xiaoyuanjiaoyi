<script lang="ts" setup>
import type { VerificationRecord } from '#/api/lostfound/verificationAdmin';

import { onMounted, ref } from 'vue';

import { useAccess } from '@vben/access';
import { Page } from '@vben/common-ui';

import {
  Button,
  Card,
  Input,
  message,
  Modal,
  Pagination,
  Popconfirm,
  Select,
  Spin,
  Table,
  Tag,
} from 'ant-design-vue';

import {
  getVerificationRecords,
  revokeVerification,
} from '#/api/lostfound/verificationAdmin';

const loading = ref(false);
const records = ref<VerificationRecord[]>([]);
const total = ref(0);
const currentPage = ref(1);
const pageSize = ref(10);
const { hasAccessByCodes } = useAccess();

// 搜索条件
const searchForm = ref({
  keyword: '',
  verified: undefined as number | undefined,
});

// 表格列
const columns = [
  { title: '用户ID', dataIndex: 'userId', width: 80 },
  { title: '用户名', dataIndex: 'username', width: 120 },
  { title: '昵称', dataIndex: 'nickname', width: 120 },
  { title: '学号', dataIndex: 'studentNo', width: 150 },
  { title: '姓名', dataIndex: 'realName', width: 100 },
  { title: '学院', dataIndex: 'college', ellipsis: true },
  { title: '认证状态', dataIndex: 'verified', width: 100 },
  { title: '认证时间', dataIndex: 'verifiedTime', width: 160 },
  { title: '操作', key: 'action', width: 100 },
];

// 加载认证记录
async function loadRecords() {
  loading.value = true;
  try {
    const res = await getVerificationRecords({
      pageNum: currentPage.value,
      pageSize: pageSize.value,
      ...searchForm.value,
    });
    records.value = res.rows || [];
    total.value = res.total || 0;
  } catch (error) {
    console.error('加载认证记录失败:', error);
  } finally {
    loading.value = false;
  }
}

// 搜索
function handleSearch() {
  currentPage.value = 1;
  loadRecords();
}

// 重置
function handleReset() {
  searchForm.value = { keyword: '', verified: undefined };
  handleSearch();
}

// 分页变化
function onPageChange(page: number, size: number) {
  currentPage.value = page;
  pageSize.value = size;
  loadRecords();
}

// 撤销认证
async function handleRevoke(userId: number) {
  Modal.confirm({
    title: '撤销认证',
    content:
      '确定要撤销该用户的身份认证吗？撤销后用户需要重新认证才能发布信息。',
    async onOk() {
      try {
        await revokeVerification(userId);
        message.success('撤销成功');
        loadRecords();
      } catch (error: any) {
        message.error(error.message || '撤销失败');
      }
    },
  });
}

// 格式化时间
function formatTime(time: string) {
  if (!time) return '-';
  return time.replace('T', ' ').slice(0, 16);
}

onMounted(() => {
  loadRecords();
});
</script>

<template>
  <Page auto-content-height>
    <div class="p-4">
      <Card title="认证记录管理">
        <!-- 搜索栏 -->
        <div class="mb-4 flex flex-wrap items-center gap-4">
          <Input
            v-model:value="searchForm.keyword"
            placeholder="用户名/学号/姓名"
            style="width: 200px"
            allow-clear
          />
          <Select
            v-model:value="searchForm.verified"
            placeholder="认证状态"
            style="width: 120px"
            allow-clear
          >
            <Select.Option :value="1">已认证</Select.Option>
            <Select.Option :value="0">未认证</Select.Option>
          </Select>
          <Button type="primary" @click="handleSearch">查询</Button>
          <Button @click="handleReset">重置</Button>
        </div>

        <!-- 表格 -->
        <Spin :spinning="loading">
          <Table
            :columns="columns"
            :data-source="records"
            :pagination="false"
            row-key="userId"
          >
            <template #bodyCell="{ column, record }">
              <template v-if="column.dataIndex === 'verified'">
                <Tag :color="record.verified === 1 ? 'green' : 'default'">
                  {{ record.verified === 1 ? '已认证' : '未认证' }}
                </Tag>
              </template>
              <template v-else-if="column.dataIndex === 'verifiedTime'">
                {{ formatTime(record.verifiedTime) }}
              </template>
              <template v-else-if="column.key === 'action'">
                <Popconfirm
                  v-if="
                    record.verified === 1 &&
                    hasAccessByCodes(['lostfound:verification:revoke'])
                  "
                  title="确定撤销该用户的认证吗？"
                  @confirm="handleRevoke(record.userId)"
                >
                  <Button type="link" size="small" danger>撤销</Button>
                </Popconfirm>
                <span v-else class="text-gray-400">-</span>
              </template>
            </template>
          </Table>

          <div v-if="records.length > 0" class="mt-4 flex justify-end">
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
        </Spin>
      </Card>
    </div>
  </Page>
</template>
