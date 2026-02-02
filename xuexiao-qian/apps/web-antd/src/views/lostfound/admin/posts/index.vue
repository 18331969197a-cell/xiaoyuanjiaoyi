<script lang="ts" setup>
import type { VxeTableGridOptions } from '#/adapter/vxe-table';

import { ref } from 'vue';
import { useRouter } from 'vue-router';

import { useAccess } from '@vben/access';
import { Page } from '@vben/common-ui';

import { Button, Input, message, Modal } from 'ant-design-vue';

import { useVbenVxeGrid } from '#/adapter/vxe-table';
import {
  adminGetPostList,
  approvePost,
  offlinePost,
  rejectPost,
  setPostRecommend,
  setPostTop,
} from '#/api/lostfound/post';

import { useColumns, useGridFormSchema } from './data';

const { hasAccessByCodes } = useAccess();
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
          const res = await adminGetPostList({
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
    case 'offline': {
      handleOffline(row);
      break;
    }
    case 'recommend': {
      handleRecommend(row);
      break;
    }
    case 'reject': {
      showRejectModal(row);
      break;
    }
    case 'top': {
      handleTop(row);
      break;
    }
    case 'view': {
      // 使用 router.push 在当前页面内跳转，而不是打开新标签页
      router.push(`/lostfound/posts/${row.id}`);
      break;
    }
  }
}

// 审核通过
async function handleApprove(row: any) {
  Modal.confirm({
    title: '审核通过',
    content: `确定通过「${row.title}」的审核吗？`,
    async onOk() {
      try {
        await approvePost(row.id);
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
    await rejectPost(rejectingId.value, rejectReason.value);
    message.success('已拒绝');
    rejectVisible.value = false;
    gridApi.query();
  } catch {
    message.error('操作失败');
  }
}

// 置顶/取消置顶
async function handleTop(row: any) {
  try {
    await setPostTop(row.id, !row.isTop);
    message.success(row.isTop ? '已取消置顶' : '已置顶');
    gridApi.query();
  } catch {
    message.error('操作失败');
  }
}

// 推荐/取消推荐
async function handleRecommend(row: any) {
  try {
    await setPostRecommend(row.id, !row.isRecommend);
    message.success(row.isRecommend ? '已取消推荐' : '已推荐');
    gridApi.query();
  } catch {
    message.error('操作失败');
  }
}

// 下架
async function handleOffline(row: any) {
  Modal.confirm({
    title: '下架帖子',
    content: `确定下架「${row.title}」吗？`,
    okType: 'danger',
    async onOk() {
      try {
        await offlinePost(row.id);
        message.success('已下架');
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
    message.warning('请选择要审核的帖子');
    return;
  }

  const pendingRecords = records.filter((r: any) => r.status === 'pending');
  if (pendingRecords.length === 0) {
    message.warning('所选帖子中没有待审核的');
    return;
  }

  Modal.confirm({
    title: '批量审核',
    content: `确定通过 ${pendingRecords.length} 个帖子的审核吗？`,
    async onOk() {
      try {
        await Promise.all(pendingRecords.map((r: any) => approvePost(r.id)));
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
    <Grid table-title="帖子审核">
      <template #toolbar-tools>
        <Button
          v-if="hasAccessByCodes(['lostfound:post:audit'])"
          type="primary"
          @click="batchApprove"
        >
          批量通过
        </Button>
      </template>
    </Grid>

    <!-- 拒绝弹窗 -->
    <Modal v-model:open="rejectVisible" title="拒绝审核" @ok="handleReject">
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
