<script lang="ts" setup>
import type { EchartsUIType } from '@vben/plugins/echarts';

import { onMounted, ref } from 'vue';

import { EchartsUI, useEcharts } from '@vben/plugins/echarts';

import { getRecoveryStats } from '#/api/lostfound/statistics';

const chartRef = ref<EchartsUIType>();
const { renderEcharts } = useEcharts(chartRef);

onMounted(async () => {
  let trendData: any[] = [];
  try {
    trendData = (await getRecoveryStats({ type: 'daily' })) || [];
  } catch {
    trendData = [];
  }

  const dates = trendData.map((i: any) => i.date?.slice(5) || '');
  const totalData = trendData.map(
    (i: any) => (Number(i.lostCount) || 0) + (Number(i.foundCount) || 0),
  );

  renderEcharts({
    grid: { bottom: 0, containLabel: true, left: '1%', right: '1%', top: '2%' },
    series: [{ barMaxWidth: 80, data: totalData, type: 'bar' }],
    tooltip: { axisPointer: { lineStyle: { width: 1 } }, trigger: 'axis' },
    xAxis: { data: dates, type: 'category' },
    yAxis: { splitNumber: 4, type: 'value' },
  });
});
</script>

<template>
  <EchartsUI ref="chartRef" />
</template>
