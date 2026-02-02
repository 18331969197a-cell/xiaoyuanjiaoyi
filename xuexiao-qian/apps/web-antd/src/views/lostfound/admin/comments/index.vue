<script lang="ts" setup>
import type { VxeTableGridOptions } from '#/adapter/vxe-table';

import { ref } from 'vue';

import { useAccess } from '@vben/access';
import { Page } from '@vben/common-ui';

import { Button, Input, message, Modal } from 'ant-design-vue';

import { useVbenVxeGrid } from '#/adapter/vxe-table';
import {
  adminApproveComment,
  adminDeleteComment,
  adminGetCommentList,
  adminRejectComment,
} from '#/api/lostfound/comment';

import { useColumns, useGridFormSchema } from './data';

const { hasAccessByCodes } = useAccess();

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
          const res = await adminGetCommentList({
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
    case 'delete': {
      handleDelete(row);
      break;
    }
    case 'reject': {
      showRejectModal(row);
      break;
    }
  }
}

// 审核通过
async function handleApprove(row: any) {
  Modal.confirm({
    title: '审核通过',
    content: `确定通过该评论吗？`,
    async onOk() {
      try {
        await adminApproveComment(row.id);
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
    await adminRejectComment(rejectingId.value, rejectReason.value);
    message.success('已拒绝');
    rejectVisible.value = false;
    gridApi.query();
  } catch {
    message.error('操作失败');
  }
}

// 删除
async function handleDelete(row: any) {
  Modal.confirm({
    title: '删除评论',
    content: `确定删除该评论吗？`,
    okType: 'danger',
    async onOk() {
      try {
        await adminDeleteComment(row.id);
        message.success('已删除');
        gridApi.query();
      } catch {
        message.error('操作失败');
      }
    },
  });
}

// 批量审核通过
async function batchApprove() {
  const records = gridApi.grid.getCheckboxRecords();
  if (records.length === 0) {
    message.warning('请选择要审核的评论');
    return;
  }

  const pendingRecords = records.filter((r: any) => r.status === 'pending');
  if (pendingRecords.length === 0) {
    message.warning('所选评论中没有待审核的');
    return;
  }

  Modal.confirm({
    title: '批量审核',
    content: `确定通过 ${pendingRecords.length} 条评论的审核吗？`,
    async onOk() {
      try {
        await Promise.all(
          pendingRecords.map((r: any) => adminApproveComment(r.id)),
        );
        message.success('批量审核成功');
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
    <Grid table-title="评论管理">
      <template #toolbar-tools>
        <Button
          v-if="hasAccessByCodes(['lostfound:comment:audit'])"
          type="primary"
          @click="batchApprove"
        >
          批量通过
        </Button>
      </template>
    </Grid>

    <!-- 拒绝弹窗 -->
    <Modal v-model:open="rejectVisible" title="拒绝评论" @ok="handleReject">
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
