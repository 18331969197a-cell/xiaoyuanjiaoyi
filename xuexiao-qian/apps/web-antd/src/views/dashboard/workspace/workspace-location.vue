<script lang="ts" setup>
import type { EchartsUIType } from '@vben/plugins/echarts';

import { onMounted, ref } from 'vue';

import { EchartsUI, useEcharts } from '@vben/plugins/echarts';

import { getLocationStats } from '#/api/lostfound/statistics';

const chartRef = ref<EchartsUIType>();
const { renderEcharts } = useEcharts(chartRef);

onMounted(async () => {
  let locationStats: any[] = [];
  try {
    locationStats = (await getLocationStats()) || [];
  } catch {
    locationStats = [];
  }

  const data = locationStats
    .slice(0, 6)
    .map((i: any) => ({ name: i.locationName || '未知', value: i.count || 0 }))
    .sort((a, b) => a.value - b.value);

  renderEcharts({
    series: [
      {
        animationDelay() {
          return Math.random() * 400;
        },
        animationEasing: 'exponentialInOut',
        animationType: 'scale',
        center: ['50%', '50%'],
        color: [
          '#5ab1ef',
          '#b6a2de',
          '#67e0e3',
          '#2ec7c9',
          '#fa8c16',
          '#f5576c',
        ],
        data,
        name: '地点统计',
        radius: '80%',
        roseType: 'radius',
        type: 'pie',
      },
    ],
    tooltip: { trigger: 'item' },
  });
});
</script>

<template>
  <EchartsUI ref="chartRef" />
</template>
