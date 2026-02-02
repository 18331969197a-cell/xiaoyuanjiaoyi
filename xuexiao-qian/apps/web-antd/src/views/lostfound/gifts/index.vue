<script lang="ts" setup>
import type { Gift, GiftCategory } from '#/api/lostfound/gifts';

import { onMounted, ref } from 'vue';
import { useRouter } from 'vue-router';

import { Page } from '@vben/common-ui';
import { useAppConfig } from '@vben/hooks';

import {
  Card,
  Col,
  Empty,
  Pagination,
  Row,
  Spin,
  Tabs,
  Tag,
} from 'ant-design-vue';

import { getGiftCategories, getGiftList } from '#/api/lostfound/gifts';

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
  // 相对路径，将 /uploads/ 转换为 /file/uploads/ 以绕过Spring Security
  if (url.startsWith('/uploads/')) {
    return `${apiURL}/file${url}`;
  }
  // 其他相对路径，添加API基础URL
  return `${apiURL}${url}`;
}

const router = useRouter();
const loading = ref(false);
const gifts = ref<Gift[]>([]);
const categories = ref<GiftCategory[]>([]);
const total = ref(0);
const currentPage = ref(1);
const pageSize = ref(12);
const selectedCategory = ref<number | undefined>(undefined);

// 加载分类
async function loadCategories() {
  try {
    categories.value = await getGiftCategories();
  } catch (error) {
    console.error('加载分类失败:', error);
  }
}

// 加载礼品列表
async function loadGifts() {
  loading.value = true;
  try {
    const res = await getGiftList({
      pageNum: currentPage.value,
      pageSize: pageSize.value,
      categoryId: selectedCategory.value,
    });
    gifts.value = res.rows || [];
    total.value = res.total || 0;
  } catch (error) {
    console.error('加载礼品失败:', error);
  } finally {
    loading.value = false;
  }
}

// 分类切换
function onCategoryChange(categoryId: number | string) {
  const id = String(categoryId);
  selectedCategory.value = id === 'all' ? undefined : Number(id);
  currentPage.value = 1;
  loadGifts();
}

// 分页变化
function onPageChange(page: number, size: number) {
  currentPage.value = page;
  pageSize.value = size;
  loadGifts();
}

// 跳转详情
function goToDetail(id: number) {
  router.push(`/lostfound/gifts/${id}`);
}

// 获取礼品图片
function getGiftImage(gift: Gift) {
  if (gift.imagesJson && gift.imagesJson.length > 0) {
    return getFullImageUrl(gift.imagesJson[0]);
  }
  return 'https://via.placeholder.com/200x200?text=No+Image';
}

// 礼品类型标签
function getGiftTypeTag(type: string) {
  return type === 'PHYSICAL'
    ? { color: 'blue', text: '实物礼品' }
    : { color: 'purple', text: '虚拟礼品' };
}

onMounted(() => {
  loadCategories();
  loadGifts();
});
</script>

<template>
  <Page auto-content-height>
    <div class="gifts-page p-4">
      <Card title="礼品商城" class="gifts-container">
        <!-- 分类筛选 -->
        <Tabs
          :active-key="selectedCategory?.toString() || 'all'"
          @change="onCategoryChange"
        >
          <Tabs.TabPane key="all" tab="全部" />
          <Tabs.TabPane
            v-for="cat in categories"
            :key="cat.id?.toString()"
            :tab="cat.name"
          />
        </Tabs>

        <Spin :spinning="loading">
          <!-- 礼品列表 -->
          <Row :gutter="[24, 24]" class="mt-4">
            <Col
              v-for="gift in gifts"
              :key="gift.id"
              :xs="24"
              :sm="12"
              :md="8"
              :lg="6"
              :xl="4"
            >
              <Card
                hoverable
                class="gift-card"
                :body-style="{ padding: '12px' }"
                @click="goToDetail(gift.id!)"
              >
                <template #cover>
                  <div class="gift-image-wrapper">
                    <img
                      :src="getGiftImage(gift)"
                      :alt="gift.name"
                      class="gift-image"
                      loading="lazy"
                    />
                    <Tag
                      :color="getGiftTypeTag(gift.giftType!).color"
                      class="gift-type-tag"
                    >
                      {{ getGiftTypeTag(gift.giftType!).text }}
                    </Tag>
                    <div v-if="gift.stock === 0" class="sold-out-overlay">
                      <span>已兑完</span>
                    </div>
                  </div>
                </template>
                <div class="gift-info">
                  <div class="gift-name" :title="gift.name">
                    {{ gift.name }}
                  </div>
                  <div class="gift-meta">
                    <span class="gift-price">
                      <span class="price-value">{{ gift.pointsCost }}</span>
                      <span class="price-unit">积分</span>
                    </span>
                    <span class="gift-stock"> 库存: {{ gift.stock }} </span>
                  </div>
                </div>
              </Card>
            </Col>
          </Row>

          <!-- 空状态 -->
          <Empty
            v-if="!loading && gifts.length === 0"
            description="暂无礼品"
            class="py-12"
          />

          <!-- 分页 -->
          <div v-if="gifts.length > 0" class="mt-6 flex justify-center">
            <Pagination
              :current="currentPage"
              :page-size="pageSize"
              :total="total"
              show-size-changer
              :page-size-options="['12', '24', '36']"
              :show-total="(t) => `共 ${t} 件礼品`"
              @change="onPageChange"
            />
          </div>
        </Spin>
      </Card>
    </div>
  </Page>
</template>

<style scoped>
.gifts-page {
  min-height: 100%;
  background: #f5f7fa;
}

.gifts-container {
  border-radius: 8px;
}

.gift-card {
  overflow: hidden;
  cursor: pointer;
  border-radius: 12px;
  transition: all 0.3s ease;
}

.gift-card:hover {
  box-shadow: 0 8px 24px rgb(0 0 0 / 12%);
  transform: translateY(-6px);
}

.gift-image-wrapper {
  position: relative;
  width: 100%;
  padding-top: 100%; /* 1:1 宽高比 */
  overflow: hidden;
  background: #f8f9fa;
}

.gift-image {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.gift-card:hover .gift-image {
  transform: scale(1.05);
}

.gift-type-tag {
  position: absolute;
  top: 8px;
  left: 8px;
  font-size: 12px;
  border-radius: 4px;
}

.sold-out-overlay {
  position: absolute;
  top: 0;
  left: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 100%;
  background: rgb(0 0 0 / 50%);
}

.sold-out-overlay span {
  padding: 8px 16px;
  font-size: 18px;
  font-weight: bold;
  color: #fff;
  background: rgb(255 77 79 / 90%);
  border-radius: 4px;
}

.gift-info {
  padding: 4px 0;
}

.gift-name {
  margin-bottom: 8px;
  overflow: hidden;
  text-overflow: ellipsis;
  font-size: 14px;
  font-weight: 500;
  color: #333;
  white-space: nowrap;
}

.gift-meta {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.gift-price {
  display: flex;
  gap: 2px;
  align-items: baseline;
}

.price-value {
  font-size: 20px;
  font-weight: bold;
  color: #ff6b00;
}

.price-unit {
  font-size: 12px;
  color: #ff6b00;
}

.gift-stock {
  font-size: 12px;
  color: #999;
}

:deep(.ant-card-cover) {
  margin: 0;
}

:deep(.ant-card-body) {
  padding: 12px !important;
}
</style>
