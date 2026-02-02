<script lang="ts" setup>
import type { EChartsOption } from 'echarts';

import type { EchartsUIType } from '@vben/plugins/echarts';

import { computed, onMounted, ref, watch } from 'vue';

import { Page } from '@vben/common-ui';
import { EchartsUI, useEcharts } from '@vben/plugins/echarts';

import { Card, Col, Row, Spin, Statistic } from 'ant-design-vue';

import {
  getAdminOverview,
  getCategoryStats,
  getRecoveryStats,
} from '#/api/lostfound/statistics';

const loading = ref(false);
const overview = ref<any>(null);
const recoveryStats = ref<any[]>([]);
const categoryStats = ref<any[]>([]);

// 趋势图表
const trendChartRef = ref<EchartsUIType>();
const { renderEcharts: renderTrendChart } = useEcharts(trendChartRef);

// 计算趋势图表配置 - 使用和统计报表一样的动态效果
const trendChartOption = computed((): EChartsOption => {
  const dates = recoveryStats.value.map((item) => item.date?.slice(5) || '');
  const lostData = recoveryStats.value.map((item) => item.lostCount || 0);
  const foundData = recoveryStats.value.map((item) => item.foundCount || 0);
  const recoveredData = recoveryStats.value.map(
    (item) => item.recoveredCount || 0,
  );

  return {
    tooltip: {
      trigger: 'axis',
      axisPointer: {
        type: 'cross',
        label: { backgroundColor: '#6a7985' },
      },
    },
    legend: {
      data: ['寻物启事', '招领信息', '成功找回'],
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
      boundaryGap: false,
      data: dates,
      axisLine: { lineStyle: { color: '#ccc' } },
      axisLabel: { color: '#666' },
    },
    yAxis: {
      type: 'value',
      minInterval: 1,
      axisLine: { show: false },
      axisTick: { show: false },
      splitLine: { lineStyle: { color: '#eee', type: 'dashed' } },
      axisLabel: { color: '#666' },
    },
    series: [
      {
        name: '寻物启事',
        type: 'line',
        smooth: true,
        symbol: 'circle',
        symbolSize: 8,
        lineStyle: { width: 3, color: '#ff4d4f' },
        itemStyle: { color: '#ff4d4f', borderWidth: 2, borderColor: '#fff' },
        areaStyle: {
          color: {
            type: 'linear',
            x: 0,
            y: 0,
            x2: 0,
            y2: 1,
            colorStops: [
              { offset: 0, color: 'rgba(255, 77, 79, 0.3)' },
              { offset: 1, color: 'rgba(255, 77, 79, 0.05)' },
            ],
          },
        },
        data: lostData,
        animationDuration: 1500,
        animationEasing: 'cubicInOut',
      },
      {
        name: '招领信息',
        type: 'line',
        smooth: true,
        symbol: 'circle',
        symbolSize: 8,
        lineStyle: { width: 3, color: '#52c41a' },
        itemStyle: { color: '#52c41a', borderWidth: 2, borderColor: '#fff' },
        areaStyle: {
          color: {
            type: 'linear',
            x: 0,
            y: 0,
            x2: 0,
            y2: 1,
            colorStops: [
              { offset: 0, color: 'rgba(82, 196, 26, 0.3)' },
              { offset: 1, color: 'rgba(82, 196, 26, 0.05)' },
            ],
          },
        },
        data: foundData,
        animationDuration: 1500,
        animationDelay: 300,
        animationEasing: 'cubicInOut',
      },
      {
        name: '成功找回',
        type: 'line',
        smooth: true,
        symbol: 'diamond',
        symbolSize: 8,
        lineStyle: { width: 3, color: '#1890ff' },
        itemStyle: { color: '#1890ff', borderWidth: 2, borderColor: '#fff' },
        areaStyle: {
          color: {
            type: 'linear',
            x: 0,
            y: 0,
            x2: 0,
            y2: 1,
            colorStops: [
              { offset: 0, color: 'rgba(24, 144, 255, 0.3)' },
              { offset: 1, color: 'rgba(24, 144, 255, 0.05)' },
            ],
          },
        },
        data: recoveredData,
        animationDuration: 1500,
        animationDelay: 600,
        animationEasing: 'cubicInOut',
      },
    ],
  };
});

// 监听数据变化，更新图表
watch(
  recoveryStats,
  () => {
    if (recoveryStats.value.length > 0) {
      renderTrendChart(trendChartOption.value);
    }
  },
  { deep: true },
);

// 加载统计数据
async function loadStats() {
  loading.value = true;
  try {
    const [overviewData, recoveryData, categoryData] = await Promise.all([
      getAdminOverview(),
      getRecoveryStats({ type: 'daily' }),
      getCategoryStats(),
    ]);
    overview.value = overviewData;
    recoveryStats.value = recoveryData || [];
    categoryStats.value = categoryData || [];
  } catch (error) {
    console.error('加载统计数据失败:', error);
  } finally {
    loading.value = false;
  }
}

onMounted(() => {
  loadStats();
});
</script>

