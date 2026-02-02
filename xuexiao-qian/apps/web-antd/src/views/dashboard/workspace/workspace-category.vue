<script lang="ts" setup>
import type { EchartsUIType } from '@vben/plugins/echarts';

import { onMounted, ref } from 'vue';

import { EchartsUI, useEcharts } from '@vben/plugins/echarts';

import { getCategoryStats } from '#/api/lostfound/statistics';

const chartRef = ref<EchartsUIType>();
const { renderEcharts } = useEcharts(chartRef);

onMounted(async () => {
  let categoryStats: any[] = [];
  try {
    categoryStats = (await getCategoryStats()) || [];
  } catch {
    categoryStats = [];
  }

  const data = categoryStats.map((i: any) => ({
    name: i.categoryName || '未分类',
    value: i.count || 0,
  }));

  renderEcharts({
    legend: { bottom: '2%', left: 'center' },
    series: [
      {
        animationDelay() {
          return Math.random() * 100;
        },
        animationEasing: 'exponentialInOut',
        animationType: 'scale',
        avoidLabelOverlap: false,
        color: [
          '#5ab1ef',
          '#b6a2de',
          '#67e0e3',
          '#2ec7c9',
          '#fa8c16',
          '#f5576c',
        ],
        data,
        emphasis: { label: { fontSize: '12', fontWeight: 'bold', show: true } },
        itemStyle: { borderRadius: 10, borderWidth: 2 },
        label: { position: 'center', show: false },
        labelLine: { show: false },
        name: '分类统计',
        radius: ['40%', '65%'],
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
