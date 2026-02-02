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
  const lostData = trendData.map((i: any) => Number(i.lostCount) || 0);
  const foundData = trendData.map((i: any) => Number(i.foundCount) || 0);

  renderEcharts({
    grid: { bottom: 0, containLabel: true, left: '1%', right: '1%', top: '2%' },
    series: [
      {
        areaStyle: {},
        data: lostData,
        itemStyle: { color: '#5ab1ef' },
        smooth: true,
        type: 'line',
        name: '寻物',
      },
      {
        areaStyle: {},
        data: foundData,
        itemStyle: { color: '#019680' },
        smooth: true,
        type: 'line',
        name: '招领',
      },
    ],
    tooltip: {
      axisPointer: { lineStyle: { color: '#019680', width: 1 } },
      trigger: 'axis',
    },
    xAxis: {
      axisTick: { show: false },
      boundaryGap: false,
      data: dates,
      splitLine: { lineStyle: { type: 'solid', width: 1 }, show: true },
      type: 'category',
    },
    yAxis: [
      {
        axisTick: { show: false },
        splitArea: { show: true },
        splitNumber: 4,
        type: 'value',
      },
    ],
  });
});
</script>

<template>
  <EchartsUI ref="chartRef" />
</template>
