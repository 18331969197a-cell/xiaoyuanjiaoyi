import type { VbenFormSchema } from '#/adapter/form';
import type { VxeTableGridOptions } from '#/adapter/vxe-table';

import { useAccess } from '@vben/access';

const { hasAccessByCodes } = useAccess();

export function useGridFormSchema(): VbenFormSchema[] {
  return [
    {
      component: 'Input',
      fieldName: 'keyword',
      label: '关键词',
    },
    {
      component: 'Select',
      componentProps: {
        allowClear: true,
        options: [
          { label: '待审核', value: 'APPLIED' },
          { label: '已通过', value: 'APPROVED' },
          { label: '已拒绝', value: 'REJECTED' },
          { label: '交接中', value: 'IN_HANDOVER' },
          { label: '已完成', value: 'COMPLETED' },
          { label: '已取消', value: 'CANCELLED' },
        ],
      },
      fieldName: 'status',
      label: '状态',
    },
    {
      component: 'RangePicker',
      fieldName: 'createTime',
      label: '申请时间',
    },
  ];
}

export function useColumns(
  onActionClick?: (params: { code: string; row: any }) => void,
): VxeTableGridOptions['columns'] {
  return [
    {
      align: 'left',
      title: 'ID',
      type: 'checkbox',
      width: 80,
      fixed: 'left',
    },
    {
      field: 'postTitle',
      title: '物品名称',
      minWidth: 150,
    },
    {
      field: 'claimantName',
      title: '认领者',
      width: 100,
    },
    {
      field: 'posterName',
      title: '发布者',
      width: 100,
    },
    {
      field: 'status',
      title: '状态',
      width: 100,
      cellRender: {
        name: 'CellTag',
        options: [
          { label: '待审核', value: 'APPLIED', color: 'orange' },
          { label: '已通过', value: 'APPROVED', color: 'blue' },
          { label: '已拒绝', value: 'REJECTED', color: 'red' },
          { label: '交接中', value: 'IN_HANDOVER', color: 'cyan' },
          { label: '已完成', value: 'COMPLETED', color: 'green' },
          { label: '已取消', value: 'CANCELLED', color: 'default' },
        ],
      },
    },
    {
      field: 'proofText',
      title: '认领说明',
      minWidth: 200,
      showOverflow: true,
    },
    {
      field: 'createTime',
      title: '申请时间',
      width: 160,
    },
    {
      align: 'center',
      cellRender: {
        attrs: {
          nameField: 'postTitle',
          nameTitle: '认领',
          onClick: onActionClick,
        },
        name: 'CellOperation',
        options: [
          {
            code: 'view',
            text: '查看',
          },
          {
            code: 'approve',
            text: '通过',
            show: (row: any) =>
              row.status === 'APPLIED' &&
              hasAccessByCodes(['lostfound:claim:audit']),
          },
          {
            code: 'reject',
            text: '拒绝',
            show: (row: any) =>
              row.status === 'APPLIED' &&
              hasAccessByCodes(['lostfound:claim:audit']),
          },
          {
            code: 'complete',
            text: '强制完成',
            show: (row: any) =>
              row.status === 'IN_HANDOVER' &&
              hasAccessByCodes(['lostfound:claim:complete']),
          },
        ],
      },
      field: 'operation',
      fixed: 'right',
      headerAlign: 'center',
      showOverflow: false,
      title: '操作',
      width: 180,
    },
  ];
}
