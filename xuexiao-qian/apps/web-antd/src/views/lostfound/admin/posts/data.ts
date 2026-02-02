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
          { label: '寻物启事', value: 'LOST' },
          { label: '招领信息', value: 'FOUND' },
        ],
      },
      fieldName: 'postType',
      label: '类型',
    },
    {
      component: 'Select',
      componentProps: {
        allowClear: true,
        options: [
          { label: '草稿', value: 'DRAFT' },
          { label: '待审核', value: 'PENDING' },
          { label: '已发布', value: 'PUBLISHED' },
          { label: '认领中', value: 'CLAIMING' },
          { label: '已结案', value: 'CLOSED' },
          { label: '已拒绝', value: 'REJECTED' },
          { label: '已下架', value: 'OFFLINE' },
        ],
      },
      fieldName: 'status',
      label: '状态',
    },
    {
      component: 'RangePicker',
      fieldName: 'createTime',
      label: '发布时间',
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
      field: 'postType',
      title: '类型',
      width: 100,
      cellRender: {
        name: 'CellTag',
        options: [
          { label: '寻物', value: 'LOST', color: 'red' },
          { label: '招领', value: 'FOUND', color: 'green' },
        ],
      },
    },
    {
      field: 'title',
      title: '物品名称',
      minWidth: 150,
    },
    {
      field: 'categoryName',
      title: '分类',
      width: 100,
    },
    {
      field: 'locationName',
      title: '地点',
      width: 120,
    },
    {
      field: 'createdByName',
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
          { label: '草稿', value: 'DRAFT', color: 'default' },
          { label: '待审核', value: 'PENDING', color: 'orange' },
          { label: '已发布', value: 'PUBLISHED', color: 'blue' },
          { label: '认领中', value: 'CLAIMING', color: 'cyan' },
          { label: '已结案', value: 'CLOSED', color: 'green' },
          { label: '已拒绝', value: 'REJECTED', color: 'red' },
          { label: '已下架', value: 'OFFLINE', color: 'default' },
        ],
      },
    },
    {
      field: 'isTop',
      title: '置顶',
      width: 80,
      cellRender: {
        name: 'CellTag',
        options: [
          { label: '是', value: true, color: 'blue' },
          { label: '否', value: false, color: 'default' },
        ],
      },
    },
    {
      field: 'isRecommend',
      title: '推荐',
      width: 80,
      cellRender: {
        name: 'CellTag',
        options: [
          { label: '是', value: true, color: 'green' },
          { label: '否', value: false, color: 'default' },
        ],
      },
    },
    {
      field: 'viewCount',
      title: '浏览量',
      width: 80,
    },
    {
      field: 'createTime',
      title: '发布时间',
      width: 160,
    },
    {
      align: 'center',
      cellRender: {
        attrs: {
          nameField: 'title',
          nameTitle: '帖子',
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
              row.status === 'PENDING' &&
              hasAccessByCodes(['lostfound:post:audit']),
          },
          {
            code: 'reject',
            text: '拒绝',
            show: (row: any) =>
              row.status === 'PENDING' &&
              hasAccessByCodes(['lostfound:post:audit']),
          },
          {
            code: 'top',
            text: (row: any) => (row.isTop ? '取消置顶' : '置顶'),
            show: () => hasAccessByCodes(['lostfound:post:top']),
          },
          {
            code: 'recommend',
            text: (row: any) => (row.isRecommend ? '取消推荐' : '推荐'),
            show: () => hasAccessByCodes(['lostfound:post:recommend']),
          },
          {
            code: 'offline',
            text: '下架',
            show: (row: any) =>
              row.status === 'PUBLISHED' &&
              hasAccessByCodes(['lostfound:post:offline']),
          },
        ],
      },
      field: 'operation',
      fixed: 'right',
      headerAlign: 'center',
      showOverflow: false,
      title: '操作',
      width: 200,
    },
  ];
}
