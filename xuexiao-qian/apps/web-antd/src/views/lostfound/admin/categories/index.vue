<script lang="ts" setup>
import type { VxeTableGridOptions } from '#/adapter/vxe-table';

import { computed, ref } from 'vue';

import { useAccess } from '@vben/access';
import { Page, useVbenModal } from '@vben/common-ui';
import { Plus } from '@vben/icons';

import { Button, message, Modal } from 'ant-design-vue';

import { useVbenForm } from '#/adapter/form';
import { useVbenVxeGrid } from '#/adapter/vxe-table';
import {
  addCategory,
  deleteCategory,
  getCategoryTree,
  updateCategory,
} from '#/api/lostfound/base';

import { useColumns, useFormSchema, useGridFormSchema } from './data';

const { hasAccessByCodes } = useAccess();

const formData = ref<any>({});
const getTitle = computed(() => {
  return formData.value?.id ? '修改分类' : '新增分类';
});

const [Form, formApi] = useVbenForm({
  layout: 'vertical',
  schema: useFormSchema(),
  showDefaultActions: false,
});

const [FormModal, modalApi] = useVbenModal({
  async onConfirm() {
    const { valid } = await formApi.validate();
    if (valid) {
      modalApi.lock();
      const data = await formApi.getValues();
      try {
        await (formData.value?.id ? updateCategory(data) : addCategory(data));
        await modalApi.close();
        gridApi.query();
      } finally {
        modalApi.lock(false);
      }
    }
  },
  onOpenChange(isOpen) {
    if (isOpen) {
      const data = modalApi.getData<any>();
      if (data) {
        formData.value = data;
        formApi.setValues(data);
      }
    }
  },
});

const [Grid, gridApi] = useVbenVxeGrid({
  formOptions: {
    schema: useGridFormSchema(),
    submitOnChange: true,
  },
  gridOptions: {
    columns: useColumns(onActionClick),
    height: 'auto',
    keepSource: true,
    pagerConfig: {
      enabled: false,
    },
    proxyConfig: {
      ajax: {
        query: async (_params: any, formValues: any) => {
          return await getCategoryTree(formValues);
        },
      },
    },
    rowConfig: {
      keyField: 'id',
    },
    toolbarConfig: {
      custom: true,
      export: false,
      refresh: true,
      search: true,
      zoom: true,
    },
    treeConfig: {
      parentField: 'parentId',
      rowField: 'id',
      childrenField: 'children',
    },
  } as VxeTableGridOptions,
});

function onActionClick({ code, row }: { code: string; row: any }) {
  switch (code) {
    case 'append': {
      onAppend(row);
      break;
    }
    case 'delete': {
      onDelete(row);
      break;
    }
    case 'edit': {
      onEdit(row);
      break;
    }
  }
}

function onCreate() {
  formData.value = {};
  modalApi.setData(null);
  formApi.resetForm();
  modalApi.open();
}

function onEdit(row: any) {
  formData.value = row;
  modalApi.setData(row);
  modalApi.open();
}

function onAppend(row: any) {
  formData.value = { parentId: row.id };
  modalApi.setData({ parentId: row.id });
  modalApi.open();
}

function onDelete(row: any) {
  Modal.confirm({
    title: '删除确认',
    content: `确定删除分类「${row.name}」吗？`,
    okType: 'danger',
    async onOk() {
      try {
        await deleteCategory(row.id);
        message.success('删除成功');
        gridApi.query();
      } catch {
        message.error('删除失败');
      }
    },
  });
}

function expandAll() {
  gridApi.grid?.setAllTreeExpand(true);
}

function collapseAll() {
  gridApi.grid?.setAllTreeExpand(false);
}
</script>

<template>
  <Page auto-content-height>
    <FormModal :title="getTitle">
      <Form class="mx-4" />
    </FormModal>

    <Grid table-title="分类管理">
      <template #toolbar-tools>
        <Button
          v-if="hasAccessByCodes(['lostfound:category:add'])"
          type="primary"
          @click="onCreate"
        >
          <Plus class="size-5" />
          新增分类
        </Button>
        <span class="mx-2"></span>
        <Button type="default" @click="expandAll">展开全部</Button>
        <span class="mx-1"></span>
        <Button type="default" @click="collapseAll">折叠全部</Button>
      </template>
    </Grid>
  </Page>
</template>
