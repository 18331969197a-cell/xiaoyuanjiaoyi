import type { UserPreferences } from '#/api/ocean/user/types/preferences.types';

import { onMounted, ref, watch } from 'vue';

import {
  getPreferences,
  resetPreferences as resetPreferencesApi,
  savePreferences as savePreferencesApi,
} from '#/api/ocean/user/preferences';

/**
 * 用户偏好Hook
 * Requirements: AC-003.1, AC-003.2, AC-003.3, AC-003.4
 *
 * 管理用户偏好配置，支持本地存储和服务端同步
 * Property 5: 用户偏好持久化往返一致性
 */

/**
 * 默认偏好配置
 */
const defaultPreferences: UserPreferences = {
  dataListColumns: [
    'id',
    'stationName',
    'time',
    'depth',
    'temperature',
    'salinity',
    'qcFlag',
  ],
  profileSettings: {
    showTemperature: true,
    showSalinity: true,
    selectedLayer: 'original',
  },
  exportSettings: {
    format: 'csv',
    fields: ['time', 'depth', 'temperature', 'salinity'],
  },
};

/**
 * 本地存储键前缀
 */
const STORAGE_PREFIX = 'ocean_user_pref_';

/**
 * 防抖保存定时器
 */
let saveDebounceTimer: null | ReturnType<typeof setTimeout> = null;

/**
 * 用户偏好Hook
 * @param key 偏好配置键
 * @param options 配置选项
 * @returns 偏好配置相关函数和状态
 */
export function useUserPreferences(
  key: string,
  options: {
    autoLoad?: boolean;
    autoSave?: boolean;
    debounceMs?: number;
  } = {},
) {
  const { autoLoad = true, autoSave = true, debounceMs = 1000 } = options;

  const preferences = ref<UserPreferences>({ ...defaultPreferences });
  const loading = ref(false);
  const saving = ref(false);
  const error = ref<null | string>(null);
  const initialized = ref(false);

  /**
   * 从本地存储加载
   */
  function loadFromLocal(): null | UserPreferences {
    try {
      const stored = localStorage.getItem(`${STORAGE_PREFIX}${key}`);
      if (stored) {
        return JSON.parse(stored) as UserPreferences;
      }
    } catch (error_) {
      console.warn('Failed to load preferences from local storage:', error_);
    }
    return null;
  }

  /**
   * 保存到本地存储
   */
  function saveToLocal(value: UserPreferences): void {
    try {
      localStorage.setItem(`${STORAGE_PREFIX}${key}`, JSON.stringify(value));
    } catch (error_) {
      console.warn('Failed to save preferences to local storage:', error_);
    }
  }

  /**
   * 从服务端加载偏好配置
   * Requirements: AC-003.3
   */
  async function load(): Promise<void> {
    loading.value = true;
    error.value = null;

    try {
      // 先尝试从本地加载，提供即时响应
      const localData = loadFromLocal();
      if (localData) {
        preferences.value = { ...defaultPreferences, ...localData };
      }

      // 然后从服务端加载最新数据
      const response = await getPreferences(key);
      if (response && response.preferenceValue) {
        preferences.value = {
          ...defaultPreferences,
          ...response.preferenceValue,
        };
        // 同步到本地存储
        saveToLocal(preferences.value);
      }
      initialized.value = true;
    } catch (error_: any) {
      // 如果服务端加载失败，使用本地存储的数据
      const localData = loadFromLocal();
      if (localData) {
        preferences.value = { ...defaultPreferences, ...localData };
        initialized.value = true;
      }
      error.value = error_.message || '加载偏好配置失败';
      console.warn('Failed to load preferences from server:', error_);
    } finally {
      loading.value = false;
    }
  }

  /**
   * 保存偏好配置到服务端
   * Requirements: AC-003.2
   */
  async function save(): Promise<void> {
    saving.value = true;
    error.value = null;

    try {
      // 先保存到本地，确保即时生效
      saveToLocal(preferences.value);

      // 然后保存到服务端
      await savePreferencesApi({
        key,
        value: preferences.value,
      });
    } catch (error_: any) {
      error.value = error_.message || '保存偏好配置失败';
      console.warn('Failed to save preferences to server:', error_);
      throw error_;
    } finally {
      saving.value = false;
    }
  }

  /**
   * 防抖保存到服务端
   */
  function debouncedSave(): void {
    if (saveDebounceTimer) {
      clearTimeout(saveDebounceTimer);
    }
    saveDebounceTimer = setTimeout(() => {
      save().catch(() => {
        // 错误已在 save 中处理
      });
    }, debounceMs);
  }

  /**
   * 重置偏好配置
   * Requirements: AC-003.4
   */
  async function reset(): Promise<void> {
    loading.value = true;
    error.value = null;

    try {
      // 重置为默认值
      preferences.value = { ...defaultPreferences };

      // 清除本地存储
      localStorage.removeItem(`${STORAGE_PREFIX}${key}`);

      // 调用服务端重置
      await resetPreferencesApi(key);
    } catch (error_: any) {
      error.value = error_.message || '重置偏好配置失败';
      console.warn('Failed to reset preferences:', error_);
    } finally {
      loading.value = false;
    }
  }

  /**
   * 更新部分偏好配置
   */
  function update(partial: Partial<UserPreferences>): void {
    preferences.value = {
      ...preferences.value,
      ...partial,
    };
  }

  /**
   * 更新数据列表列配置
   * Requirements: AC-003.1
   */
  function updateColumns(columns: string[]): void {
    preferences.value = {
      ...preferences.value,
      dataListColumns: columns,
    };
  }

  /**
   * 获取数据列表列配置
   */
  function getColumns(): string[] {
    return (
      preferences.value.dataListColumns ||
      defaultPreferences.dataListColumns ||
      []
    );
  }

  /**
   * 监听偏好变化，自动保存
   */
  watch(
    preferences,
    (newValue) => {
      // 保存到本地存储（即时）
      saveToLocal(newValue);
      // 如果启用自动保存且已初始化，防抖保存到服务端
      if (autoSave && initialized.value) {
        debouncedSave();
      }
    },
    { deep: true },
  );

  /**
   * 组件挂载时自动加载
   */
  if (autoLoad) {
    onMounted(() => {
      load();
    });
  }

  return {
    preferences,
    loading,
    saving,
    error,
    initialized,
    load,
    save,
    reset,
    update,
    updateColumns,
    getColumns,
    defaultPreferences,
  };
}

export default useUserPreferences;
