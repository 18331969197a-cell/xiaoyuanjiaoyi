/**
 * 该文件可自行根据业务逻辑进行调整
 */
import type { RequestClientOptions } from '@vben/request';

import { useAppConfig } from '@vben/hooks';
import { preferences } from '@vben/preferences';
import {
  defaultResponseInterceptor,
  errorMessageResponseInterceptor,
  RequestClient,
} from '@vben/request';
import { useAccessStore } from '@vben/stores';

import { message } from 'ant-design-vue';

import { useAuthStore } from '#/store';

import { refreshTokenApi } from './core';

const { apiURL } = useAppConfig(import.meta.env, import.meta.env.PROD);

/**
 * 网络重试配置
 */
const RETRY_CONFIG = {
  /** 最大重试次数 */
  maxRetries: 3,
  /** 重试延迟（毫秒） */
  retryDelay: 1000,
  /** 需要重试的HTTP状态码 */
  retryStatusCodes: [408, 500, 502, 503, 504],
  /** 需要重试的错误类型 */
  retryErrorTypes: ['ECONNABORTED', 'ETIMEDOUT', 'ENOTFOUND', 'ENETUNREACH'],
};

/**
 * 延迟函数
 */
function delay(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

/**
 * 判断是否应该重试
 */
function shouldRetry(error: any): boolean {
  // 网络错误
  if (!error.response) {
    const errorCode = error.code || '';
    return RETRY_CONFIG.retryErrorTypes.some((type) =>
      errorCode.includes(type),
    );
  }

  // HTTP状态码错误
  const status = error.response?.status;
  return RETRY_CONFIG.retryStatusCodes.includes(status);
}

function createRequestClient(baseURL: string, options?: RequestClientOptions) {
  const client = new RequestClient({
    ...options,
    baseURL,
  });

  /**
   * 重新认证逻辑
   */
  async function doReAuthenticate(isLoginRequest = false) {
    console.warn('Access token or refresh token is invalid or expired. ');
    const accessStore = useAccessStore();
    const authStore = useAuthStore();
    accessStore.setAccessToken(null);

    if (
      preferences.app.loginExpiredMode === 'modal' &&
      accessStore.isAccessChecked
    ) {
      accessStore.setLoginExpired(true);
    } else {
      // 如果是登录请求失败，不调用注销API，直接跳转到登录页
      if (isLoginRequest) {
        console.warn('Login failed, clearing tokens without logout API call.');
        accessStore.setRefreshToken(null);
        await authStore.logout(false, false);
      } else {
        await authStore.logout();
      }
    }
  }

  /**
   * 刷新token逻辑
   */
  async function doRefreshToken() {
    const accessStore = useAccessStore();
    const response = await refreshTokenApi(accessStore.refreshToken);
    const { accessToken, refreshToken } = response.data.data;
    accessStore.setAccessToken(accessToken);
    accessStore.setRefreshToken(refreshToken);
    return accessToken;
  }

  function formatToken(token: null | string) {
    return token ?? null;
  }

  // 请求头处理
  client.addRequestInterceptor({
    fulfilled: async (config) => {
      const accessStore = useAccessStore();

      config.headers.Authorization = formatToken(accessStore.accessToken);
      config.headers['Accept-Language'] = preferences.app.locale;
      return config;
    },
  });

  // 处理返回的响应数据格式
  client.addResponseInterceptor(
    defaultResponseInterceptor({
      codeField: 'code',
      dataField: 'data',
      successCode: 200,
    }),
  );

  // 转换响应数据中的HTTPS URL为HTTP URL（解决MinIO证书问题）
  client.addResponseInterceptor({
    fulfilled: (response) => {
      if (response && typeof response === 'object') {
        // 递归遍历响应数据，转换所有HTTPS URL为HTTP
        const convertHttpsToHttp = (data: any): any => {
          if (typeof data === 'string') {
            // 如果是字符串，直接转换
            return data.replace(/^https:\/\//i, 'http://');
          } else if (Array.isArray(data)) {
            // 如果是数组，递归处理数组中的每个元素
            return data.map((item) => convertHttpsToHttp(item));
          } else if (data !== null && typeof data === 'object') {
            // 如果是对象，递归处理对象的每个属性
            const result = {} as Record<string, any>;
            for (const key in data) {
              if (Object.prototype.hasOwnProperty.call(data, key)) {
                result[key] = convertHttpsToHttp(data[key]);
              }
            }
            return result;
          }
          return data;
        };
        return convertHttpsToHttp(response);
      }
      return response;
    },
  });

  // token过期的处理 - 自定义拦截器以支持登录失败处理
  client.addResponseInterceptor({
    rejected: async (error) => {
      const { config, response } = error;
      const responseData = response?.data;

      if (responseData && typeof responseData.code === 'number') {
        // 检查是否是登录请求
        const isLoginRequest = config.url?.includes('/auth/login');

        // 登录错误
        if (responseData.code === 4013) {
          await doReAuthenticate(isLoginRequest);
          throw error;
        }
        // 4011: token过期，需要刷新token
        if (responseData.code === 4011) {
          // 检查是否是刷新token的URL
          const isRefreshTokenUrl = config.url?.includes('/auth/refresh');

          // 如果是刷新token的URL出现4011错误，需要重新登录
          if (isRefreshTokenUrl) {
            const errorMessage =
              responseData?.message || '刷新令牌失败，请重新登录';

            // 创建包含具体错误信息的错误对象
            const refreshTokenError = Object.assign({}, error, {
              isRefreshTokenError: true,
              specificMessage: errorMessage,
            });

            // 执行重新认证
            await doReAuthenticate();
            throw refreshTokenError;
          }

          // 判断是否启用了 refreshToken 功能
          if (!preferences.app.enableRefreshToken || config.__isRetryRequest) {
            await doReAuthenticate();
            throw error;
          }

          // 如果正在刷新 token，则将请求加入队列，等待刷新完成
          if (client.isRefreshing) {
            return new Promise((resolve) => {
              client.refreshTokenQueue.push((newToken: string) => {
                config.headers.Authorization = formatToken(newToken);
                resolve(client.request(config.url, { ...config }));
              });
            });
          }

          // 标记开始刷新 token
          client.isRefreshing = true;
          // 标记当前请求为重试请求，避免无限循环
          config.__isRetryRequest = true;

          try {
            const newToken = await doRefreshToken();

            // 处理队列中的请求
            client.refreshTokenQueue.forEach((callback) => callback(newToken));
            // 清空队列
            client.refreshTokenQueue = [];

            return client.request(error.config.url, { ...error.config });
          } catch (refreshError) {
            // 如果刷新 token 失败，处理错误（如强制登出或跳转登录页面）
            client.refreshTokenQueue.forEach((callback) => callback(''));
            client.refreshTokenQueue = [];
            console.error('Refresh token failed, please login again.');
            await doReAuthenticate();

            throw refreshError;
          } finally {
            client.isRefreshing = false;
          }
        }
        // 4012: 需要重新登录
        else if (responseData.code === 4012) {
          const errorMessage = responseData.message || '需要重新登录';

          // 创建包含具体错误信息的错误对象
          const reAuthError = Object.assign({}, error, {
            isReAuthError: true,
            specificMessage: errorMessage,
          });

          // 执行重新认证
          await doReAuthenticate();
          throw reAuthError;
        }
      }
      // 其他所有错误（包括HTTP状态码错误）直接抛出，交给errorMessageResponseInterceptor处理
      throw error;
    },
  });

  // 通用的错误处理，如果没有进入上面的错误处理逻辑，就会进入这里
  client.addResponseInterceptor(
    errorMessageResponseInterceptor((msg: string, error) => {
      // 这里可以根据业务进行定制,你可以拿到 error 内的信息进行定制化处理，根据不同的 code 做不同的提示，而不是直接使用 message.error 提示 msg
      // 当前mock接口返回的错误字段是 error 或者 message
      const responseData = error?.response?.data ?? {};
      const errorMessage = responseData?.error ?? responseData?.message ?? '';

      // 如果没有错误信息，则会根据状态码进行提示
      // msg 参数已经在 errorMessageResponseInterceptor 中根据状态码处理过了
      message.error(errorMessage || msg);
    }),
  );

  // 网络重试拦截器
  client.addResponseInterceptor({
    rejected: async (error) => {
      const config = error.config;

      // 初始化重试计数
      config.__retryCount = config.__retryCount || 0;

      // 判断是否应该重试
      if (shouldRetry(error) && config.__retryCount < RETRY_CONFIG.maxRetries) {
        config.__retryCount += 1;

        console.warn(
          `网络请求失败，正在进行第 ${config.__retryCount} 次重试...`,
          config.url,
        );

        // 延迟后重试
        await delay(RETRY_CONFIG.retryDelay * config.__retryCount);

        // 重新发起请求
        return client.request(config.url, { ...config });
      }

      // 超过重试次数或不需要重试，抛出错误
      if (config.__retryCount >= RETRY_CONFIG.maxRetries) {
        message.error('网络连接不稳定，请检查网络后重试');
      }

      throw error;
    },
  });

  return client;
}

export const requestClient = createRequestClient(apiURL, {
  responseReturn: 'data',
});

export const baseRequestClient = new RequestClient({ baseURL: apiURL });
