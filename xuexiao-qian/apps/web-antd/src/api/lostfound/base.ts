import { requestClient } from '#/api/request';

// 分类类型
export interface BizCategory {
  id?: number;
  parentId?: number;
  name?: string;
  icon?: string;
  sort?: number;
  status?: number;
  createTime?: string;
  updateTime?: string;
  // 子分类
  children?: BizCategory[];
}

// 地点类型
export interface BizLocation {
  id?: number;
  parentId?: number;
  name?: string;
  fullPath?: string;
  sort?: number;
  status?: number;
  isPickupPoint?: number;
  openTime?: string;
  contact?: string;
  createTime?: string;
  updateTime?: string;
  // 子地点
  children?: BizLocation[];
}

// ========== 分类接口 ==========

/**
 * 分类筛选参数
 */
export interface CategoryQueryParams {
  name?: string;
  status?: number;
}

/**
 * 获取分类树
 */
async function getCategoryTree(params?: CategoryQueryParams) {
  return requestClient.get<BizCategory[]>('/lostfound/category/tree', {
    params,
  });
}

/**
 * 获取所有分类列表
 */
async function getCategoryList() {
  return requestClient.get<BizCategory[]>('/lostfound/category/list');
}

/**
 * 获取分类详情
 */
async function getCategoryById(id: number) {
  return requestClient.get<BizCategory>(`/lostfound/category/${id}`);
}

/**
 * 创建分类
 */
async function createCategory(data: BizCategory) {
  return requestClient.post<number>('/lostfound/category', data);
}

/**
 * 更新分类
 */
async function updateCategory(data: BizCategory) {
  return requestClient.put('/lostfound/category', data);
}

/**
 * 删除分类
 */
async function deleteCategory(id: number) {
  return requestClient.delete(`/lostfound/category/${id}`);
}

/**
 * 更新分类状态
 */
async function updateCategoryStatus(id: number, status: number) {
  return requestClient.put(`/lostfound/category/${id}/status/${status}`);
}

// ========== 地点接口 ==========

/**
 * 地点筛选参数
 */
export interface LocationQueryParams {
  name?: string;
  status?: number;
  isPickupPoint?: number;
}

/**
 * 获取地点树
 */
async function getLocationTree(params?: LocationQueryParams) {
  return requestClient.get<BizLocation[]>('/lostfound/location/tree', {
    params,
  });
}

/**
 * 获取所有地点列表
 */
async function getLocationList() {
  return requestClient.get<BizLocation[]>('/lostfound/location/list');
}

/**
 * 获取招领点列表
 */
async function getPickupPoints() {
  return requestClient.get<BizLocation[]>('/lostfound/location/pickup-points');
}

/**
 * 获取地点详情
 */
async function getLocationById(id: number) {
  return requestClient.get<BizLocation>(`/lostfound/location/${id}`);
}

/**
 * 创建地点
 */
async function createLocation(data: BizLocation) {
  return requestClient.post<number>('/lostfound/location', data);
}

/**
 * 更新地点
 */
async function updateLocation(data: BizLocation) {
  return requestClient.put('/lostfound/location', data);
}

/**
 * 删除地点
 */
async function deleteLocation(id: number) {
  return requestClient.delete(`/lostfound/location/${id}`);
}

/**
 * 更新地点状态
 */
async function updateLocationStatus(id: number, status: number) {
  return requestClient.put(`/lostfound/location/${id}/status/${status}`);
}

/**
 * 设置招领点
 */
async function setPickupPoint(
  id: number,
  isPickupPoint: number,
  openTime?: string,
  contact?: string,
) {
  return requestClient.put(`/lostfound/location/${id}/pickup-point`, null, {
    params: { isPickupPoint, openTime, contact },
  });
}

// ========== 管理端别名 ==========

/**
 * 添加分类（别名）
 */
const addCategory = createCategory;

/**
 * 添加地点（别名）
 */
const addLocation = createLocation;

export {
  addCategory,
  addLocation,
  createCategory,
  createLocation,
  deleteCategory,
  deleteLocation,
  getCategoryById,
  getCategoryList,
  getCategoryTree,
  getLocationById,
  getLocationList,
  getLocationTree,
  getPickupPoints,
  setPickupPoint,
  updateCategory,
  updateCategoryStatus,
  updateLocation,
  updateLocationStatus,
};
