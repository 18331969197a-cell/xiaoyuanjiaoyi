<script lang="ts" setup>
import type { VxeTableGridOptions } from '#/adapter/vxe-table';

import { ref } from 'vue';
import { useRouter } from 'vue-router';

import { Page } from '@vben/common-ui';

import { Button, Input, message, Modal, Select } from 'ant-design-vue';

import { useVbenVxeGrid } from '#/adapter/vxe-table';
import {
  adminGetReportList,
  adminRejectReport,
  adminResolveReport,
} from '#/api/lostfound/report';

import { useColumns, useGridFormSchema } from './data';

const router = useRouter();

// 处理弹窗
const resolveVisible = ref(false);
const resolveAction = ref('warning');
const resolveRemark = ref('');
const resolvingId = ref<null | number>(null);

// 驳回弹窗
const rejectVisible = ref(false);
const rejectReason = ref('');
const rejectingId = ref<null | number>(null);

const actionOptions = [
  { label: '警告', value: 'warning' },
  { label: '删除内容', value: 'offline_post' },
  { label: '禁言', value: 'mute' },
  { label: '封禁账号', value: 'ban_user' },
];

// 查看被举报内容 - 使用 router.push 在当前页面内跳转
function viewTarget(row: any) {
  if (row.targetType === 'POST') {
    router.push(`/lostfound/posts/${row.targetId}`);
  } else if (row.targetType === 'COMMENT' && row.postId) {
    router.push(`/lostfound/posts/${row.postId}`);
  }
}

// 显示处理弹窗
function showResolveModal(row: any) {
  resolvingId.value = row.id;
  resolveAction.value = 'warning';
  resolveRemark.value = '';
  resolveVisible.value = true;
}

// 显示驳回弹窗
function showRejectModal(row: any) {
  rejectingId.value = row.id;
  rejectReason.value = '';
  rejectVisible.value = true;
}

function onActionClick({ code, row }: { code: string; row: any }) {
  switch (code) {
    case 'reject': {
      showRejectModal(row);
      break;
    }
    case 'resolve': {
      showResolveModal(row);
      break;
    }
    case 'view': {
      viewTarget(row);
      break;
    }
  }
}

const [Grid, gridApi] = useVbenVxeGrid({
  formOptions: {
    fieldMappingTime: [['createTime', ['startTime', 'endTime'], 'YYYY-MM-DD HH:mm:ss']],
    schema: useGridFormSchema(),
    submitOnChange: true,
  },
  gridOptions: {
    checkboxConfig: {
      highlight: true,
      labelField: 'id',
    },
    columns: useColumns(onActionClick),
    height: 'auto',
    keepSource: true,
    pagerConfig: {
      enabled: true,
    },
    proxyConfig: {
      ajax: {
        query: async ({ page }, formValues) => {
          return await adminGetReportList({
            pageNum: page?.currentPage,
            pageSize: page?.pageSize,
            ...formValues,
          });
        },
      },
    },
    rowConfig: {
      keyField: 'id',
    },
    toolbarConfig: {
      custom: true,
      export: false,
      refresh: true,
      search: true,
      zoom: true,
    },
  } as VxeTableGridOptions,
});

function showAllReports() {
  gridApi.formApi?.resetForm();
  gridApi.query();
}

function showRiskAlerts() {
  router.push('/lostfound/admin/risk-alerts');
}

function showRiskAlertsToday() {
  router.push({
    path: '/lostfound/admin/risk-alerts',
    query: { preset: 'today' },
  });
}

// 处理举报
async function handleResolve() {
  if (!resolvingId.value) return;

  try {
    await adminResolveReport(resolvingId.value, {
      action: resolveAction.value,
      remark: resolveRemark.value,
    });
    message.success('处理成功');
    resolveVisible.value = false;
    gridApi.query();
  } catch {
    message.error('操作失败');
  }
}

// 驳回举报
async function handleReject() {
  if (!rejectReason.value.trim()) {
    message.warning('请输入驳回原因');
    return;
  }
  if (!rejectingId.value) return;

  try {
    await adminRejectReport(rejectingId.value, rejectReason.value);
    message.success('已驳回');
    rejectVisible.value = false;
    gridApi.query();
  } catch {
    message.error('操作失败');
  }
}

</script>

<template>
  <Page auto-content-height>
    <Grid table-title="举报处理">
      <template #toolbar-tools>
        <Button @click="showAllReports">全部举报</Button>
        <span class="mx-1"></span>
        <Button type="primary" @click="showRiskAlerts">风险告警</Button>
        <span class="mx-1"></span>
        <Button @click="showRiskAlertsToday">今日风险</Button>
      </template>
    </Grid>

    <!-- 处理弹窗 -->
    <Modal v-model:open="resolveVisible" title="处理举报" @ok="handleResolve">
      <div class="space-y-4">
        <div>
          <div class="mb-1">处理方式</div>
          <Select
            v-model:value="resolveAction"
            :options="actionOptions"
            style="width: 100%"
          />
        </div>
        <div>
          <div class="mb-1">处理备注</div>
          <Input.TextArea
            v-model:value="resolveRemark"
            placeholder="请输入处理备注（可选）"
            :rows="3"
            :maxlength="500"
          />
        </div>
      </div>
    </Modal>

    <!-- 驳回弹窗 -->
    <Modal v-model:open="rejectVisible" title="驳回举报" @ok="handleReject">
      <Input.TextArea
        v-model:value="rejectReason"
        placeholder="请输入驳回原因..."
        :rows="4"
        :maxlength="500"
        show-count
      />
    </Modal>
  </Page>
</template>
