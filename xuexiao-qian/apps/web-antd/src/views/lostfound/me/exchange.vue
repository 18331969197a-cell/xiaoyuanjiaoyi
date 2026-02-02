<script lang="ts" setup>
import type { ExchangeOrder } from '#/api/lostfound/gifts';

import { onMounted, ref } from 'vue';

import { Page } from '@vben/common-ui';

import {
  Button,
  Card,
  Descriptions,
  Empty,
  message,
  Modal,
  Pagination,
  Spin,
  Table,
  Tabs,
  Tag,
} from 'ant-design-vue';

import {
  confirmReceive,
  getExchangeOrderDetail,
  getMyExchangeOrders,
} from '#/api/lostfound/gifts';

const loading = ref(false);
const orders = ref<ExchangeOrder[]>([]);
const total = ref(0);
const currentPage = ref(1);
const pageSize = ref(10);
const selectedStatus = ref<string | undefined>(undefined);

// 订单详情弹窗
const detailModalVisible = ref(false);
const detailLoading = ref(false);
const currentOrder = ref<ExchangeOrder | null>(null);

// 状态配置
const statusConfig: Record<string, { color: string; label: string }> = {
  PENDING: { color: 'orange', label: '待发货' },
  SHIPPED: { color: 'blue', label: '已发货' },
  COMPLETED: { color: 'green', label: '已完成' },
  CANCELLED: { color: 'default', label: '已取消' },
};

// 表格列
const columns = [
  {
    title: '订单编号',
    dataIndex: 'orderNo',
    width: 180,
  },
  {
    title: '礼品名称',
    dataIndex: 'giftName',
    ellipsis: true,
  },
  {
    title: '类型',
    dataIndex: 'giftType',
    width: 100,
  },
  {
    title: '消耗积分',
    dataIndex: 'pointsCost',
    width: 100,
  },
  {
    title: '状态',
    dataIndex: 'status',
    width: 100,
  },
  {
    title: '时间',
    dataIndex: 'createdAt',
    width: 160,
  },
  {
    title: '操作',
    key: 'action',
    width: 120,
  },
];

// 加载订单列表
async function loadOrders() {
  loading.value = true;
  try {
    const res = await getMyExchangeOrders({
      pageNum: currentPage.value,
      pageSize: pageSize.value,
      status: selectedStatus.value,
    });
    orders.value = res.rows || [];
    total.value = res.total || 0;
  } catch (error) {
    console.error('加载订单失败:', error);
  } finally {
    loading.value = false;
  }
}

// 状态切换
function onStatusChange(status: string) {
  selectedStatus.value = status === 'all' ? undefined : status;
  currentPage.value = 1;
  loadOrders();
}

// 分页变化
function onPageChange(page: number, size: number) {
  currentPage.value = page;
  pageSize.value = size;
  loadOrders();
}

// 查看详情
async function viewDetail(id: number) {
  detailLoading.value = true;
  detailModalVisible.value = true;
  try {
    currentOrder.value = await getExchangeOrderDetail(id);
  } catch (error) {
    console.error('加载订单详情失败:', error);
    message.error('加载订单详情失败');
  } finally {
    detailLoading.value = false;
  }
}

// 确认收货
async function handleConfirmReceive(id: number) {
  Modal.confirm({
    title: '确认收货',
    content: '确认已收到礼品吗？',
    async onOk() {
      try {
        await confirmReceive(id);
        message.success('确认收货成功');
        loadOrders();
        if (currentOrder.value?.id === id) {
          currentOrder.value.status = 'COMPLETED';
        }
      } catch (error: any) {
        message.error(error.message || '操作失败');
      }
    },
  });
}

// 格式化时间
function formatTime(time: string) {
  if (!time) return '';
  return time.replace('T', ' ').slice(0, 16);
}

// 礼品类型
function getGiftTypeText(type: string) {
  return type === 'PHYSICAL' ? '实物' : '虚拟';
}

onMounted(() => {
  loadOrders();
});
</script>

