<script lang="ts" setup>
import type { GiftCategory } from '#/api/lostfound/gifts';

import { onMounted, ref } from 'vue';

import { Page } from '@vben/common-ui';

import {
  Button,
  Card,
  Form,
  Input,
  InputNumber,
  message,
  Modal,
  Popconfirm,
  Space,
  Switch,
  Table,
  Tag,
} from 'ant-design-vue';

import {
  adminCreateCategory,
  adminDeleteCategory,
  adminGetCategoryList,
  adminUpdateCategory,
} from '#/api/lostfound/giftAdmin';

const loading = ref(false);
const categories = ref<GiftCategory[]>([]);
const total = ref(0);
const currentPage = ref(1);
const pageSize = ref(10);

// 编辑弹窗
const editModalVisible = ref(false);
const editLoading = ref(false);
const isEdit = ref(false);
const editForm = ref<GiftCategory>({
  name: '',
  sort: 0,
  status: 1,
});

// 表格列
const columns = [
  {
    title: '分类名称',
    dataIndex: 'name',
  },
  {
    title: '排序',
    dataIndex: 'sort',
    width: 100,
  },
  {
    title: '状态',
    dataIndex: 'status',
    width: 100,
  },
  {
    title: '创建时间',
    dataIndex: 'createdAt',
    width: 180,
  },
  {
    title: '操作',
    key: 'action',
    width: 150,
  },
];

// 加载分类列表
async function loadCategories() {
  loading.value = true;
  try {
    const res = await adminGetCategoryList({
      pageNum: currentPage.value,
      pageSize: pageSize.value,
    });
    categories.value = res.rows || [];
    total.value = res.total || 0;
  } catch (error) {
    console.error('加载分类失败:', error);
  } finally {
    loading.value = false;
  }
}

// 分页变化
function handleTableChange(pagination: any) {
  currentPage.value = pagination.current;
  pageSize.value = pagination.pageSize;
  loadCategories();
}

// 新增分类
function handleAdd() {
  isEdit.value = false;
  editForm.value = {
    name: '',
    sort: 0,
    status: 1,
  };
  editModalVisible.value = true;
}

// 编辑分类
function handleEdit(record: GiftCategory) {
  isEdit.value = true;
  editForm.value = { ...record };
  editModalVisible.value = true;
}

// 保存分类
async function handleSave() {
  if (!editForm.value.name) {
    message.warning('请输入分类名称');
    return;
  }

  editLoading.value = true;
  try {
    if (isEdit.value) {
      await adminUpdateCategory(editForm.value.id!, editForm.value);
      message.success('更新成功');
    } else {
      await adminCreateCategory(editForm.value);
      message.success('创建成功');
    }
    editModalVisible.value = false;
    loadCategories();
  } catch (error: any) {
    message.error(error.message || '操作失败');
  } finally {
    editLoading.value = false;
  }
}

// 删除分类
async function handleDelete(id: number) {
  try {
    await adminDeleteCategory(id);
    message.success('删除成功');
    loadCategories();
  } catch (error: any) {
    message.error(error.message || '删除失败，该分类下可能存在礼品');
  }
}

// 格式化时间
function formatTime(time: string) {
  if (!time) return '';
  return time.replace('T', ' ').slice(0, 16);
}

onMounted(() => {
  loadCategories();
});
</script>

<template>
  <Page auto-content-height>
    <div class="p-4">
      <Card title="礼品分类管理">
        <!-- 操作栏 -->
        <div class="mb-4">
          <Button type="primary" @click="handleAdd">新增分类</Button>
        </div>

        <!-- 表格 -->
        <Table
          :columns="columns"
          :data-source="categories"
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
            <template v-if="column.dataIndex === 'status'">
              <Tag :color="record.status === 1 ? 'green' : 'default'">
                {{ record.status === 1 ? '启用' : '禁用' }}
              </Tag>
            </template>
            <template v-else-if="column.dataIndex === 'createdAt'">
              {{ formatTime(record.createdAt) }}
            </template>
            <template v-else-if="column.key === 'action'">
              <Space>
                <Button type="link" size="small" @click="handleEdit(record)">
                  编辑
                </Button>
                <Popconfirm
                  title="确定删除该分类吗？"
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
        :title="isEdit ? '编辑分类' : '新增分类'"
        :confirm-loading="editLoading"
        @ok="handleSave"
      >
        <Form layout="vertical">
          <Form.Item label="分类名称" required>
            <Input v-model:value="editForm.name" placeholder="请输入分类名称" />
          </Form.Item>
          <Form.Item label="排序">
            <InputNumber
              v-model:value="editForm.sort"
              :min="0"
              style="width: 100%"
            />
          </Form.Item>
          <Form.Item label="状态">
            <Switch
              :checked="editForm.status === 1"
              checked-children="启用"
              un-checked-children="禁用"
              @change="
                (checked: boolean) => (editForm.status = checked ? 1 : 0)
              "
            />
          </Form.Item>
        </Form>
      </Modal>
    </div>
  </Page>
</template>
