CREATE TABLE leave_groups (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    created_by integer  DEFAULT 1 NOT NULL,
    last_modified_by integer  DEFAULT 1 NOT NULL,
    version integer DEFAULT 1 NOT NULL
);
