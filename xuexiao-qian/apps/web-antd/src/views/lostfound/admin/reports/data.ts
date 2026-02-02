import type { VbenFormSchema } from '#/adapter/form';
import type { VxeTableGridOptions } from '#/adapter/vxe-table';

import { useAccess } from '@vben/access';

const { hasAccessByCodes } = useAccess();

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
        ],
      },
      fieldName: 'targetType',
      label: '举报类型',
    },
    {
      component: 'Select',
      componentProps: {
        allowClear: true,
        options: [
          { label: '待处理', value: 'PENDING' },
          { label: '已处理', value: 'RESOLVED' },
          { label: '已驳回', value: 'REJECTED' },
        ],
      },
      fieldName: 'status',
      label: '状态',
    },
    {
      component: 'Select',
      componentProps: {
        allowClear: true,
        options: [
          { label: '警告', value: 'warning' },
          { label: '删除内容', value: 'offline_post' },
          { label: '禁言', value: 'mute' },
          { label: '封禁账号', value: 'ban_user' },
        ],
      },
      fieldName: 'resolveAction',
      label: '处理动作',
    },
    {
      component: 'RangePicker',
      fieldName: 'createTime',
      label: '举报时间',
    },
  ];
}

export function useColumns(
  onActionClick?: (params: { code: string; row: any }) => void,
): VxeTableGridOptions['columns'] {
  return [
    {
      type: 'seq',
      title: '序号',
      width: 60,
    },
    {
      field: 'targetType',
      title: '举报类型',
      width: 100,
      cellRender: {
        name: 'CellTag',
        options: [
          { label: '帖子', value: 'POST', color: 'blue' },
          { label: '评论', value: 'COMMENT', color: 'cyan' },
          { label: '用户', value: 'USER', color: 'orange' },
        ],
      },
    },
    {
      field: 'targetTitle',
      title: '被举报内容',
      minWidth: 150,
      showOverflow: true,
    },
    {
      field: 'reporterName',
      title: '举报人',
      width: 100,
    },
    {
      field: 'reasonDetail',
      title: '举报原因',
      minWidth: 200,
      showOverflow: true,
    },
    {
      field: 'status',
      title: '状态',
      width: 100,
      cellRender: {
        name: 'CellTag',
        options: [
          { label: '待处理', value: 'PENDING', color: 'orange' },
          { label: '已处理', value: 'RESOLVED', color: 'green' },
          { label: '已驳回', value: 'REJECTED', color: 'default' },
        ],
      },
    },
    {
      field: 'resolveAction',
      title: '处理动作',
      width: 120,
      cellRender: {
        name: 'CellTag',
        options: [
          { label: '警告', value: 'warning', color: 'blue' },
          { label: '删除内容', value: 'offline_post', color: 'red' },
          { label: '禁言', value: 'mute', color: 'orange' },
          { label: '封禁账号', value: 'ban_user', color: 'red' },
        ],
      },
    },
    {
      field: 'createTime',
      title: '举报时间',
      width: 160,
    },
    {
      align: 'center',
      cellRender: {
        attrs: {
          nameField: 'reason',
          nameTitle: '举报',
          onClick: onActionClick,
        },
        name: 'CellOperation',
        options: [
          {
            code: 'view',
            text: '查看',
          },
          {
            code: 'resolve',
            text: '处理',
            show: (row: any) =>
              row.status === 'PENDING' &&
              hasAccessByCodes(['lostfound:report:handle']),
          },
          {
            code: 'reject',
            text: '驳回',
            show: (row: any) =>
              row.status === 'PENDING' &&
              hasAccessByCodes(['lostfound:report:handle']),
          },
        ],
      },
      field: 'operation',
      fixed: 'right',
      headerAlign: 'center',
      showOverflow: false,
      title: '操作',
      width: 150,
    },
  ];
}
