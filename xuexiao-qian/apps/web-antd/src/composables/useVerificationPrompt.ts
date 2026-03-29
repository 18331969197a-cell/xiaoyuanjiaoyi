import type { Router } from 'vue-router';

import { Modal } from 'ant-design-vue';

let activeVerificationPrompt: null | { destroy?: () => void } = null;
let promptVisible = false;

export function closeVerificationPrompt() {
  activeVerificationPrompt?.destroy?.();
  activeVerificationPrompt = null;
  promptVisible = false;
}

export function openVerificationPrompt(
  router: Router,
  options: {
    onCancel?: () => void;
  } = {},
) {
  if (promptVisible) {
    return activeVerificationPrompt;
  }

  promptVisible = true;
  activeVerificationPrompt = Modal.confirm({
    title: '需要身份认证',
    content: '发布失物招领信息前需要完成身份认证，是否前往认证？',
    okText: '去认证',
    cancelText: '返回',
    async onOk() {
      closeVerificationPrompt();
      await router.push('/lostfound/me/verification');
    },
    onCancel() {
      closeVerificationPrompt();
      options.onCancel?.();
    },
    afterClose() {
      activeVerificationPrompt = null;
      promptVisible = false;
    },
  });

  return activeVerificationPrompt;
}
