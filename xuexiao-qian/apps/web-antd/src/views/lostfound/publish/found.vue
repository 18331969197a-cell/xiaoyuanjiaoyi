<script lang="ts" setup>
import { computed, onMounted, ref } from 'vue';
import { useRouter } from 'vue-router';

import { Page } from '@vben/common-ui';
import { useAccessStore } from '@vben/stores';

import {
  Button,
  Card,
  DatePicker,
  Form,
  FormItem,
  Input,
  message,
  Modal,
  Select,
  Upload,
} from 'ant-design-vue';
import type { UploadFile } from 'ant-design-vue';

import {
  getCategoryTree,
  getLocationTree,
  getPickupPoints,
} from '#/api/lostfound/base';
import { createPost, saveDraft } from '#/api/lostfound/post';
import type { PostCreateParams } from '#/api/lostfound/post';
import { getVerificationStatus } from '#/api/lostfound/verification';

const accessStore = useAccessStore();

// 上传配置
const uploadAction = computed(
  () => `${import.meta.env.VITE_GLOB_API_URL}/lostfound/upload/image`,
);
const uploadHeaders = computed(() => ({
  Authorization: accessStore.accessToken || '',
}));

const router = useRouter();
const formRef = ref();
const loading = ref(false);
const savingDraft = ref(false);
const checkingVerification = ref(true);
const isVerified = ref(false);

// 表单数据
const formData = ref<PostCreateParams>({
  postType: 'FOUND',
  title: '',
  categoryId: undefined,
  locationId: undefined,
  occurTime: '',
  description: '',
  imagesJson: [],
  storagePlace: '',
  contactInfo: '',
  rewardAmount: undefined,
  rewardDesc: '',
  featureTokens: [],
});

const featureTokensInput = ref('');

// 选项数据
const categoryOptions = ref<any[]>([]);
const locationOptions = ref<any[]>([]);
const pickupPoints = ref<any[]>([]);
const fileList = ref<UploadFile[]>([]);

// 表单规则（增强版）
const rules = {
  title: [
    { required: true, message: '请输入物品名称' },
    { min: 2, max: 50, message: '物品名称长度应在2-50个字符之间' },
  ],
  categoryId: [{ required: true, message: '请选择物品分类' }],
  locationId: [{ required: true, message: '请选择拾取地点' }],
  occurTime: [{ required: true, message: '请选择拾取时间' }],
  description: [
    { required: true, message: '请输入物品描述' },
    { min: 10, max: 1000, message: '物品描述长度应在10-1000个字符之间' },
  ],
  storagePlace: [{ max: 200, message: '存放地点不能超过200个字符' }],
  contactInfo: [{ max: 100, message: '联系方式不能超过100个字符' }],
  rewardAmount: [
    {
      type: 'number',
      transform: (value: any) =>
        value === '' || value === null ? undefined : Number(value),
      min: 0,
      message: '悬赏金额需为非负数字',
    },
  ],
};

// 检查认证状态
async function checkVerification() {
  checkingVerification.value = true;
  try {
    const status = await getVerificationStatus();
    isVerified.value = status.verified;
    if (!status.verified) {
      showVerificationModal();
    }
  } catch (error) {
    console.error('检查认证状态失败:', error);
    isVerified.value = false;
    showVerificationModal();
  } finally {
    checkingVerification.value = false;
  }
}

// 显示认证提示弹窗
function showVerificationModal() {
  Modal.confirm({
    title: '需要身份认证',
    content: '发布失物招领信息前需要完成身份认证，是否前往认证？',
    okText: '去认证',
    cancelText: '返回',
    onOk() {
      router.push('/lostfound/me/verification');
    },
    onCancel() {
      router.back();
    },
  });
}

// 加载选项
async function loadOptions() {
  try {
    const [categories, locations, points] = await Promise.all([
      getCategoryTree(),
      getLocationTree(),
      getPickupPoints(),
    ]);
    categoryOptions.value = flattenTree(categories, 'categoryName');
    locationOptions.value = flattenTree(locations, 'locationName');
    pickupPoints.value = points.map((p: any) => ({
      value: p.id,
      label: p.locationName,
    }));
  } catch (error) {
    console.error('加载选项失败:', error);
  }
}

function flattenTree(
  tree: any[],
  labelField: string,
  result: any[] = [],
): any[] {
  for (const node of tree) {
    result.push({ value: node.id, label: node.name || node[labelField] });
    if (node.children?.length) {
      flattenTree(node.children, labelField, result);
    }
  }
  return result;
}

// 图片上传处理
function handleUploadChange(info: any) {
  fileList.value = info.fileList;
  // 提取已上传成功的图片URL
  formData.value.imagesJson = info.fileList
    .filter((f: UploadFile) => f.status === 'done' && f.response?.data?.url)
    .map((f: UploadFile) => f.response.data.url);
}

// 日期变化
function onDateChange(date: any, dateString: string) {
  formData.value.occurTime = dateString;
}

function parseFeatureTokens(input: string): string[] {
  return input
    .split(/[\n,，]/)
    .map((s) => s.trim())
    .filter(Boolean);
}

