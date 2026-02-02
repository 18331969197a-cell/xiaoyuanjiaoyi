<script lang="ts" setup>
import type { PointsInfo, PointsLog } from '#/api/lostfound/points';

import { onMounted, ref } from 'vue';
import { useRouter } from 'vue-router';

import { Page } from '@vben/common-ui';

import { GiftOutlined, ShoppingCartOutlined } from '@ant-design/icons-vue';
import {
  Button,
  Card,
  Col,
  Empty,
  Pagination,
  Row,
  Spin,
  Statistic,
  Table,
  Tag,
} from 'ant-design-vue';

import { getGiftList, getMyExchangeOrders } from '#/api/lostfound/gifts';
import { getMyPoints, getPointsLogs } from '#/api/lostfound/points';

const router = useRouter();

const loading = ref(false);
const logsLoading = ref(false);
const pointsInfo = ref<null | PointsInfo>(null);
const logs = ref<PointsLog[]>([]);
const total = ref(0);
const currentPage = ref(1);
const pageSize = ref(10);

// 礼品商城统计
const giftStats = ref({
  totalGifts: 0,
  pendingOrders: 0,
  completedOrders: 0,
});

// 积分类型配置（支持大写和小写key）
const typeConfig: Record<string, { color: string; label: string }> = {
  // 小写格式
  publish_found: { color: 'green', label: '发布招领' },
  claim_success: { color: 'green', label: '认领成功' },
  handover_complete: { color: 'green', label: '交接完成' },
  good_evaluation: { color: 'green', label: '好评奖励' },
  daily_login: { color: 'blue', label: '每日登录' },
  admin_adjust: { color: 'orange', label: '管理员调整' },
  report_accepted: { color: 'green', label: '举报有效' },
  violation: { color: 'red', label: '违规扣除' },
  // 大写格式（数据库实际存储格式）
  PUBLISH_FOUND: { color: 'green', label: '发布招领' },
  CLAIM_SUCCESS: { color: 'green', label: '认领成功' },
  CLAIM_OWNER: { color: 'green', label: '失主认领' },
  HANDOVER_COMPLETE: { color: 'green', label: '交接完成' },
  GOOD_EVALUATION: { color: 'green', label: '好评奖励' },
  DAILY_LOGIN: { color: 'blue', label: '每日登录' },
  ADMIN_ADJUST: { color: 'orange', label: '管理员调整' },
  REPORT_ACCEPTED: { color: 'green', label: '举报有效' },
  VIOLATION: { color: 'red', label: '违规扣除' },
  EXCHANGE: { color: 'orange', label: '积分兑换' },
};

// 表格列
const columns = [
  {
    title: '类型',
    dataIndex: 'type',
    width: 120,
  },
  {
    title: '积分变动',
    dataIndex: 'points',
    width: 100,
  },
  {
    title: '说明',
    dataIndex: 'description',
    ellipsis: true,
  },
  {
    title: '时间',
    dataIndex: 'createTime',
    width: 160,
  },
];

// 加载积分信息
async function loadPointsInfo() {
  loading.value = true;
  try {
    pointsInfo.value = await getMyPoints();
  } catch (error) {
    console.error('加载积分信息失败:', error);
  } finally {
    loading.value = false;
  }
}

// 加载积分流水
async function loadLogs() {
  logsLoading.value = true;
  try {
    const res = await getPointsLogs({
      pageNum: currentPage.value,
      pageSize: pageSize.value,
    });
    logs.value = res.rows || [];
    total.value = res.total || 0;
  } catch (error) {
    console.error('加载积分流水失败:', error);
  } finally {
    logsLoading.value = false;
  }
}

// 分页变化
function onPageChange(page: number, size: number) {
  currentPage.value = page;
  pageSize.value = size;
  loadLogs();
}

// 加载礼品商城统计
async function loadGiftStats() {
  try {
    // 获取礼品总数
    const giftsRes = await getGiftList({ pageNum: 1, pageSize: 1 });
    giftStats.value.totalGifts = giftsRes.total || 0;

    // 获取我的兑换订单统计
    const ordersRes = await getMyExchangeOrders({ pageNum: 1, pageSize: 100 });
    const orders = ordersRes.rows || [];
    giftStats.value.pendingOrders = orders.filter(
      (o: any) => o.status === 'PENDING' || o.status === 'SHIPPED',
    ).length;
    giftStats.value.completedOrders = orders.filter(
      (o: any) => o.status === 'COMPLETED',
    ).length;
  } catch (error) {
    console.error('加载礼品统计失败:', error);
  }
}

// 跳转到礼品商城
function goToGiftMall() {
  router.push('/lostfound/gifts');
}

// 跳转到我的兑换
function goToMyExchange() {
  router.push('/lostfound/me/exchange');
}

// 格式化时间
function formatTime(time: string) {
  if (!time) return '';
  return time.replace('T', ' ').slice(0, 16);
}

// 等级名称
function getLevelName(level: number) {
  const levels: Record<number, string> = {
    1: '新手',
    2: '初级',
    3: '中级',
    4: '高级',
    5: '专家',
  };
  return levels[level] || `等级${level}`;
}

onMounted(() => {
  loadPointsInfo();
  loadLogs();
  loadGiftStats();
});
</script>

