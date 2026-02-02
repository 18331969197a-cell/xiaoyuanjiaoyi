import { requestClient } from '#/api/request';

export interface SecurityLogItem {
  id?: number;
  userId?: number;
  title?: string;
  operationType?: string;
  operationRegion?: string;
  operationIp?: string;
  operationTime?: string;
}

export interface SecurityLogQueryParams {
  pageNum?: number;
  pageSize?: number;
  operationType?: string;
  userId?: number;
  startTime?: string;
  endTime?: string;
}

export interface MybatisPlusPage<T> {
  records: T[];
  total: number;
  size: number;
  current: number;
  pages: number;
}

async function adminGetSecurityLogList(params?: SecurityLogQueryParams) {
  const result = await requestClient.get<MybatisPlusPage<SecurityLogItem>>(
    '/system/security-log/admin/list',
    { params },
  );
  return {
    rows: result.records || [],
    total: result.total || 0,
  };
}

export { adminGetSecurityLogList };
