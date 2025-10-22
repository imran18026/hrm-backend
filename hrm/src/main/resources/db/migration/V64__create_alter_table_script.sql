ALTER TABLE leave_policies
ADD COLUMN is_paid Boolean;

ALTER TABLE leave_approvals
DROP CONSTRAINT IF EXISTS leave_approvals_approver_id_fkey;

ALTER TABLE leave_approvals
ALTER COLUMN approver_id TYPE BIGINT,
ALTER COLUMN approver_id SET NOT NULL;

ALTER TABLE leave_approvals
ADD COLUMN employee_id BIGINT NOT NULL,
ADD CONSTRAINT leave_approvals_employee_id_fkey
FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE;

CREATE TABLE leave_notifications (
    id BIGSERIAL PRIMARY KEY,
    recipient_id BIGINT,
    sender_id BIGINT,             -- The person who triggered the event (e.g., employee or approver)
    leave_approval_id BIGINT REFERENCES leave_approvals(id) ON DELETE CASCADE, -- Directly link to the approval
    type VARCHAR(50) NOT NULL,                             -- e.g. LEAVE_REQUEST_SUBMITTED, LEAVE_APPROVED, LEAVE_REJECTED
    message TEXT NOT NULL,
    notification_status VARCHAR(20) DEFAULT 'UNREAD',                   -- UNREAD, READ, ARCHIVED
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL
);