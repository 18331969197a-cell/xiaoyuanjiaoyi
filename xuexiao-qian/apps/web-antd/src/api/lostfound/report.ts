import { requestClient } from '#/api/request';

// 举报类型
export interface BizReport {
  id?: number;
  reporterId?: number;
  reporterName?: string;
  targetType?: string;
  targetId?: number;
  reasonType?: string;
  reasonDetail?: string;
  reason?: string;
  description?: string;
  imagesJson?: string;
  status?: string;
  resolveBy?: number;
  resolveAt?: string;
  resolveResult?: string;
  resolveAction?: string;
  createTime?: string;
}

// 举报查询参数
export interface ReportQueryParams {
  pageNum?: number;
  pageSize?: number;
  targetType?: string;
  status?: string;
  resolveAction?: string;
}

/**
 * 提交举报
 */
async function createReport(data: BizReport) {
  return requestClient.post<number>('/lostfound/report', data);
}

// MyBatis-Plus 分页结果类型
export interface MybatisPlusPage<T> {
  records: T[];
  total: number;
  size: number;
  current: number;
  pages: number;
}

/**
 * 获取我的举报
 */
async function getMyReports(params?: { pageNum?: number; pageSize?: number }) {
  return requestClient.get<MybatisPlusPage<BizReport>>('/lostfound/report/my', {
    params,
  });
}

// ========== 管理端接口 ==========

/**
 * 获取举报列表
 */
async function adminGetReportList(params?: ReportQueryParams) {
  const result = await requestClient.get<MybatisPlusPage<BizReport>>(
    '/lostfound/report/admin/list',
    { params },
  );
  // 直接返回VxeGrid期望的格式
  return {
    rows: result.records || [],
    total: result.total || 0,
  };
}

/**
 * 处理举报
 */
async function handleReport(id: number, result: string, action?: string) {
  return requestClient.post(`/lostfound/report/admin/${id}/handle`, null, {
    params: { result, action },
  });
}

/**
 * 通过举报（处理）
 */
async function adminResolveReport(
  id: number,
  data?: { action?: string; remark?: string },
) {
  return requestClient.post(`/lostfound/report/admin/${id}/resolve`, null, {
    params: data,
  });
}

/**
 * 驳回举报
 */
async function adminRejectReport(id: number, reason?: string) {
  return requestClient.post(`/lostfound/report/admin/${id}/reject`, null, {
    params: { reason },
  });
}

/**
 * 获取举报详情
 */
async function getReportById(id: number) {
  return requestClient.get<BizReport>(`/lostfound/report/admin/${id}`);
}

export {
  adminGetReportList,
  adminRejectReport,
  adminResolveReport,
  createReport,
  getMyReports,
  getReportById,
  handleReport,
};
