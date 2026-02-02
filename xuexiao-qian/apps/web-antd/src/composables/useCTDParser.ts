import type {
  CTDMetadata,
  CTDParseError,
  CTDParseResult,
  SensorConfig,
} from '#/api/ocean/file/types/ctd.types';

import { ref } from 'vue';

/**
 * CTD文件解析器Hook
 * Requirements: 1.1, 1.2, 1.3, 1.4
 *
 * 解析CTD仪器原始数据文件（如SBE格式）
 */

/**
 * CTD文件解析器Hook
 */
export function useCTDParser() {
  const metadata = ref<CTDMetadata | null>(null);
  const loading = ref(false);

  /**
   * 解析CTD文件（接受File对象）
   */
  async function parse(file: File): Promise<CTDParseResult | null> {
    loading.value = true;
    try {
      const content = await file.text();
      const result = parseContent(content);
      metadata.value = result.metadata;
      return result;
    } catch (error) {
      console.error('CTD文件解析失败:', error);
      return null;
    } finally {
      loading.value = false;
    }
  }

  /**
   * 解析CTD文件内容
   * Property 1: CTD文件解析正确性
   */
  function parseContent(content: string): CTDParseResult {
    const lines = content.split('\n');
    const errors: CTDParseError[] = [];

    // 查找 *END* 标记，分离头部和数据区域
    const endIndex = lines.findIndex((line) => line.trim().includes('*END*'));

    if (endIndex === -1) {
      errors.push({
        line: 0,
        message: '未找到 *END* 标记，无法分离头部和数据区域',
      });
      return {
        metadata: createEmptyMetadata(),
        columns: [],
        data: [],
        errors,
      };
    }

    // 解析头部元数据
    const headerLines = lines.slice(0, endIndex);
    const metadata = extractMetadata(headerLines);

    // 推断列名
    const columns = inferColumnNames(metadata);

    // 解析数据行
    const dataLines = lines.slice(endIndex + 1).filter((l) => l.trim());
    const data = parseDataLines(dataLines, errors, endIndex + 1);

    return {
      metadata,
      columns,
      data,
      errors,
    };
  }

  /**
   * 提取元数据
   * Property 2: CTD元数据提取完整性
   */
  function extractMetadata(headerLines: string[]): CTDMetadata {
    const rawHeader = headerLines.join('\n');
    const metadata: CTDMetadata = {
      id: '',
      fileId: '',
      rawHeader,
      createdAt: new Date().toISOString(),
    };

    // 提取仪器类型
    const instrumentMatch = rawHeader.match(
      /<InstrumentType>([^<]+)<\/InstrumentType>/i,
    );
    if (instrumentMatch && instrumentMatch[1]) {
      metadata.instrumentType = instrumentMatch[1].trim();
    }

    // 提取序列号
    const serialMatch = rawHeader.match(
      /<SerialNumber>([^<]+)<\/SerialNumber>/i,
    );
    if (serialMatch && serialMatch[1]) {
      metadata.serialNumber = serialMatch[1].trim();
    }

    // 提取软件版本
    const softwareMatch = rawHeader.match(/# datcnv_date = ([^\n]+)/i);
    if (softwareMatch && softwareMatch[1]) {
      metadata.dataConversionDate = softwareMatch[1].trim();
    }

    // 提取传感器配置
    metadata.sensorConfig = extractSensorConfigs(rawHeader);

    // 提取校准系数
    metadata.calibrationCoefficients =
      extractCalibrationCoefficients(rawHeader);

    return metadata;
  }

  /**
   * 提取传感器配置
   */
  function extractSensorConfigs(rawHeader: string): SensorConfig[] {
    const configs: SensorConfig[] = [];

    // 匹配传感器配置块
    const sensorRegex = /<Sensor index="(\d+)"[^>]*>[\s\S]*?<\/Sensor>/gi;
    let match;

    while ((match = sensorRegex.exec(rawHeader)) !== null) {
      const sensorBlock = match[0];
      const channelStr = match[1] || '0';
      const channel = Number.parseInt(channelStr, 10);

      // 提取传感器类型
      const typeMatch = sensorBlock.match(/<(\w+SensorID)>/);
      const sensorType =
        typeMatch && typeMatch[1]
          ? typeMatch[1].replace('SensorID', '')
          : 'Unknown';

      // 提取序列号
      const snMatch = sensorBlock.match(
        /<SerialNumber>([^<]+)<\/SerialNumber>/i,
      );
      const serialNumber = snMatch && snMatch[1] ? snMatch[1].trim() : '';

      // 提取校准日期
      const calDateMatch = sensorBlock.match(
        /<CalibrationDate>([^<]+)<\/CalibrationDate>/i,
      );
      const calibrationDate =
        calDateMatch && calDateMatch[1] ? calDateMatch[1].trim() : '';

      configs.push({
        channel,
        sensorType,
        sensorId: `${sensorType}_${channel}`,
        serialNumber,
        calibrationDate,
      });
    }

    return configs;
  }

  /**
   * 提取校准系数
   */
  function extractCalibrationCoefficients(
    rawHeader: string,
  ): Record<string, number> {
    const coefficients: Record<string, number> = {};

    // 匹配常见的校准系数模式
    const coeffPatterns = [
      /<([A-Z]\d*)>([+-]?\d+(?:\.\d*)?(?:e[+-]?\d+)?)<\/\1>/gi,
      /# ([a-z_]+) = ([+-]?\d+\.?\d*(?:e[+-]?\d+)?)/gi,
    ];

    for (const pattern of coeffPatterns) {
      let match;
      while ((match = pattern.exec(rawHeader)) !== null) {
        const key = match[1];
        const valueStr = match[2];
        if (key && valueStr) {
          const value = Number.parseFloat(valueStr);
          if (!isNaN(value)) {
            coefficients[key] = value;
          }
        }
      }
    }

    return coefficients;
  }

  /**
   * 解析数据行
   */
  function parseDataLines(
    dataLines: string[],
    errors: CTDParseError[],
    startLineNumber: number,
  ): number[][] {
    const data: number[][] = [];

    for (const [i, rawLine] of dataLines.entries()) {
      if (!rawLine) continue;
      const line = rawLine.trim();
      if (!line) continue;

      // 空格分隔的数值数据
      const values = line.split(/\s+/).map((v) => {
        const num = Number.parseFloat(v);
        return isNaN(num) ? 0 : num;
      });

      if (values.length > 0) {
        data.push(values);
      } else {
        errors.push({
          line: startLineNumber + i + 1,
          message: `无法解析数据行: ${line.slice(0, 50)}...`,
        });
      }
    }

    return data;
  }

  /**
   * 推断列名
   */
  function inferColumnNames(metadata: CTDMetadata): string[] {
    // 默认CTD列名顺序（基于常见SBE格式）
    const defaultColumns = [
      'scan', // 扫描序号
      'temperature1', // 温度1
      'temperature2', // 温度2
      'conductivity1', // 电导率1
      'conductivity2', // 电导率2
      'pressure', // 压力/深度
      'fluorescence', // 荧光
      'oxygen', // 溶解氧
      'salinity', // 盐度
      'density', // 密度
      'soundSpeed', // 声速
    ];

    // 如果有传感器配置，尝试根据配置推断
    if (metadata.sensorConfig && metadata.sensorConfig.length > 0) {
      const columns: string[] = [];
      for (const sensor of metadata.sensorConfig) {
        const type = sensor.sensorType.toLowerCase();
        if (type.includes('temp')) {
          columns.push(
            `temperature${columns.filter((c) => c.includes('temperature')).length + 1}`,
          );
        } else if (type.includes('cond')) {
          columns.push(
            `conductivity${columns.filter((c) => c.includes('conductivity')).length + 1}`,
          );
        } else if (type.includes('press')) {
          columns.push('pressure');
        } else if (type.includes('fluor')) {
          columns.push('fluorescence');
        } else if (type.includes('oxygen')) {
          columns.push('oxygen');
        } else {
          columns.push(type);
        }
      }
      return columns.length > 0 ? columns : defaultColumns;
    }

    return defaultColumns;
  }

  /**
   * 创建空的元数据对象
   */
  function createEmptyMetadata(): CTDMetadata {
    return {
      id: '',
      fileId: '',
      createdAt: new Date().toISOString(),
    };
  }

  return {
    parse,
    parseContent,
    extractMetadata,
    parseDataLines,
    inferColumnNames,
    metadata,
    loading,
  };
}

export default useCTDParser;
