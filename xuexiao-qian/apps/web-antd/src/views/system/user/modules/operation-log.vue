<script lang="ts" setup>
import type { VxeTableGridOptions } from '#/adapter/vxe-table';

import { computed, ref, watch } from 'vue';

import { useVbenDrawer } from '@vben/common-ui';

import { Button, DatePicker, message, Select, Space } from 'ant-design-vue';
import dayjs from 'dayjs';

import { useVbenVxeGrid } from '#/adapter/vxe-table';

// 操作记录类型
interface OperationLog {
  id: string;
  userId: string;
  username: string;
  operationType: string;
  operationDesc: string;
  targetType: string;
  targetId: string;
  ip: string;
  createTime: string;
  status: 'success' | 'failed';
}

// 操作类型选项
const operationTypeOptions = [
  { label: '全部', value: '' },
  { label: '登录', value: 'login' },
  { label: '登出', value: 'logout' },
  { label: '数据导入', value: 'data_import' },
  { label: '数据导出', value: 'data_export' },
  { label: 'QC操作', value: 'qc_operation' },
  { label: '数据修复', value: 'data_repair' },
  { label: '配置变更', value: 'config_change' },
];

// 抽屉配置
const [Drawer, drawerApi] = useVbenDrawer({
  onOpenChange(isOpen) {
    if (isOpen) {
      const data = drawerApi.getData<{ userId: string; username: string }>();
      if (data) {
        userId.value = data.userId;
        username.value = data.username;
        onRefresh();
      }
    }
  },
});

// 状态
const userId = ref<string>('');
const username = ref<string>('');
const operationType = ref<string>('');
const dateRange = ref<[dayjs.Dayjs, dayjs.Dayjs] | null>(null);
const isExporting = ref(false);

// 计算抽屉标题
const drawerTitle = computed(() => {
  return username.value ? `${username.value} 的操作记录` : '用户操作记录';
});

// 表格列配置
function useColumns() {
  return [
    {
      field: 'operationType',
      title: '操作类型',
      width: 120,
      slots: { default: 'operationType' },
    },
    {
      field: 'operationDesc',
      title: '操作描述',
      minWidth: 200,
    },
    {
      field: 'targetType',
      title: '操作对象',
      width: 120,
    },
    {
      field: 'ip',
      title: 'IP地址',
      width: 140,
    },
    {
      field: 'status',
      title: '状态',
      width: 80,
      slots: { default: 'status' },
    },
    {
      field: 'createTime',
      title: '操作时间',
      width: 180,
    },
  ];
}

// 模拟获取用户操作记录
async function getUserOperationLogs(params: {
  userId: string;
  operationType?: string;
  startTime?: string;
  endTime?: string;
  pageNum?: number;
  pageSize?: number;
}) {
  // 模拟API调用
  await new Promise((resolve) => setTimeout(resolve, 500));

  // 模拟数据
  const mockData: OperationLog[] = [
    {
      id: '1',
      userId: params.userId,
      username: username.value,
      operationType: 'login',
      operationDesc: '用户登录系统',
      targetType: '系统',
      targetId: '',
      ip: '192.168.1.100',
      createTime: '2024-12-10 09:00:00',
      status: 'success',
    },
    {
      id: '2',
      userId: params.userId,
      username: username.value,
      operationType: 'data_import',
      operationDesc: '导入海洋数据文件 ocean_data_2024.csv',
      targetType: '数据文件',
      targetId: 'file_001',
      ip: '192.168.1.100',
      createTime: '2024-12-10 10:30:00',
      status: 'success',
    },
    {
      id: '3',
      userId: params.userId,
      username: username.value,
      operationType: 'qc_operation',
      operationDesc: '执行QC批处理任务',
      targetType: 'QC任务',
      targetId: 'qc_task_001',
      ip: '192.168.1.100',
      createTime: '2024-12-10 11:00:00',
      status: 'success',
    },
  ];

  return {
    items: mockData,
    total: mockData.length,
  };
}

