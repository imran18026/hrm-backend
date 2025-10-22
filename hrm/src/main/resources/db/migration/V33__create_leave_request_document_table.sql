
CREATE TABLE leave_request_document (
    id SERIAL PRIMARY KEY,
    document_path VARCHAR(255),
    uploaded_at TIMESTAMP,

    created_by INT NULL,
    last_modified_by INT NULL,
    version INT DEFAULT 1 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    leave_request_id BIGINT REFERENCES leave_requests(id) ON DELETE CASCADE
);