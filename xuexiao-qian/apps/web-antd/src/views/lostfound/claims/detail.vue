<script lang="ts" setup>
import type { BizClaim } from '#/api/lostfound/claim';
import type { BizHandover } from '#/api/lostfound/handover';

import { computed, onMounted, ref } from 'vue';
import { useRoute, useRouter } from 'vue-router';

import { Page } from '@vben/common-ui';
import { useUserStore } from '@vben/stores';

import {
  Avatar,
  Button,
  Card,
  DatePicker,
  Descriptions,
  DescriptionsItem,
  Image,
  ImagePreviewGroup,
  Input,
  message,
  Modal,
  Spin,
  Steps,
  Tag,
  Upload,
} from 'ant-design-vue';
import dayjs from 'dayjs';

import {
  appendProof,
  approveClaim,
  cancelClaim,
  confirmRewardPaid,
  getClaimById,
  refundReward,
  rejectClaim,
} from '#/api/lostfound/claim';
import { createEvaluation } from '#/api/lostfound/evaluation';
import {
  cancelHandover,
  confirmHandover,
  confirmHandoverReceipt,
  createHandover,
  disputeHandover,
  getHandoverByClaimId,
  markHandoverNoShow,
  rescheduleHandover,
  submitHandoverReceipt,
} from '#/api/lostfound/handover';
import { getPostById } from '#/api/lostfound/post';
import { parseImages } from '#/utils/lostfound';

// 扩展认领详情类型
interface ClaimDetail extends BizClaim {
  isPublisher?: boolean;
  isClaimer?: boolean;
  hasEvaluated?: boolean;
  proofImages?: string[];
  description?: string;
  featureAnswers?: string[];
  post?: {
    description?: string;
    eventTime?: string;
    images?: string[];
    itemName?: string;
    locationName?: string;
    rewardAmount?: number;
    rewardStatus?: string;
  };
  handover?: BizHandover & {
    claimerConfirmed?: boolean;
    location?: string;
    publisherConfirmed?: boolean;
    scheduledTime?: string;
  };
  publisher?: {
    avatar?: string;
    nickname?: string;
  };
  claimer?: {
    avatar?: string;
    nickname?: string;
  };
}

const route = useRoute();
const router = useRouter();
const userStore = useUserStore();
const loading = ref(false);
const claim = ref<ClaimDetail | null>(null);

// 操作状态
const actionLoading = ref(false);
const rejectVisible = ref(false);
const rejectReason = ref('');
const handoverVisible = ref(false);
const handoverLocation = ref('');
const handoverTime = ref<dayjs.Dayjs | undefined>(undefined);
const receiptVisible = ref(false);
const receiptActualTime = ref<dayjs.Dayjs | undefined>(undefined);
const receiptLocation = ref('');
const receiptRemark = ref('');
const receiptFileList = ref<any[]>([]);
const receiptImages = ref<string[]>([]);
const rescheduleVisible = ref(false);
const rescheduleTime = ref<dayjs.Dayjs | undefined>(undefined);
const rescheduleLocation = ref('');
const rescheduleReason = ref('');
const disputeVisible = ref(false);
const disputeReason = ref('');
const noShowVisible = ref(false);
const noShowReason = ref('');
const evaluateVisible = ref(false);
const evaluateScore = ref(5);
const evaluateContent = ref('');
const appendVisible = ref(false);
const appendText = ref('');
const appendFileList = ref<any[]>([]);
const appendImages = ref<string[]>([]);

// 状态配置 - 兼容后端返回的大写状态和前端小写状态
const statusConfig: Record<
  string,
  { color: string; label: string; step: number }
> = {
  pending: { color: 'orange', label: '待审核', step: 0 },
  applied: { color: 'orange', label: '待审核', step: 0 }, // 后端返回APPLIED
  need_proof: { color: 'orange', label: '需补充佐证', step: 0 },
  approved: { color: 'blue', label: '已通过', step: 1 },
  rejected: { color: 'red', label: '已拒绝', step: -1 },
  handover: { color: 'cyan', label: '交接中', step: 2 },
  in_handover: { color: 'cyan', label: '交接中', step: 2 }, // 后端可能返回IN_HANDOVER
  completed: { color: 'green', label: '已完成', step: 3 },
  cancelled: { color: 'default', label: '已取消', step: -1 },
};

// 当前步骤
const currentStep = computed(() => {
  if (!claim.value?.status) return 0;
  return statusConfig[claim.value.status]?.step || 0;
});

// 是否是发布者 - 通过比较当前用户ID和posterId判断
const isPublisher = computed(() => {
  if (!claim.value || !userStore.userInfo?.userId) return false;
  // 后端返回的posterId可能是字符串或数字，统一转换比较
  const posterId = claim.value.posterId || (claim.value as any).ownerId;
  return String(posterId) === String(userStore.userInfo.userId);
});