<template>
  <Page auto-content-height>
    <div class="p-4">
      <Card title="我的兑换记录">
        <!-- 状态筛选 -->
        <Tabs :active-key="selectedStatus || 'all'" @change="onStatusChange">
          <Tabs.TabPane key="all" tab="全部" />
          <Tabs.TabPane key="PENDING" tab="待发货" />
          <Tabs.TabPane key="SHIPPED" tab="已发货" />
          <Tabs.TabPane key="COMPLETED" tab="已完成" />
          <Tabs.TabPane key="CANCELLED" tab="已取消" />
        </Tabs>

        <Spin :spinning="loading">
          <Table
            :columns="columns"
            :data-source="orders"
            :pagination="false"
            row-key="id"
          >
            <template #bodyCell="{ column, record }">
              <template v-if="column.dataIndex === 'giftType'">
                <Tag
                  :color="record.giftType === 'PHYSICAL' ? 'blue' : 'purple'"
                >
                  {{ getGiftTypeText(record.giftType) }}
                </Tag>
              </template>
              <template v-else-if="column.dataIndex === 'status'">
                <Tag :color="statusConfig[record.status]?.color || 'default'">
                  {{ statusConfig[record.status]?.label || record.status }}
                </Tag>
              </template>
              <template v-else-if="column.dataIndex === 'createdAt'">
                {{ formatTime(record.createdAt) }}
              </template>
              <template v-else-if="column.key === 'action'">
                <Button type="link" size="small" @click="viewDetail(record.id)">
                  详情
                </Button>
                <Button
                  v-if="
                    record.status === 'SHIPPED' &&
                    record.giftType === 'PHYSICAL'
                  "
                  type="link"
                  size="small"
                  @click="handleConfirmReceive(record.id)"
                >
                  确认收货
                </Button>
              </template>
            </template>
          </Table>

          <div v-if="orders.length > 0" class="mt-4 flex justify-end">
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
            v-if="!loading && orders.length === 0"
            description="暂无兑换记录"
          />
        </Spin>
      </Card>

      <!-- 订单详情弹窗 -->
      <Modal
        v-model:open="detailModalVisible"
        title="订单详情"
        :footer="null"
        width="600px"
      >
        <Spin :spinning="detailLoading">
          <Descriptions v-if="currentOrder" :column="2" bordered>
            <Descriptions.Item label="订单编号" :span="2">
              {{ currentOrder.orderNo }}
            </Descriptions.Item>
            <Descriptions.Item label="礼品名称" :span="2">
              {{ currentOrder.giftName }}
            </Descriptions.Item>
            <Descriptions.Item label="礼品类型">
              <Tag
                :color="
                  currentOrder.giftType === 'PHYSICAL' ? 'blue' : 'purple'
                "
              >
                {{ getGiftTypeText(currentOrder.giftType!) }}
              </Tag>
            </Descriptions.Item>
            <Descriptions.Item label="消耗积分">
              {{ currentOrder.pointsCost }}
            </Descriptions.Item>
            <Descriptions.Item label="数量">
              {{ currentOrder.quantity }}
            </Descriptions.Item>
            <Descriptions.Item label="订单状态">
              <Tag :color="statusConfig[currentOrder.status!]?.color">
                {{ statusConfig[currentOrder.status!]?.label }}
              </Tag>
            </Descriptions.Item>

            <!-- 实物礼品收货信息 -->
            <template v-if="currentOrder.giftType === 'PHYSICAL'">
              <Descriptions.Item label="收货人" :span="2">
                {{ currentOrder.receiverName }} {{ currentOrder.receiverPhone }}
              </Descriptions.Item>
              <Descriptions.Item label="收货地址" :span="2">
                {{ currentOrder.receiverAddress }}
              </Descriptions.Item>
              <Descriptions.Item
                v-if="currentOrder.trackingNo"
                label="物流单号"
                :span="2"
              >
                {{ currentOrder.trackingNo }}
              </Descriptions.Item>
            </template>

            <!-- 虚拟礼品内容 -->
            <template
              v-if="
                currentOrder.giftType === 'VIRTUAL' &&
                currentOrder.status === 'COMPLETED'
              "
            >
              <Descriptions.Item label="兑换内容" :span="2">
                <div class="rounded bg-green-50 p-2">
                  {{ currentOrder.virtualContent }}
                </div>
              </Descriptions.Item>
            </template>

            <Descriptions.Item label="下单时间" :span="2">
              {{ formatTime(currentOrder.createdAt!) }}
            </Descriptions.Item>
            <Descriptions.Item
              v-if="currentOrder.shippedAt"
              label="发货时间"
              :span="2"
            >
              {{ formatTime(currentOrder.shippedAt) }}
            </Descriptions.Item>
            <Descriptions.Item
              v-if="currentOrder.completedAt"
              label="完成时间"
              :span="2"
            >
              {{ formatTime(currentOrder.completedAt) }}
            </Descriptions.Item>
            <Descriptions.Item
              v-if="currentOrder.cancelReason"
              label="取消原因"
              :span="2"
            >
              {{ currentOrder.cancelReason }}
            </Descriptions.Item>
          </Descriptions>

          <!-- 确认收货按钮 -->
          <div
            v-if="
              currentOrder?.status === 'SHIPPED' &&
              currentOrder?.giftType === 'PHYSICAL'
            "
            class="mt-4 text-right"
          >
            <Button
              type="primary"
              @click="handleConfirmReceive(currentOrder.id!)"
            >
              确认收货
            </Button>
          </div>
        </Spin>
      </Modal>
    </div>
  </Page>
</template>
