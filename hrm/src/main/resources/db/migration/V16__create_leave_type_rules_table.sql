CREATE TABLE leave_type_rules (
    id BIGSERIAL PRIMARY KEY,
    leave_type_id BIGINT NOT NULL REFERENCES leave_types(id) ON DELETE CASCADE,
    rule_key VARCHAR(100) NOT NULL,
    rule_value VARCHAR(255) NOT NULL,
    description TEXT,
    status BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL
);