// 是否是认领者 - 通过比较当前用户ID和claimantId判断
const isClaimer = computed(() => {
  if (!claim.value || !userStore.userInfo?.userId) return false;
  const claimantId = claim.value.claimantId || (claim.value as any).claimerId;
  return String(claimantId) === String(userStore.userInfo.userId);
});

const rewardStatusLabel: Record<string, string> = {
  HOLD: '托管中',
  PAID: '已发放',
  REFUND: '已退款',
  NONE: '无悬赏',
};

const handoverStatusConfig: Record<string, { color: string; label: string }> = {
  PENDING: { color: 'blue', label: '待确认' },
  RESCHEDULED: { color: 'gold', label: '已改约' },
  NO_SHOW: { color: 'orange', label: '爽约待处理' },
  DISPUTED: { color: 'red', label: '争议处理中' },
  CONFIRMED: { color: 'green', label: '已完成' },
  CANCELLED: { color: 'default', label: '已取消' },
};

const canHandleReward = computed(() => {
  if (!isPublisher.value || claim.value?.status !== 'completed') return false;
  const rewardAmount = claim.value?.post?.rewardAmount || 0;
  if (rewardAmount <= 0) return false;
  const rewardStatus = (claim.value?.post?.rewardStatus || '').toUpperCase();
  return rewardStatus === 'HOLD';
});

const currentUserId = computed(() => String(userStore.userInfo?.userId || ''));

const handoverStatus = computed(() => claim.value?.handover?.status || '');

const isInHandoverPhase = computed(
  () => claim.value?.status === 'handover' || claim.value?.status === 'in_handover',
);

const canDirectConfirmHandover = computed(() => {
  if (!isInHandoverPhase.value || !claim.value?.handover) return false;
  const handover = claim.value.handover;
  if (!['PENDING', 'RESCHEDULED', 'NO_SHOW'].includes(handover.status || '')) {
    return false;
  }
  if (isPublisher.value) {
    return !handover.confirmedByFromAt;
  }
  if (isClaimer.value) {
    return !handover.confirmedByToAt;
  }
  return false;
});

const canCancelHandoverAction = computed(() => {
  if (!isInHandoverPhase.value || !claim.value?.handover) return false;
  return !['CANCELLED', 'CONFIRMED'].includes(claim.value.handover.status || '');
});

const canSubmitReceipt = computed(() => {
  if (!isInHandoverPhase.value || !claim.value?.handover) return false;
  const handover = claim.value.handover;
  if (!['PENDING', 'RESCHEDULED', 'NO_SHOW'].includes(handover.status || '')) {
    return false;
  }
  const submitter = handover.receiptSubmittedBy
    ? String(handover.receiptSubmittedBy)
    : '';
  return !submitter || submitter === currentUserId.value;
});

const canConfirmReceipt = computed(() => {
  if (!isInHandoverPhase.value || !claim.value?.handover) return false;
  const handover = claim.value.handover;
  if (!['PENDING', 'RESCHEDULED', 'NO_SHOW'].includes(handover.status || '')) {
    return false;
  }
  if (!handover.receiptSubmittedBy || handover.receiptConfirmedBy) return false;
  return String(handover.receiptSubmittedBy) !== currentUserId.value;
});

const canReschedule = computed(() => {
  if (!isInHandoverPhase.value || !claim.value?.handover) return false;
  return !['CANCELLED', 'CONFIRMED', 'DISPUTED'].includes(
    claim.value.handover.status || '',
  );
});

const canRaiseDispute = computed(() => {
  if (!isInHandoverPhase.value || !claim.value?.handover) return false;
  return !['CANCELLED', 'CONFIRMED', 'DISPUTED'].includes(
    claim.value.handover.status || '',
  );
});

const canMarkNoShow = computed(() => {
  if (!isInHandoverPhase.value || !claim.value?.handover) return false;
  return !['CANCELLED', 'CONFIRMED'].includes(claim.value.handover.status || '');
});

function normalizeFeatureAnswers(value?: unknown): string[] {
  if (!value) return [];
  if (Array.isArray(value)) return value.filter(Boolean).map(String);
  if (typeof value === 'string') {
    try {
      const parsed = JSON.parse(value);
      if (Array.isArray(parsed)) {
        return parsed.filter(Boolean).map(String);
      }
    } catch {
      // ignore parse error
    }
    return value
      .split(/[;；,，、\n]/)
      .map((item) => item.trim())
      .filter(Boolean);
  }
  return [];
}

function normalizeEvidence(value?: unknown): string[] {
  if (!value) return [];
  if (Array.isArray(value)) return value.filter(Boolean).map(String);
  if (typeof value === 'string') {
    try {
      const parsed = JSON.parse(value);
      if (Array.isArray(parsed)) {
        return parsed.filter(Boolean).map(String);
      }
    } catch {
      return [];
    }
  }
  return [];
}

function formatScore(score?: number) {
  if (typeof score !== 'number') return '-';
  const fixed = Math.round(score);
  if (fixed >= 0 && fixed <= 100) return `${fixed}%`;
  return `${fixed}`;
}

