import { expect, test } from '@playwright/test';

test.describe('Workspace page', () => {
  test('renders key sections and quick actions', async ({ page }) => {
    await page.goto('/#/auth/login');
    await page.getByRole('textbox', { name: '请输入用户名' }).fill('admin');
    await page.getByRole('textbox', { name: '密码' }).fill('admin123');
    await page.getByRole('textbox', { name: '请输入验证码' }).fill('1234');
    await page.getByRole('button', { name: 'login' }).click();
    await page.waitForURL('**/#/workspace');

    await expect(page.getByText('平台总帖子')).toBeVisible();
    await expect(page.getByText('寻物启事')).toBeVisible();
    await expect(page.getByText('招领信息')).toBeVisible();
    await expect(page.getByText('成功找回')).toBeVisible();

    await expect(page.getByRole('tab', { name: '发布趋势' })).toBeVisible();
    await expect(page.getByRole('tab', { name: '月度统计' })).toBeVisible();

    await expect(page.getByRole('heading', { name: '帖子分布' })).toBeVisible();
    await expect(page.getByRole('heading', { name: '分类统计' })).toBeVisible();
    await expect(page.getByRole('heading', { name: '地点统计' })).toBeVisible();
  });
});
