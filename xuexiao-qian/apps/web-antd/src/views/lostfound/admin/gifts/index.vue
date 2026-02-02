<script lang="ts" setup>
import type { UploadFile } from 'ant-design-vue';

import type { Gift, GiftCategory } from '#/api/lostfound/gifts';

import { computed, onMounted, ref } from 'vue';

import { Page } from '@vben/common-ui';
import { useAppConfig } from '@vben/hooks';
import { useAccessStore } from '@vben/stores';

import {
  Button,
  Card,
  Form,
  Image,
  Input,
  InputNumber,
  message,
  Modal,
  Popconfirm,
  Select,
  Space,
  Table,
  Tag,
  Upload,
} from 'ant-design-vue';

import {
  adminCreateGift,
  adminDeleteGift,
  adminGetCategoryList,
  adminGetGiftList,
  adminUpdateGift,
  adminUpdateGiftStatus,
} from '#/api/lostfound/giftAdmin';

const accessStore = useAccessStore();

// 获取API基础URL用于图片路径
const { apiURL } = useAppConfig(import.meta.env, import.meta.env.PROD);

// 上传配置
const uploadAction = computed(
  () => `${import.meta.env.VITE_GLOB_API_URL}/lostfound/upload/image`,
);
const uploadHeaders = computed(() => ({
  Authorization: accessStore.accessToken || '',
}));

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

const loading = ref(false);
const gifts = ref<Gift[]>([]);
const categories = ref<GiftCategory[]>([]);
const total = ref(0);
const currentPage = ref(1);
const pageSize = ref(10);

// 搜索条件
const searchForm = ref({
  categoryId: undefined as number | undefined,
  status: undefined as string | undefined,
  keyword: '',
});

// 编辑弹窗
const editModalVisible = ref(false);
const editLoading = ref(false);
const isEdit = ref(false);
const editForm = ref<Gift>({
  name: '',
  categoryId: undefined,
  description: '',
  imagesJson: [],
  pointsCost: 0,
  stock: 0,
  giftType: 'PHYSICAL',
  virtualContent: '',
  sort: 0,
});

// 图片上传文件列表
const fileList = ref<UploadFile[]>([]);

// 表格列
const columns = [
  {
    title: '图片',
    dataIndex: 'imagesJson',
    width: 80,
  },
  {
    title: '名称',
    dataIndex: 'name',
    ellipsis: true,
  },
  {
    title: '分类',
    dataIndex: 'categoryId',
    width: 100,
  },
  {
    title: '类型',
    dataIndex: 'giftType',
    width: 100,
  },
  {
    title: '积分',
    dataIndex: 'pointsCost',
    width: 80,
  },
  {
    title: '库存',
    dataIndex: 'stock',
    width: 80,
  },
  {
    title: '已兑换',
    dataIndex: 'exchangeCount',
    width: 80,
  },
  {
    title: '状态',
    dataIndex: 'status',
    width: 100,
  },
  {
    title: '操作',
    key: 'action',
    width: 180,
  },
];

// 加载分类
async function loadCategories() {
  try {
    const res = await adminGetCategoryList({ pageSize: 100 });
    categories.value = res.rows || [];
  } catch (error) {
    console.error('加载分类失败:', error);
  }
}

// 加载礼品列表
async function loadGifts() {
  loading.value = true;
  try {
    const res = await adminGetGiftList({
      pageNum: currentPage.value,
      pageSize: pageSize.value,
      ...searchForm.value,
    });
    gifts.value = res.rows || [];
    total.value = res.total || 0;
  } catch (error) {
    console.error('加载礼品失败:', error);
  } finally {
    loading.value = false;
  }
}

// 搜索
function handleSearch() {
  currentPage.value = 1;
  loadGifts();
}

// 重置
function handleReset() {
  searchForm.value = {
    categoryId: undefined,
    status: undefined,
    keyword: '',
  };
  handleSearch();
}

// 分页变化
function handleTableChange(pagination: any) {
  currentPage.value = pagination.current;
  pageSize.value = pagination.pageSize;
  loadGifts();
}

// 新增礼品
function handleAdd() {
  isEdit.value = false;
  editForm.value = {
    name: '',
    categoryId: undefined,
    description: '',
    imagesJson: [],
    pointsCost: 0,
    stock: 0,
    giftType: 'PHYSICAL',
    virtualContent: '',
    sort: 0,
  };
  fileList.value = [];
  editModalVisible.value = true;
}