function buildPayload(): PostCreateParams {
  const rawReward = formData.value.rewardAmount;
  const rewardAmount =
    rawReward !== undefined && rawReward !== null && rawReward !== ''
      ? Number(rawReward)
      : undefined;
  return {
    ...formData.value,
    rewardAmount,
    featureTokens: parseFeatureTokens(featureTokensInput.value),
  };
}

// 提交发布
async function handleSubmit() {
  if (!isVerified.value) {
    showVerificationModal();
    return;
  }
  try {
    await formRef.value.validate();
    loading.value = true;
    await createPost(buildPayload());
    message.success('发布成功，等待审核');
    router.push('/lostfound/me/posts');
  } catch (error: any) {
    if (error.errorFields) {
      message.warning('请填写完整信息');
    } else if (error.message?.includes('认证')) {
      showVerificationModal();
    } else {
      message.error('发布失败');
    }
  } finally {
    loading.value = false;
  }
}

// 保存草稿
async function handleSaveDraft() {
  savingDraft.value = true;
  try {
    await saveDraft(buildPayload());
    message.success('草稿已保存');
  } catch (error) {
    message.error('保存失败');
  } finally {
    savingDraft.value = false;
  }
}

// 返回
function goBack() {
  router.back();
}

onMounted(() => {
  checkVerification();
  loadOptions();
});
</script>

<template>
  <Page auto-content-height>
    <div class="mx-auto max-w-2xl p-4">
      <Card title="发布招领信息">
        <Form ref="formRef" :model="formData" :rules="rules" layout="vertical">
          <FormItem label="物品名称" name="title">
            <Input
              v-model:value="formData.title"
              placeholder="请输入拾取物品名称"
              :maxlength="50"
              show-count
            />
          </FormItem>

          <FormItem label="物品分类" name="categoryId">
            <Select
              v-model:value="formData.categoryId"
              placeholder="请选择物品分类"
              :options="categoryOptions"
              show-search
              :filter-option="
                (input: string, option: any) =>
                  option.label.toLowerCase().includes(input.toLowerCase())
              "
            />
          </FormItem>

          <FormItem label="拾取地点" name="locationId">
            <Select
              v-model:value="formData.locationId"
              placeholder="请选择拾取地点"
              :options="locationOptions"
              show-search
              :filter-option="
                (input: string, option: any) =>
                  option.label.toLowerCase().includes(input.toLowerCase())
              "
            />
          </FormItem>

          <FormItem label="拾取时间" name="occurTime">
            <DatePicker
              style="width: 100%"
              show-time
              placeholder="请选择拾取时间"
              format="YYYY-MM-DD HH:mm"
              @change="onDateChange"
            />
          </FormItem>

          <FormItem label="物品描述" name="description">
            <Input.TextArea
              v-model:value="formData.description"
              placeholder="请详细描述物品特征，如颜色、品牌、型号等，便于失主识别"
              :rows="4"
              :maxlength="1000"
              show-count
            />
          </FormItem>

          <FormItem label="物品图片">
            <Upload
              v-model:file-list="fileList"
              :action="uploadAction"
              :headers="uploadHeaders"
              list-type="picture-card"
              :max-count="6"
              accept="image/*"
              @change="handleUploadChange"
            >
              <div v-if="fileList.length < 6">
                <div class="text-2xl">+</div>
                <div class="mt-2">上传图片</div>
              </div>
            </Upload>
            <div class="text-gray-400">最多上传6张图片</div>
          </FormItem>

          <FormItem label="暂存地点">
            <Select
              v-model:value="formData.storagePlace"
              placeholder="请选择物品暂存地点（可选）"
              :options="pickupPoints"
              allow-clear
            />
            <div class="mt-1 text-sm text-gray-500">
              选择官方招领点可获得额外积分奖励
            </div>
          </FormItem>

          <FormItem label="联系方式">
            <Input
              v-model:value="formData.contactInfo"
              placeholder="可选，留下您的联系方式（手机号/微信等）"
              :maxlength="100"
            />
            <div class="mt-1 text-sm text-orange-500">
              提示：联系方式将公开显示，请注意隐私保护
            </div>
          </FormItem>

          <FormItem label="悬赏金额（可选）" name="rewardAmount">
            <Input
              v-model:value="formData.rewardAmount"
              type="number"
              min="0"
              placeholder="如需提高找回效率，可设置悬赏金额"
            />
            <div class="mt-1 text-sm text-gray-500">
              金额为可选项，发布时托管，确认认领后发放
            </div>
          </FormItem>

          <FormItem label="部分特征（可选）">
            <Input.TextArea
              v-model:value="featureTokensInput"
              placeholder="填写部分关键特征，用于匹配认领。多条可用逗号或换行分隔。"
              :rows="3"
              :maxlength="300"
              show-count
            />
          </FormItem>

          <FormItem>
            <div class="flex gap-2">
              <Button type="primary" :loading="loading" @click="handleSubmit">
                提交发布
              </Button>
              <Button :loading="savingDraft" @click="handleSaveDraft">
                保存草稿
              </Button>
              <Button @click="goBack">取消</Button>
            </div>
          </FormItem>
        </Form>
      </Card>
    </div>
  </Page>
</template>
