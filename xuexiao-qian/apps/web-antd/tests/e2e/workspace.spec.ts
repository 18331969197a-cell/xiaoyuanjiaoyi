import { expect, test } from '@playwright/test';

test.describe('Workspace page', () => {
  test('renders key sections and quick actions', async ({ page }) => {
    await page.goto('/#/workspace');

    await expect(page.getByText('工作台')).toBeVisible();

    const statCards = page.locator('.stat-card');
    await expect(statCards).toHaveCount(4);
    await expect(statCards.nth(0)).toContainText('今日新增帖子');
    await expect(statCards.nth(1)).toContainText('待审核');

    await expect(page.getByRole('heading', { name: '快捷操作' })).toBeVisible();
    await expect(page.getByRole('button', { name: '发布寻物' })).toBeVisible();
    await expect(page.getByRole('button', { name: '发布招领' })).toBeVisible();

    await expect(page.getByRole('heading', { name: '待办事项' })).toBeVisible();
    await expect(page.getByText('审核新发布的帖子')).toBeVisible();

    await expect(
      page.getByRole('heading', { name: '公告与提醒' }),
    ).toBeVisible();
    await expect(page.getByText('线下交接请当面核实信息')).toBeVisible();
  });
});
