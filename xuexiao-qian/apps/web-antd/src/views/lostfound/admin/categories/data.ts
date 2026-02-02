import type { VbenFormSchema } from '#/adapter/form';
import type { VxeTableGridOptions } from '#/adapter/vxe-table';

import { useAccess } from '@vben/access';

import { z } from '#/adapter/form';
import { getCategoryTree } from '#/api/lostfound/base';

const { hasAccessByCodes } = useAccess();

export function useGridFormSchema(): VbenFormSchema[] {
  return [
    {
      component: 'Input',
      fieldName: 'name',
      label: '分类名称',
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
  ];
}

export function useFormSchema(): VbenFormSchema[] {
  return [
    {
      component: 'Input',
      fieldName: 'id',
      label: '分类ID',
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
        placeholder: '请输入分类名称',
      },
      fieldName: 'name',
      label: '分类名称',
      rules: z
        .string()
        .min(1, '分类名称不能为空')
        .max(50, '分类名称最多50个字符'),
    },
    {
      component: 'ApiTreeSelect',
      componentProps: {
        allowClear: true,
        api: getCategoryTree,
        labelField: 'name',
        valueField: 'id',
        childrenField: 'children',
        placeholder: '请选择上级分类',
      },
      fieldName: 'parentId',
      label: '上级分类',
    },
    {
      component: 'Input',
      componentProps: {
        placeholder: '请输入图标名称',
      },
      fieldName: 'icon',
      label: '图标',
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
      title: '分类名称',
      treeNode: true,
      minWidth: 200,
    },
    {
      field: 'icon',
      title: '图标',
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
          nameTitle: '分类',
          onClick: onActionClick,
        },
        name: 'CellOperation',
        options: [
          {
            code: 'append',
            text: '新增下级',
            show: () => hasAccessByCodes(['lostfound:category:add']),
          },
          {
            code: 'edit',
            text: '编辑',
            show: () => hasAccessByCodes(['lostfound:category:edit']),
          },
          {
            code: 'delete',
            text: '删除',
            show: () => hasAccessByCodes(['lostfound:category:delete']),
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
