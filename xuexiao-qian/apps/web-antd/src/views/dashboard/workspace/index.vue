<script lang="ts" setup>
import type { AnalysisOverviewItem } from '@vben/common-ui';
import type { TabOption } from '@vben/types';

import { computed, onMounted, ref } from 'vue';

import {
  AnalysisChartCard,
  AnalysisChartsTabs,
  AnalysisOverview,
} from '@vben/common-ui';
import {
  SvgBellIcon,
  SvgCakeIcon,
  SvgCardIcon,
  SvgDownloadIcon,
} from '@vben/icons';

import { getHomeStatistics } from '#/api/lostfound/statistics';

import WorkspaceCategory from './workspace-category.vue';
import WorkspaceLocation from './workspace-location.vue';
import WorkspaceMonthly from './workspace-monthly.vue';
import WorkspaceRadar from './workspace-radar.vue';
import WorkspaceTrends from './workspace-trends.vue';

const homeStats = ref<any>({});

const overviewItems = computed<AnalysisOverviewItem[]>(() => [
  {
    icon: SvgCardIcon,
    title: '平台总帖子',
    totalTitle: '本月新增',
    totalValue: Number(homeStats.value.monthPosts) || 0,
    value: Number(homeStats.value.totalPosts) || 0,
  },
  {
    icon: SvgCakeIcon,
    title: '寻物启事',
    totalTitle: '待找回',
    totalValue: Number(homeStats.value.lostCount) || 0,
    value: Number(homeStats.value.lostCount) || 0,
  },
  {
    icon: SvgDownloadIcon,
    title: '招领信息',
    totalTitle: '待认领',
    totalValue: Number(homeStats.value.foundCount) || 0,
    value: Number(homeStats.value.foundCount) || 0,
  },
  {
    icon: SvgBellIcon,
    title: '成功找回',
    totalTitle: '找回率',
    totalValue: homeStats.value.totalPosts
      ? Math.round(
          ((Number(homeStats.value.successCount) || 0) /
            Number(homeStats.value.totalPosts)) *
            100,
        )
      : 0,
    value: Number(homeStats.value.successCount) || 0,
  },
]);

const chartTabs: TabOption[] = [
  { label: '发布趋势', value: 'trends' },
  { label: '月度统计', value: 'monthly' },
];

onMounted(async () => {
  try {
    homeStats.value = (await getHomeStatistics()) || {};
  } catch {
    homeStats.value = {};
  }
});
</script>

<template>
  <div class="p-5">
    <AnalysisOverview :items="overviewItems" />
    <AnalysisChartsTabs :tabs="chartTabs" class="mt-5">
      <template #trends>
        <WorkspaceTrends />
      </template>
      <template #monthly>
        <WorkspaceMonthly />
      </template>
    </AnalysisChartsTabs>
    <div class="mt-5 w-full md:flex">
      <AnalysisChartCard class="mt-5 md:mr-4 md:mt-0 md:w-1/3" title="帖子分布">
        <WorkspaceRadar />
      </AnalysisChartCard>
      <AnalysisChartCard class="mt-5 md:mr-4 md:mt-0 md:w-1/3" title="分类统计">
        <WorkspaceCategory />
      </AnalysisChartCard>
      <AnalysisChartCard class="mt-5 md:mt-0 md:w-1/3" title="地点统计">
        <WorkspaceLocation />
      </AnalysisChartCard>
    </div>
  </div>
</template>
