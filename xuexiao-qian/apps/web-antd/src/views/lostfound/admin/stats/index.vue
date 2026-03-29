<script lang="ts" setup>
import type { EChartsOption } from 'echarts';

import { computed, onMounted, ref, watch } from 'vue';

import { Page } from '@vben/common-ui';
import { EchartsUI, useEcharts } from '@vben/plugins/echarts';

import {
  Button,
  Card,
  Col,
  DatePicker,
  message,
  Row,
  Select,
  Spin,
  Statistic,
  Table,
} from 'ant-design-vue';

import {
  exportStats,
  getCategoryStatsDetail,
  getLocationStatsDetail,
  getOverviewStats,
  getRecoveryStats,
} from '#/api/lostfound/statistics';

const loading = ref(false);
const exporting = ref(false);
const overview = ref<any>(null);
const recoveryStats = ref<any[]>([]);
const categoryStats = ref<any[]>([]);
const locationStats = ref<any[]>([]);

// ECharts 引用
const trendChartRef = ref();
const { renderEcharts: renderTrendChart } = useEcharts(trendChartRef);

// 筛选条件
const dateRange = ref<[string, string] | null>(null);
const statsType = ref<string>('daily');

// 分类统计表格列
const categoryColumns = [
  { title: '分类名称', dataIndex: 'categoryName', key: 'categoryName' },
  { title: '帖子数量', dataIndex: 'postCount', key: 'postCount' },
  { title: '寻物数量', dataIndex: 'lostCount', key: 'lostCount' },
  { title: '招领数量', dataIndex: 'foundCount', key: 'foundCount' },
  { title: '找回数量', dataIndex: 'recoveredCount', key: 'recoveredCount' },
  {
    title: '找回率',
    dataIndex: 'recoveryRate',
    key: 'recoveryRate',
    customRender: ({ text }: { text: number }) => `${(text * 100).toFixed(1)}%`,
  },
];

// 地点统计表格列
const locationColumns = [
  { title: '地点名称', dataIndex: 'locationName', key: 'locationName' },
  { title: '帖子数量', dataIndex: 'postCount', key: 'postCount' },
  { title: '寻物数量', dataIndex: 'lostCount', key: 'lostCount' },
  { title: '招领数量', dataIndex: 'foundCount', key: 'foundCount' },
  { title: '找回数量', dataIndex: 'recoveredCount', key: 'recoveredCount' },
];

// 趋势图配置
const trendChartOptions = computed((): EChartsOption => {
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
      renderTrendChart(trendChartOptions.value);
    }
  },
  { deep: true },
);

// 加载统计数据
async function loadStats() {
  loading.value = true;
  try {
    const params = {
      startDate: dateRange.value?.[0],
      endDate: dateRange.value?.[1],
      type: statsType.value,
    };

    const [overviewData, recoveryData, categoryData, locationData] =
      await Promise.all([
        getOverviewStats(params),
        getRecoveryStats(params),
        getCategoryStatsDetail(params),
        getLocationStatsDetail(params),
      ]);

    overview.value = overviewData;
    recoveryStats.value = recoveryData || [];
    categoryStats.value = categoryData || [];
    locationStats.value = locationData || [];
  } catch (error) {
    console.error('加载统计数据失败:', error);
  } finally {
    loading.value = false;
  }
}

// 日期范围变化
function onDateChange(dates: any) {
  dateRange.value =
    dates && dates.length === 2
      ? [dates[0]?.format('YYYY-MM-DD'), dates[1]?.format('YYYY-MM-DD')]
      : null;
  loadStats();
}

// 导出统计
async function handleExport() {
  exporting.value = true;
  try {
    const data = await exportStats({
      startDate: dateRange.value?.[0],
      endDate: dateRange.value?.[1],
      type: statsType.value,
    });

    // 生成CSV内容
    let csvContent = '\uFEFF'; // BOM for UTF-8

    // 概览数据
    csvContent += '统计概览\n';
    csvContent += `总帖子数,${data.overview?.totalPosts || 0}\n`;
    csvContent += `寻物启事,${data.overview?.lostPosts || 0}\n`;
    csvContent += `招领信息,${data.overview?.foundPosts || 0}\n`;
    csvContent += `成功找回,${data.overview?.recoveredCount || 0}\n`;
    csvContent += `审核通过数,${data.overview?.approvedClaims || 0}\n`;
    csvContent += `交接完成数,${data.overview?.completedClaims || data.overview?.recoveredCount || 0}\n`;
    csvContent += `审核通过率,${data.overview?.approvedRate || 0}%\n`;
    csvContent += `交接完成率,${data.overview?.handoverCompletionRate || 0}%\n`;
    csvContent += `找回率,${data.overview?.recoveryRate || 0}%\n`;
    csvContent += `活跃用户,${data.overview?.activeUsers || 0}\n`;
    csvContent += `总认领数,${data.overview?.totalClaims || 0}\n`;
    csvContent += `发放积分,${data.overview?.totalPoints || 0}\n`;
    csvContent += '\n';

    // 趋势数据
    csvContent += '发布趋势\n';
    csvContent += '日期,寻物数量,招领数量,找回数量\n';
    (data.trend || []).forEach((item: any) => {
      csvContent += `${item.date},${item.lostCount},${item.foundCount},${item.recoveredCount}\n`;
    });
    csvContent += '\n';

    // 分类统计
    csvContent += '分类统计\n';
    csvContent += '分类名称,帖子数量,寻物数量,招领数量,找回数量\n';
    (data.categoryStats || []).forEach((item: any) => {
      csvContent += `${item.categoryName},${item.postCount},${item.lostCount},${item.foundCount},${item.recoveredCount}\n`;
    });
    csvContent += '\n';

    // 地点统计
    csvContent += '地点统计\n';
    csvContent += '地点名称,帖子数量,寻物数量,招领数量,找回数量\n';
    (data.locationStats || []).forEach((item: any) => {
      csvContent += `${item.locationName},${item.postCount},${item.lostCount},${item.foundCount},${item.recoveredCount}\n`;
    });

    // 创建下载
    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
    const link = document.createElement('a');
    const url = URL.createObjectURL(blob);
    link.setAttribute('href', url);
    link.setAttribute(
      'download',
      `统计报表_${new Date().toISOString().slice(0, 10)}.csv`,
    );
    link.style.visibility = 'hidden';
    document.body.append(link);
    link.click();
    link.remove();

    message.success('导出成功');
  } catch (error) {
    console.error('导出失败:', error);
    message.error('导出失败');
  } finally {
    exporting.value = false;
  }
}

