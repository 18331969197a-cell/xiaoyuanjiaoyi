<script lang="ts" setup>
import type { ExchangeParams, Gift } from '#/api/lostfound/gifts';
import type { PointsInfo } from '#/api/lostfound/points';

import { computed, onMounted, ref } from 'vue';
import { useRoute, useRouter } from 'vue-router';

import { Page } from '@vben/common-ui';
import { useAppConfig } from '@vben/hooks';

import {
  Button,
  Card,
  Carousel,
  Col,
  Form,
  Input,
  InputNumber,
  message,
  Modal,
  Row,
  Spin,
  Tag,
} from 'ant-design-vue';

import { exchangeGift, getGiftDetail } from '#/api/lostfound/gifts';
import { getMyPoints } from '#/api/lostfound/points';
import { parseImages } from '#/utils/lostfound';

// 获取API基础URL用于图片路径
const { apiURL } = useAppConfig(import.meta.env, import.meta.env.PROD);

// 处理图片URL，将相对路径转换为完整URL
function getFullImageUrl(url: string | undefined): string {
  if (!url) return '';
  // 如果已经是完整URL，直接返回
  if (
    url.startsWith('http://') ||
    url.startsWith('https://') ||
    url.startsWith('data:')
  ) {
    return url;
  }
  // 兼容仅存文件名或无前缀路径的情况
  if (!url.startsWith('/')) {
    url = `/uploads/${url}`;
  }
  // 相对路径，将 /uploads/ 转换为 /file/uploads/ 以绕过Spring Security
  if (url.startsWith('/uploads/')) {
    return `${apiURL}/file${url}`;
  }
  // 其他相对路径，添加API基础URL
  return `${apiURL}${url}`;
}

const route = useRoute();
const router = useRouter();
const loading = ref(false);
const gift = ref<Gift | null>(null);
const pointsInfo = ref<null | PointsInfo>(null);
const exchangeModalVisible = ref(false);
const exchangeLoading = ref(false);

// 兑换表单
const exchangeForm = ref<ExchangeParams>({
  giftId: 0,
  quantity: 1,
  receiverName: '',
  receiverPhone: '',
  receiverAddress: '',
});

// 计算所需积分
const totalPoints = computed(() => {
  if (!gift.value) return 0;
  return gift.value.pointsCost! * (exchangeForm.value.quantity || 1);
});

// 是否可以兑换
const canExchange = computed(() => {
  if (!gift.value || !pointsInfo.value) return false;
  return gift.value.stock! > 0 && pointsInfo.value.points! >= totalPoints.value;
});

// 加载礼品详情
async function loadGift() {
  loading.value = true;
  try {
    const id = Number(route.params.id || route.query.id);
    if (!id) {
      message.error('缺少礼品ID');
      router.replace('/lostfound/gifts');
      return;
    }
    gift.value = await getGiftDetail(id);
    exchangeForm.value.giftId = id;
  } catch (error) {
    console.error('加载礼品详情失败:', error);
    message.error('礼品不存在或已下架');
    router.back();
  } finally {
    loading.value = false;
  }
}

// 加载积分信息
async function loadPoints() {
  try {
    pointsInfo.value = await getMyPoints();
  } catch (error) {
    console.error('加载积分信息失败:', error);
  }
}

// 打开兑换弹窗
function openExchangeModal() {
  if (!canExchange.value) {
    if (gift.value?.stock === 0) {
      message.warning('礼品库存不足');
    } else {
      message.warning('积分不足，无法兑换');
    }
    return;
  }
  exchangeForm.value.quantity = 1;
  exchangeForm.value.receiverName = '';
  exchangeForm.value.receiverPhone = '';
  exchangeForm.value.receiverAddress = '';
  exchangeModalVisible.value = true;
}

// 确认兑换
async function confirmExchange() {
  // 实物礼品校验收货信息
  if (gift.value?.giftType === 'PHYSICAL') {
    if (!exchangeForm.value.receiverName) {
      message.warning('请填写收货人姓名');
      return;
    }
    if (!exchangeForm.value.receiverPhone) {
      message.warning('请填写收货人电话');
      return;
    }
    if (!exchangeForm.value.receiverAddress) {
      message.warning('请填写收货地址');
      return;
    }
  }

  exchangeLoading.value = true;
  try {
    await exchangeGift(exchangeForm.value);
    message.success('兑换成功！');
    exchangeModalVisible.value = false;
    // 刷新数据
    loadGift();
    loadPoints();
  } catch (error: any) {
    message.error(error.message || '兑换失败');
  } finally {
    exchangeLoading.value = false;
  }
}

// 获取礼品图片列表
function getGiftImages() {
  const images = parseImages(gift.value?.imagesJson as any);
  if (images.length > 0) return images.map((url) => getFullImageUrl(url));
  return ['https://via.placeholder.com/400x300?text=No+Image'];
}

