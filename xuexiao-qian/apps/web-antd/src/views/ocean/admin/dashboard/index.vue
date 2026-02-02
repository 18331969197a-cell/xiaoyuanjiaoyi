<script lang="ts" setup>
import { h, ref } from 'vue';

import { Button, Card, Col, Row, Statistic } from 'ant-design-vue';
import {
  UserOutlined,
  ShoppingCartOutlined,
  DollarOutlined,
  ShopOutlined,
} from '@ant-design/icons-vue';

// 示例数据
const stats = ref({
  users: 12580,
  orders: 2560,
  revenue: 88646,
  products: 368,
});

// 模拟加载状态
const loading = ref(false);
</script>

<template>
  <div class="p-5">
    <div class="mb-5">
      <h1 class="text-2xl font-bold">仪表盘</h1>
      <p class="text-gray-500">欢迎回来，这里是数据概览</p>
    </div>

    <Row :gutter="16" class="mb-5">
      <Col :span="6">
        <Card :loading="loading">
          <Statistic
            title="总用户数"
            :value="stats.users"
            :prefix="h(UserOutlined)"
            :value-style="{ color: '#3f8600' }"
          />
        </Card>
      </Col>
      <Col :span="6">
        <Card :loading="loading">
          <Statistic
            title="总订单数"
            :value="stats.orders"
            :prefix="h(ShoppingCartOutlined)"
            :value-style="{ color: '#1890ff' }"
          />
        </Card>
      </Col>
      <Col :span="6">
        <Card :loading="loading">
          <Statistic
            title="总收入"
            :value="stats.revenue"
            :prefix="h(DollarOutlined)"
            :precision="2"
            :value-style="{ color: '#cf1322' }"
          />
        </Card>
      </Col>
      <Col :span="6">
        <Card :loading="loading">
          <Statistic
            title="商品数量"
            :value="stats.products"
            :prefix="h(ShopOutlined)"
            :value-style="{ color: '#722ed1' }"
          />
        </Card>
      </Col>
    </Row>

    <Row :gutter="16">
      <Col :span="12">
        <Card title="快速操作" class="h-full">
          <div class="space-y-3">
            <Button type="primary" block>查看用户列表</Button>
            <Button block>管理订单</Button>
            <Button block>商品管理</Button>
            <Button block>系统设置</Button>
          </div>
        </Card>
      </Col>
      <Col :span="12">
        <Card title="系统信息" class="h-full">
          <div class="space-y-2">
            <div class="flex justify-between">
              <span class="text-gray-600">系统版本</span>
              <span>v1.0.0</span>
            </div>
            <div class="flex justify-between">
              <span class="text-gray-600">运行时间</span>
              <span>3天 5小时</span>
            </div>
            <div class="flex justify-between">
              <span class="text-gray-600">服务器状态</span>
              <span class="text-green-500">正常</span>
            </div>
            <div class="flex justify-between">
              <span class="text-gray-600">最后更新</span>
              <span>2024-12-27</span>
            </div>
          </div>
        </Card>
      </Col>
    </Row>
  </div>
</template>
