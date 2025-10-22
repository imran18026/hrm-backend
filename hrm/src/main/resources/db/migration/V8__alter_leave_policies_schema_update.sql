-- V14__alter_leave_policies_schema_update.sql

ALTER TABLE leave_policies
    ADD COLUMN accrual_rate_per_month DOUBLE PRECISION,
    ADD COLUMN extra_days_after_years INTEGER,
    ADD COLUMN restrict_bridge_leave BOOLEAN DEFAULT FALSE,
    ADD COLUMN max_bridge_days INTEGER,
    ADD COLUMN allow_negative_balance BOOLEAN DEFAULT FALSE,
    ADD COLUMN max_advance_days INTEGER;
