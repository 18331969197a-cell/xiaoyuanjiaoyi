import type { PageResult } from '@vben/types';

import { requestClient } from '#/api/request';

// 学生名单
export interface StudentRoster {
  id: number;
  studentNo: string;
  realName: string;
  idCardSuffix?: string;
  college?: string;
  major?: string;
  className?: string;
  enrollYear?: number;
  status: number;
  createdAt?: string;
}

// 学生名单导入DTO
export interface StudentRosterDTO {
  studentNo: string;
  realName: string;
  idCardSuffix: string;
  college?: string;
  major?: string;
  className?: string;
  enrollmentYear?: number;
  status?: number;
}

// 认证记录VO
export interface VerificationRecord {
  userId: number;
  userName: string;
  nickname?: string;
  verifiedStudentNo?: string;
  realName?: string;
  college?: string;
  major?: string;
  className?: string;
  verified: number;
  verifiedTime?: string;
}

// 导入结果
export interface ImportResult {
  insertCount: number;
  updateCount: number;
}

/**
 * 获取学生名单列表
 */
async function getStudentRosterList(params?: {
  keyword?: string;
  pageNum?: number;
  pageSize?: number;
}): Promise<PageResult<StudentRoster>> {
  const res = await requestClient.get<PageResult<StudentRoster>>(
    '/lostfound/admin/verification/roster',
    { params },
  );
  return {
    rows: (res as any).records || res.rows || [],
    total: res.total || 0,
  };
}

/**
 * 导入学生名单（Excel文件）
 */
async function importStudentRoster(file: File): Promise<ImportResult> {
  const formData = new FormData();
  formData.append('file', file);
  return requestClient.post<ImportResult>(
    '/lostfound/admin/verification/import',
    formData,
    {
      headers: { 'Content-Type': 'multipart/form-data' },
    },
  );
}

/**
 * 删除学生名单
 */
async function deleteStudentRoster(id: number): Promise<void> {
  return requestClient.delete(`/lostfound/admin/verification/roster/${id}`);
}

/**
 * 查询认证记录
 */
async function getVerificationRecords(params?: {
  keyword?: string;
  pageNum?: number;
  pageSize?: number;
  verified?: number;
}): Promise<PageResult<VerificationRecord>> {
  const res = await requestClient.get<PageResult<VerificationRecord>>(
    '/lostfound/admin/verification/records',
    { params },
  );
  return {
    rows: (res as any).records || res.rows || [],
    total: res.total || 0,
  };
}

/**
 * 撤销用户认证
 */
async function revokeVerification(userId: number): Promise<void> {
  return requestClient.post(`/lostfound/admin/verification/revoke/${userId}`);
}

export {
  deleteStudentRoster,
  getStudentRosterList,
  getVerificationRecords,
  importStudentRoster,
  revokeVerification,
};

export type {
  ImportResult,
  StudentRoster,
  StudentRosterDTO,
  VerificationRecord,
};
