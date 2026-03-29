-- Fix personal profile permission typos in older demo databases.
-- `personal:profile:updatee` should be `personal:profile:update`.

START TRANSACTION;

UPDATE sys_menu
SET
  permission = 'personal:profile:update',
  update_by = 'system_fix',
  remark = CONCAT(IFNULL(remark, ''), ' | 修正 personal:profile:update 拼写')
WHERE permission = 'personal:profile:updatee';

COMMIT;
