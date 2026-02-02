<script lang="ts" setup>
import type { UploadFile } from 'ant-design-vue';

import type { StudentRoster } from '#/api/lostfound/verificationAdmin';

import { onMounted, ref } from 'vue';

import { useAccess } from '@vben/access';
import { Page } from '@vben/common-ui';

import {
  Alert,
  Button,
  Card,
  Input,
  message,
  Modal,
  Pagination,
  Popconfirm,
  Space,
  Spin,
  Table,
  Tag,
  Upload,
} from 'ant-design-vue';

import {
  deleteStudentRoster,
  getStudentRosterList,
  importStudentRoster,
} from '#/api/lostfound/verificationAdmin';

const loading = ref(false);
const uploading = ref(false);
const students = ref<StudentRoster[]>([]);
const total = ref(0);
const currentPage = ref(1);
const pageSize = ref(10);
const { hasAccessByCodes } = useAccess();

// 搜索条件
const searchForm = ref({
  keyword: '',
});

// 导入弹窗
const importModalVisible = ref(false);
const fileList = ref<UploadFile[]>([]);

// 表格列
const columns = [
  { title: '学号', dataIndex: 'studentNo', width: 150 },
  { title: '姓名', dataIndex: 'realName', width: 100 },
  { title: '学院', dataIndex: 'college', ellipsis: true },
  { title: '专业', dataIndex: 'major', ellipsis: true },
  { title: '班级', dataIndex: 'className', width: 120 },
  { title: '入学年份', dataIndex: 'enrollmentYear', width: 100 },
  { title: '状态', dataIndex: 'status', width: 100 },
  { title: '操作', key: 'action', width: 100 },
];

// 加载学生名单
async function loadStudents() {
  loading.value = true;
  try {
    const res = await getStudentRosterList({
      pageNum: currentPage.value,
      pageSize: pageSize.value,
      ...searchForm.value,
    });
    students.value = res.rows || [];
    total.value = res.total || 0;
  } catch (error) {
    console.error('加载学生名单失败:', error);
  } finally {
    loading.value = false;
  }
}

// 搜索
function handleSearch() {
  currentPage.value = 1;
  loadStudents();
}

// 重置
function handleReset() {
  searchForm.value = { keyword: '' };
  handleSearch();
}

// 分页变化
function onPageChange(page: number, size: number) {
  currentPage.value = page;
  pageSize.value = size;
  loadStudents();
}

// 打开导入弹窗
function openImportModal() {
  fileList.value = [];
  importModalVisible.value = true;
}

// 文件上传前检查
function beforeUpload(file: File) {
  const isExcel = file.name.endsWith('.xlsx') || file.name.endsWith('.xls');
  if (!isExcel) {
    message.error('只能上传 Excel 文件！');
    return false;
  }
  return false; // 阻止自动上传
}

// 文件变化
function handleFileChange(info: any) {
  fileList.value = info.fileList.slice(-1); // 只保留最后一个文件
}

// 执行导入
async function handleImport() {
  if (fileList.value.length === 0) {
    message.warning('请选择要导入的文件');
    return;
  }
  uploading.value = true;
  try {
    const file = fileList.value[0]?.originFileObj;
    if (!file) {
      message.error('文件无效');
      return;
    }
    const result = await importStudentRoster(file);
    message.success(
      `导入成功！新增 ${result.insertCount} 条，更新 ${result.updateCount} 条`,
    );
    importModalVisible.value = false;
    loadStudents();
  } catch (error: any) {
    message.error(error.message || '导入失败');
  } finally {
    uploading.value = false;
  }
}

// 删除学生
async function handleDelete(id: number) {
  try {
    await deleteStudentRoster(id);
    message.success('删除成功');
    loadStudents();
  } catch (error: any) {
    message.error(error.message || '删除失败');
  }
}

onMounted(() => {
  loadStudents();
});
</script>

<template>
  <Page auto-content-height>
    <div class="p-4">
      <Card title="学生名单管理">
        <!-- 搜索栏 -->
        <div class="mb-4 flex flex-wrap items-center gap-4">
          <Input
            v-model:value="searchForm.keyword"
            placeholder="学号/姓名"
            style="width: 200px"
            allow-clear
          />
          <Button type="primary" @click="handleSearch">查询</Button>
          <Button @click="handleReset">重置</Button>
          <div class="flex-1"></div>
          <Button
            v-if="hasAccessByCodes(['lostfound:verification:import'])"
            type="primary"
            @click="openImportModal"
          >
            导入名单
          </Button>
        </div>

        <!-- 表格 -->
        <Spin :spinning="loading">
          <Table
            :columns="columns"
            :data-source="students"
            :pagination="false"
            row-key="id"
          >
            <template #bodyCell="{ column, record }">
              <template v-if="column.dataIndex === 'status'">
                <Tag :color="record.status === 0 ? 'green' : 'default'">
                  {{ record.status === 0 ? '正常' : '禁用' }}
                </Tag>
              </template>
              <template v-else-if="column.key === 'action'">
                <Popconfirm
                  v-if="hasAccessByCodes(['lostfound:verification:delete'])"
                  title="确定删除该学生信息吗？"
                  @confirm="handleDelete(record.id)"
                >
                  <Button type="link" size="small" danger>删除</Button>
                </Popconfirm>
                <span v-else class="text-gray-400">-</span>
              </template>
            </template>
          </Table>

          <div v-if="students.length > 0" class="mt-4 flex justify-end">
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
        </Spin>
      </Card>

      <!-- 导入弹窗 -->
      <Modal
        v-model:open="importModalVisible"
        title="导入学生名单"
        :confirm-loading="uploading"
        @ok="handleImport"
      >
        <Alert message="导入说明" type="info" show-icon class="mb-4">
          <template #description>
            <ul class="list-disc pl-4">
              <li>请上传 Excel 文件（.xlsx 或 .xls）</li>
              <li>必填列：学号、姓名、身份证后6位</li>
              <li>可选列：学院、专业、班级、入学年份</li>
              <li>已存在的学号将更新信息</li>
            </ul>
          </template>
        </Alert>

        <Upload
          :file-list="fileList"
          :before-upload="beforeUpload"
          :max-count="1"
          accept=".xlsx,.xls"
          @change="handleFileChange"
        >
          <Button>
            <Space>
              <span>选择文件</span>
            </Space>
          </Button>
        </Upload>
      </Modal>
    </div>
  </Page>
</template>
