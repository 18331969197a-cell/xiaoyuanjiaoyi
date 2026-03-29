-- Fix missing permissions required by the system user edit drawer.
-- The backend checks `system:user:info` and `system:role:options`,
-- but older demo databases may not contain these menu permissions.

START TRANSACTION;

INSERT INTO sys_menu (
  name,
  title,
  type,
  status,
  parent_id,
  permission,
  sort,
  create_by,
  update_by,
  remark
)
SELECT
  'getUserInfo',
  '用户详情',
  'button',
  0,
  4,
  'system:user:info',
  0,
  'system_fix',
  'system_fix',
  '补充用户详情权限'
FROM DUAL
WHERE NOT EXISTS (
  SELECT 1 FROM sys_menu WHERE permission = 'system:user:info'
);

INSERT INTO sys_menu (
  name,
  title,
  type,
  status,
  parent_id,
  permission,
  sort,
  create_by,
  update_by,
  remark
)
SELECT
  'roleOptions',
  '角色选项',
  'button',
  0,
  5,
  'system:role:options',
  0,
  'system_fix',
  'system_fix',
  '补充角色选项权限'
FROM DUAL
WHERE NOT EXISTS (
  SELECT 1 FROM sys_menu WHERE permission = 'system:role:options'
);

INSERT INTO sys_role_menu (role_id, menu_id, permission_type)
SELECT
  23,
  m.id,
  1
FROM sys_menu m
WHERE m.permission = 'system:user:info'
  AND NOT EXISTS (
    SELECT 1
    FROM sys_role_menu rm
    WHERE rm.role_id = 23
      AND rm.menu_id = m.id
  );

INSERT INTO sys_role_menu (role_id, menu_id, permission_type)
SELECT
  23,
  m.id,
  1
FROM sys_menu m
WHERE m.permission = 'system:role:options'
  AND NOT EXISTS (
    SELECT 1
    FROM sys_role_menu rm
    WHERE rm.role_id = 23
      AND rm.menu_id = m.id
  );

COMMIT;
