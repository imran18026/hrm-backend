
ALTER TABLE notice_period_config
ADD COLUMN employee_separation_id BIGINT NOT NULL REFERENCES employee_separations(id) ON DELETE RESTRICT;

ALTER TABLE notice_period_config
DROP COLUMN employment_type,
DROP COLUMN grade_level;