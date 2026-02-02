<script lang="ts" setup>
import type { VxeTableGridOptions } from '#/adapter/vxe-table';

import { Page } from '@vben/common-ui';

import { Button } from 'ant-design-vue';
import dayjs from 'dayjs';

import { useVbenVxeGrid } from '#/adapter/vxe-table';
import { adminGetSecurityLogList } from '#/api/system/securityLog';

import { useColumns, useGridFormSchema } from './data';

function inferAutoAction(title?: string) {
  const text = (title || '').toLowerCase();
  if (
    text.includes('钓鱼') ||
    text.includes('恶意') ||
    text.includes('欺诈') ||
    text.includes('木马') ||
    text.includes('病毒') ||
    text.includes('盗号') ||
    text.includes('封禁')
  ) {
    return 'BAN';
  }
  if (
    text.includes('频繁') ||
    text.includes('多次') ||
    text.includes('异常登录') ||
    text.includes('爆破') ||
    text.includes('撞库')
  ) {
    return 'RATE_LIMIT';
  }
  return 'WATCH';
}

const [Grid, gridApi] = useVbenVxeGrid({
  formOptions: {
    fieldMappingTime: [
      ['operationTime', ['startTime', 'endTime'], 'YYYY-MM-DD HH:mm:ss'],
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
          const res = await adminGetSecurityLogList({
            pageNum: page?.currentPage,
            pageSize: page?.pageSize,
            operationType: 'RISK_ALERT',
            ...formValues,
          });
          return {
            rows: (res.rows || []).map((row: any) => ({
              ...row,
              autoAction: inferAutoAction(row.title),
            })),
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

function showAll() {
  gridApi.formApi?.resetForm();
  gridApi.query();
}

function showToday() {
  gridApi.formApi?.setValues({
    operationTime: [dayjs().startOf('day'), dayjs().endOf('day')],
  });
  gridApi.query();
}
</script>

<template>
  <Page auto-content-height>
    <Grid table-title="风险告警">
      <template #toolbar-tools>
        <Button @click="showAll">全部告警</Button>
        <span class="mx-1"></span>
        <Button type="primary" @click="showToday">今日告警</Button>
      </template>
    </Grid>
  </Page>
</template>
