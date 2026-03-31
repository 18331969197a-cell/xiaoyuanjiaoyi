<script lang="ts" setup>
import type { VxeTableGridOptions } from '#/adapter/vxe-table';
import type { BizRiskEvent } from '#/api/lostfound/riskEvent';

import { onMounted, ref } from 'vue';
import { useRoute } from 'vue-router';

import { Page } from '@vben/common-ui';

import { Button, Input, message, Modal, Select } from 'ant-design-vue';
import dayjs from 'dayjs';

import { useVbenVxeGrid } from '#/adapter/vxe-table';
import {
  adminGetRiskEventList,
  adminResolveRiskEvent,
} from '#/api/lostfound/riskEvent';

import { useColumns, useGridFormSchema } from './data';

const route = useRoute();

const baseFilters = {};

const resolveVisible = ref(false);
const resolveLoading = ref(false);
const resolvingEvent = ref<BizRiskEvent | null>(null);
const resolveAction = ref('warning');
const resolveRemark = ref('');

const actionOptions = [
  { label: '封禁账号', value: 'ban_user' },
  { label: '删除内容', value: 'offline_post' },
  { label: '禁言', value: 'mute' },
  { label: '警告', value: 'warning' },
  { label: '上报争议', value: 'RAISE_DISPUTE' },
  { label: '上报爽约', value: 'MARK_NO_SHOW' },
  { label: '升级人工', value: 'ESCALATE_MANUAL' },
];

function showResolveModal(row: BizRiskEvent) {
  resolvingEvent.value = row;
  resolveAction.value = row.actionType || 'warning';
  resolveRemark.value = row.remark || '';
  resolveVisible.value = true;
}

function onActionClick({ code, row }: { code: string; row: BizRiskEvent }) {
  if (code === 'resolve') {
    showResolveModal(row);
  }
}

const [Grid, gridApi] = useVbenVxeGrid({
  formOptions: {
    fieldMappingTime: [
      ['createTime', ['startTime', 'endTime'], 'YYYY-MM-DD HH:mm:ss'],
    ],
    schema: useGridFormSchema(),
    submitOnChange: true,
  },
  gridOptions: {
    columns: useColumns(onActionClick),
    height: 'auto',
    keepSource: true,
    pagerConfig: {
      enabled: true,
    },
    proxyConfig: {
      ajax: {
        query: async ({ page }, formValues) => {
          const res = await adminGetRiskEventList({
            pageNum: page?.currentPage,
            pageSize: page?.pageSize,
            ...baseFilters,
            ...formValues,
          });
          return res;
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

function showAll() {
  gridApi.formApi?.resetForm();
  gridApi.formApi?.setValues({
    ...baseFilters,
  });
  gridApi.query();
}

function showUserRisk() {
  gridApi.formApi?.setValues({
    ...baseFilters,
    targetType: 'USER',
    actionType: undefined,
    eventStatus: undefined,
    createTime: undefined,
  });
  gridApi.query();
}

function showContentRisk() {
  gridApi.formApi?.setValues({
    ...baseFilters,
    targetType: 'POST',
    actionType: undefined,
    eventStatus: undefined,
    createTime: undefined,
  });
  gridApi.query();
}

function showToday() {
  gridApi.formApi?.setValues({
    ...baseFilters,
    createTime: [dayjs().startOf('day'), dayjs().endOf('day')],
  });
  gridApi.query();
}

async function handleResolve() {
  const eventId = resolvingEvent.value?.id;
  if (!eventId) {
    return;
  }
  if (!resolveAction.value) {
    message.warning('请选择处理动作');
    return;
  }

  resolveLoading.value = true;
  try {
    await adminResolveRiskEvent(eventId, {
      actionType: resolveAction.value,
      remark: resolveRemark.value.trim() || undefined,
    });
    message.success('处理成功');
    resolveVisible.value = false;
    gridApi.query();
  } catch {
    message.error('处理失败，请稍后重试');
  } finally {
    resolveLoading.value = false;
  }
}

onMounted(() => {
  if (route.query.preset === 'today') {
    showToday();
    return;
  }
  showAll();
});
</script>

<template>
  <Page auto-content-height>
    <Grid table-title="风险告警">
      <template #toolbar-tools>
        <Button @click="showAll">全部风险</Button>
        <span class="mx-1"></span>
        <Button @click="showUserRisk">账号风险</Button>
        <span class="mx-1"></span>
        <Button @click="showContentRisk">内容风险</Button>
        <span class="mx-1"></span>
        <Button type="primary" @click="showToday">今日告警</Button>
      </template>
    </Grid>

    <Modal
      v-model:open="resolveVisible"
      title="处理风险告警"
      :confirm-loading="resolveLoading"
      @ok="handleResolve"
    >
      <div class="space-y-4">
        <div>
          <div class="mb-1">处理动作</div>
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
            :rows="4"
            :maxlength="500"
            show-count
          />
        </div>
      </div>
    </Modal>
  </Page>
</template>
