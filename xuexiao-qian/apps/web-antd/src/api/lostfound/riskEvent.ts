import { requestClient } from '#/api/request';

export interface BizRiskEvent {
  id?: number;
  sourceType?: string;
  sourceId?: number;
  reportId?: number;
  targetType?: string;
  targetId?: number;
  riskType?: string;
  actionType?: string;
  eventStatus?: string;
  scopeType?: string;
  scopeId?: number;
  remark?: string;
  resolvedBy?: number;
  resolvedAt?: string;
  createTime?: string;
  updateTime?: string;
  reporterName?: string;
  resolverName?: string;
  reportReasonDetail?: string;
}

export interface RiskEventQueryParams {
  pageNum?: number;
  pageSize?: number;
  targetType?: string;
  targetId?: number;
  eventStatus?: string;
  actionType?: string;
  startTime?: string;
  endTime?: string;
}

interface MybatisPlusPage<T> {
  records: T[];
  total: number;
  size: number;
  current: number;
  pages: number;
}

async function adminGetRiskEventList(params?: RiskEventQueryParams) {
  const result = await requestClient.get<MybatisPlusPage<BizRiskEvent>>(
    '/lostfound/risk-event/admin/list',
    { params },
  );
  return {
    rows: result.records || [],
    total: result.total || 0,
  };
}

export { adminGetRiskEventList };
