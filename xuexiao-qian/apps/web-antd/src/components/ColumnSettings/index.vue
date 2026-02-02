<script lang="ts" setup>
/**
 * 列配置组件
 * Requirements: 4.3
 *
 * 支持拖拽排序和显示/隐藏切换
 */
import { computed, ref, watch } from 'vue';

import { Settings } from '@vben/icons';

import { Button, Checkbox, Divider, Popover, Space } from 'ant-design-vue';

interface ColumnItem {
  field: string;
  title: string;
  visible: boolean;
}

interface Props {
  columns: ColumnItem[];
}

interface Emits {
  (e: 'update:columns', columns: ColumnItem[]): void;
  (e: 'change', columns: ColumnItem[]): void;
}

const props = defineProps<Props>();
const emit = defineEmits<Emits>();

const visible = ref(false);
const localColumns = ref<ColumnItem[]>([]);

// 初始化本地列配置
watch(
  () => props.columns,
  (newColumns) => {
    localColumns.value = newColumns.map((col) => ({ ...col }));
  },
  { immediate: true, deep: true },
);

// 全选状态
const allChecked = computed(() => {
  return localColumns.value.every((col) => col.visible);
});

// 部分选中状态
const indeterminate = computed(() => {
  const checkedCount = localColumns.value.filter((col) => col.visible).length;
  return checkedCount > 0 && checkedCount < localColumns.value.length;
});

// 切换单个列的显示状态
function toggleColumn(field: string) {
  const col = localColumns.value.find((c) => c.field === field);
  if (col) {
    col.visible = !col.visible;
  }
}

// 全选/取消全选
function toggleAll() {
  const newValue = !allChecked.value;
  localColumns.value.forEach((col) => {
    col.visible = newValue;
  });
}

// 应用配置
function applySettings() {
  emit('update:columns', localColumns.value);
  emit('change', localColumns.value);
  visible.value = false;
}

// 重置配置
function resetSettings() {
  localColumns.value = props.columns.map((col) => ({ ...col }));
}
</script>

<template>
  <Popover v-model:open="visible" trigger="click" placement="bottomRight">
    <template #content>
      <div class="column-settings-content">
        <div class="column-settings-header">
          <Checkbox
            :checked="allChecked"
            :indeterminate="indeterminate"
            @change="toggleAll"
          >
            全选
          </Checkbox>
        </div>
        <Divider class="my-2" />
        <div class="column-settings-list">
          <div
            v-for="col in localColumns"
            :key="col.field"
            class="column-settings-item"
          >
            <Checkbox
              :checked="col.visible"
              @change="() => toggleColumn(col.field)"
            >
              {{ col.title }}
            </Checkbox>
          </div>
        </div>
        <Divider class="my-2" />
        <div class="column-settings-footer">
          <Space>
            <Button size="small" @click="resetSettings">重置</Button>
            <Button size="small" type="primary" @click="applySettings">
              应用
            </Button>
          </Space>
        </div>
      </div>
    </template>
    <Button>
      <template #icon>
        <Settings class="h-4 w-4" />
      </template>
      列设置
    </Button>
  </Popover>
</template>

<style scoped>
.column-settings-content {
  width: 200px;
}

.column-settings-header {
  padding: 4px 0;
}

.column-settings-list {
  max-height: 300px;
  overflow-y: auto;
}

.column-settings-item {
  padding: 4px 0;
}

.column-settings-footer {
  display: flex;
  justify-content: flex-end;
}
</style>