function scoreColor(score?: number) {
  if (typeof score !== 'number') return 'default';
  if (score >= 80) return 'green';
  if (score >= 60) return 'blue';
  if (score >= 40) return 'orange';
  return 'red';
}

function handleAppendUploadChange(info: any) {
  appendFileList.value = info.fileList || [];
  appendImages.value = appendFileList.value
    .filter((f) => f.status === 'done' && f.response?.url)
    .map((f) => f.response.url);
}

function handleReceiptUploadChange(info: any) {
  receiptFileList.value = info.fileList || [];
  receiptImages.value = receiptFileList.value
    .filter((f) => f.status === 'done' && f.response?.url)
    .map((f) => f.response.url);
}

function showAppendModal() {
  appendVisible.value = true;
  appendText.value = '';
  appendFileList.value = [];
  appendImages.value = [];
}

async function handleAppendProof() {
  if (!claim.value?.id) return;
  if (!appendText.value.trim() && appendImages.value.length === 0) {
    message.warning('请填写补充说明或上传图片');
    return;
  }
  actionLoading.value = true;
  try {
    await appendProof(claim.value.id, {
      proofText: appendText.value.trim() || undefined,
      proofImagesJson:
        appendImages.value.length > 0
          ? JSON.stringify(appendImages.value)
          : undefined,
    });
    message.success('补充佐证已提交');
    appendVisible.value = false;
    loadClaim();
  } catch {
    message.error('提交失败');
  } finally {
    actionLoading.value = false;
  }
}

// 加载认领详情
async function loadClaim() {
  const id = Number(route.params.id);
  if (!id) return;

  loading.value = true;
  try {
    const data = await getClaimById(id);
    // 转换数据格式
    const claimData: ClaimDetail = {
      ...data,
      status: data.status?.toLowerCase() || 'pending',
      proofImages: Array.isArray(data.proofImagesJson)
        ? data.proofImagesJson
        : (data.proofImagesJson
          ? JSON.parse(data.proofImagesJson)
          : []),
      featureAnswers: normalizeFeatureAnswers((data as any).featureAnswers),
    };

    // 加载帖子详情
    if (data.postId) {
      try {
        const postData = await getPostById(data.postId);
        if (postData) {
          claimData.post = {
            itemName: postData.title,
            description: postData.description,
            locationName: postData.locationName,
            eventTime:
              postData.occurTime || postData.lostTime || postData.foundTime,
            rewardAmount: postData.rewardAmount,
            rewardStatus: postData.rewardStatus,
            images: parseImages(postData.imagesJson as any),
          };
        }
      } catch {
        // 帖子可能已删除，忽略错误
      }
    }

    // 尝试加载交接信息
    try {
      const handoverData = await getHandoverByClaimId(id);
      if (handoverData) {
        handoverData.receiptEvidenceJson = normalizeEvidence(
          handoverData.receiptEvidenceJson as any,
        );
        claimData.handover = handoverData;
        // 如果有交接记录且状态还是approved，更新为handover状态
        if (
          claimData.status === 'approved' &&
          handoverData.status &&
          handoverData.status !== 'CANCELLED'
        ) {
          claimData.status = 'handover';
        }
      }
    } catch {
      // 没有交接记录，忽略错误
    }

    // 设置双方信息
    claimData.publisher = {
      nickname: data.posterName || '发布者',
    };
    claimData.claimer = {
      nickname: data.claimantName || '认领者',
    };

    claim.value = claimData;
  } catch {
    message.error('加载失败');
  } finally {
    loading.value = false;
  }
}

// 通过认领
async function handleApprove() {
  if (!claim.value?.id) return;
  Modal.confirm({
    title: '确认通过',
    content: '确定通过该认领申请吗？',
    async onOk() {
      actionLoading.value = true;
      try {
        await approveClaim(claim.value!.id!);
        message.success('已通过');
        loadClaim();
      } catch {
        message.error('操作失败');
      } finally {
        actionLoading.value = false;
      }
    },
  });
}

// 拒绝认领
function showRejectModal() {
  rejectVisible.value = true;
  rejectReason.value = '';
}

async function handleReject() {
  if (!rejectReason.value.trim()) {
    message.warning('请输入拒绝原因');
    return;
  }
  if (!claim.value?.id) return;

  actionLoading.value = true;
  try {
    await rejectClaim(claim.value.id, rejectReason.value);
    message.success('已拒绝');
    rejectVisible.value = false;
    loadClaim();
  } catch {
    message.error('操作失败');
  } finally {
    actionLoading.value = false;
  }
}

// 取消认领
async function handleCancel() {
  if (!claim.value?.id) return;
  Modal.confirm({
    title: '确认取消',
    content: '确定取消该认领申请吗？',
    async onOk() {
      actionLoading.value = true;
      try {
        await cancelClaim(claim.value!.id!);
        message.success('已取消');
        loadClaim();
      } catch {
        message.error('操作失败');
      } finally {
        actionLoading.value = false;
      }
    },
  });
}

