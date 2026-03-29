import type {
  ComponentRecordType,
  GenerateMenuAndRoutesOptions,
  MenuRecordRaw,
} from '@vben/types';

import { generateAccessible } from '@vben/access';
import { preferences } from '@vben/preferences';

import { message } from 'ant-design-vue';

import { getDynamicRoute } from '#/api';
import { BasicLayout, IFrameView } from '#/layouts';
import { $t } from '#/locales';

const forbiddenComponent = () => import('#/views/_core/fallback/forbidden.vue');

function isAdminRole(role: string) {
  return (
    role === 'super_admin' ||
    role === 'admin' ||
    role === 'demo' ||
    role === 'admindemo' ||
    role.toLowerCase().includes('admin')
  );
}

function keepAdminMenu(path = '') {
  return (
    path === '/workspace' ||
    path.startsWith('/system') ||
    path.startsWith('/monitor') ||
    path.startsWith('/tool') ||
    path.startsWith('/lostfound/admin')
  );
}

function filterAdminMenus(menus: MenuRecordRaw[]): MenuRecordRaw[] {
  return menus.reduce<MenuRecordRaw[]>((result, menu) => {
    const children = menu.children ? filterAdminMenus(menu.children) : undefined;
    const shouldKeep =
      keepAdminMenu(menu.path) || Boolean(children && children.length > 0);

    if (!shouldKeep) {
      return result;
    }

    result.push({
      ...menu,
      children,
    });

    return result;
  }, []);
}

async function generateAccess(options: GenerateMenuAndRoutesOptions) {
  const pageMap: ComponentRecordType = import.meta.glob('../views/**/*.vue');

  const layoutMap: ComponentRecordType = {
    BasicLayout,
    IFrameView,
  };

  const access = await generateAccessible(preferences.app.accessMode, {
    ...options,
    fetchMenuListAsync: async () => {
      message.loading({
        content: `${$t('common.loadingMenu')}...`,
        duration: 1.5,
      });
      return await getDynamicRoute();
    },
    // 可以指定没有权限跳转403页面
    forbiddenComponent,
    // 如果 route.meta.menuVisibleWithForbidden = true
    layoutMap,
    pageMap,
  });

  const roles = options.roles ?? [];
  if (roles.some(isAdminRole)) {
    access.accessibleMenus = filterAdminMenus(access.accessibleMenus);
  }

  return access;
}

export { generateAccess };
