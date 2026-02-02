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
          { label: '待审核', value: 'PENDING' },
          { label: '已通过', value: 'PUBLISHED' },
          { label: '已拒绝', value: 'REJECTED' },
        ],
      },
      fieldName: 'status',
      label: '状态',
    },
    {
      component: 'RangePicker',
      fieldName: 'createTime',
      label: '评论时间',
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
      title: '所属帖子',
      width: 150,
    },
    {
      field: 'userName',
      title: '评论者',
      width: 100,
    },
    {
      field: 'content',
      title: '评论内容',
      minWidth: 250,
      showOverflow: true,
    },
    {
      field: 'status',
      title: '状态',
      width: 100,
      cellRender: {
        name: 'CellTag',
        options: [
          { label: '待审核', value: 'PENDING', color: 'orange' },
          { label: '已通过', value: 'PUBLISHED', color: 'green' },
          { label: '已拒绝', value: 'REJECTED', color: 'red' },
        ],
      },
    },
    {
      field: 'createTime',
      title: '评论时间',
      width: 160,
    },
    {
      align: 'center',
      cellRender: {
        attrs: {
          nameField: 'content',
          nameTitle: '评论',
          onClick: onActionClick,
        },
        name: 'CellOperation',
        options: [
          {
            code: 'approve',
            text: '通过',
            show: (row: any) =>
              row.status === 'PENDING' &&
              hasAccessByCodes(['lostfound:comment:audit']),
          },
          {
            code: 'reject',
            text: '拒绝',
            show: (row: any) =>
              row.status === 'PENDING' &&
              hasAccessByCodes(['lostfound:comment:audit']),
          },
          {
            code: 'delete',
            text: '删除',
            show: () => hasAccessByCodes(['lostfound:comment:delete']),
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