// 发起交接
function showHandoverModal() {
  handoverVisible.value = true;
  handoverLocation.value = '';
  handoverTime.value = undefined;
}

async function handleCreateHandover() {
  if (!handoverLocation.value.trim() || !handoverTime.value) {
    message.warning('请填写交接信息');
    return;
  }
  if (!claim.value?.id) return;

  actionLoading.value = true;
  try {
    await createHandover({
      claimId: claim.value.id,
      location: handoverLocation.value,
      handoverTime: handoverTime.value.format('YYYY-MM-DD HH:mm:ss'),
    });
    message.success('交接已发起');
    handoverVisible.value = false;
    loadClaim();
  } catch {
    message.error('操作失败');
  } finally {
    actionLoading.value = false;
  }
}

// 确认交接
async function handleConfirmHandover() {
  if (!claim.value?.handover?.id) return;
  Modal.confirm({
    title: '确认交接',
    content: '确认已完成物品交接吗？',
    async onOk() {
      actionLoading.value = true;
      try {
        await confirmHandover(claim.value!.handover!.id!);
        message.success('交接确认成功');
        loadClaim();
      } catch {
        message.error('操作失败');
      } finally {
        actionLoading.value = false;
      }
    },
  });
}

// 取消交接
async function handleCancelHandover() {
  if (!claim.value?.handover?.id) return;
  Modal.confirm({
    title: '取消交接',
    content: '确认取消当前交接安排吗？取消后可重新发起交接。',
    async onOk() {
      actionLoading.value = true;
      try {
        await cancelHandover(claim.value!.handover!.id!, '用户取消交接');
        message.success('交接已取消');
        loadClaim();
      } catch {
        message.error('操作失败');
      } finally {
        actionLoading.value = false;
      }
    },
  });
}

function showReceiptModal() {
  receiptVisible.value = true;
  receiptActualTime.value = dayjs();
  receiptLocation.value =
    claim.value?.handover?.receiptLocation ||
    claim.value?.handover?.location ||
    '';
  receiptRemark.value = claim.value?.handover?.receiptRemark || '';
  receiptFileList.value = [];
  receiptImages.value = [];
}

async function handleSubmitReceipt() {
  if (!claim.value?.handover?.id) return;
  if (!receiptActualTime.value || !receiptLocation.value.trim()) {
    message.warning('请填写线下交接时间和地点');
    return;
  }
  actionLoading.value = true;
  try {
    await submitHandoverReceipt(claim.value.handover.id, {
      receiptActualTime: receiptActualTime.value.format('YYYY-MM-DD HH:mm:ss'),
      receiptLocation: receiptLocation.value.trim(),
      receiptRemark: receiptRemark.value.trim() || undefined,
      receiptEvidenceJson: receiptImages.value,
    });
    message.success('线下回传已提交，等待对方确认');
    receiptVisible.value = false;
    loadClaim();
  } catch {
    message.error('提交失败');
  } finally {
    actionLoading.value = false;
  }
}

async function handleConfirmReceipt() {
  if (!claim.value?.handover?.id) return;
  Modal.confirm({
    title: '确认线下回传',
    content: '确认对方提交的线下回传信息无误吗？',
    async onOk() {
      actionLoading.value = true;
      try {
        await confirmHandoverReceipt(claim.value!.handover!.id!);
        message.success('已确认回传，交接将自动完成');
        loadClaim();
      } catch {
        message.error('操作失败');
      } finally {
        actionLoading.value = false;
      }
    },
  });
}

function showRescheduleModal() {
  rescheduleVisible.value = true;
  rescheduleLocation.value = claim.value?.handover?.location || '';
  rescheduleTime.value = claim.value?.handover?.handoverTime
    ? dayjs(claim.value.handover.handoverTime)
    : undefined;
  rescheduleReason.value = '';
}

async function handleReschedule() {
  if (!claim.value?.handover?.id) return;
  if (!rescheduleLocation.value.trim() && !rescheduleTime.value) {
    message.warning('请至少提供新的时间或地点');
    return;
  }
  actionLoading.value = true;
  try {
    await rescheduleHandover(
      claim.value.handover.id,
      {
        location: rescheduleLocation.value.trim() || undefined,
        handoverTime: rescheduleTime.value?.format('YYYY-MM-DD HH:mm:ss'),
      },
      rescheduleReason.value.trim() || undefined,
    );
    message.success('已发起改约');
    rescheduleVisible.value = false;
    loadClaim();
  } catch {
    message.error('改约失败');
  } finally {
    actionLoading.value = false;
  }
}

function showDisputeModal() {
  disputeVisible.value = true;
  disputeReason.value = '';
}

async function handleDispute() {
  if (!claim.value?.handover?.id) return;
  actionLoading.value = true;
  try {
    await disputeHandover(
      claim.value.handover.id,
      disputeReason.value.trim() || undefined,
    );
    message.success('争议已上报，请等待人工处理');
    disputeVisible.value = false;
    loadClaim();
  } catch {
    message.error('上报失败');
  } finally {
    actionLoading.value = false;
  }
}

