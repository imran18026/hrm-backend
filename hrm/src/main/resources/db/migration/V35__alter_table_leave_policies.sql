ALTER TABLE leave_policies
    ADD COLUMN earned_leave BOOLEAN DEFAULT FALSE,
    ADD COLUMN earned_after_days INTEGER,
    ADD COLUMN earned_leave_days INTEGER,
    ADD COLUMN min_documents_required INTEGER,
    ADD COLUMN status BOOLEAN DEFAULT true,
    ADD COLUMN covering_employee_required BOOLEAN DEFAULT FALSE;