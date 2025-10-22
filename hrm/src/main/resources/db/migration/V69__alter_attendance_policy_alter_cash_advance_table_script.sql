
CREATE TABLE attendance_policy (
    id BIGSERIAL PRIMARY KEY,
    company_id BIGINT NOT NULL,
   	effective_from DATE NOT NULL, -- Start date inclusive
    effective_to DATE DEFAULT NULL,
    grace_in_minutes INT NOT NULL, -- Late grace (arrival)
    grace_out_minutes INT NOT NULL, -- Early grace (departure)
    late_threshold_minutes INT NOT NULL, -- Late if IN - start >= threshold after grace
    early_leave_threshold_minutes INT NOT NULL, -- Early if end - OUT >= threshold after grace
    min_work_minutes INT NOT NULL, -- Below this → “Insufficient Work”
    half_day_threshold_minutes INT NOT NULL, -- Half-day threshold in minutes
    absence_threshold_minutes INT NOT NULL, -- Below this → Absent
    movement_enabled BOOLEAN, -- MVP default false
    movement_allow_minutes INT DEFAULT 0,
	notes TEXT,
	status BOOLEAN,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL,
	CONSTRAINT fk_attendance_policy_company FOREIGN KEY (company_id)
        REFERENCES companies (id) ON DELETE RESTRICT
);

ALTER TABLE cash_advance_slab_config
   ADD COLUMN advance_percent NUMERIC(15,2),
   ADD COLUMN service_charge_type VARCHAR(100),
   ADD COLUMN service_charge_amount NUMERIC(15,2),
   ADD COLUMN is_range_wise_limit BOOLEAN DEFAULT FALSE,
   ADD COLUMN setup_name VARCHAR(250);
   ALTER TABLE cash_advance_slab_config_details
   DROP COLUMN IF EXISTS advance_amount_type,
   DROP COLUMN IF EXISTS advance_amount;

ALTER TABLE cash_advance_slab_config DROP CONSTRAINT IF EXISTS fk_cash_advance_slab_config_departments;
   ALTER TABLE cash_advance_slab_config DROP CONSTRAINT IF EXISTS fk_cash_advance_slab_config_designations;
   ALTER TABLE cash_advance_slab_config DROP CONSTRAINT IF EXISTS fk_cash_advance_slab_config_teams;
   ALTER TABLE cash_advance_slab_config DROP COLUMN IF EXISTS department_id;
   ALTER TABLE cash_advance_slab_config DROP COLUMN IF EXISTS designation_id;
   ALTER TABLE cash_advance_slab_config DROP COLUMN IF EXISTS team_id;

ALTER TABLE cash_advance_slab_config  DROP COLUMN IF EXISTS is_range_wise_limit;

ALTER TABLE advance_salary_request RENAME COLUMN requested_amount_percent TO service_charge_amount;
   ALTER TABLE advance_salary_request DROP COLUMN IF EXISTS remarks;