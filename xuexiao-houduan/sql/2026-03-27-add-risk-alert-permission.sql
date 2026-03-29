-- 风险告警专用权限，避免以 system:security-log:list 兜底导致越权
INSERT INTO `sys_menu` (
  `id`, `name`, `title`, `path`, `type`, `status`, `parent_id`,
  `active_path`, `active_icon`, `icon`, `component`, `permission`,
  `badge_type`, `badge`, `badge_variants`, `keep_alive`, `affix_tab`,
  `hide_in_menu`, `hide_children_in_menu`, `hide_in_breadcrumb`, `hide_in_tab`,
  `link`, `sort`, `create_time`, `update_time`, `create_by`, `update_by`, `remark`
) VALUES (
  332, 'LostFoundRiskAlertList', '风险告警列表', '', 'button', 0, 301,
  NULL, NULL, NULL, NULL, 'lostfound:risk-alert:list',
  NULL, NULL, NULL, 0, 0,
  0, 0, 0, 0,
  NULL, 3, NOW(), NOW(), 'system', NULL, '风险告警专用列表权限'
)
ON DUPLICATE KEY UPDATE
  `permission` = VALUES(`permission`),
  `title` = VALUES(`title`),
  `update_time` = NOW(),
  `remark` = VALUES(`remark`);
