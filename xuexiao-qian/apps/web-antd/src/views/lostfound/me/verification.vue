<script lang="ts" setup>
import type {
  VerificationRequest,
  VerificationStatus,
} from '#/api/lostfound/verification';

import { onMounted, ref } from 'vue';

import { Page } from '@vben/common-ui';

import {
  Alert,
  Button,
  Card,
  Descriptions,
  Form,
  FormItem,
  Input,
  message,
  Result,
  Spin,
  Tag,
} from 'ant-design-vue';

import {
  getVerificationStatus,
  submitVerification,
} from '#/api/lostfound/verification';

const loading = ref(false);
const submitting = ref(false);
const formRef = ref();
const verificationStatus = ref<null | VerificationStatus>(null);

// 表单数据
const formData = ref<VerificationRequest>({
  studentNo: '',
  realName: '',
  idCardSuffix: '',
});

// 表单规则
const rules = {
  studentNo: [{ required: true, message: '请输入学号' }],
  realName: [{ required: true, message: '请输入真实姓名' }],
  idCardSuffix: [
    { required: true, message: '请输入身份证后6位' },
    { len: 6, message: '身份证后6位必须是6位' },
  ],
};

// 加载认证状态
async function loadStatus() {
  loading.value = true;
  try {
    verificationStatus.value = await getVerificationStatus();
  } catch (error) {
    console.error('加载认证状态失败:', error);
  } finally {
    loading.value = false;
  }
}

// 提交认证
async function handleSubmit() {
  try {
    await formRef.value.validate();
    submitting.value = true;
    const result = await submitVerification(formData.value);
    if (result.verified) {
      message.success('身份认证成功！');
      verificationStatus.value = result;
    } else {
      message.error(result.message || '认证失败');
    }
  } catch (error: any) {
    if (error.errorFields) {
      message.warning('请填写完整信息');
    } else {
      message.error(error.message || '认证失败，请检查信息是否正确');
    }
  } finally {
    submitting.value = false;
  }
}

// 格式化时间
function formatTime(time: string) {
  if (!time) return '';
  return time.replace('T', ' ').slice(0, 16);
}

onMounted(() => {
  loadStatus();
});
</script>

<template>
  <Page auto-content-height>
    <div class="p-4">
      <Card title="身份认证">
        <Spin :spinning="loading">
          <!-- 已认证状态 -->
          <template v-if="verificationStatus?.verified">
            <Result
              status="success"
              title="身份认证已完成"
              sub-title="您已通过校园身份认证，可以正常使用平台功能"
            >
              <template #extra>
                <Descriptions :column="2" bordered class="mt-4">
                  <Descriptions.Item label="学号">
                    {{ verificationStatus.studentNo }}
                  </Descriptions.Item>
                  <Descriptions.Item label="姓名">
                    {{ verificationStatus.realName }}
                  </Descriptions.Item>
                  <Descriptions.Item
                    v-if="verificationStatus.college"
                    label="学院"
                  >
                    {{ verificationStatus.college }}
                  </Descriptions.Item>
                  <Descriptions.Item
                    v-if="verificationStatus.major"
                    label="专业"
                  >
                    {{ verificationStatus.major }}
                  </Descriptions.Item>
                  <Descriptions.Item
                    v-if="verificationStatus.className"
                    label="班级"
                  >
                    {{ verificationStatus.className }}
                  </Descriptions.Item>
                  <Descriptions.Item label="认证状态">
                    <Tag color="green">已认证</Tag>
                  </Descriptions.Item>
                  <Descriptions.Item label="认证时间" :span="2">
                    {{ formatTime(verificationStatus.verifiedTime!) }}
                  </Descriptions.Item>
                </Descriptions>
              </template>
            </Result>
          </template>

          <!-- 未认证状态 -->
          <template v-else>
            <Alert
              message="身份认证说明"
              description="为确保平台信息的真实性，发布失物或招领信息前需要完成身份认证。请填写您的学号、真实姓名和身份证后6位进行认证。"
              type="info"
              show-icon
              class="mb-6"
            />

            <div class="mx-auto max-w-md">
              <Form
                ref="formRef"
                :model="formData"
                :rules="rules"
                layout="vertical"
              >
                <FormItem label="学号" name="studentNo">
                  <Input
                    v-model:value="formData.studentNo"
                    placeholder="请输入您的学号"
                  />
                </FormItem>

                <FormItem label="真实姓名" name="realName">
                  <Input
                    v-model:value="formData.realName"
                    placeholder="请输入您的真实姓名"
                  />
                </FormItem>

                <FormItem label="身份证后6位" name="idCardSuffix">
                  <Input
                    v-model:value="formData.idCardSuffix"
                    placeholder="请输入身份证后6位"
                    :maxlength="6"
                  />
                </FormItem>

                <FormItem>
                  <Button
                    type="primary"
                    block
                    :loading="submitting"
                    @click="handleSubmit"
                  >
                    提交认证
                  </Button>
                </FormItem>
              </Form>
            </div>

            <Alert message="温馨提示" type="warning" show-icon class="mt-4">
              <template #description>
                <ul class="list-disc pl-4">
                  <li>请确保填写的信息与学校登记信息一致</li>
                  <li>身份证后6位将加密存储，请放心填写</li>
                  <li>每个学号只能绑定一个账号</li>
                  <li>如有问题请联系管理员</li>
                </ul>
              </template>
            </Alert>
          </template>
        </Spin>
      </Card>
    </div>
  </Page>
</template>
