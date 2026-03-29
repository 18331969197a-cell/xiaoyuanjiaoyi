-- 交接流程扩展：线下回传字段
ALTER TABLE `biz_handover`
    ADD COLUMN IF NOT EXISTS `receipt_submitted_by` bigint NULL DEFAULT NULL COMMENT '线下回传提交人' AFTER `remark`,
    ADD COLUMN IF NOT EXISTS `receipt_submitted_at` datetime NULL DEFAULT NULL COMMENT '线下回传提交时间' AFTER `receipt_submitted_by`,
    ADD COLUMN IF NOT EXISTS `receipt_actual_time` datetime NULL DEFAULT NULL COMMENT '线下实际完成时间' AFTER `receipt_submitted_at`,
    ADD COLUMN IF NOT EXISTS `receipt_location` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '线下实际地点' AFTER `receipt_actual_time`,
    ADD COLUMN IF NOT EXISTS `receipt_evidence_json` json NULL COMMENT '线下回传凭证' AFTER `receipt_location`,
    ADD COLUMN IF NOT EXISTS `receipt_remark` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '线下回传备注' AFTER `receipt_evidence_json`,
    ADD COLUMN IF NOT EXISTS `receipt_confirmed_by` bigint NULL DEFAULT NULL COMMENT '线下回传确认人' AFTER `receipt_remark`,
    ADD COLUMN IF NOT EXISTS `receipt_confirmed_at` datetime NULL DEFAULT NULL COMMENT '线下回传确认时间' AFTER `receipt_confirmed_by`;

-- 风险事件主表：举报/交接超时统一沉淀
CREATE TABLE IF NOT EXISTS `biz_risk_event` (
    `id` bigint NOT NULL AUTO_INCREMENT COMMENT '风险事件ID',
    `source_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '来源类型：REPORT/HANDOVER',
    `source_id` bigint NOT NULL COMMENT '来源记录ID',
    `report_id` bigint NULL DEFAULT NULL COMMENT '关联举报ID',
    `target_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '目标类型',
    `target_id` bigint NULL DEFAULT NULL COMMENT '目标ID',
    `risk_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '风险类型',
    `action_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '处置动作',
    `event_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'OPEN' COMMENT '事件状态：OPEN/RESOLVED',
    `scope_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'GLOBAL' COMMENT '权限范围类型：GLOBAL/DEPT',
    `scope_id` bigint NULL DEFAULT NULL COMMENT '权限范围ID',
    `remark` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
    `resolved_by` bigint NULL DEFAULT NULL COMMENT '处理人',
    `resolved_at` datetime NULL DEFAULT NULL COMMENT '处理时间',
    `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE INDEX `uk_source`(`source_type` ASC, `source_id` ASC) USING BTREE,
    INDEX `idx_target`(`target_type` ASC, `target_id` ASC) USING BTREE,
    INDEX `idx_event_status`(`event_status` ASC) USING BTREE,
    INDEX `idx_action_type`(`action_type` ASC) USING BTREE,
    INDEX `idx_create_time`(`create_time` ASC) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='风险事件表';
