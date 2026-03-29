export interface OceanData {
  id: string;
  depth: number;
  temperature: null | number;
  salinity: null | number;
  qcFlag: number;
  [key: string]: unknown;
}