// 编辑礼品
function handleEdit(record: Gift) {
  isEdit.value = true;
  editForm.value = { ...record };
  // 初始化文件列表
  fileList.value =
    record.imagesJson && record.imagesJson.length > 0
      ? record.imagesJson.map((url, index) => ({
          uid: `-${index}`,
          name: `image-${index}`,
          status: 'done',
          url: getFullImageUrl(url),
          response: { data: { url } },
        }))
      : [];
  editModalVisible.value = true;
}

// 图片上传处理
function handleUploadChange(info: any) {
  fileList.value = info.fileList;
  // 提取已上传成功的图片URL
  editForm.value.imagesJson = info.fileList
    .filter((f: UploadFile) => f.status === 'done')
    .map((f: UploadFile) => {
      // 优先使用response中的url，否则使用原有url
      if (f.response?.data?.url) {
        return f.response.data.url;
      }
      // 编辑时已有的图片
      if (f.url) {
        // 从完整URL中提取相对路径
        const url = f.url;
        if (url.includes('/file/uploads/')) {
          return url.slice(Math.max(0, url.indexOf('/uploads/')));
        }
        return url;
      }
      return null;
    })
    .filter(Boolean);
}

// 保存礼品
async function handleSave() {
  if (!editForm.value.name) {
    message.warning('请输入礼品名称');
    return;
  }
  if (!editForm.value.categoryId) {
    message.warning('请选择分类');
    return;
  }
  if (!editForm.value.pointsCost || editForm.value.pointsCost <= 0) {
    message.warning('请输入有效的积分');
    return;
  }

  editLoading.value = true;
  try {
    if (isEdit.value) {
      await adminUpdateGift(editForm.value.id!, editForm.value);
      message.success('更新成功');
    } else {
      await adminCreateGift(editForm.value);
      message.success('创建成功');
    }
    editModalVisible.value = false;
    loadGifts();
  } catch (error: any) {
    message.error(error.message || '操作失败');
  } finally {
    editLoading.value = false;
  }
}

// 上架/下架
async function handleStatusChange(record: Gift) {
  const newStatus = record.status === 'ON' ? 'OFF' : 'ON';
  try {
    await adminUpdateGiftStatus(record.id!, newStatus);
    message.success(newStatus === 'ON' ? '上架成功' : '下架成功');
    loadGifts();
  } catch (error: any) {
    message.error(error.message || '操作失败');
  }
}

// 删除礼品
async function handleDelete(id: number) {
  try {
    await adminDeleteGift(id);
    message.success('删除成功');
    loadGifts();
  } catch (error: any) {
    message.error(error.message || '删除失败');
  }
}

// 获取分类名称
function getCategoryName(categoryId: number) {
  const cat = categories.value.find((c) => c.id === categoryId);
  return cat?.name || '-';
}

// 获取礼品图片
function getGiftImage(images: string[]) {
  if (images && images.length > 0) {
    return getFullImageUrl(images[0]);
  }
  return '';
}

onMounted(() => {
  loadCategories();
  loadGifts();
});
</script>

