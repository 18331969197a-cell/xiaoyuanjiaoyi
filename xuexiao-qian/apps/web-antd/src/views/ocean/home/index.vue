<script lang="ts" setup>
import { Page } from '@vben/common-ui';
import { Card, Col, Row, Typography } from 'ant-design-vue';
</script>

<template>
  <Page title="数据概览" description="海洋数据质控系统工作台">
    <Row :gutter="[16, 16]">
      <Col :span="24">
        <Card>
          <div class="welcome-container">
            <Typography.Title :level="2" class="welcome-title">
              欢迎使用海洋数据质控系统
            </Typography.Title>
            <Typography.Paragraph class="welcome-desc">
              该模块正在建设中，敬请期待...
            </Typography.Paragraph>
          </div>
        </Card>
      </Col>
    </Row>
  </Page>
</template>

<style scoped>
.welcome-container {
  padding: 60px 20px;
  text-align: center;
}

.welcome-title {
  margin-bottom: 16px;
  color: #1890ff;
}

.welcome-desc {
  font-size: 16px;
  color: #666;
}
</style>
