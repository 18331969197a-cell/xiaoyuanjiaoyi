<script lang="ts" setup>
import type { UploadFile } from 'ant-design-vue';

import type { BizPost } from '#/api/lostfound/post';

import { onMounted, ref } from 'vue';
import { useRoute, useRouter } from 'vue-router';

import { Page } from '@vben/common-ui';

import {
  Button,
  Card,
  Descriptions,
  DescriptionsItem,
  Form,
  FormItem,
  Image,
  Input,
  message,
  Tag,
  Upload,
} from 'ant-design-vue';

import { createClaim } from '#/api/lostfound/claim';
import { getPostById } from '#/api/lostfound/post';
import { parseImages } from '#/utils/lostfound';

// 扩展帖子详情类型
interface PostDetail extends BizPost {
  type?: string;
  itemName?: string;
  images?: string[];
  eventTime?: string;
}

const route = useRoute();
const router = useRouter();
const loading = ref(false);
const postLoading = ref(false);
const post = ref<null | PostDetail>(null);

// 表单数据
const formData = ref({
  postId: 0,
  description: '',
  featureAnswers: [] as string[],
  proofImages: [] as string[],
});

const featureAnswersInput = ref('');

const fileList = ref<UploadFile[]>([]);

// 表单规则
const rules = {
  description: [
    { required: true, message: '请描述您的认领理由' },
    { min: 20, message: '描述至少20个字符' },
  ],
};

const formRef = ref();

// 加载帖子信息
async function loadPost() {
  const postId = Number(route.query.postId);
  if (!postId) {
    message.error('缺少帖子ID');
    router.back();
    return;
  }

  formData.value.postId = postId;
  postLoading.value = true;
  try {
    const data = await getPostById(postId);
    // 转换数据格式并补全图片URL
    const images = parseImages(data.imagesJson as any);
    post.value = {
      ...data,
      type: data.postType === 'FOUND' ? 'found' : 'lost',
      itemName: data.title,
      images,
      eventTime: data.occurTime || data.lostTime || data.foundTime,
      status: data.status?.toLowerCase() || 'pending',
    } as PostDetail;
    if (post.value.type !== 'found') {
      message.error('只能认领招领信息');
      router.back();
    }
    if (post.value.status !== 'approved' && post.value.status !== 'published') {
      message.error('该帖子暂不可认领');
      router.back();
    }
  } catch {
    message.error('加载帖子信息失败');
    router.back();
  } finally {
    postLoading.value = false;
  }
}

// 图片上传处理
function handleUploadChange(info: any) {
  fileList.value = info.fileList;
  formData.value.proofImages = info.fileList
    .filter((f: UploadFile) => f.status === 'done' && f.response?.url)
    .map((f: UploadFile) => f.response.url);
}

function parseAnswers(input: string): string[] {
  return input
    .split(/[\n,，]/)
    .map((s) => s.trim())
    .filter(Boolean);
}

// 提交认领
async function handleSubmit() {
  try {
    await formRef.value.validate();
    loading.value = true;
    const payload = {
      ...formData.value,
      featureAnswers: parseAnswers(featureAnswersInput.value),
    };
    await createClaim(payload);
    message.success('认领申请已提交，请等待发布者审核');
    router.push('/lostfound/me/claims');
  } catch (error: any) {
    if (error.errorFields) {
      message.warning('请填写完整信息');
    } else {
      message.error('提交失败');
    }
  } finally {
    loading.value = false;
  }
}

// 返回
function goBack() {
  router.back();
}

// 格式化时间
function formatTime(time?: string) {
  if (!time) return '';
  return time.replace('T', ' ').slice(0, 16);
}

onMounted(() => {
  loadPost();
});
</script>

<template>
  <Page auto-content-height>
    <div class="mx-auto max-w-2xl p-4">
      <!-- 物品信息 -->
      <Card v-if="post" title="物品信息" class="mb-4" :loading="postLoading">
        <div class="flex gap-4">
          <div v-if="post.images?.[0]" class="shrink-0">
            <Image
              :src="post.images[0]"
              :width="120"
              :height="120"
              class="rounded object-cover"
            />
          </div>
          <div class="flex-1">
            <div class="mb-2 flex items-center gap-2">
              <Tag color="green">招领信息</Tag>
              <span class="text-lg font-medium">{{ post.itemName }}</span>
            </div>
            <Descriptions :column="1" size="small">
              <DescriptionsItem label="分类">
                {{ post.categoryName || '-' }}
              </DescriptionsItem>
              <DescriptionsItem label="拾取地点">
                {{ post.locationName || '-' }}
              </DescriptionsItem>
              <DescriptionsItem label="拾取时间">
                {{ formatTime(post.eventTime) || '-' }}
              </DescriptionsItem>
              <DescriptionsItem label="描述">
                {{ post.description || '-' }}
              </DescriptionsItem>
            </Descriptions>
          </div>
        </div>
      </Card>

      <!-- 认领表单 -->
      <Card title="填写认领信息">
        <Form ref="formRef" :model="formData" :rules="rules" layout="vertical">
          <FormItem label="认领说明" name="description">
            <Input.TextArea
              v-model:value="formData.description"
              placeholder="请详细描述您为什么认为这是您的物品，包括物品的特征、丢失时间地点等信息，以便发布者核实"
              :rows="5"
              :maxlength="1000"
              show-count
            />
          </FormItem>

          <FormItem label="佐证材料">
            <Upload
              v-model:file-list="fileList"
              action="/api/upload"
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
            <div class="text-gray-500">
              可上传购买凭证、使用照片等证明材料，最多6张
            </div>
          </FormItem>

          <FormItem label="补充特征（可选）">
            <Input.TextArea
              v-model:value="featureAnswersInput"
              placeholder="填写仅失主知道的特征，用于自动匹配校验。多条用逗号或换行分隔。"
              :rows="3"
              :maxlength="300"
              show-count
            />
          </FormItem>

          <FormItem>
            <div class="rounded bg-orange-50 p-3 text-sm text-orange-600">
              <p class="font-medium">温馨提示：</p>
              <ul class="mt-1 list-inside list-disc">
                <li>请如实填写认领信息，虚假认领将影响您的信誉</li>
                <li>发布者将根据您提供的信息进行核实</li>
                <li>认领成功后，请及时与发布者联系完成交接</li>
              </ul>
            </div>
          </FormItem>

          <FormItem>
            <div class="flex gap-2">
              <Button type="primary" :loading="loading" @click="handleSubmit">
                提交认领
              </Button>
              <Button @click="goBack">取消</Button>
            </div>
          </FormItem>
        </Form>
      </Card>
    </div>
  </Page>
</template>
