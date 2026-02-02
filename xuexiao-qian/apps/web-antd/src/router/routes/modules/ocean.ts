import type { RouteRecordRaw } from 'vue-router';

const routes: RouteRecordRaw[] = [
  {
    meta: {
      icon: 'lucide:waves',
      order: 10,
      title: '海洋数据质控',
      hideInMenu: true,
    },
    name: 'Ocean',
    path: '/ocean',
    redirect: '/ocean/home',
    children: [
      // 概览模块
      {
        name: 'OceanHome',
        path: '/ocean/home',
        component: () => import('#/views/ocean/home/index.vue'),
        meta: {
          icon: 'lucide:home',
          title: '数据概览',
        },
      },
    ],
  },
];

export default routes;
