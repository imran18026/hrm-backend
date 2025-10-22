CREATE TABLE leave_requests (
    id SERIAL PRIMARY KEY,
    version integer DEFAULT 1 NOT NULL,
    employee_id BIGINT NOT NULL,
    leave_type_id BIGINT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    days_requested INT NOT NULL,
    reason TEXT,
    proof_document_path VARCHAR(255),
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    requested_at TIMESTAMP NOT NULL DEFAULT NOW(),
    approved_by BIGINT,
    approved_at TIMESTAMP,
    deleted_at TIMESTAMP NULL,

    created_by integer NULL,
    last_modified_by integer NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_leave_status CHECK (status IN ('PENDING', 'APPROVED', 'REJECTED', 'CANCELLED')),

    CONSTRAINT fk_leave_requests_employee FOREIGN KEY (employee_id)
        REFERENCES employees (id) ON DELETE CASCADE,

    CONSTRAINT fk_leave_requests_leave_type FOREIGN KEY (leave_type_id)
        REFERENCES leave_types (id) ON DELETE RESTRICT,

    CONSTRAINT fk_leave_requests_approved_by FOREIGN KEY (approved_by)
        REFERENCES employees (id) ON DELETE SET NULL
);
