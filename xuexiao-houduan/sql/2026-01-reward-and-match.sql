-- reward & matching field additions
-- append-only DDL; apply to target database manually

ALTER TABLE biz_post
    ADD COLUMN IF NOT EXISTS reward_amount DECIMAL(12,2) NULL COMMENT 'reward amount',
    ADD COLUMN IF NOT EXISTS reward_status VARCHAR(16) DEFAULT 'NONE' COMMENT 'reward status',
    ADD COLUMN IF NOT EXISTS reward_desc VARCHAR(255) NULL COMMENT 'reward note',
    ADD COLUMN IF NOT EXISTS feature_tokens JSON NULL COMMENT 'finder feature tokens';

ALTER TABLE biz_claim
    ADD COLUMN IF NOT EXISTS feature_answers JSON NULL COMMENT 'claimer feature answers',
    ADD COLUMN IF NOT EXISTS auto_match_score INT NULL COMMENT 'auto match score',
    ADD COLUMN IF NOT EXISTS reward_pay_at DATETIME NULL COMMENT 'reward pay time';

CREATE INDEX IF NOT EXISTS idx_post_status_type_time ON biz_post (status, post_type, create_time);
CREATE INDEX IF NOT EXISTS idx_claim_status_time ON biz_claim (status, create_time);
