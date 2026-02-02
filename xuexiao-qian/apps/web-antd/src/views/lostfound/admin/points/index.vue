<script lang="ts" setup>
import type { VxeTableGridOptions } from '#/adapter/vxe-table';

import { ref } from 'vue';

import { useAccess } from '@vben/access';
import { Page } from '@vben/common-ui';

import {
  Button,
  Form,
  Input,
  InputNumber,
  message,
  Modal,
} from 'ant-design-vue';

import { useVbenVxeGrid } from '#/adapter/vxe-table';
import {
  adminAdjustPoints,
  adminGetUserPointsList,
} from '#/api/lostfound/points';

const { hasAccessByCodes } = useAccess();

// 调整积分弹窗
const adjustVisible = ref(false);
const adjustForm = ref({
  userId: null as null | number,
  userName: '',
  points: 0,
  reason: '',
});

const [Grid, gridApi] = useVbenVxeGrid({
  formOptions: {
    schema: [
      {
        component: 'Input',
        fieldName: 'userName',
        label: '用户名',
      },
    ],
    submitOnChange: true,
  },
  gridOptions: {
    columns: [
      { type: 'seq', width: 60, title: '序号' },
      { field: 'userId', title: '用户ID', width: 100 },
      { field: 'userName', title: '用户名', width: 150 },
      { field: 'nickname', title: '昵称', width: 150 },
      { field: 'totalPoints', title: '总积分', width: 120 },
      { field: 'availablePoints', title: '可用积分', width: 120 },
      { field: 'usedPoints', title: '已使用积分', width: 120 },
      { field: 'level', title: '等级', width: 80 },
      { field: 'createTime', title: '注册时间', width: 180 },
      {
        title: '操作',
        width: 150,
        slots: { default: 'action' },
      },
    ],
    height: 'auto',
    keepSource: true,
    pagerConfig: {
      enabled: true,
    },
    proxyConfig: {
      ajax: {
        query: async ({ page: _page }, _formValues) => {
          return await adminGetUserPointsList({
            pageNum: _page?.currentPage,
            pageSize: _page?.pageSize,
            ..._formValues,
          });
        },
      },
    },
    rowConfig: {
      keyField: 'userId',
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

// 显示调整积分弹窗
function showAdjustModal(row: any) {
  adjustForm.value = {
    userId: row.userId,
    userName: row.userName || row.nickname,
    points: 0,
    reason: '',
  };
  adjustVisible.value = true;
}

// 调整积分
async function handleAdjust() {
  if (!adjustForm.value.points) {
    message.warning('请输入调整积分数');
    return;
  }
  if (!adjustForm.value.reason?.trim()) {
    message.warning('请输入调整原因');
    return;
  }

  try {
    await adminAdjustPoints({
      userId: adjustForm.value.userId!,
      points: adjustForm.value.points,
      reason: adjustForm.value.reason,
    });
    message.success('积分调整成功');
    adjustVisible.value = false;
    await gridApi.reload();
  } catch {
    message.error('操作失败');
  }
}
</script>

<template>
  <Page auto-content-height>
    <Grid table-title="积分管理">
      <template #action="{ row }">
        <Button
          v-if="hasAccessByCodes(['lostfound:points:adjust'])"
          type="link"
          size="small"
          @click="showAdjustModal(row)"
        >
          调整积分
        </Button>
      </template>
    </Grid>

    <!-- 调整积分弹窗 -->
    <Modal v-model:open="adjustVisible" title="调整积分" @ok="handleAdjust">
      <Form layout="vertical">
        <Form.Item label="用户">
          <Input :value="adjustForm.userName" disabled />
        </Form.Item>
        <Form.Item label="调整积分" required>
          <InputNumber
            v-model:value="adjustForm.points"
            :min="-10000"
            :max="10000"
            style="width: 100%"
            placeholder="正数增加，负数扣除"
          />
        </Form.Item>
        <Form.Item label="调整原因" required>
          <Input.TextArea
            v-model:value="adjustForm.reason"
            placeholder="请输入调整原因..."
            :rows="3"
            :maxlength="200"
            show-count
          />
        </Form.Item>
      </Form>
    </Modal>
  </Page>
</template>
