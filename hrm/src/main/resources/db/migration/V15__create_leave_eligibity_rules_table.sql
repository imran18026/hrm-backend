CREATE TABLE leave_eligibility_rules (
    id BIGSERIAL PRIMARY KEY,
    leave_type_id BIGINT NOT NULL REFERENCES leave_types(id) ON DELETE CASCADE,
    group_id BIGINT REFERENCES leave_groups(id)  ON DELETE CASCADE,
    gender VARCHAR(10),
    min_tenure_months INT,
    max_tenure_months INT,
    employment_status VARCHAR(50),
    status BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL
);
