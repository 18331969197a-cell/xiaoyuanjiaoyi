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

  const data = categoryStats.slice(0, 6);
  const indicator = data.map((i: any) => ({
    name: i.categoryName || '未分类',
  }));
  const values = data.map((i: any) => i.count || 0);

  renderEcharts({
    legend: { bottom: 0, data: ['帖子分布'] },
    radar: { indicator, radius: '60%', splitNumber: 8 },
    series: [
      {
        areaStyle: {
          opacity: 1,
          shadowBlur: 0,
          shadowColor: 'rgba(0,0,0,.2)',
          shadowOffsetX: 0,
          shadowOffsetY: 10,
        },
        data: [
          { itemStyle: { color: '#5ab1ef' }, name: '帖子分布', value: values },
        ],
        itemStyle: { borderRadius: 10, borderWidth: 2 },
        symbolSize: 0,
        type: 'radar',
      },
    ],
    tooltip: {},
  });
});
</script>

<template>
  <EchartsUI ref="chartRef" />
</template>