<template>
  <Page auto-content-height>
    <div class="p-4">
      <Spin :spinning="loading">
        <!-- 数据概览 -->
        <Row :gutter="[16, 16]">
          <Col :xs="12" :sm="6">
            <Card>
              <Statistic
                title="今日发布"
                :value="overview?.todayPosts || 0"
                :value-style="{ color: '#1890ff' }"
              />
            </Card>
          </Col>
          <Col :xs="12" :sm="6">
            <Card>
              <Statistic
                title="待审核"
                :value="overview?.pendingPosts || 0"
                :value-style="{ color: '#faad14' }"
              />
            </Card>
          </Col>
          <Col :xs="12" :sm="6">
            <Card>
              <Statistic
                title="本周找回"
                :value="overview?.weeklyRecovered || 0"
                :value-style="{ color: '#52c41a' }"
              />
            </Card>
          </Col>
          <Col :xs="12" :sm="6">
            <Card>
              <Statistic
                title="找回率"
                :value="overview?.recoveryRate || 0"
                suffix="%"
                :value-style="{ color: '#52c41a' }"
              />
            </Card>
          </Col>
        </Row>

        <!-- 更多统计卡片 -->
        <Row :gutter="[16, 16]" class="mt-4">
          <Col :xs="12" :sm="6">
            <Card>
              <Statistic title="总帖子数" :value="overview?.totalPosts || 0" />
            </Card>
          </Col>
          <Col :xs="12" :sm="6">
            <Card>
              <Statistic
                title="寻物启事"
                :value="overview?.lostPosts || 0"
                :value-style="{ color: '#ff4d4f' }"
              />
            </Card>
          </Col>
          <Col :xs="12" :sm="6">
            <Card>
              <Statistic
                title="招领信息"
                :value="overview?.foundPosts || 0"
                :value-style="{ color: '#52c41a' }"
              />
            </Card>
          </Col>
          <Col :xs="12" :sm="6">
            <Card>
              <Statistic title="活跃用户" :value="overview?.activeUsers || 0" />
            </Card>
          </Col>
        </Row>

        <!-- 近7天趋势 - 使用动态曲线图 -->
        <Card title="近7天发布趋势" class="mt-4">
          <EchartsUI ref="trendChartRef" class="h-72 w-full" />
        </Card>

        <!-- 分类统计 -->
        <Card title="分类统计" class="mt-4">
          <Row :gutter="[16, 16]">
            <Col
              v-for="item in categoryStats.slice(0, 8)"
              :key="item.categoryId"
              :xs="12"
              :sm="6"
              :md="3"
            >
              <div class="rounded bg-gray-50 p-3 text-center">
                <div class="text-lg font-medium">{{ item.count }}</div>
                <div class="truncate text-sm text-gray-500">
                  {{ item.categoryName }}
                </div>
              </div>
            </Col>
          </Row>
        </Card>

        <!-- 待处理事项和本月数据 -->
        <Row :gutter="[16, 16]" class="mt-4">
          <Col :xs="24" :md="12">
            <Card title="待处理事项">
              <div class="space-y-3">
                <div class="flex items-center justify-between">
                  <span class="text-gray-600">待审核帖子</span>
                  <span class="font-medium text-orange-500">
                    {{ overview?.pendingPosts || 0 }}
                  </span>
                </div>
                <div class="flex items-center justify-between">
                  <span class="text-gray-600">待处理认领</span>
                  <span class="font-medium text-blue-500">
                    {{ overview?.pendingClaims || 0 }}
                  </span>
                </div>
                <div class="flex items-center justify-between">
                  <span class="text-gray-600">待处理举报</span>
                  <span class="font-medium text-red-500">
                    {{ overview?.pendingReports || 0 }}
                  </span>
                </div>
                <div class="flex items-center justify-between">
                  <span class="text-gray-600">待审核评论</span>
                  <span class="font-medium">
                    {{ overview?.pendingComments || 0 }}
                  </span>
                </div>
              </div>
            </Card>
          </Col>
          <Col :xs="24" :md="12">
            <Card title="本月数据">
              <div class="space-y-3">
                <div class="flex items-center justify-between">
                  <span class="text-gray-600">新增帖子</span>
                  <span class="font-medium">{{
                    overview?.monthlyPosts || 0
                  }}</span>
                </div>
                <div class="flex items-center justify-between">
                  <span class="text-gray-600">成功找回</span>
                  <span class="font-medium text-green-600">
                    {{ overview?.monthlyRecovered || 0 }}
                  </span>
                </div>
                <div class="flex items-center justify-between">
                  <span class="text-gray-600">新增用户</span>
                  <span class="font-medium">{{
                    overview?.monthlyUsers || 0
                  }}</span>
                </div>
                <div class="flex items-center justify-between">
                  <span class="text-gray-600">发放积分</span>
                  <span class="font-medium text-blue-600">
                    {{ overview?.monthlyPoints || 0 }}
                  </span>
                </div>
              </div>
            </Card>
          </Col>
        </Row>
      </Spin>
    </div>
  </Page>
</template>
