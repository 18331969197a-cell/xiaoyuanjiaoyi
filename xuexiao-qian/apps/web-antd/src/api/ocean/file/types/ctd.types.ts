export interface SensorConfig {
  calibrationDate?: string;
  channel: number;
  sensorId: string;
  sensorType: string;
  serialNumber?: string;
}

export interface CTDMetadata {
  calibrationCoefficients?: Record<string, number>;
  createdAt: string;
  dataConversionDate?: string;
  fileId: string;
  id: string;
  instrumentType?: string;
  rawHeader?: string;
  sensorConfig?: SensorConfig[];
  serialNumber?: string;
}

export interface CTDParseError {
  line: number;
  message: string;
}

export interface CTDParseResult {
  columns: string[];
  data: number[][];
  errors: CTDParseError[];
  metadata: CTDMetadata;
}