// 表格配置
const [Grid, gridApi] = useVbenVxeGrid({
  gridOptions: {
    columns: useColumns(),
    height: 'auto',
    pagerConfig: {
      enabled: true,
      pageSize: 10,
    },
    proxyConfig: {
      ajax: {
        query: async ({ page }) => {
          if (!userId.value) {
            return { items: [], total: 0 };
          }
          return await getUserOperationLogs({
            userId: userId.value,
            operationType: operationType.value || undefined,
            startTime: dateRange.value?.[0]?.format('YYYY-MM-DD HH:mm:ss'),
            endTime: dateRange.value?.[1]?.format('YYYY-MM-DD HH:mm:ss'),
            pageNum: page?.currentPage,
            pageSize: page?.pageSize,
          });
        },
      },
    },
    rowConfig: {
      keyField: 'id',
    },
  } as VxeTableGridOptions<OperationLog>,
});

// 刷新列表
function onRefresh() {
  gridApi.query();
}

// 筛选条件变化
function onFilterChange() {
  onRefresh();
}

// 导出操作记录
async function onExport() {
  if (!userId.value) {
    message.warning('请先选择用户');
    return;
  }

  try {
    isExporting.value = true;
    message.loading({
      content: '正在导出操作记录...',
      duration: 0,
      key: 'export_log_msg',
    });

    // 模拟导出
    await new Promise((resolve) => setTimeout(resolve, 1000));

    message.success({
      content: '操作记录导出成功',
      key: 'export_log_msg',
    });
  } catch (error: any) {
    message.error({
      content: error?.message || '导出失败',
      key: 'export_log_msg',
    });
  } finally {
    isExporting.value = false;
  }
}

// 获取操作类型标签
function getOperationTypeLabel(type: string) {
  const option = operationTypeOptions.find((o) => o.value === type);
  return option?.label || type;
}

// 获取操作类型颜色
function getOperationTypeColor(type: string) {
  const colorMap: Record<string, string> = {
    login: 'green',
    logout: 'orange',
    data_import: 'blue',
    data_export: 'cyan',
    qc_operation: 'purple',
    data_repair: 'gold',
    config_change: 'red',
  };
  return colorMap[type] || 'default';
}
</script>

<template>
  <Drawer :title="drawerTitle" class="w-[800px]">
    <div class="operation-log-container">
      <!-- 筛选区域 -->
      <div class="filter-section mb-4">
        <Space wrap>
          <Select
            v-model:value="operationType"
            :options="operationTypeOptions"
            placeholder="操作类型"
            style="width: 150px"
            @change="onFilterChange"
          />
          <DatePicker.RangePicker
            v-model:value="dateRange"
            :placeholder="['开始时间', '结束时间']"
            show-time
            format="YYYY-MM-DD HH:mm:ss"
            @change="onFilterChange"
          />
          <Button @click="onRefresh">查询</Button>
          <Button
            :loading="isExporting"
            :disabled="isExporting"
            @click="onExport"
          >
            {{ isExporting ? '导出中...' : '导出' }}
          </Button>
        </Space>
      </div>

      <!-- 表格 -->
      <Grid>
        <template #operationType="{ row }">
          <a-tag :color="getOperationTypeColor(row.operationType)">
            {{ getOperationTypeLabel(row.operationType) }}
          </a-tag>
        </template>
        <template #status="{ row }">
          <a-tag :color="row.status === 'success' ? 'green' : 'red'">
            {{ row.status === 'success' ? '成功' : '失败' }}
          </a-tag>
        </template>
      </Grid>
    </div>
  </Drawer>
</template>

<style scoped>
.operation-log-container {
  display: flex;
  flex-direction: column;
  height: 100%;
}

.filter-section {
  padding: 12px;
  background: #fafafa;
  border-radius: 8px;
}
</style>
