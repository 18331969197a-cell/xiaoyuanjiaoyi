<script lang="ts" setup>
import type { VxeTableGridOptions } from '#/adapter/vxe-table';

import { ref } from 'vue';
import { useRouter } from 'vue-router';

import { Page } from '@vben/common-ui';

import { Input, message, Modal } from 'ant-design-vue';

import { useVbenVxeGrid } from '#/adapter/vxe-table';
import {
  adminApproveClaim,
  adminCompleteClaim,
  adminGetClaimList,
  adminRejectClaim,
} from '#/api/lostfound/claim';

import { useColumns, useGridFormSchema } from './data';

const router = useRouter();

// 拒绝弹窗
const rejectVisible = ref(false);
const rejectReason = ref('');
const rejectingId = ref<null | number>(null);

const [Grid, gridApi] = useVbenVxeGrid({
  formOptions: {
    fieldMappingTime: [['createTime', ['startTime', 'endTime']]],
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
          const res = await adminGetClaimList({
            pageNum: page?.currentPage,
            pageSize: page?.pageSize,
            ...formValues,
          });
          // 转换数据格式：后端返回 records，VxeGrid 期望 rows
          return {
            rows: res.records || [],
            total: res.total || 0,
          };
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

function onActionClick({ code, row }: { code: string; row: any }) {
  switch (code) {
    case 'approve': {
      handleApprove(row);
      break;
    }
    case 'complete': {
      handleComplete(row);
      break;
    }
    case 'reject': {
      showRejectModal(row);
      break;
    }
    case 'view': {
      // 使用 router.push 在当前页面内跳转，而不是打开新标签页
      router.push(`/lostfound/claims/${row.id}`);
      break;
    }
  }
}

// 审核通过
async function handleApprove(row: any) {
  Modal.confirm({
    title: '审核通过',
    content: `确定通过该认领申请吗？`,
    async onOk() {
      try {
        await adminApproveClaim(row.id);
        message.success('审核通过');
        gridApi.query();
      } catch {
        message.error('操作失败');
      }
    },
  });
}

// 显示拒绝弹窗
function showRejectModal(row: any) {
  rejectingId.value = row.id;
  rejectReason.value = '';
  rejectVisible.value = true;
}

// 审核拒绝
async function handleReject() {
  if (!rejectReason.value.trim()) {
    message.warning('请输入拒绝原因');
    return;
  }
  if (!rejectingId.value) return;

  try {
    await adminRejectClaim(rejectingId.value, rejectReason.value);
    message.success('已拒绝');
    rejectVisible.value = false;
    gridApi.query();
  } catch {
    message.error('操作失败');
  }
}

// 强制完成
async function handleComplete(row: any) {
  Modal.confirm({
    title: '强制完成',
    content: `确定强制完成该认领吗？这将跳过交接确认流程。`,
    okType: 'danger',
    async onOk() {
      try {
        await adminCompleteClaim(row.id);
        message.success('已完成');
        gridApi.query();
      } catch {
        message.error('操作失败');
      }
    },
  });
}
</script>

<template>
  <Page auto-content-height>
    <Grid table-title="认领管理" />

    <!-- 拒绝弹窗 -->
    <Modal v-model:open="rejectVisible" title="拒绝认领" @ok="handleReject">
      <Input.TextArea
        v-model:value="rejectReason"
        placeholder="请输入拒绝原因..."
        :rows="4"
        :maxlength="500"
        show-count
      />
    </Modal>
  </Page>
</template>
