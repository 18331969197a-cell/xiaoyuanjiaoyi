import type { RouteRecordStringComponent } from '@vben/types';

import { requestClient } from '#/api/request';

const EMBEDDED_ROUTE_PATHS: Record<string, string> = {
  '/api/druid/login.html': '/druid/login.html',
  '/api/swagger-ui/index.html': '/swagger-ui/index.html',
};

function normalizeIframeSrc(src?: string) {
  if (!src) {
    return src;
  }

  const backendUrl =
    import.meta.env.VITE_BACKEND_URL || import.meta.env.VITE_GLOB_API_URL;
  if (!backendUrl) {
    return src;
  }

  try {
    const targetUrl = new URL(src, window.location.origin);
    const mappedPath = EMBEDDED_ROUTE_PATHS[targetUrl.pathname];
    if (!mappedPath) {
      return src;
    }

    return new URL(mappedPath, backendUrl).toString();
  } catch {
    return src;
  }
}

function normalizeRoutes(
  routes: RouteRecordStringComponent[],
): RouteRecordStringComponent[] {
  return routes.map((route) => {
    const iframeSrc = normalizeIframeSrc(route.meta?.iframeSrc);
    const normalizedRoute = {
      ...route,
      children: route.children ? normalizeRoutes(route.children) : route.children,
      meta: route.meta ? { ...route.meta } : route.meta,
    } as RouteRecordStringComponent;

    if (iframeSrc && normalizedRoute.meta) {
      normalizedRoute.meta.iframeSrc = iframeSrc;
    }

    return normalizedRoute;
  });
}

/**
 * 获取用户所有菜单
 */
export async function getDynamicRoute() {
  const routes = await requestClient.get<RouteRecordStringComponent[]>(
    '/system/menu/route',
  );
  return normalizeRoutes(routes);
}
