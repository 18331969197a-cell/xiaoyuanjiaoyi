import type { OceanData } from '#/api/ocean/data/types/data.types';

/**
 * 行高亮Hook
 * Requirements: 3.1, 3.2, 3.3, 3.4, 17.1
 *
 * 根据数据的QC标志和缺失状态返回对应的CSS类名
 */

/**
 * 行高亮配置
 */
export interface RowHighlightConfig {
  /** 可疑数据颜色 (qcFlag = 1) */
  suspicious: string;
  /** 异常数据颜色 (qcFlag = 2) */
  abnormal: string;
  /** 缺失数据颜色 (qcFlag = 3) */
  missing: string;
  /** 已修复数据颜色 (qcFlag = 4) */
  repaired: string;
  /** 空值数据颜色 */
  nullValue: string;
}

/**
 * 行高亮结果
 */
export interface RowHighlightResult {
  /** 获取行CSS类名的函数 */
  rowClassName: (params: { row: OceanData }) => string;
  /** 获取状态tooltip的函数 */
  getStatusTooltip: (qcFlag: number, hasNullValue?: boolean) => string;
  /** 高亮配置 */
  highlightConfig: RowHighlightConfig;
}

/**
 * 默认高亮配置
 */
const defaultConfig: RowHighlightConfig = {
  suspicious: 'row-suspicious',
  abnormal: 'row-abnormal',
  missing: 'row-missing',
  repaired: 'row-repaired',
  nullValue: 'row-null-value',
};

/**
 * QC标志对应的状态说明
 */
const qcFlagTooltips: Record<number, string> = {
  0: '正常数据',
  1: '可疑数据 - 数据值可能存在问题，需要进一步检查',
  2: '异常数据 - 数据值明显异常，建议修复',
  3: '缺失数据 - 数据缺失或无效',
  4: '已修复数据 - 数据已经过修复处理',
};

/**
 * 行高亮Hook
 * @param config 自定义高亮配置
 * @returns 行高亮相关函数和配置
 */
export function useRowHighlight(
  config?: Partial<RowHighlightConfig>,
): RowHighlightResult {
  const highlightConfig: RowHighlightConfig = {
    ...defaultConfig,
    ...config,
  };

  /**
   * 获取行CSS类名
   * Property 3: 行高亮规则一致性
   */
  const rowClassName = ({ row }: { row: OceanData }): string => {
    // 首先检查是否有空值（温度或盐度为空）
    if (
      row.temperature === null ||
      row.temperature === undefined ||
      row.salinity === null ||
      row.salinity === undefined
    ) {
      return highlightConfig.nullValue;
    }

    // 根据QC标志返回对应类名
    switch (row.qcFlag) {
      case 1: {
        return highlightConfig.suspicious;
      }
      case 2: {
        return highlightConfig.abnormal;
      }
      case 4: {
        return highlightConfig.repaired;
      }
      default: {
        return '';
      }
    }
  };

  /**
   * 获取状态tooltip说明
   */
  const getStatusTooltip = (qcFlag: number, hasNullValue?: boolean): string => {
    if (hasNullValue) {
      return '数据存在缺失值（温度或盐度为空）';
    }
    return qcFlagTooltips[qcFlag] || '未知状态';
  };

  return {
    rowClassName,
    getStatusTooltip,
    highlightConfig,
  };
}

export default useRowHighlight;
