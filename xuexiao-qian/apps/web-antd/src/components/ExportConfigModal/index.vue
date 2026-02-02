<script lang="ts" setup>
/**
 * 图表导出配置弹窗
 * Requirements: 14.1, 14.2, 14.3
 */
import type { ECharts } from 'echarts';

import { reactive, ref } from 'vue';

import { Form, Input, message, Modal, Radio, Select } from 'ant-design-vue';

interface Props {
  open: boolean;
  chartInstance?: ECharts | null;
  defaultTitle?: string;
}

interface Emits {
  (e: 'update:open', value: boolean): void;
  (e: 'export', config: ExportConfig): void;
}

interface ExportConfig {
  format: 'pdf' | 'png' | 'svg';
  resolution: 1 | 2 | 4;
  title: string;
  showLegend: boolean;
  showSource: boolean;
  sourceText: string;
}

const props = defineProps<Props>();
const emit = defineEmits<Emits>();

const exporting = ref(false);

const config = reactive<ExportConfig>({
  format: 'png',
  resolution: 2,
  title: props.defaultTitle || '海洋数据图表',
  showLegend: true,
  showSource: true,
  sourceText: '数据来源: 海洋数据质控系统',
});

// 分辨率选项
const resolutionOptions = [
  { label: '1x (标准)', value: 1 },
  { label: '2x (高清)', value: 2 },
  { label: '4x (超高清)', value: 4 },
];

// 格式选项
const formatOptions = [
  { label: 'PNG', value: 'png' },
  { label: 'SVG', value: 'svg' },
  { label: 'PDF', value: 'pdf' },
];

// 关闭弹窗
function handleClose() {
  emit('update:open', false);
}

// 执行导出
async function handleExport() {
  if (!props.chartInstance) {
    message.error('图表实例不存在');
    return;
  }

  exporting.value = true;

  try {
    const chart = props.chartInstance;
    const pixelRatio = config.resolution;

    switch (config.format) {
      case 'pdf': {
        // PDF导出 - 需要额外库支持，这里简化为PNG
        const dataUrl = chart.getDataURL({
          type: 'png',
          pixelRatio,
          backgroundColor: '#fff',
        });
        downloadFile(dataUrl, `${config.title}.png`);
        message.info('PDF导出暂不支持，已导出为PNG格式');

        break;
      }
      case 'png': {
        // PNG导出
        const dataUrl = chart.getDataURL({
          type: 'png',
          pixelRatio,
          backgroundColor: '#fff',
        });
        downloadFile(dataUrl, `${config.title}.png`);

        break;
      }
      case 'svg': {
        // SVG导出
        const svgData = chart.renderToSVGString();
        downloadFile(svgData, `${config.title}.svg`, 'image/svg+xml');

        break;
      }
      // No default
    }

    emit('export', { ...config });
    message.success('导出成功');
    handleClose();
  } catch (error: any) {
    message.error(error?.message || '导出失败');
  } finally {
    exporting.value = false;
  }
}

// 下载文件
function downloadFile(data: string, filename: string, mimeType?: string) {
  const link = document.createElement('a');
  link.download = filename;

  if (data.startsWith('data:')) {
    link.href = data;
  } else {
    const blob = new Blob([data], { type: mimeType || 'text/plain' });
    link.href = URL.createObjectURL(blob);
  }

  document.body.append(link);
  link.click();
  link.remove();
}
</script>

<template>
  <Modal
    :open="open"
    title="导出图表"
    :confirm-loading="exporting"
    @cancel="handleClose"
    @ok="handleExport"
  >
    <Form layout="vertical">
      <Form.Item label="图表标题">
        <Input v-model:value="config.title" placeholder="输入图表标题" />
      </Form.Item>

      <Form.Item label="导出格式">
        <Radio.Group v-model:value="config.format" :options="formatOptions" />
      </Form.Item>

      <Form.Item label="分辨率">
        <Select
          v-model:value="config.resolution"
          :options="resolutionOptions"
          style="width: 200px"
        />
      </Form.Item>

      <Form.Item label="包含内容">
        <div class="flex flex-col gap-2">
          <label class="flex items-center gap-2">
            <input v-model="config.showLegend" type="checkbox" />
            <span>显示图例</span>
          </label>
          <label class="flex items-center gap-2">
            <input v-model="config.showSource" type="checkbox" />
            <span>显示数据来源</span>
          </label>
        </div>
      </Form.Item>

      <Form.Item v-if="config.showSource" label="数据来源">
        <Input
          v-model:value="config.sourceText"
          placeholder="输入数据来源说明"
        />
      </Form.Item>
    </Form>
  </Modal>
</template>
