<script lang="ts" setup>
import type { VxeTableGridOptions } from '#/adapter/vxe-table';

import { onMounted } from 'vue';
import { useRoute } from 'vue-router';

import { Page } from '@vben/common-ui';

import { Button } from 'ant-design-vue';
import dayjs from 'dayjs';

import { useVbenVxeGrid } from '#/adapter/vxe-table';
import { adminGetRiskEventList } from '#/api/lostfound/riskEvent';

import { useColumns, useGridFormSchema } from './data';

const route = useRoute();

const baseFilters = {};

const [Grid, gridApi] = useVbenVxeGrid({
  formOptions: {
    fieldMappingTime: [
      ['createTime', ['startTime', 'endTime'], 'YYYY-MM-DD HH:mm:ss'],
    ],
    schema: useGridFormSchema(),
    submitOnChange: true,
  },
  gridOptions: {
    columns: useColumns(),
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
  </Page>
</template>
