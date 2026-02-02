<script lang="ts" setup>
import type { ExchangeOrder } from '#/api/lostfound/gifts';

import { onMounted, ref } from 'vue';

import { Page } from '@vben/common-ui';

import {
  Button,
  Card,
  Descriptions,
  Form,
  Input,
  message,
  Modal,
  Select,
  Space,
  Spin,
  Table,
  Tag,
} from 'ant-design-vue';

import {
  adminCancelOrder,
  adminGetOrderDetail,
  adminGetOrderList,
  adminShipOrder,
} from '#/api/lostfound/giftAdmin';

const loading = ref(false);
const orders = ref<ExchangeOrder[]>([]);
const total = ref(0);
const currentPage = ref(1);
const pageSize = ref(10);

// 搜索条件
const searchForm = ref({
  orderNo: '',
  status: undefined as string | undefined,
});

// 详情弹窗
const detailModalVisible = ref(false);
const detailLoading = ref(false);
const currentOrder = ref<ExchangeOrder | null>(null);

// 发货弹窗
const shipModalVisible = ref(false);
const shipLoading = ref(false);
const shipForm = ref({
  orderId: 0,
  trackingNo: '',
});

// 取消弹窗
const cancelModalVisible = ref(false);
const cancelLoading = ref(false);
const cancelForm = ref({
  orderId: 0,
  cancelReason: '',
});

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
    width: 80,
  },
  {
    title: '积分',
    dataIndex: 'pointsCost',
    width: 80,
  },
  {
    title: '数量',
    dataIndex: 'quantity',
    width: 60,
  },
  {
    title: '状态',
    dataIndex: 'status',
    width: 100,
  },
  {
    title: '下单时间',
    dataIndex: 'createdAt',
    width: 160,
  },
  {
    title: '操作',
    key: 'action',
    width: 180,
  },
];

// 加载订单列表
async function loadOrders() {
  loading.value = true;
  try {
    const res = await adminGetOrderList({
      pageNum: currentPage.value,
      pageSize: pageSize.value,
      ...searchForm.value,
    });
    orders.value = res.rows || [];
    total.value = res.total || 0;
  } catch (error) {
    console.error('加载订单失败:', error);
  } finally {
    loading.value = false;
  }
}

// 搜索
function handleSearch() {
  currentPage.value = 1;
  loadOrders();
}

// 重置
function handleReset() {
  searchForm.value = {
    orderNo: '',
    status: undefined,
  };
  handleSearch();
}

// 分页变化
function handleTableChange(pagination: any) {
  currentPage.value = pagination.current;
  pageSize.value = pagination.pageSize;
  loadOrders();
}

// 查看详情
async function viewDetail(id: number) {
  detailLoading.value = true;
  detailModalVisible.value = true;
  try {
    currentOrder.value = await adminGetOrderDetail(id);
  } catch (error) {
    console.error('加载订单详情失败:', error);
    message.error('加载订单详情失败');
  } finally {
    detailLoading.value = false;
  }
}

// 打开发货弹窗
function openShipModal(record: ExchangeOrder) {
  shipForm.value = {
    orderId: record.id!,
    trackingNo: '',
  };
  shipModalVisible.value = true;
}

// 确认发货
async function handleShip() {
  if (!shipForm.value.trackingNo) {
    message.warning('请输入物流单号');
    return;
  }
  shipLoading.value = true;
  try {
    await adminShipOrder(shipForm.value.orderId, shipForm.value.trackingNo);
    message.success('发货成功');
    shipModalVisible.value = false;
    loadOrders();
  } catch (error: any) {
    message.error(error.message || '发货失败');
  } finally {
    shipLoading.value = false;
  }
}

// 打开取消弹窗
function openCancelModal(record: ExchangeOrder) {
  cancelForm.value = {
    orderId: record.id!,
    cancelReason: '',
  };
  cancelModalVisible.value = true;
}

// 确认取消
async function handleCancel() {
  if (!cancelForm.value.cancelReason) {
    message.warning('请输入取消原因');
    return;
  }
  cancelLoading.value = true;
  try {
    await adminCancelOrder(
      cancelForm.value.orderId,
      cancelForm.value.cancelReason,
    );
    message.success('取消成功，积分已退还');
    cancelModalVisible.value = false;
    loadOrders();
  } catch (error: any) {
    message.error(error.message || '取消失败');
  } finally {
    cancelLoading.value = false;
  }
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
      <Card title="兑换订单管理">
        <!-- 搜索栏 -->
        <div class="mb-4 flex flex-wrap items-center gap-4">
          <Input
            v-model:value="searchForm.orderNo"
            placeholder="订单编号"
            style="width: 200px"
            allow-clear
          />
          <Select
            v-model:value="searchForm.status"
            placeholder="订单状态"
            style="width: 150px"
            allow-clear
          >
            <Select.Option value="PENDING">待发货</Select.Option>
            <Select.Option value="SHIPPED">已发货</Select.Option>
            <Select.Option value="COMPLETED">已完成</Select.Option>
            <Select.Option value="CANCELLED">已取消</Select.Option>
          </Select>
          <Button type="primary" @click="handleSearch">查询</Button>
          <Button @click="handleReset">重置</Button>
        </div>

        <!-- 表格 -->
        <Table
          :columns="columns"
          :data-source="orders"
          :loading="loading"
          :pagination="{
            current: currentPage,
            pageSize,
            total,
            showSizeChanger: true,
            showQuickJumper: true,
            showTotal: (t: number) => `共 ${t} 条`,
          }"
          row-key="id"
          @change="handleTableChange"
        >
          <template #bodyCell="{ column, record }">
            <template v-if="column.dataIndex === 'giftType'">
              <Tag :color="record.giftType === 'PHYSICAL' ? 'blue' : 'purple'">
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
              <Space>
                <Button type="link" size="small" @click="viewDetail(record.id)">
                  详情
                </Button>
                <Button
                  v-if="
                    record.status === 'PENDING' &&
                    record.giftType === 'PHYSICAL'
                  "
                  type="link"
                  size="small"
                  @click="openShipModal(record)"
                >
                  发货
                </Button>
                <Button
                  v-if="
                    record.status === 'PENDING' || record.status === 'SHIPPED'
                  "
                  type="link"
                  size="small"
                  danger
                  @click="openCancelModal(record)"
                >
                  取消
                </Button>
              </Space>
            </template>
          </template>
        </Table>
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
        </Spin>
      </Modal>

      <!-- 发货弹窗 -->
      <Modal
        v-model:open="shipModalVisible"
        title="订单发货"
        :confirm-loading="shipLoading"
        @ok="handleShip"
      >
        <Form layout="vertical">
          <Form.Item label="物流单号" required>
            <Input
              v-model:value="shipForm.trackingNo"
              placeholder="请输入物流单号"
            />
          </Form.Item>
        </Form>
      </Modal>

      <!-- 取消弹窗 -->
      <Modal
        v-model:open="cancelModalVisible"
        title="取消订单"
        :confirm-loading="cancelLoading"
        @ok="handleCancel"
      >
        <Form layout="vertical">
          <Form.Item label="取消原因" required>
            <Input.TextArea
              v-model:value="cancelForm.cancelReason"
              placeholder="请输入取消原因"
              :rows="3"
            />
          </Form.Item>
          <div class="text-orange-500">
            注意：取消订单后，用户消耗的积分将自动退还
          </div>
        </Form>
      </Modal>
    </div>
  </Page>
</template>
