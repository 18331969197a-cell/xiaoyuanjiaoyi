<script lang="ts" setup>
/**
 * 小型剖面图组件
 * Requirements: 7.2, 7.3
 *
 * 显示温度和盐度的垂直分布，高亮当前数据点
 */
import type { OceanData } from '#/api/ocean/data/types/data.types';

import { computed, onMounted, ref, watch } from 'vue';

import { Card } from 'ant-design-vue';
import * as echarts from 'echarts';

interface Props {
  /** 周围数据点 */
  data: OceanData[];
  /** 当前数据点ID */
  currentId?: string;
  /** 图表标题 */
  title?: string;
}

const props = withDefaults(defineProps<Props>(), {
  data: () => [],
  title: '垂直剖面',
});

const chartRef = ref<HTMLDivElement>();
let chartInstance: echarts.ECharts | null = null;

// 图表配置
const chartOption = computed(() => {
  const sortedData = [...props.data].sort((a, b) => a.depth - b.depth);

  const depths = sortedData.map((d) => d.depth);
  const temperatures = sortedData.map((d) => d.temperature);
  const salinities = sortedData.map((d) => d.salinity);

  // 找到当前点的索引
  const currentIndex = sortedData.findIndex((d) => d.id === props.currentId);

  return {
    tooltip: {
      trigger: 'axis',
      formatter: (params: any[]) => {
        const depth = params[0]?.axisValue ?? '-';
        let result = `深度: ${depth}m<br/>`;
        params.forEach((param) => {
          const value = param.value ?? '-';
          result += `${param.marker} ${param.seriesName}: ${typeof value === 'number' ? value.toFixed(3) : value}<br/>`;
        });
        return result;
      },
    },
    legend: {
      data: ['温度', '盐度'],
      bottom: 0,
    },
    grid: {
      left: '3%',
      right: '15%',
      bottom: '15%',
      top: '10%',
      containLabel: true,
    },
    xAxis: [
      {
        type: 'value',
        name: '温度(℃)',
        nameLocation: 'middle',
        nameGap: 25,
        position: 'bottom',
      },
      {
        type: 'value',
        name: '盐度(PSU)',
        nameLocation: 'middle',
        nameGap: 25,
        position: 'top',
      },
    ],
    yAxis: {
      type: 'category',
      name: '深度(m)',
      inverse: true,
      data: depths,
    },
    series: [
      {
        name: '温度',
        type: 'line',
        xAxisIndex: 0,
        data: temperatures,
        smooth: true,
        symbol: 'circle',
        symbolSize: (_value: any, params: any) => {
          return params.dataIndex === currentIndex ? 12 : 6;
        },
        itemStyle: {
          color: '#ff7875',
        },
        lineStyle: {
          width: 2,
        },
        markPoint:
          currentIndex === -1
            ? undefined
            : {
                data: [
                  {
                    coord: [temperatures[currentIndex], depths[currentIndex]],
                    symbol: 'pin',
                    symbolSize: 30,
                    itemStyle: {
                      color: '#ff4d4f',
                    },
                    label: {
                      show: true,
                      formatter: '当前',
                    },
                  },
                ],
              },
      },
      {
        name: '盐度',
        type: 'line',
        xAxisIndex: 1,
        data: salinities,
        smooth: true,
        symbol: 'circle',
        symbolSize: (_value: any, params: any) => {
          return params.dataIndex === currentIndex ? 12 : 6;
        },
        itemStyle: {
          color: '#1890ff',
        },
        lineStyle: {
          width: 2,
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
  () => [props.data, props.currentId],
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
    <div v-if="data.length === 0" class="py-8 text-center text-gray-400">
      暂无周围数据
    </div>
  </Card>
</template>

<style scoped>
.chart-container {
  width: 100%;
  height: 350px;
}
</style>