function showNoShowModal() {
  noShowVisible.value = true;
  noShowReason.value = '';
}

async function handleNoShow() {
  if (!claim.value?.handover?.id) return;
  actionLoading.value = true;
  try {
    await markHandoverNoShow(
      claim.value.handover.id,
      noShowReason.value.trim() || undefined,
    );
    message.success('爽约情况已上报');
    noShowVisible.value = false;
    loadClaim();
  } catch {
    message.error('上报失败');
  } finally {
    actionLoading.value = false;
  }
}

// 线下确认悬赏发放
async function handleConfirmRewardPaid() {
  if (!claim.value?.id) return;
  Modal.confirm({
    title: '确认悬赏发放',
    content: '确认已线下向拾得者发放悬赏吗？',
    async onOk() {
      actionLoading.value = true;
      try {
        await confirmRewardPaid(claim.value!.id!);
        message.success('已确认发放');
        loadClaim();
      } catch {
        message.error('操作失败');
      } finally {
        actionLoading.value = false;
      }
    },
  });
}

// 线下悬赏退款
async function handleRefundReward() {
  if (!claim.value?.id) return;
  Modal.confirm({
    title: '悬赏退款',
    content: '确认撤销托管并线下退款吗？',
    async onOk() {
      actionLoading.value = true;
      try {
        await refundReward(claim.value!.id!);
        message.success('已退款');
        loadClaim();
      } catch {
        message.error('操作失败');
      } finally {
        actionLoading.value = false;
      }
    },
  });
}

// 评价
function showEvaluateModal() {
  evaluateVisible.value = true;
  evaluateScore.value = 5;
  evaluateContent.value = '';
}

async function handleEvaluate() {
  if (!claim.value?.handover?.id) return;
  actionLoading.value = true;
  try {
    await createEvaluation({
      handoverId: claim.value.handover.id,
      score: evaluateScore.value,
      content: evaluateContent.value,
    });
    message.success('评价成功');
    evaluateVisible.value = false;
    loadClaim();
  } catch {
    message.error('评价失败');
  } finally {
    actionLoading.value = false;
  }
}

// 格式化时间
function formatTime(time?: string) {
  if (!time) return '';
  return time.replace('T', ' ').slice(0, 16);
}

// 返回
function goBack() {
  router.back();
}

onMounted(() => {
  loadClaim();
});
</script>

