<script lang="ts" setup>
import type { FavoriteItem } from '#/api/lostfound/favorite';

import { onMounted, ref } from 'vue';
import { useRouter } from 'vue-router';

import { Page } from '@vben/common-ui';
import { useAppConfig } from '@vben/hooks';

import {
  Button,
  Card,
  Col,
  Empty,
  message,
  Modal,
  Pagination,
  Row,
  Spin,
  Tag,
} from 'ant-design-vue';

import { getMyFavorites, removeFavorite } from '#/api/lostfound/favorite';

const router = useRouter();
const { apiURL } = useAppConfig(import.meta.env, import.meta.env.PROD);
const loading = ref(false);
const favorites = ref<FavoriteItem[]>([]);
const total = ref(0);
const currentPage = ref(1);
const pageSize = ref(12);

// 状态配置
const statusConfig: Record<string, { color: string; label: string }> = {
  pending: { color: 'orange', label: '待审核' },
  approved: { color: 'blue', label: '已发布' },
  matched: { color: 'green', label: '已匹配' },
  closed: { color: 'default', label: '已结案' },
};

// 处理图片URL，将相对路径转换为完整URL
function getFullImageUrl(url: string | undefined): string {
  if (!url) return '';
  if (
    url.startsWith('http://') ||
    url.startsWith('https://') ||
    url.startsWith('data:')
  ) {
    return url;
  }
  if (url.startsWith('/uploads/')) {
    return `${apiURL}/file${url}`;
  }
  return `${apiURL}${url}`;
}

// 加载收藏列表
async function loadFavorites() {
  loading.value = true;
  try {
    const res = await getMyFavorites({
      pageNum: currentPage.value,
      pageSize: pageSize.value,
    });
    // 兼容 records 和 rows 两种返回格式
    const list = res.records || res.rows || [];
    // 转换数据格式，API直接返回帖子信息
    favorites.value = list.map((item: any) => {
      let images: string[] = [];
      if (Array.isArray(item.imagesJson)) {
        images = item.imagesJson as string[];
      } else if (typeof item.imagesJson === 'string' && item.imagesJson) {
        try {
          images = JSON.parse(item.imagesJson);
        } catch {
          images = [];
        }
      }
      const normalizedImages = images.filter(Boolean).map(getFullImageUrl);
      return {
        id: item.id,
        postId: item.id,
        createTime: item.createTime,
        post: {
          itemName: item.title,
          description: item.description,
          type: item.postType === 'LOST' ? 'lost' : 'found',
          status: item.status?.toLowerCase(),
          locationName: item.locationName,
          images: normalizedImages,
        },
      };
    });
    total.value = res.total || 0;
  } catch (error) {
    console.error('加载收藏列表失败:', error);
  } finally {
    loading.value = false;
  }
}

// 分页变化
function onPageChange(page: number, size: number) {
  currentPage.value = page;
  pageSize.value = size;
  loadFavorites();
}

// 查看详情
function viewDetail(postId: number) {
  router.push(`/lostfound/posts/${postId}`);
}

// 取消收藏
async function handleRemove(item: FavoriteItem) {
  Modal.confirm({
    title: '取消收藏',
    content: `确定取消收藏「${item.post?.itemName}」吗？`,
    async onOk() {
      try {
        await removeFavorite(item.postId);
        message.success('已取消收藏');
        loadFavorites();
      } catch {
        message.error('操作失败');
      }
    },
  });
}

// 格式化时间
function formatTime(time: string) {
  if (!time) return '';
  return time.slice(0, 10);
}

onMounted(() => {
  loadFavorites();
});
</script>

<template>
  <Page auto-content-height>
    <div class="p-4">
      <Card title="我的收藏">
        <Spin :spinning="loading">
          <div v-if="favorites.length > 0">
            <Row :gutter="[16, 16]">
              <Col
                v-for="item in favorites"
                :key="item.id"
                :xs="24"
                :sm="12"
                :md="8"
                :lg="6"
              >
                <Card hoverable class="h-full">
                  <template #cover>
                    <div
                      class="relative h-40 cursor-pointer overflow-hidden bg-gray-100"
                      @click="viewDetail(item.postId)"
                    >
                      <img
                        v-if="item.post?.images?.[0]"
                        :src="item.post.images[0]"
                        :alt="item.post?.itemName"
                        class="size-full object-cover"
                        loading="lazy"
                      />
                      <div
                        v-else
                        class="flex size-full items-center justify-center text-gray-400"
                      >
                        暂无图片
                      </div>
                      <Tag
                        :color="item.post?.type === 'lost' ? 'red' : 'green'"
                        class="absolute left-2 top-2"
                      >
                        {{ item.post?.type === 'lost' ? '寻物' : '招领' }}
                      </Tag>
                    </div>
                  </template>

                  <Card.Meta>
                    <template #title>
                      <div
                        class="cursor-pointer truncate text-base hover:text-blue-500"
                        @click="viewDetail(item.postId)"
                      >
                        {{ item.post?.itemName }}
                      </div>
                    </template>
                    <template #description>
                      <div class="space-y-1 text-sm">
                        <div class="truncate text-gray-500">
                          {{ item.post?.description || '暂无描述' }}
                        </div>
                        <div class="flex items-center justify-between">
                          <span class="text-gray-400">
                            {{ item.post?.locationName || '未知地点' }}
                          </span>
                          <Tag
                            :color="
                              statusConfig[item.post?.status || '']?.color
                            "
                            size="small"
                          >
                            {{ statusConfig[item.post?.status || '']?.label }}
                          </Tag>
                        </div>
                        <div class="flex items-center justify-between">
                          <span class="text-gray-400">
                            收藏于 {{ formatTime(item.createTime) }}
                          </span>
                          <Button
                            type="link"
                            size="small"
                            danger
                            @click.stop="handleRemove(item)"
                          >
                            取消收藏
                          </Button>
                        </div>
                      </div>
                    </template>
                  </Card.Meta>
                </Card>
              </Col>
            </Row>

            <div class="mt-6 flex justify-center">
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
          </div>

          <Empty v-else description="暂无收藏" class="py-20" />
        </Spin>
      </Card>
    </div>
  </Page>
</template>
