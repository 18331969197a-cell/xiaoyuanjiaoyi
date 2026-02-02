import type { RouteRecordRaw } from 'vue-router';

const BasicLayout = () => import('#/layouts/basic.vue');

/**
 * 失物招领模块静态路由
 * 这些路由不需要从后端菜单系统加载，用于处理带参数的详情页
 */
const routes: RouteRecordRaw[] = [
  {
    component: BasicLayout,
    meta: {
      hideInMenu: true,
      title: '失物招领',
    },
    name: 'LostFoundDetail',
    path: '/lostfound',
    children: [
      {
        name: 'PostDetail',
        path: 'posts/:id',
        component: () => import('#/views/lostfound/posts/detail.vue'),
        meta: {
          hideInMenu: true,
          title: '帖子详情',
        },
      },
      {
        name: 'ClaimDetail',
        path: 'claims/:id',
        component: () => import('#/views/lostfound/claims/detail.vue'),
        meta: {
          hideInMenu: true,
          title: '认领详情',
        },
      },
      {
        name: 'ClaimCreate',
        path: 'claims/create',
        component: () => import('#/views/lostfound/claims/create.vue'),
        meta: {
          hideInMenu: true,
          title: '发起认领',
        },
      },
      {
        name: 'MessageChat',
        path: 'messages/:threadId',
        component: () => import('#/views/lostfound/messages/chat.vue'),
        meta: {
          hideInMenu: true,
          title: '聊天',
        },
      },
      {
        name: 'GiftDetail',
        path: 'gifts/:id',
        component: () => import('#/views/lostfound/gifts/detail.vue'),
        meta: {
          hideInMenu: true,
          title: '礼品详情',
        },
      },
    ],
  },
];

export default routes;
