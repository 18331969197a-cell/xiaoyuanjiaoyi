import type { VbenFormSchema } from '#/adapter/form';
import type { VxeTableGridOptions } from '#/adapter/vxe-table';

export function useGridFormSchema(): VbenFormSchema[] {
  return [
    {
      component: 'Input',
      fieldName: 'userId',
      label: '用户ID',
    },
    {
      component: 'RangePicker',
      fieldName: 'operationTime',
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
      field: 'userId',
      title: '用户ID',
      width: 100,
    },
    {
      field: 'title',
      title: '标题',
      minWidth: 140,
    },
    {
      field: 'operationType',
      title: '类型',
      width: 120,
      cellRender: {
        name: 'CellTag',
        options: [{ label: '风险告警', value: 'RISK_ALERT', color: 'red' }],
      },
    },
    {
      field: 'autoAction',
      title: '自动处置',
      width: 120,
      cellRender: {
        name: 'CellTag',
        options: [
          { label: '自动限流', value: 'RATE_LIMIT', color: 'orange' },
          { label: '自动封禁', value: 'BAN', color: 'red' },
          { label: '观察', value: 'WATCH', color: 'default' },
        ],
      },
    },
    {
      field: 'operationIp',
      title: 'IP',
      width: 140,
    },
    {
      field: 'operationRegion',
      title: '地区',
      width: 140,
    },
    {
      field: 'operationTime',
      title: '时间',
      width: 180,
    },
  ];
}
