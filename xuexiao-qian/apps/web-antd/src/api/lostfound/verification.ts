import { requestClient } from '#/api/request';

// 认证请求参数
export interface VerificationRequest {
  studentNo: string;
  realName: string;
  idCardSuffix: string;
}

// 认证状态响应
export interface VerificationStatus {
  verified: boolean;
  studentNo?: string;
  realName?: string;
  college?: string;
  major?: string;
  className?: string;
  verifiedTime?: string;
  message?: string;
}

/**
 * 提交身份认证
 */
async function submitVerification(
  data: VerificationRequest,
): Promise<VerificationStatus> {
  return requestClient.post<VerificationStatus>(
    '/lostfound/verification/verify',
    data,
  );
}

/**
 * 获取认证状态
 */
async function getVerificationStatus(): Promise<VerificationStatus> {
  return requestClient.get<VerificationStatus>(
    '/lostfound/verification/status',
  );
}

/**
 * 检查是否已认证
 */
async function checkVerified(): Promise<boolean> {
  return requestClient.get<boolean>('/lostfound/verification/check');
}

export { checkVerified, getVerificationStatus, submitVerification };