<template>
  <Page auto-content-height>
    <Spin :spinning="loading">
      <div v-if="claim" class="mx-auto max-w-3xl p-4">
        <!-- 状态进度 -->
        <Card class="mb-4">
          <Steps
            :current="currentStep"
            :status="currentStep < 0 ? 'error' : undefined"
          >
            <Steps.Step title="提交申请" />
            <Steps.Step title="审核通过" />
            <Steps.Step title="物品交接" />
            <Steps.Step title="完成" />
          </Steps>
        </Card>

        <!-- 认领信息 -->
        <Card title="认领信息" class="mb-4">
          <Descriptions :column="2" bordered>
            <DescriptionsItem label="认领状态">
              <Tag :color="statusConfig[claim.status || 'pending']?.color">
                {{ statusConfig[claim.status || 'pending']?.label }}
              </Tag>
            </DescriptionsItem>
            <DescriptionsItem label="申请时间">
              {{ formatTime(claim.createTime) }}
            </DescriptionsItem>
            <DescriptionsItem label="自动核验">
              <Tag :color="scoreColor(claim.autoMatchScore)">
                匹配度 {{ formatScore(claim.autoMatchScore) }}
              </Tag>
            </DescriptionsItem>
            <DescriptionsItem label="认领说明" :span="2">
              {{ claim.proofText || claim.description || '-' }}
            </DescriptionsItem>
            <DescriptionsItem label="补充特征" :span="2">
              {{
                claim.featureAnswers && claim.featureAnswers.length > 0
                  ? claim.featureAnswers.join('、')
                  : '-'
              }}
            </DescriptionsItem>
          </Descriptions>

          <!-- 佐证材料 -->
          <div v-if="claim.proofImages?.length" class="mt-4">
            <div class="mb-2 font-medium">佐证材料</div>
            <ImagePreviewGroup>
              <div class="flex flex-wrap gap-2">
                <Image
                  v-for="(img, idx) in claim.proofImages"
                  :key="idx"
                  :src="img"
                  :width="100"
                  :height="100"
                  class="rounded object-cover"
                />
              </div>
            </ImagePreviewGroup>
          </div>

          <!-- 拒绝原因 -->
          <div
            v-if="claim.status === 'rejected' && claim.rejectReason"
            class="mt-4"
          >
            <div class="rounded bg-red-50 p-3 text-red-600">
              <span class="font-medium">拒绝原因：</span>
              {{ claim.rejectReason }}
            </div>
          </div>

          <!-- 需补充佐证 -->
          <div
            v-if="claim.status === 'need_proof' && claim.reviewReason"
            class="mt-4"
          >
            <div class="rounded bg-amber-50 p-3 text-amber-700">
              <span class="font-medium">需补充说明：</span>
              {{ claim.reviewReason }}
            </div>
          </div>
        </Card>

        <!-- 物品信息 -->
        <Card title="物品信息" class="mb-4">
          <div class="flex gap-4">
            <div v-if="claim.post?.images?.[0]" class="shrink-0">
              <Image
                :src="claim.post.images[0]"
                :width="100"
                :height="100"
                class="rounded object-cover"
              />
            </div>
            <div class="flex-1">
              <div class="mb-2 text-lg font-medium">
                {{ claim.post?.itemName }}
              </div>
              <div class="text-gray-500">{{ claim.post?.description }}</div>
              <div class="mt-2 text-sm text-gray-400">
                地点：{{ claim.post?.locationName }} | 时间：{{
                  formatTime(claim.post?.eventTime || '')
                }}
              </div>
              <div
                v-if="claim.post?.rewardAmount"
                class="mt-1 text-sm text-gray-400"
              >
                悬赏：{{ claim.post.rewardAmount }} | 状态：{{
                  rewardStatusLabel[
                    (claim.post.rewardStatus || '').toUpperCase()
                  ] || '-'
                }}
              </div>
            </div>
          </div>
        </Card>

        <!-- 交接信息 -->
        <Card v-if="claim.handover" title="交接信息" class="mb-4">
          <Descriptions :column="2" bordered>
            <DescriptionsItem label="交接状态">
              <Tag :color="handoverStatusConfig[handoverStatus]?.color || 'blue'">
                {{ handoverStatusConfig[handoverStatus]?.label || '进行中' }}
              </Tag>
            </DescriptionsItem>
            <DescriptionsItem label="交接地点">
              {{
                claim.handover.location ||
                claim.handover.handoverLocation ||
                '-'
              }}
            </DescriptionsItem>
            <DescriptionsItem label="约定时间">
              {{
                formatTime(
                  claim.handover.handoverTime || claim.handover.scheduledTime,
                )
              }}
            </DescriptionsItem>
            <DescriptionsItem label="发布者确认">
              <Tag
                :color="
                  claim.handover.confirmedByFromAt ||
                  claim.handover.publisherConfirmed ||
                  claim.handover.giverConfirmed
                    ? 'green'
                    : 'orange'
                "
              >
                {{
                  claim.handover.confirmedByFromAt ||
                  claim.handover.publisherConfirmed ||
                  claim.handover.giverConfirmed
                    ? '已确认'
                    : '待确认'
                }}
              </Tag>
            </DescriptionsItem>
            <DescriptionsItem label="认领者确认">
              <Tag
                :color="
                  claim.handover.confirmedByToAt ||
                  claim.handover.claimerConfirmed ||
                  claim.handover.receiverConfirmed
                    ? 'green'
                    : 'orange'
                "
              >
                {{
                  claim.handover.confirmedByToAt ||
                  claim.handover.claimerConfirmed ||
                  claim.handover.receiverConfirmed
                    ? '已确认'
                    : '待确认'
                }}
              </Tag>
            </DescriptionsItem>
            <DescriptionsItem label="回传提交时间">
              {{ formatTime(claim.handover.receiptSubmittedAt) || '-' }}
            </DescriptionsItem>
            <DescriptionsItem label="回传确认时间">
              {{ formatTime(claim.handover.receiptConfirmedAt) || '-' }}
            </DescriptionsItem>
            <DescriptionsItem label="线下完成时间">
              {{ formatTime(claim.handover.receiptActualTime) || '-' }}
            </DescriptionsItem>
            <DescriptionsItem label="线下完成地点">
              {{ claim.handover.receiptLocation || '-' }}
            </DescriptionsItem>
            <DescriptionsItem label="回传备注" :span="2">
              {{ claim.handover.receiptRemark || '-' }}
            </DescriptionsItem>
          </Descriptions>
          <div
            v-if="
              claim.handover.receiptEvidenceJson &&
              claim.handover.receiptEvidenceJson.length > 0
            "
            class="mt-4"
          >
            <div class="mb-2 font-medium">回传凭证</div>
            <ImagePreviewGroup>
              <div class="flex flex-wrap gap-2">
                <Image
                  v-for="(img, idx) in claim.handover.receiptEvidenceJson"
                  :key="idx"
                  :src="img"
                  :width="100"
                  :height="100"
                  class="rounded object-cover"
                />
              </div>
            </ImagePreviewGroup>
          </div>
        </Card>

        <!-- 双方信息 -->
        <Card title="双方信息" class="mb-4">
          <div class="flex justify-around">
            <div class="text-center">
              <Avatar :src="claim.publisher?.avatar" :size="64">
                {{ claim.publisher?.nickname?.charAt(0) }}
              </Avatar>
              <div class="mt-2 font-medium">
                {{ claim.publisher?.nickname }}
              </div>
              <div class="text-sm text-gray-500">发布者</div>
            </div>
            <div class="text-center">
              <Avatar :src="claim.claimer?.avatar" :size="64">
                {{ claim.claimer?.nickname?.charAt(0) }}
              </Avatar>
              <div class="mt-2 font-medium">{{ claim.claimer?.nickname }}</div>
              <div class="text-sm text-gray-500">认领者</div>
            </div>
          </div>
        </Card>

        <!-- 操作按钮 -->
        <Card>
          <div class="flex flex-wrap justify-center gap-2">
            <!-- 发布者操作 -->
            <template v-if="isPublisher">
              <Button
                v-if="claim.status === 'pending' || claim.status === 'applied'"
                type="primary"
                :loading="actionLoading"
                @click="handleApprove"
              >
                通过认领
              </Button>
              <Button
                v-if="claim.status === 'pending' || claim.status === 'applied'"
                danger
                :loading="actionLoading"
                @click="showRejectModal"
              >
                拒绝认领
              </Button>
              <Button
                v-if="claim.status === 'approved'"
                type="primary"
                :loading="actionLoading"
                @click="showHandoverModal"
              >
                发起交接
              </Button>
              <Button
                v-if="canHandleReward"
                type="primary"
                :loading="actionLoading"
                @click="handleConfirmRewardPaid"
              >
                确认悬赏发放
              </Button>
              <Button
                v-if="canHandleReward"
                danger
                :loading="actionLoading"
                @click="handleRefundReward"
              >
                悬赏退款
              </Button>
            </template>

            <!-- 认领者操作 -->
            <template v-if="isClaimer">
              <Button
                v-if="claim.status === 'pending' || claim.status === 'applied'"
                :loading="actionLoading"
                @click="handleCancel"
              >
                取消认领
              </Button>
              <Button
                v-if="claim.status === 'need_proof'"
                type="primary"
                :loading="actionLoading"
                @click="showAppendModal"
              >
                补充佐证
              </Button>
              <Button
                v-if="claim.status === 'completed' && !claim.hasEvaluated"
                type="primary"
                @click="showEvaluateModal"
              >
                评价
              </Button>
            </template>

            <!-- 交接阶段双方共用操作 -->
            <template
              v-if="
                (isPublisher || isClaimer) &&
                (claim.status === 'handover' || claim.status === 'in_handover')
              "
            >
              <Button
                v-if="canDirectConfirmHandover"
                type="primary"
                :loading="actionLoading"
                @click="handleConfirmHandover"
              >
                直接确认交接
              </Button>
              <Button
                v-if="canSubmitReceipt"
                type="primary"
                :loading="actionLoading"
                @click="showReceiptModal"
              >
                提交线下回传
              </Button>
              <Button
                v-if="canConfirmReceipt"
                type="primary"
                :loading="actionLoading"
                @click="handleConfirmReceipt"
              >
                确认线下回传
              </Button>
              <Button
                v-if="canReschedule"
                :loading="actionLoading"
                @click="showRescheduleModal"
              >
                改约
              </Button>
              <Button
                v-if="canMarkNoShow"
                :loading="actionLoading"
                @click="showNoShowModal"
              >
                上报爽约
              </Button>
              <Button
                v-if="canRaiseDispute"
                danger
                :loading="actionLoading"
                @click="showDisputeModal"
              >
                上报争议
              </Button>
              <Button
                v-if="canCancelHandoverAction"
                :loading="actionLoading"
                @click="handleCancelHandover"
              >
                取消交接
              </Button>
            </template>

            <Button @click="goBack">返回</Button>
          </div>
        </Card>
      </div>
    </Spin>

    <!-- 拒绝弹窗 -->
    <Modal
      v-model:open="rejectVisible"
      title="拒绝认领"
      :confirm-loading="actionLoading"
      @ok="handleReject"
    >
      <Input.TextArea
        v-model:value="rejectReason"
        placeholder="请输入拒绝原因..."
        :rows="4"
        :maxlength="500"
        show-count
      />
    </Modal>

    <!-- 交接弹窗 -->
    <Modal
      v-model:open="handoverVisible"
      title="发起交接"
      :confirm-loading="actionLoading"
      @ok="handleCreateHandover"
    >
      <div class="space-y-4">
        <div>
          <div class="mb-1">交接地点</div>
          <Input
            v-model:value="handoverLocation"
            placeholder="请输入交接地点"
          />
        </div>
        <div>
          <div class="mb-1">约定时间</div>
          <DatePicker
            v-model:value="handoverTime"
            show-time
            format="YYYY-MM-DD HH:mm"
            placeholder="请选择约定时间"
            style="width: 100%"
            :disabled-date="
              (current: dayjs.Dayjs) =>
                current && current < dayjs().startOf('day')
            "
          />
        </div>
      </div>
    </Modal>

    <!-- 线下回传弹窗 -->
    <Modal
      v-model:open="receiptVisible"
      title="提交线下回传"
      :confirm-loading="actionLoading"
      @ok="handleSubmitReceipt"
    >
      <div class="space-y-4">
        <div>
          <div class="mb-1">线下完成时间</div>
          <DatePicker
            v-model:value="receiptActualTime"
            show-time
            format="YYYY-MM-DD HH:mm"
            style="width: 100%"
            placeholder="请选择线下完成时间"
          />
        </div>
        <div>
          <div class="mb-1">线下完成地点</div>
          <Input
            v-model:value="receiptLocation"
            placeholder="请输入线下交接实际地点"
          />
        </div>
        <div>
          <div class="mb-1">回传说明</div>
          <Input.TextArea
            v-model:value="receiptRemark"
            placeholder="可填写现场说明、交付情况等（可选）"
            :rows="3"
            :maxlength="500"
            show-count
          />
        </div>
        <div>
          <div class="mb-1">回传凭证</div>
          <Upload
            v-model:file-list="receiptFileList"
            action="/api/upload"
            list-type="picture-card"
            :max-count="6"
            accept="image/*"
            @change="handleReceiptUploadChange"
          >
            <div v-if="receiptFileList.length < 6">
              <div class="text-2xl">+</div>
              <div class="mt-2">上传凭证</div>
            </div>
          </Upload>
          <div class="text-gray-500">可上传交接凭证图片，最多6张</div>
        </div>
      </div>
    </Modal>

    <!-- 改约弹窗 -->
    <Modal
      v-model:open="rescheduleVisible"
      title="改约"
      :confirm-loading="actionLoading"
      @ok="handleReschedule"
    >
      <div class="space-y-4">
        <div>
          <div class="mb-1">新的交接时间</div>
          <DatePicker
            v-model:value="rescheduleTime"
            show-time
            format="YYYY-MM-DD HH:mm"
            placeholder="请选择新的交接时间"
            style="width: 100%"
          />
        </div>
        <div>
          <div class="mb-1">新的交接地点</div>
          <Input
            v-model:value="rescheduleLocation"
            placeholder="请输入新的交接地点"
          />
        </div>
        <div>
          <div class="mb-1">改约原因</div>
          <Input.TextArea
            v-model:value="rescheduleReason"
            placeholder="请输入改约原因（可选）"
            :rows="3"
            :maxlength="300"
            show-count
          />
        </div>
      </div>
    </Modal>

    <!-- 争议弹窗 -->
    <Modal
      v-model:open="disputeVisible"
      title="上报争议"
      :confirm-loading="actionLoading"
      @ok="handleDispute"
    >
      <Input.TextArea
        v-model:value="disputeReason"
        placeholder="请描述争议原因（可选）"
        :rows="4"
        :maxlength="500"
        show-count
      />
    </Modal>

    <!-- 爽约弹窗 -->
    <Modal
      v-model:open="noShowVisible"
      title="上报爽约"
      :confirm-loading="actionLoading"
      @ok="handleNoShow"
    >
      <Input.TextArea
        v-model:value="noShowReason"
        placeholder="请描述爽约情况（可选）"
        :rows="4"
        :maxlength="500"
        show-count
      />
    </Modal>

    <!-- 补充佐证弹窗 -->
    <Modal
      v-model:open="appendVisible"
      title="补充佐证"
      :confirm-loading="actionLoading"
      @ok="handleAppendProof"
    >
      <div class="space-y-4">
        <div>
          <div class="mb-1">补充说明</div>
          <Input.TextArea
            v-model:value="appendText"
            placeholder="补充更多能证明物品归属的信息（可选）"
            :rows="4"
            :maxlength="1000"
            show-count
          />
        </div>
        <div>
          <div class="mb-1">补充图片</div>
          <Upload
            v-model:file-list="appendFileList"
            action="/api/upload"
            list-type="picture-card"
            :max-count="6"
            accept="image/*"
            @change="handleAppendUploadChange"
          >
            <div v-if="appendFileList.length < 6">
              <div class="text-2xl">+</div>
              <div class="mt-2">上传图片</div>
            </div>
          </Upload>
          <div class="text-gray-500">
            可上传购买凭证、使用照片等证明材料，最多6张
          </div>
        </div>
      </div>
    </Modal>

    <!-- 评价弹窗 -->
    <Modal
      v-model:open="evaluateVisible"
      title="评价"
      :confirm-loading="actionLoading"
      @ok="handleEvaluate"
    >
      <div class="space-y-4">
        <div>
          <div class="mb-1">评分</div>
          <div class="flex gap-2">
            <Button
              v-for="i in 5"
              :key="i"
              :type="evaluateScore >= i ? 'primary' : 'default'"
              shape="circle"
              @click="evaluateScore = i"
            >
              {{ i }}
            </Button>
          </div>
        </div>
        <div>
          <div class="mb-1">评价内容</div>
          <Input.TextArea
            v-model:value="evaluateContent"
            placeholder="请输入评价内容（可选）"
            :rows="3"
            :maxlength="200"
          />
        </div>
      </div>
    </Modal>
  </Page>
</template>
