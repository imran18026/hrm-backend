ALTER TABLE access_revocation_log
DROP COLUMN employee_id;

ALTER TABLE exit_interview
DROP COLUMN employee_id;

ALTER TABLE separation_documents
DROP COLUMN file_size;

ALTER TABLE final_settlement
DROP COLUMN employee_id;


CREATE TABLE leave_approvals (
    id BIGSERIAL PRIMARY KEY,
    leave_request_id BIGINT NOT NULL REFERENCES leave_requests(id) ON DELETE CASCADE,
    approver_id BIGINT NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
    level INT NOT NULL,  -- approval sequence (1=Manager, 2=HR, etc.)
    leave_status VARCHAR(20) NOT NULL CHECK (leave_status IN ('PENDING', 'APPROVED', 'REJECTED','CANCELLED')),
    remarks TEXT,
    action_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL
);

ALTER TABLE leave_request_document ADD COLUMN file_type VARCHAR(255);
ALTER TABLE leave_request_document ADD COLUMN file_name TEXT;
ALTER TABLE leave_request_document ADD COLUMN file_path TEXT