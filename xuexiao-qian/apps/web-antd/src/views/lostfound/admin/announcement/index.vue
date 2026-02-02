<script lang="ts" setup>
import { ref } from 'vue';

import { Page } from '@vben/common-ui';

import {
  Button,
  Card,
  Checkbox,
  Form,
  FormItem,
  Input,
  message,
  Textarea,
} from 'ant-design-vue';

import { publishAnnouncement } from '#/api/lostfound/announcement';

const formRef = ref();
const loading = ref(false);

const formState = ref({
  title: '',
  content: '',
  onlyVerified: false,
});

const rules = {
  title: [
    { required: true, message: '请输入公告标题' },
    { max: 100, message: '标题不能超过100个字符' },
  ],
  content: [
    { required: true, message: '请输入公告内容' },
    { max: 1000, message: '内容不能超过1000个字符' },
  ],
};

async function handleSubmit() {
  try {
    await formRef.value?.validate();
    loading.value = true;
    await publishAnnouncement({
      title: formState.value.title,
      content: formState.value.content,
      onlyVerified: formState.value.onlyVerified,
    });
    message.success('公告发布成功');
    // 重置表单
    formState.value = {
      title: '',
      content: '',
      onlyVerified: false,
    };
  } catch (error: any) {
    if (error?.errorFields) {
      // 表单验证错误
      return;
    }
    message.error('发布失败');
  } finally {
    loading.value = false;
  }
}

function handleReset() {
  formState.value = {
    title: '',
    content: '',
    onlyVerified: false,
  };
  formRef.value?.resetFields();
}
</script>

<template>
  <Page auto-content-height>
    <div class="p-4">
      <Card title="发布系统公告">
        <Form
          ref="formRef"
          :model="formState"
          :rules="rules"
          :label-col="{ span: 4 }"
          :wrapper-col="{ span: 16 }"
        >
          <FormItem label="公告标题" name="title">
            <Input
              v-model:value="formState.title"
              placeholder="请输入公告标题"
              :maxlength="100"
              show-count
            />
          </FormItem>

          <FormItem label="公告内容" name="content">
            <Textarea
              v-model:value="formState.content"
              placeholder="请输入公告内容"
              :rows="6"
              :maxlength="1000"
              show-count
            />
          </FormItem>

          <FormItem label="目标用户" name="onlyVerified">
            <Checkbox v-model:checked="formState.onlyVerified">
              仅发送给已认证用户
            </Checkbox>
            <div class="mt-1 text-xs text-gray-400">不勾选则发送给所有用户</div>
          </FormItem>

          <FormItem :wrapper-col="{ offset: 4, span: 16 }">
            <div class="flex gap-4">
              <Button type="primary" :loading="loading" @click="handleSubmit">
                发布公告
              </Button>
              <Button @click="handleReset">重置</Button>
            </div>
          </FormItem>
        </Form>
      </Card>
    </div>
  </Page>
</template>
