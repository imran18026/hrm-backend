ALTER TABLE leave_requests
	ADD COLUMN IF NOT EXISTS leave_group_assign_id BIGINT NOT NULL;

ALTER TABLE leave_requests
	ADD CONSTRAINT fk_leave_requests_leave_group_assign
	FOREIGN KEY (leave_group_assign_id)
	REFERENCES leave_group_assigns (id);

ALTER TABLE banks
    ALTER COLUMN country_id DROP NOT NULL;