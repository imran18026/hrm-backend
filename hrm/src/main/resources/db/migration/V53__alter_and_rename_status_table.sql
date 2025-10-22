ALTER TABLE leave_groups
ADD COLUMN IF NOT EXISTS status BOOLEAN NOT NULL DEFAULT TRUE;


ALTER TABLE workflow_stages
ADD COLUMN status BOOLEAN DEFAULT TRUE;

ALTER TABLE employee_separations
DROP CONSTRAINT IF EXISTS employee_separations_status_check;
ALTER TABLE employee_separations
RENAME COLUMN status TO separations_status;

ALTER TABLE employee_clearance_checklist
DROP CONSTRAINT IF EXISTS employee_clearance_checklist_status_check;
ALTER TABLE employee_clearance_checklist
RENAME COLUMN status TO clearance_status;


ALTER TABLE final_settlement
RENAME COLUMN status TO settlement_status;

ALTER TABLE exit_interview
RENAME COLUMN status TO exit_status;

ALTER TABLE access_revocation_log
RENAME COLUMN status TO access_status;

ALTER TABLE handover_checklist
RENAME COLUMN status TO checklist_status;

ALTER TABLE Employee_documents
RENAME COLUMN status TO document_status;

ALTER TABLE Employee_documents
ADD COLUMN status BOOLEAN DEFAULT TRUE;