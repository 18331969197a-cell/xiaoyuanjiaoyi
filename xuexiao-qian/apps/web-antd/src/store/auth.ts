import type { Recordable } from '@vben/types';

import { ref } from 'vue';
import { useRouter } from 'vue-router';

import { LOGIN_PATH } from '@vben/constants';
import { preferences } from '@vben/preferences';
import { resetAllStores, useAccessStore, useUserStore } from '@vben/stores';

import { notification } from 'ant-design-vue';
import { defineStore } from 'pinia';

import { getPermissionCode, getUserInfoApi, loginApi, logoutApi } from '#/api';
import { $t } from '#/locales';
import { resetRoutes } from '#/router';

export const useAuthStore = defineStore('auth', () => {
  const accessStore = useAccessStore();
  const userStore = useUserStore();
  const router = useRouter();

  const loginLoading = ref(false);

  /**
   * 异步处理登录操作
   * Asynchronously handle the login process
   * @param params 登录表单数据
   * @param onSuccess
   */
  async function authLogin(
    params: Recordable<any>,
    onSuccess?: () => Promise<void> | void,
  ) {
    // 异步处理用户登录操作并获取 accessToken
    let userInfo: any = null;
    try {
      loginLoading.value = true;
      const { accessToken, refreshToken } = await loginApi(params);

      // 如果成功获取到 accessToken
      if (accessToken) {
        accessStore.setAccessToken(accessToken);
        accessStore.setRefreshToken(refreshToken);

        // 获取用户信息并存储到 accessStore 中
        const [fetchUserInfoResult, accessCodes] = await Promise.all([
          fetchUserInfo(),
          getPermissionCode(),
        ]);

        userInfo = fetchUserInfoResult;

        userStore.setUserInfo(userInfo);
        accessStore.setAccessCodes(accessCodes);

        if (accessStore.loginExpired) {
          accessStore.setLoginExpired(false);
        } else {
          // 根据用户角色决定跳转的首页
          // 管理员角色跳转到 /workspace，普通用户跳转到 /lostfound/home
          // 管理员角色包括: super_admin, admin, demo, admindemo 或包含 admin 的角色
          const isAdmin = userInfo?.roles?.some(
            (role: string) =>
              role === 'super_admin' ||
              role === 'admin' ||
              role === 'demo' ||
              role === 'admindemo' ||
              role.toLowerCase().includes('admin'),
          );
          const homePath = isAdmin
            ? '/workspace'
            : preferences.app.defaultHomePath;

          onSuccess ? await onSuccess?.() : await router.push(homePath);
        }

        if (userInfo?.nickname) {
          notification.success({
            description: `${$t('authentication.loginSuccessDesc')}:${userInfo?.nickname}`,
            duration: 3,
            message: $t('authentication.loginSuccess'),
          });
        }

        // 登录成功后初始化轮询服务（替代WebSocket）
        try {
          const { startPolling } = await import('#/realtime/polling');
          startPolling();
        } catch (error) {
          console.warn('[Auth] 轮询服务启动失败:', error);
        }
      }
    } finally {
      loginLoading.value = false;
    }

    return {
      userInfo,
    };
  }

  /**
   * 登出
   * @param redirect 是否跳转回登录页
   * @param callLogoutApi 是否调用注销API
   */
  async function logout(
    redirect: boolean = true,
    callLogoutApi: boolean = true,
  ) {
    // 尝试调用注销API，设置3秒超时，不阻塞后续的清理操作
    if (callLogoutApi) {
      try {
        const timeoutPromise = new Promise((_, reject) =>
          setTimeout(() => reject(new Error('Logout timeout')), 3000),
        );
        await Promise.race([logoutApi(), timeoutPromise]);
      } catch (error) {
        // 注销API失败或超时时只记录错误，不阻塞清理操作
        console.warn(
          'Logout API failed or timeout, but continuing with local cleanup:',
          error,
        );
      }
    }

    // 清理轮询服务
    try {
      const { stopPolling } = await import('#/realtime/polling');
      stopPolling();
    } catch (error) {
      console.warn('[Auth] 轮询服务清理失败:', error);
    }

    // 无论API是否成功，都执行清理操作
    resetAllStores();
    accessStore.setLoginExpired(false);
    resetRoutes();

    // 回登录页带上当前路由地址
    await router.replace({
      path: LOGIN_PATH,
      query: redirect
        ? {
            redirect: encodeURIComponent(router.currentRoute.value.fullPath),
          }
        : {},
    });

    // 强制刷新到登录页，避免仍停留在受保护页面
    if (redirect && typeof window !== 'undefined') {
      window.location.replace(LOGIN_PATH);
    }
  }

  async function fetchUserInfo() {
    const apiResponse = await getUserInfoApi();

    // Transform the nested API response to the flat structure expected by the user store
    let transformedUserInfo = null;
    if (apiResponse) {
      transformedUserInfo = {
        userId: apiResponse.user.userId,
        username: apiResponse.user.username,
        nickname: apiResponse.user.nickname,
        avatar: apiResponse.user.avatar,
        email: apiResponse.user.email,
        roles: apiResponse.roles,
      };
    }

    userStore.setUserInfo(transformedUserInfo);
    return transformedUserInfo;
  }

  function $reset() {
    loginLoading.value = false;
  }

  return {
    $reset,
    authLogin,
    fetchUserInfo,
    loginLoading,
    logout,
  };
});