<template>
  <Page auto-content-height>
    <div class="p-4">
      <!-- 积分概览 -->
      <Card title="积分概览" class="mb-4">
        <Spin :spinning="loading">
          <Row :gutter="24">
            <Col :xs="12" :sm="6">
              <Statistic
                title="当前积分"
                :value="pointsInfo?.points || 0"
                :value-style="{ color: '#1890ff' }"
              />
            </Col>
            <Col :xs="12" :sm="6">
              <Statistic
                title="信誉等级"
                :value="getLevelName(pointsInfo?.level || 1)"
              />
            </Col>
            <Col :xs="12" :sm="6">
              <Statistic
                title="累计获得"
                :value="pointsInfo?.totalEarned || 0"
                :value-style="{ color: '#52c41a' }"
              />
            </Col>
            <Col :xs="12" :sm="6">
              <Statistic
                title="累计消耗"
                :value="pointsInfo?.totalSpent || 0"
                :value-style="{ color: '#ff4d4f' }"
              />
            </Col>
          </Row>

          <!-- 等级进度 -->
          <div v-if="pointsInfo" class="mt-6">
            <div class="mb-2 flex items-center justify-between">
              <span>距离下一等级还需
                {{ pointsInfo.nextLevelPoints - pointsInfo.points }} 积分</span>
              <span class="text-gray-500">
                {{ pointsInfo.points }} / {{ pointsInfo.nextLevelPoints }}
              </span>
            </div>
            <div class="h-2 overflow-hidden rounded-full bg-gray-200">
              <div
                class="h-full rounded-full bg-blue-500 transition-all"
                :style="{
                  width: `${Math.min((pointsInfo.points / pointsInfo.nextLevelPoints) * 100, 100)}%`,
                }"
              ></div>
            </div>
          </div>
        </Spin>
      </Card>

      <!-- 积分规则 -->
      <Card title="积分规则" class="mb-4">
        <Row :gutter="[16, 16]">
          <Col :xs="12" :sm="8" :md="6">
            <div class="rounded bg-green-50 p-3 text-center">
              <div class="text-lg font-medium text-green-600">+10</div>
              <div class="text-sm text-gray-500">发布招领</div>
            </div>
          </Col>
          <Col :xs="12" :sm="8" :md="6">
            <div class="rounded bg-green-50 p-3 text-center">
              <div class="text-lg font-medium text-green-600">+20</div>
              <div class="text-sm text-gray-500">认领成功</div>
            </div>
          </Col>
          <Col :xs="12" :sm="8" :md="6">
            <div class="rounded bg-green-50 p-3 text-center">
              <div class="text-lg font-medium text-green-600">+30</div>
              <div class="text-sm text-gray-500">交接完成</div>
            </div>
          </Col>
          <Col :xs="12" :sm="8" :md="6">
            <div class="rounded bg-green-50 p-3 text-center">
              <div class="text-lg font-medium text-green-600">+5</div>
              <div class="text-sm text-gray-500">获得好评</div>
            </div>
          </Col>
        </Row>
      </Card>

      <!-- 积分兑换入口 -->
      <Card class="mb-4">
        <div class="flex items-center justify-between">
          <div class="flex items-center gap-6">
            <div class="flex items-center gap-3">
              <div
                class="flex h-12 w-12 items-center justify-center rounded-full bg-orange-100"
              >
                <GiftOutlined class="text-2xl text-orange-500" />
              </div>
              <div>
                <div class="text-lg font-medium">礼品商城</div>
                <div class="text-sm text-gray-500">用积分兑换精美礼品</div>
              </div>
            </div>
            <div class="flex gap-8 border-l pl-6">
              <Statistic
                title="可兑换礼品"
                :value="giftStats.totalGifts"
                suffix="件"
              />
              <Statistic
                title="待处理订单"
                :value="giftStats.pendingOrders"
                :value-style="
                  giftStats.pendingOrders > 0 ? { color: '#faad14' } : {}
                "
              />
              <Statistic
                title="已完成兑换"
                :value="giftStats.completedOrders"
                :value-style="{ color: '#52c41a' }"
              />
            </div>
          </div>
          <div class="flex gap-3">
            <Button @click="goToMyExchange">
              <template #icon><ShoppingCartOutlined /></template>
              我的兑换
            </Button>
            <Button type="primary" @click="goToGiftMall">
              <template #icon><GiftOutlined /></template>
              进入商城
            </Button>
          </div>
        </div>
      </Card>

      <!-- 积分流水 -->
      <Card title="积分流水">
        <Spin :spinning="logsLoading">
          <Table
            :columns="columns"
            :data-source="logs"
            :pagination="false"
            row-key="id"
          >
            <template #bodyCell="{ column, record }">
              <template v-if="column.dataIndex === 'type'">
                <Tag :color="typeConfig[record.type]?.color || 'default'">
                  {{ typeConfig[record.type]?.label || record.type }}
                </Tag>
              </template>
              <template v-else-if="column.dataIndex === 'points'">
                <span
                  :class="record.points > 0 ? 'text-green-600' : 'text-red-600'"
                >
                  {{ record.points > 0 ? '+' : '' }}{{ record.points }}
                </span>
              </template>
              <template v-else-if="column.dataIndex === 'createTime'">
                {{ formatTime(record.createTime) }}
              </template>
            </template>
          </Table>

          <div v-if="logs.length > 0" class="mt-4 flex justify-end">
            <Pagination
              :current="currentPage"
              :page-size="pageSize"
              :total="total"
              show-size-changer
              show-quick-jumper
              :show-total="(t) => `共 ${t} 条`"
              @change="onPageChange"
            />
          </div>

          <Empty
            v-if="!logsLoading && logs.length === 0"
            description="暂无积分记录"
          />
        </Spin>
      </Card>
    </div>
  </Page>
</template>