<template>
  <Page auto-content-height>
    <div class="p-4">
      <Card title="礼品管理">
        <!-- 搜索栏 -->
        <div class="mb-4 flex flex-wrap items-center gap-4">
          <Input
            v-model:value="searchForm.keyword"
            placeholder="礼品名称"
            style="width: 200px"
            allow-clear
          />
          <Select
            v-model:value="searchForm.categoryId"
            placeholder="选择分类"
            style="width: 150px"
            allow-clear
          >
            <Select.Option
              v-for="cat in categories"
              :key="cat.id"
              :value="cat.id"
            >
              {{ cat.name }}
            </Select.Option>
          </Select>
          <Select
            v-model:value="searchForm.status"
            placeholder="状态"
            style="width: 120px"
            allow-clear
          >
            <Select.Option value="ON">上架</Select.Option>
            <Select.Option value="OFF">下架</Select.Option>
          </Select>
          <Button type="primary" @click="handleSearch">查询</Button>
          <Button @click="handleReset">重置</Button>
          <div class="flex-1"></div>
          <Button type="primary" @click="handleAdd">新增礼品</Button>
        </div>

        <!-- 表格 -->
        <Table
          :columns="columns"
          :data-source="gifts"
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
            <template v-if="column.dataIndex === 'imagesJson'">
              <Image
                v-if="getGiftImage(record.imagesJson)"
                :src="getGiftImage(record.imagesJson)"
                :width="50"
                :height="50"
                style="object-fit: cover"
              />
              <span v-else class="text-gray-400">无图</span>
            </template>
            <template v-else-if="column.dataIndex === 'categoryId'">
              {{ getCategoryName(record.categoryId) }}
            </template>
            <template v-else-if="column.dataIndex === 'giftType'">
              <Tag :color="record.giftType === 'PHYSICAL' ? 'blue' : 'purple'">
                {{ record.giftType === 'PHYSICAL' ? '实物' : '虚拟' }}
              </Tag>
            </template>
            <template v-else-if="column.dataIndex === 'status'">
              <Tag :color="record.status === 'ON' ? 'green' : 'default'">
                {{ record.status === 'ON' ? '上架' : '下架' }}
              </Tag>
            </template>
            <template v-else-if="column.key === 'action'">
              <Space>
                <Button type="link" size="small" @click="handleEdit(record)">
                  编辑
                </Button>
                <Button
                  type="link"
                  size="small"
                  @click="handleStatusChange(record)"
                >
                  {{ record.status === 'ON' ? '下架' : '上架' }}
                </Button>
                <Popconfirm
                  title="确定删除该礼品吗？"
                  @confirm="handleDelete(record.id)"
                >
                  <Button type="link" size="small" danger>删除</Button>
                </Popconfirm>
              </Space>
            </template>
          </template>
        </Table>
      </Card>

      <!-- 编辑弹窗 -->
      <Modal
        v-model:open="editModalVisible"
        :title="isEdit ? '编辑礼品' : '新增礼品'"
        :confirm-loading="editLoading"
        width="600px"
        @ok="handleSave"
      >
        <Form layout="vertical">
          <Form.Item label="礼品名称" required>
            <Input v-model:value="editForm.name" placeholder="请输入礼品名称" />
          </Form.Item>
          <Form.Item label="分类" required>
            <Select
              v-model:value="editForm.categoryId"
              placeholder="请选择分类"
            >
              <Select.Option
                v-for="cat in categories"
                :key="cat.id"
                :value="cat.id"
              >
                {{ cat.name }}
              </Select.Option>
            </Select>
          </Form.Item>
          <Form.Item label="礼品类型" required>
            <Select v-model:value="editForm.giftType">
              <Select.Option value="PHYSICAL">实物礼品</Select.Option>
              <Select.Option value="VIRTUAL">虚拟礼品</Select.Option>
            </Select>
          </Form.Item>
          <Form.Item label="所需积分" required>
            <InputNumber
              v-model:value="editForm.pointsCost"
              :min="1"
              style="width: 100%"
            />
          </Form.Item>
          <Form.Item label="库存数量" required>
            <InputNumber
              v-model:value="editForm.stock"
              :min="0"
              style="width: 100%"
            />
          </Form.Item>
          <Form.Item v-if="editForm.giftType === 'VIRTUAL'" label="虚拟内容">
            <Input.TextArea
              v-model:value="editForm.virtualContent"
              placeholder="如兑换码、链接等"
              :rows="3"
            />
          </Form.Item>
          <Form.Item label="礼品图片">
            <Upload
              v-model:file-list="fileList"
              :action="uploadAction"
              :headers="uploadHeaders"
              list-type="picture-card"
              :max-count="3"
              accept="image/*"
              @change="handleUploadChange"
            >
              <div v-if="fileList.length < 3">
                <div class="text-2xl">+</div>
                <div class="mt-2">上传图片</div>
              </div>
            </Upload>
            <div class="text-gray-400">最多上传3张图片，建议尺寸 400x300</div>
          </Form.Item>
          <Form.Item label="描述">
            <Input.TextArea
              v-model:value="editForm.description"
              placeholder="请输入礼品描述"
              :rows="3"
            />
          </Form.Item>
          <Form.Item label="排序">
            <InputNumber
              v-model:value="editForm.sort"
              :min="0"
              style="width: 100%"
            />
          </Form.Item>
        </Form>
      </Modal>
    </div>
  </Page>
</template>
