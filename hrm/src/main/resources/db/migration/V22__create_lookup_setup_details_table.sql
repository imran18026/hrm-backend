CREATE TABLE lookup_setup_details (
    id BIGSERIAL PRIMARY KEY,
    setup_id BIGINT REFERENCES lookup_setup_entry(id) ON DELETE SET NULL,
    name VARCHAR(100) NOT NULL,
    details TEXT,
    status BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL
);

