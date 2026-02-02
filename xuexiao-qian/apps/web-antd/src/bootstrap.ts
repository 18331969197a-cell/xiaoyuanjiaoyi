import { createApp, ref, watch, watchEffect } from 'vue';

import { registerAccessDirective } from '@vben/access';
import { registerLoadingDirective } from '@vben/common-ui/es/loading';
import { preferences, updatePreferences } from '@vben/preferences';
import { initStores, useAccessStore } from '@vben/stores';
import '@vben/styles';
import '@vben/styles/antd';

import { useTitle } from '@vueuse/core';

import { $t, setupI18n } from '#/locales';

import { initComponentAdapter } from './adapter/component';
import { initSetupVbenForm } from './adapter/form';
import App from './app.vue';
import { router } from './router';

// 海洋数据表格行高亮样式
import './styles/ocean-table.css';
// 失物招领平台移动端响应式样式
import './styles/lostfound-mobile.css';

async function bootstrap(namespace: string) {
  // 在应用启动早期，为所有img标签添加onerror处理，将HTTPS转换为HTTP
  // 这是一个全局的补救方案，用于处理MinIO HTTPS证书问题
  if (typeof window !== 'undefined') {
    // 使用事件委托方式，提升性能，并标记为passive避免浏览器警告
    document.addEventListener(
      'error',
      (event) => {
        const target = event.target as HTMLElement;
        if (target.tagName === 'IMG') {
          const img = target as HTMLImageElement;
          if (img.src && img.src.includes('https://minio')) {
            // 替换为HTTP协议
            img.src = img.src.replace(/^https:\/\//i, 'http://');
          }
        }
      },
      { passive: true, capture: true },
    ); // 添加passive标记，避免阻塞滚动
  }

  // 初始化组件适配器
  await initComponentAdapter();

  // 初始化表单组件
  await initSetupVbenForm();

  // // 设置弹窗的默认配置
  // setDefaultModalProps({
  //   fullscreenButton: false,
  // });
  // // 设置抽屉的默认配置
  // setDefaultDrawerProps({
  //   zIndex: 1020,
  // });

  const app = createApp(App);

  // 注册v-loading指令
  registerLoadingDirective(app, {
    loading: 'loading', // 在这里可以自定义指令名称，也可以明确提供false表示不注册这个指令
    spinning: 'spinning',
  });

  // 国际化 i18n 配置
  await setupI18n(app);

  // 配置 pinia-tore
  await initStores(app, { namespace });

  // 安装权限指令
  registerAccessDirective(app);

  // 初始化 tippy
  const { initTippy } = await import('@vben/common-ui/es/tippy');
  initTippy(app);

  // 配置路由及路由守卫
  app.use(router);

  // 配置Motion插件
  const { MotionPlugin } = await import('@vben/plugins/motion');
  app.use(MotionPlugin);

  // 动态更新标题
  watchEffect(() => {
    if (preferences.app.dynamicTitle) {
      const routeTitle = router.currentRoute.value.meta?.title;
      const pageTitle =
        (routeTitle ? `${$t(routeTitle)} - ` : '') + preferences.app.name;
      useTitle(pageTitle);
    }
  });

  // 根据访问端隔离布局偏好（用户端/管理端各自固定）
  if (typeof window !== 'undefined') {
    const layoutKey = (scope: 'admin' | 'user') =>
      `${namespace}-layout-${scope}`;
    const resolveScope = (path: string) =>
      path.startsWith('/lostfound/admin') ? 'admin' : 'user';
    const currentScope = ref<'admin' | 'user'>(
      resolveScope(router.currentRoute.value.path),
    );

    const applyStoredLayout = (scope: 'admin' | 'user') => {
      const stored = localStorage.getItem(layoutKey(scope));
      if (stored && stored !== preferences.app.layout) {
        updatePreferences({ app: { layout: stored as any } });
      }
    };

    // 初始化时应用当前端的布局偏好
    applyStoredLayout(currentScope.value);

    // 监听路由变化，切换端时应用对应布局
    watch(
      () => router.currentRoute.value.path,
      (path) => {
        const nextScope = resolveScope(path);
        if (nextScope !== currentScope.value) {
          currentScope.value = nextScope;
          applyStoredLayout(nextScope);
        }
      },
    );

    // 监听布局变化，写入对应端的本地存储
    watch(
      () => preferences.app.layout,
      (val) => {
        if (!val) return;
        localStorage.setItem(layoutKey(currentScope.value), String(val));
      },
    );
  }

  // 异步初始化轮询服务（替代WebSocket，不阻塞应用启动）
  const accessStore = useAccessStore();
  if (accessStore.accessToken) {
    // 使用 Promise.resolve() 确保异步执行，不阻塞应用启动
    Promise.resolve().then(async () => {
      const { startPolling } = await import('#/realtime/polling');
      startPolling();
    });
  }

  app.mount('#app');
}

export { bootstrap };
