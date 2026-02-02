import type { VbenFormSchema } from '#/adapter/form';
import type { VxeTableGridOptions } from '#/adapter/vxe-table';

import { useAccess } from '@vben/access';

import { z } from '#/adapter/form';
import { getLocationTree } from '#/api/lostfound/base';

const { hasAccessByCodes } = useAccess();

export function useGridFormSchema(): VbenFormSchema[] {
  return [
    {
      component: 'Input',
      fieldName: 'name',
      label: '地点名称',
    },
    {
      component: 'Select',
      componentProps: {
        allowClear: true,
        options: [
          { label: '已启用', value: 1 },
          { label: '已禁用', value: 0 },
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
          { label: '是', value: 1 },
          { label: '否', value: 0 },
        ],
      },
      fieldName: 'isPickupPoint',
      label: '招领点',
    },
  ];
}

export function useFormSchema(): VbenFormSchema[] {
  return [
    {
      component: 'Input',
      fieldName: 'id',
      label: '地点ID',
      componentProps: {
        disabled: true,
      },
      dependencies: {
        triggerFields: ['id'],
        show: (values) => !!values.id,
      },
    },
    {
      component: 'Input',
      componentProps: {
        placeholder: '请输入地点名称',
      },
      fieldName: 'name',
      label: '地点名称',
      rules: z
        .string()
        .min(1, '地点名称不能为空')
        .max(100, '地点名称最多100个字符'),
    },
    {
      component: 'ApiTreeSelect',
      componentProps: {
        allowClear: true,
        api: getLocationTree,
        labelField: 'name',
        valueField: 'id',
        childrenField: 'children',
        placeholder: '请选择上级地点',
      },
      fieldName: 'parentId',
      label: '上级地点',
    },
    {
      component: 'Input',
      componentProps: {
        placeholder: '请输入详细地址',
      },
      fieldName: 'address',
      label: '详细地址',
    },
    {
      component: 'RadioGroup',
      componentProps: {
        buttonStyle: 'solid',
        options: [
          { label: '是', value: 1 },
          { label: '否', value: 0 },
        ],
        optionType: 'button',
      },
      defaultValue: 0,
      fieldName: 'isPickupPoint',
      label: '招领点',
    },
    {
      component: 'InputNumber',
      componentProps: {
        min: 0,
        placeholder: '请输入排序号',
      },
      defaultValue: 0,
      fieldName: 'sort',
      label: '排序',
    },
    {
      component: 'RadioGroup',
      componentProps: {
        buttonStyle: 'solid',
        options: [
          { label: '已启用', value: 1 },
          { label: '已禁用', value: 0 },
        ],
        optionType: 'button',
      },
      defaultValue: 1,
      fieldName: 'status',
      label: '状态',
    },
    {
      component: 'Textarea',
      componentProps: {
        maxLength: 200,
        rows: 3,
        showCount: true,
        placeholder: '请输入备注',
      },
      fieldName: 'remark',
      label: '备注',
    },
  ];
}

export function useColumns(
  onActionClick?: (params: { code: string; row: any }) => void,
): VxeTableGridOptions['columns'] {
  return [
    {
      align: 'left',
      field: 'name',
      fixed: 'left',
      title: '地点名称',
      treeNode: true,
      minWidth: 200,
    },
    {
      field: 'address',
      title: '详细地址',
      minWidth: 150,
    },
    {
      cellRender: {
        name: 'CellTag',
        options: [
          { label: '是', value: 1, color: 'green' },
          { label: '否', value: 0, color: 'default' },
        ],
      },
      field: 'isPickupPoint',
      title: '招领点',
      width: 80,
    },
    {
      field: 'sort',
      title: '排序',
      width: 80,
    },
    {
      cellRender: {
        name: 'CellTag',
        options: [
          { label: '已启用', value: 1, color: 'success' },
          { label: '已禁用', value: 0, color: 'error' },
        ],
      },
      field: 'status',
      title: '状态',
      width: 100,
    },
    {
      field: 'createTime',
      title: '创建时间',
      width: 160,
    },
    {
      align: 'right',
      cellRender: {
        attrs: {
          nameField: 'name',
          nameTitle: '地点',
          onClick: onActionClick,
        },
        name: 'CellOperation',
        options: [
          {
            code: 'append',
            text: '新增下级',
            show: () => hasAccessByCodes(['lostfound:location:add']),
          },
          {
            code: 'edit',
            text: '编辑',
            show: () => hasAccessByCodes(['lostfound:location:edit']),
          },
          {
            code: 'delete',
            text: '删除',
            show: () => hasAccessByCodes(['lostfound:location:delete']),
            disabled: (row: any) => !!(row.children && row.children.length > 0),
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
