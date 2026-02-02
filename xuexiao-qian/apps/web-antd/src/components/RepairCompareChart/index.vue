<script lang="ts" setup>
/**
 * 修复对比图组件
 * Requirements: 10.1, 10.2, 10.3
 */
import type { ECharts, EChartsOption } from 'echarts';

import { computed, onMounted, onUnmounted, ref, watch } from 'vue';

import { Alert } from 'ant-design-vue';
import * as echarts from 'echarts';

interface DataPoint {
  depth: number;
  originalValue: number;
  repairedValue: number;
}

interface Props {
  data: DataPoint[];
  title?: string;
  /** 偏离警告阈值（百分比） */
  deviationThreshold?: number;
}

const props = withDefaults(defineProps<Props>(), {
  data: () => [],
  title: '数值',
  deviationThreshold: 20,
});

const chartRef = ref<HTMLDivElement | null>(null);
let chartInstance: ECharts | null = null;

// 计算偏离度
const deviations = computed(() => {
  return props.data.map((point) => {
    if (point.originalValue === 0) return 0;
    return Math.abs(
      ((point.repairedValue - point.originalValue) / point.originalValue) * 100,
    );
  });
});

// 最大偏离度
const maxDeviation = computed(() => Math.max(...deviations.value, 0));

// 是否显示警告
const showWarning = computed(
  () => maxDeviation.value > props.deviationThreshold,
);

// 超过阈值的点数
const warningCount = computed(() => {
  return deviations.value.filter((d) => d > props.deviationThreshold).length;
});

// 图表配置
const chartOption = computed<EChartsOption>(() => ({
  tooltip: {
    trigger: 'axis',
    formatter: (params: any) => {
      const depth = params[0]?.axisValue;
      let html = `深度: ${depth}m<br/>`;
      params.forEach((p: any) => {
        html += `${p.seriesName}: ${p.value?.toFixed(3) ?? '--'}<br/>`;
      });
      // 计算偏离度
      const original = params.find(
        (p: any) => p.seriesName === '原始值',
      )?.value;
      const repaired = params.find(
        (p: any) => p.seriesName === '修复值',
      )?.value;
      if (original && repaired && original !== 0) {
        const deviation = Math.abs(((repaired - original) / original) * 100);
        html += `<span style="color: ${deviation > props.deviationThreshold ? '#ff4d4f' : '#52c41a'}">
          偏离: ${deviation.toFixed(1)}%
        </span>`;
      }
      return html;
    },
  },
  legend: {
    data: ['原始值', '修复值'],
    top: 10,
  },
  grid: {
    left: 60,
    right: 20,
    top: 50,
    bottom: 40,
  },
  xAxis: {
    type: 'category',
    data: props.data.map((d) => d.depth.toFixed(1)),
    name: '深度 (m)',
    nameLocation: 'middle',
    nameGap: 25,
  },
  yAxis: {
    type: 'value',
    name: props.title,
  },
  series: [
    {
      name: '原始值',
      type: 'line',
      data: props.data.map((d) => d.originalValue),
      lineStyle: {
        type: 'dashed',
        color: '#8c8c8c',
      },
      itemStyle: {
        color: '#8c8c8c',
      },
      symbol: 'circle',
      symbolSize: 6,
    },
    {
      name: '修复值',
      type: 'line',
      data: props.data.map((d) => d.repairedValue),
      lineStyle: {
        type: 'solid',
        color: '#1890ff',
      },
      itemStyle: {
        color: '#1890ff',
      },
      symbol: 'circle',
      symbolSize: 6,
      // 标记超过阈值的点
      markPoint: {
        data: props.data
          .map((d, i) => {
            if (deviations.value[i]! > props.deviationThreshold) {
              return {
                coord: [i, d.repairedValue],
                symbol: 'pin',
                symbolSize: 30,
                itemStyle: { color: '#ff4d4f' },
              };
            }
            return null;
          })
          .filter(Boolean) as any[],
      },
    },
  ],
}));

onMounted(() => {
  initChart();
});

onUnmounted(() => {
  if (chartInstance) {
    chartInstance.dispose();
    chartInstance = null;
  }
});

watch(
  () => props.data,
  () => updateChart(),
  { deep: true },
);

function initChart() {
  if (!chartRef.value) return;
  chartInstance = echarts.init(chartRef.value);
  chartInstance.setOption(chartOption.value);
  window.addEventListener('resize', handleResize);
}

function updateChart() {
  chartInstance?.setOption(chartOption.value);
}

function handleResize() {
  chartInstance?.resize();
}
</script>

<template>
  <div class="repair-compare-chart">
    <Alert
      v-if="showWarning"
      type="warning"
      show-icon
      class="mb-3"
      :message="`警告: ${warningCount} 个数据点偏离超过 ${deviationThreshold}%，最大偏离 ${maxDeviation.toFixed(1)}%`"
    />
    <div ref="chartRef" style="width: 100%; height: 300px"></div>
  </div>
</template>
