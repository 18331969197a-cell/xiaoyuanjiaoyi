import { defineOverridesPreferences } from '@vben/preferences';

/**
 * @description 项目配置文件
 * 只需要覆盖项目中的一部分配置，不需要的配置不用覆盖，会自动使用默认配置
 * !!! 更改配置后请清空缓存，否则可能不生效
 */
export const overridesPreferences = defineOverridesPreferences({
  app: {
    accessMode: 'backend',
    name: '校园互助失物招领平台',
    enableRefreshToken: true,
    loginExpiredMode: 'modal',
  },
  theme: {
    mode: 'light',
    semiDarkSidebar: false, // 侧边栏保持白色
  },
  logo: {
    source: '/logo/logo.png', // 使用本地图片，放在 public/ 目录下
    fit: 'contain', // 图片适应方式
  },
  widget: {
    languageToggle: false, // 禁用语言切换按钮
  },
  // 优化页面切换性能
  transition: {
    enable: true, // 保持动画但使用更轻量的效果
    loading: false, // 禁用页面加载动画，减少卡顿感
    name: 'fade', // 使用简单的淡入淡出，比 fade-slide 更流畅
    progress: true, // 保留顶部进度条
  },
  // 优化标签页性能
  tabbar: {
    keepAlive: true, // 保持页面缓存，避免重复渲染
  },
});
