import type { Router } from 'vue-router';

import { LOGIN_PATH } from '@vben/constants';
import { preferences } from '@vben/preferences';
import { useAccessStore, useUserStore } from '@vben/stores';
import { startProgress, stopProgress } from '@vben/utils';

import { accessRoutes, coreRouteNames } from '#/router/routes';
import { useAuthStore } from '#/store';

import { generateAccess } from './access';

/**
 * 通用守卫配置
 * @param router
 */
function setupCommonGuard(router: Router) {
  // 记录已经加载的页面
  const loadedPaths = new Set<string>();

  router.beforeEach((to) => {
    // 处理礼品详情占位路径（/lostfound/gifts/:id）避免空白页
    if (to.path === '/lostfound/gifts/:id' || to.params?.id === ':id') {
      return {
        path: '/lostfound/gifts',
        replace: true,
      };
    }

    to.meta.loaded = loadedPaths.has(to.path);

    // 页面加载进度条 - 仅在首次加载时显示
    if (!to.meta.loaded && preferences.transition.progress) {
      startProgress();
    }
    return true;
  });

  router.afterEach((to) => {
    // 记录页面是否加载,如果已经加载，后续的页面切换动画等效果不在重复执行
    loadedPaths.add(to.path);

    // 关闭页面加载进度条 - 使用 requestAnimationFrame 避免阻塞渲染
    if (preferences.transition.progress) {
      requestAnimationFrame(() => {
        stopProgress();
      });
    }
  });
}

/**
 * 权限访问守卫配置
 * @param router
 */
function setupAccessGuard(router: Router) {
  // 添加一个标记，避免重复执行权限检查
  let isGeneratingAccess = false;

  router.beforeEach(async (to, from) => {
    const accessStore = useAccessStore();
    const userStore = useUserStore();
    const authStore = useAuthStore();

    // 基本路由，这些路由不需要进入权限拦截
    if (coreRouteNames.includes(to.name as string)) {
      if (to.path === LOGIN_PATH && accessStore.accessToken) {
        return decodeURIComponent(
          (to.query?.redirect as string) || preferences.app.defaultHomePath,
        );
      }
      return true;
    }

    // accessToken 检查
    if (!accessStore.accessToken) {
      // 明确声明忽略权限访问权限，则可以访问
      if (to.meta.ignoreAccess) {
        return true;
      }

      // 没有访问权限，跳转登录页面
      if (to.fullPath !== LOGIN_PATH) {
        return {
          path: LOGIN_PATH,
          // 如不需要，直接删除 query
          query:
            to.fullPath === preferences.app.defaultHomePath
              ? {}
              : { redirect: encodeURIComponent(to.fullPath) },
          // 携带当前跳转的页面，登录后重新跳转该页面
          replace: true,
        };
      }
      return to;
    }

    // 是否已经生成过动态路由
    if (accessStore.isAccessChecked) {
      return true;
    }

    // 如果正在生成权限，等待完成
    if (isGeneratingAccess) {
      return false;
    }

    try {
      isGeneratingAccess = true;

      // 生成路由表
      // 当前登录用户拥有的角色标识列表
      const userInfo = userStore.userInfo || (await authStore.fetchUserInfo());
      const userRoles = userInfo?.roles ?? [];

      // 生成菜单和路由
      const { accessibleMenus, accessibleRoutes } = await generateAccess({
        roles: userRoles,
        router,
        // 则会在菜单中显示，但是访问会被重定向到403
        routes: accessRoutes,
      });

      // 保存菜单信息和路由信息
      accessStore.setAccessMenus(accessibleMenus);
      accessStore.setAccessRoutes(accessibleRoutes);
      accessStore.setIsAccessChecked(true);

      const redirectPath = (from.query.redirect ??
        (to.path === preferences.app.defaultHomePath
          ? preferences.app.defaultHomePath
          : to.fullPath)) as string;

      // 根据用户角色决定首页路径
      // 管理员角色跳转到 /workspace，普通用户跳转到 /lostfound/home
      const isAdmin = userRoles.some(
        (role: string) =>
          role === 'super_admin' ||
          role === 'admin' ||
          role === 'demo' ||
          role === 'admindemo' ||
          role.toLowerCase().includes('admin'),
      );
      const roleBasedHomePath = isAdmin
        ? '/workspace'
        : preferences.app.defaultHomePath;

      // 如果重定向路径是根路径或默认首页，则根据角色决定
      const finalRedirectPath =
        redirectPath === '/' || redirectPath === preferences.app.defaultHomePath
          ? roleBasedHomePath
          : redirectPath;

      const decodedRedirectPath = decodeURIComponent(finalRedirectPath);
      const resolvedRedirect = router.resolve(decodedRedirectPath);
      const isNotFound = resolvedRedirect.matched.some(
        (record) => record.name === 'FallbackNotFound',
      );

      if (isNotFound) {
        const fallbackMenuPath = accessibleMenus[0]?.path;
        const fallbackRoutePath = accessibleRoutes.find(
          (route) =>
            typeof route.path === 'string' && !route.path.includes(':'),
        )?.path;
        const fallbackPath =
          fallbackMenuPath ||
          fallbackRoutePath ||
          preferences.app.defaultHomePath;

        if (fallbackPath && fallbackPath !== decodedRedirectPath) {
          return {
            ...router.resolve(fallbackPath),
            replace: true,
          };
        }
      }

      return {
        ...resolvedRedirect,
        replace: true,
      };
    } finally {
      isGeneratingAccess = false;
    }
  });
}

/**
 * 项目守卫配置
 * @param router
 */
function createRouterGuard(router: Router) {
  /** 通用 */
  setupCommonGuard(router);
  /** 权限访问 */
  setupAccessGuard(router);
}

export { createRouterGuard };
