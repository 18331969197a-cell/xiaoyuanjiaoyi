import type { VbenFormSchema } from '#/adapter/form';
import type { VxeTableGridOptions } from '#/adapter/vxe-table';

const SOURCE_TYPE_TEXT: Record<string, string> = {
  HANDOVER: '交接',
  REPORT: '举报',
};

const TARGET_TYPE_TEXT: Record<string, string> = {
  CLAIM: '认领',
  COMMENT: '评论',
  POST: '帖子',
  USER: '用户',
};

function formatRiskNo(id?: number | string) {
  if (id === null || id === undefined || id === '') {
    return '-';
  }
  return `风险单#${String(id).padStart(4, '0')}`;
}

function formatSourceNo(sourceType?: string, sourceId?: number | string) {
  if (sourceId === null || sourceId === undefined || sourceId === '') {
    return '-';
  }
  const sourceName = SOURCE_TYPE_TEXT[sourceType || ''] || '来源';
  return `${sourceName}单#${sourceId}`;
}

function formatTargetNo(targetType?: string, targetId?: number | string) {
  if (targetId === null || targetId === undefined || targetId === '') {
    return '-';
  }
  const targetName = TARGET_TYPE_TEXT[targetType || ''] || '对象';
  return `${targetName}#${targetId}`;
}

export function useGridFormSchema(): VbenFormSchema[] {
  return [
    {
      component: 'Select',
      componentProps: {
        allowClear: true,
        options: [
          { label: '帖子', value: 'POST' },
          { label: '评论', value: 'COMMENT' },
          { label: '用户', value: 'USER' },
          { label: '认领单', value: 'CLAIM' },
        ],
      },
      fieldName: 'targetType',
      label: '目标类型',
    },
    {
      component: 'Input',
      fieldName: 'targetId',
      label: '目标ID',
    },
    {
      component: 'Select',
      componentProps: {
        allowClear: true,
        options: [
          { label: '封禁账号', value: 'ban_user' },
          { label: '删除内容', value: 'offline_post' },
          { label: '禁言', value: 'mute' },
          { label: '警告', value: 'warning' },
          { label: '上报争议', value: 'RAISE_DISPUTE' },
          { label: '上报爽约', value: 'MARK_NO_SHOW' },
          { label: '升级人工', value: 'ESCALATE_MANUAL' },
        ],
      },
      fieldName: 'actionType',
      label: '处置动作',
    },
    {
      component: 'Select',
      componentProps: {
        allowClear: true,
        options: [
          { label: '待处理', value: 'OPEN' },
          { label: '已处理', value: 'RESOLVED' },
        ],
      },
      fieldName: 'eventStatus',
      label: '事件状态',
    },
    {
      component: 'RangePicker',
      fieldName: 'createTime',
      label: '告警时间',
    },
  ];
}

export function useColumns(): VxeTableGridOptions['columns'] {
  return [
    {
      type: 'seq',
      title: '序号',
      width: 60,
    },
    {
      field: 'id',
      title: '风险单号',
      width: 140,
      formatter: ({ cellValue }: { cellValue?: number | string }) =>
        formatRiskNo(cellValue),
    },
    {
      field: 'sourceType',
      title: '来源',
      width: 100,
      cellRender: {
        name: 'CellTag',
        options: [
          { label: '举报', value: 'REPORT', color: 'blue' },
          { label: '交接', value: 'HANDOVER', color: 'orange' },
        ],
      },
    },
    {
      field: 'sourceId',
      title: '来源单号',
      width: 120,
      formatter: ({
        row,
      }: {
        row: { sourceId?: number | string; sourceType?: string };
      }) => formatSourceNo(row.sourceType, row.sourceId),
    },
    {
      field: 'targetType',
      title: '目标类型',
      width: 100,
      cellRender: {
        name: 'CellTag',
        options: [
          { label: '帖子', value: 'POST', color: 'blue' },
          { label: '评论', value: 'COMMENT', color: 'cyan' },
          { label: '用户', value: 'USER', color: 'orange' },
          { label: '认领单', value: 'CLAIM', color: 'purple' },
        ],
      },
    },
    {
      field: 'targetId',
      title: '目标对象',
      width: 120,
      formatter: ({
        row,
      }: {
        row: { targetId?: number | string; targetType?: string };
      }) => formatTargetNo(row.targetType, row.targetId),
    },
    {
      field: 'riskType',
      title: '风险类型',
      width: 120,
      cellRender: {
        name: 'CellTag',
        options: [
          { label: '账号风险', value: 'ACCOUNT_RISK', color: 'red' },
          { label: '内容风险', value: 'CONTENT_RISK', color: 'orange' },
          { label: '交接争议', value: 'HANDOVER_DISPUTE', color: 'volcano' },
          { label: '交接爽约', value: 'HANDOVER_NO_SHOW', color: 'gold' },
          { label: '交接超时', value: 'HANDOVER_TIMEOUT', color: 'purple' },
        ],
      },
    },
    {
      field: 'actionType',
      title: '处置动作',
      width: 120,
      cellRender: {
        name: 'CellTag',
        options: [
          { label: '封禁账号', value: 'ban_user', color: 'red' },
          { label: '删除内容', value: 'offline_post', color: 'red' },
          { label: '禁言', value: 'mute', color: 'orange' },
          { label: '警告', value: 'warning', color: 'blue' },
          { label: '上报争议', value: 'RAISE_DISPUTE', color: 'volcano' },
          { label: '上报爽约', value: 'MARK_NO_SHOW', color: 'gold' },
          { label: '升级人工', value: 'ESCALATE_MANUAL', color: 'purple' },
        ],
      },
    },
    {
      field: 'eventStatus',
      title: '事件状态',
      width: 100,
      cellRender: {
        name: 'CellTag',
        options: [
          { label: '待处理', value: 'OPEN', color: 'orange' },
          { label: '已处理', value: 'RESOLVED', color: 'green' },
        ],
      },
    },
    {
      field: 'reporterName',
      title: '举报人',
      width: 110,
    },
    {
      field: 'resolverName',
      title: '处理人',
      width: 110,
    },
    {
      field: 'reportReasonDetail',
      title: '举报说明',
      minWidth: 160,
      showOverflow: true,
    },
    {
      field: 'remark',
      title: '处置备注',
      minWidth: 180,
      showOverflow: true,
    },
    {
      field: 'createTime',
      title: '时间',
      width: 180,
    },
    {
      field: 'resolvedAt',
      title: '处理时间',
      width: 180,
    },
  ];
}