onMounted(() => {
  loadStats();
});
</script>

<template>
  <Page auto-content-height>
    <div class="p-4">
      <!-- 筛选条件 -->
      <Card class="mb-4">
        <div class="flex flex-wrap items-center gap-4">
          <div class="flex items-center gap-2">
            <span>时间范围：</span>
            <DatePicker.RangePicker
              style="width: 240px"
              @change="onDateChange"
            />
          </div>
          <div class="flex items-center gap-2">
            <span>统计类型：</span>
            <Select
              v-model:value="statsType"
              style="width: 120px"
              :options="[
                { label: '按日', value: 'daily' },
                { label: '按周', value: 'weekly' },
                { label: '按月', value: 'monthly' },
              ]"
              @change="loadStats"
            />
          </div>
          <Button type="primary" @click="loadStats">查询</Button>
          <Button :loading="exporting" @click="handleExport">导出报表</Button>
        </div>
      </Card>

      <Spin :spinning="loading">
        <!-- 数据概览 -->
        <Row :gutter="[16, 16]">
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
              <Statistic
                title="成功找回"
                :value="overview?.recoveredCount || 0"
                :value-style="{ color: '#1890ff' }"
              />
            </Card>
          </Col>
        </Row>

        <Row :gutter="[16, 16]" class="mt-4">
          <Col :xs="12" :sm="6">
            <Card>
              <Statistic
                title="找回率"
                :value="overview?.recoveryRate || 0"
                suffix="%"
                :precision="1"
                :value-style="{ color: '#52c41a' }"
              />
            </Card>
          </Col>
          <Col :xs="12" :sm="6">
            <Card>
              <Statistic title="活跃用户" :value="overview?.activeUsers || 0" />
            </Card>
          </Col>
          <Col :xs="12" :sm="6">
            <Card>
              <Statistic title="审核通过数" :value="overview?.approvedClaims || 0" />
            </Card>
          </Col>
          <Col :xs="12" :sm="6">
            <Card>
              <Statistic
                title="交接完成率"
                :value="overview?.handoverCompletionRate || 0"
                suffix="%"
                :precision="1"
                :value-style="{ color: '#1677ff' }"
              />
            </Card>
          </Col>
        </Row>

        <Row :gutter="[16, 16]" class="mt-4">
          <Col :xs="12" :sm="8">
            <Card>
              <Statistic title="总认领数" :value="overview?.totalClaims || 0" />
            </Card>
          </Col>
          <Col :xs="12" :sm="8">
            <Card>
              <Statistic
                title="审核通过率"
                :value="overview?.approvedRate || 0"
                suffix="%"
                :precision="1"
                :value-style="{ color: '#13c2c2' }"
              />
            </Card>
          </Col>
          <Col :xs="12" :sm="8">
            <Card>
              <Statistic
                title="发放积分"
                :value="overview?.totalPoints || 0"
                :value-style="{ color: '#faad14' }"
              />
            </Card>
          </Col>
        </Row>

        <!-- 趋势图 - 使用 ECharts -->
        <Card title="发布趋势" class="mt-4">
          <EchartsUI ref="trendChartRef" class="h-80 w-full" />
        </Card>

        <!-- 分类统计 -->
        <Card title="分类统计" class="mt-4">
          <Table
            :columns="categoryColumns"
            :data-source="categoryStats"
            :pagination="false"
            row-key="categoryId"
            size="small"
          />
        </Card>

        <!-- 地点统计 -->
        <Card title="地点统计" class="mt-4">
          <Table
            :columns="locationColumns"
            :data-source="locationStats"
            :pagination="false"
            row-key="locationId"
            size="small"
          />
        </Card>
      </Spin>
    </div>
  </Page>
</template>