// 礼品类型标签
function getGiftTypeTag(type: string) {
  return type === 'PHYSICAL'
    ? { color: 'blue', text: '实物礼品' }
    : { color: 'purple', text: '虚拟礼品' };
}

onMounted(() => {
  loadGift();
  loadPoints();
});
</script>

<template>
  <Page auto-content-height>
    <div class="p-4">
      <Spin :spinning="loading">
        <Row v-if="gift" :gutter="24">
          <!-- 左侧图片 -->
          <Col :xs="24" :md="12">
            <Card>
              <Carousel autoplay>
                <div v-for="(img, index) in getGiftImages()" :key="index">
                  <img
                    :src="img"
                    :alt="gift.name"
                    class="h-80 w-full object-contain"
                  />
                </div>
              </Carousel>
            </Card>
          </Col>

          <!-- 右侧信息 -->
          <Col :xs="24" :md="12">
            <Card title="礼品详情">
              <div class="space-y-4">
                <div>
                  <h2 class="text-xl font-bold">{{ gift.name }}</h2>
                  <Tag
                    :color="getGiftTypeTag(gift.giftType!).color"
                    class="mt-2"
                  >
                    {{ getGiftTypeTag(gift.giftType!).text }}
                  </Tag>
                </div>

                <div class="text-2xl font-bold text-orange-500">
                  {{ gift.pointsCost }} 积分
                </div>

                <div class="flex items-center gap-4 text-gray-500">
                  <span>剩余库存: {{ gift.stock }}</span>
                  <span>已兑换: {{ gift.exchangeCount }}</span>
                </div>

                <div v-if="pointsInfo" class="rounded bg-gray-50 p-3">
                  <span class="text-gray-600">我的积分: </span>
                  <span class="text-lg font-bold text-blue-500">
                    {{ pointsInfo.points }}
                  </span>
                </div>

                <Button
                  type="primary"
                  size="large"
                  block
                  :disabled="!canExchange"
                  @click="openExchangeModal"
                >
                  {{
                    gift.stock === 0
                      ? '已兑完'
                      : canExchange
                        ? '立即兑换'
                        : '积分不足'
                  }}
                </Button>
              </div>
            </Card>
          </Col>
        </Row>

        <!-- 礼品描述 -->
        <Card v-if="gift" title="礼品描述" class="mt-4">
          <div class="whitespace-pre-wrap">
            {{ gift.description || '暂无描述' }}
          </div>
        </Card>
      </Spin>

      <!-- 兑换确认弹窗 -->
      <Modal
        v-model:open="exchangeModalVisible"
        title="确认兑换"
        :confirm-loading="exchangeLoading"
        @ok="confirmExchange"
      >
        <div class="space-y-4">
          <div class="rounded bg-gray-50 p-4">
            <div class="mb-2 font-medium">{{ gift?.name }}</div>
            <div class="flex items-center justify-between text-sm">
              <span>单价: {{ gift?.pointsCost }} 积分</span>
              <span>库存: {{ gift?.stock }}</span>
            </div>
          </div>

          <Form layout="vertical">
            <Form.Item label="兑换数量">
              <InputNumber
                v-model:value="exchangeForm.quantity"
                :min="1"
                :max="gift?.stock || 1"
                style="width: 100%"
              />
            </Form.Item>

            <!-- 实物礼品收货信息 -->
            <template v-if="gift?.giftType === 'PHYSICAL'">
              <Form.Item label="收货人姓名" required>
                <Input
                  v-model:value="exchangeForm.receiverName"
                  placeholder="请输入收货人姓名"
                />
              </Form.Item>
              <Form.Item label="收货人电话" required>
                <Input
                  v-model:value="exchangeForm.receiverPhone"
                  placeholder="请输入收货人电话"
                />
              </Form.Item>
              <Form.Item label="收货地址" required>
                <Input.TextArea
                  v-model:value="exchangeForm.receiverAddress"
                  placeholder="请输入详细收货地址"
                  :rows="2"
                />
              </Form.Item>
            </template>

            <div class="rounded bg-orange-50 p-3">
              <div class="flex items-center justify-between">
                <span>消耗积分:</span>
                <span class="text-lg font-bold text-orange-500">
                  {{ totalPoints }}
                </span>
              </div>
              <div
                class="mt-1 flex items-center justify-between text-sm text-gray-500"
              >
                <span>当前积分: {{ pointsInfo?.points }}</span>
                <span
                  >兑换后: {{ (pointsInfo?.points || 0) - totalPoints }}</span
                >
              </div>
            </div>
          </Form>
        </div>
      </Modal>
    </div>
  </Page>
</template>
