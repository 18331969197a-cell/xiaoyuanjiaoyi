<script lang="ts" setup>
/**
 * 数据对比图表组件
 * Requirements: 6.1, 6.2, 6.3
 *
 * 使用柱状图对比原始值、QC值、修复值
 */
import { computed, onMounted, ref, watch } from 'vue';

import { Card } from 'ant-design-vue';
import * as echarts from 'echarts';

interface DataValue {
  temperature: null | number;
  salinity: null | number;
}

interface Props {
  /** 原始值 */
  originalValue?: DataValue;
  /** QC后值 */
  qcValue?: DataValue;
  /** 修复后值 */
  repairedValue?: DataValue;
  /** 图表标题 */
  title?: string;
}

const props = withDefaults(defineProps<Props>(), {
  title: '数据对比',
});

const chartRef = ref<HTMLDivElement>();
let chartInstance: echarts.ECharts | null = null;

// 计算变化百分比
function calcChangePercent(
  original: null | number,
  current: null | number,
): string {
  if (original === null || current === null || original === 0) {
    return '-';
  }
  const percent = ((current - original) / Math.abs(original)) * 100;
  return `${percent >= 0 ? '+' : ''}${percent.toFixed(2)}%`;
}

// 图表配置
const chartOption = computed(() => {
  const categories = ['温度 (℃)', '盐度 (PSU)'];
  const originalData = [
    props.originalValue?.temperature ?? null,
    props.originalValue?.salinity ?? null,
  ];
  const qcData = [
    props.qcValue?.temperature ?? null,
    props.qcValue?.salinity ?? null,
  ];
  const repairedData = [
    props.repairedValue?.temperature ?? null,
    props.repairedValue?.salinity ?? null,
  ];

  return {
    tooltip: {
      trigger: 'axis',
      axisPointer: {
        type: 'shadow',
      },
      formatter: (params: any[]) => {
        let result = `${params[0].axisValue}<br/>`;
        params.forEach((param) => {
          const value = param.value ?? '-';
          const originalVal =
            param.seriesName === '原始值'
              ? value
              : originalData[param.dataIndex];
          const changePercent =
            param.seriesName !== '原始值' &&
            originalVal !== null &&
            value !== null
              ? ` (${calcChangePercent(originalVal, value)})`
              : '';
          result += `${param.marker} ${param.seriesName}: ${value === null ? '-' : value.toFixed(3)}${changePercent}<br/>`;
        });
        return result;
      },
    },
    legend: {
      data: ['原始值', 'QC值', '修复值'],
      bottom: 0,
    },
    grid: {
      left: '3%',
      right: '4%',
      bottom: '15%',
      top: '10%',
      containLabel: true,
    },
    xAxis: {
      type: 'category',
      data: categories,
    },
    yAxis: {
      type: 'value',
    },
    series: [
      {
        name: '原始值',
        type: 'bar',
        data: originalData,
        itemStyle: {
          color: '#1890ff',
        },
      },
      {
        name: 'QC值',
        type: 'bar',
        data: qcData,
        itemStyle: {
          color: '#faad14',
        },
      },
      {
        name: '修复值',
        type: 'bar',
        data: repairedData,
        itemStyle: {
          color: '#52c41a',
        },
      },
    ],
  };
});

// 初始化图表
function initChart() {
  if (!chartRef.value) return;

  chartInstance = echarts.init(chartRef.value);
  chartInstance.setOption(chartOption.value);
}

// 更新图表
function updateChart() {
  if (chartInstance) {
    chartInstance.setOption(chartOption.value);
  }
}

// 监听数据变化
watch(
  () => [props.originalValue, props.qcValue, props.repairedValue],
  () => {
    updateChart();
  },
  { deep: true },
);

// 监听窗口大小变化
function handleResize() {
  chartInstance?.resize();
}

onMounted(() => {
  initChart();
  window.addEventListener('resize', handleResize);
});
</script>

<template>
  <Card :title="title" size="small">
    <div ref="chartRef" class="chart-container"></div>
  </Card>
</template>

<style scoped>
.chart-container {
  width: 100%;
  height: 300px;
}
</style>
