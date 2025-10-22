-- ============================================
-- WORKFLOW MANAGEMENT SYSTEM - PostgreSQL Schema
-- ============================================

-- ============================================
-- 1. MODULES TABLE
-- ============================================
CREATE TABLE modules (
    id SERIAL PRIMARY KEY,
    module_name VARCHAR(100) UNIQUE NOT NULL,
    module_code VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    status BOOLEAN DEFAULT true,

    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- 2. WORKFLOW TEMPLATES TABLE
-- ============================================
CREATE TABLE workflow_templates (
    id SERIAL PRIMARY KEY,
    module_id INTEGER NOT NULL REFERENCES modules(id) ON DELETE RESTRICT,
    template_name VARCHAR(100) NOT NULL,
    description TEXT,
    is_default BOOLEAN DEFAULT false,
    status BOOLEAN DEFAULT true,

    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_workflow_templates_module ON workflow_templates(module_id);
CREATE INDEX idx_workflow_templates_is_default ON workflow_templates(is_default);

-- ============================================
-- 3. WORKFLOW STAGES TABLE
-- ============================================
CREATE TABLE workflow_stages (
    id SERIAL PRIMARY KEY,
    template_id INTEGER NOT NULL REFERENCES workflow_templates(id) ON DELETE RESTRICT,
    stage_name VARCHAR(100) NOT NULL,
    stage_order INTEGER NOT NULL,
    stage_type VARCHAR(20) DEFAULT 'approval' CHECK (stage_type IN ('approval', 'review', 'notification', 'system')),
    is_mandatory BOOLEAN DEFAULT true,
    can_skip BOOLEAN DEFAULT false,
    min_approvers INTEGER DEFAULT 1,
    approval_type VARCHAR(20) DEFAULT 'sequential' CHECK (approval_type IN ('sequential', 'parallel', 'any_one')),
    escalation_hours INTEGER,

    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_workflow_stages_template ON workflow_stages(template_id);
CREATE INDEX idx_workflow_stages_order ON workflow_stages(template_id, stage_order);

-- ============================================
-- 4. STAGE APPROVERS TABLE
-- ============================================
CREATE TABLE stage_approvers (
    id SERIAL PRIMARY KEY,
    stage_id INTEGER NOT NULL REFERENCES workflow_stages(id) ON DELETE RESTRICT,
    user_id INTEGER,
    role_id INTEGER,
    department_id INTEGER,
    approver_type VARCHAR(30) NOT NULL CHECK (approver_type IN ('user', 'role', 'department', 'reporting_manager', 'custom')),
    sequence_order INTEGER DEFAULT 1,
    status BOOLEAN DEFAULT true,

    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_stage_approvers_stage ON stage_approvers(stage_id);
CREATE INDEX idx_stage_approvers_user ON stage_approvers(user_id);
CREATE INDEX idx_stage_approvers_role ON stage_approvers(role_id);
CREATE INDEX idx_stage_approvers_department ON stage_approvers(department_id);

-- ============================================
-- 5. WORKFLOW INSTANCES TABLE
-- ============================================
CREATE TABLE workflow_instances (
    id SERIAL PRIMARY KEY,
    module_id INTEGER NOT NULL REFERENCES modules(id) ON DELETE RESTRICT,
    template_id INTEGER NOT NULL REFERENCES workflow_templates(id) ON DELETE RESTRICT,
    reference_id INTEGER NOT NULL,
    reference_number VARCHAR(50),
    initiated_by INTEGER NOT NULL,
    initiated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    current_stage_id INTEGER REFERENCES workflow_stages(id) ON DELETE RESTRICT,
    current_status VARCHAR(20) DEFAULT 'pending' CHECK (current_status IN ('draft', 'pending', 'in_progress', 'approved', 'rejected', 'cancelled', 'on_hold')),
    priority VARCHAR(20) DEFAULT 'normal' CHECK (priority IN ('low', 'normal', 'high', 'urgent')),
    completed_at TIMESTAMP,
    remarks TEXT,
    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_workflow_instances_module ON workflow_instances(module_id);
CREATE INDEX idx_workflow_instances_template ON workflow_instances(template_id);
CREATE INDEX idx_workflow_instances_reference ON workflow_instances(reference_id);
CREATE INDEX idx_workflow_instances_initiated_by ON workflow_instances(initiated_by);
CREATE INDEX idx_workflow_instances_status ON workflow_instances(current_status);
CREATE INDEX idx_workflow_instances_priority ON workflow_instances(priority);

-- ============================================
-- 6. WORKFLOW INSTANCE STAGES TABLE
-- ============================================
CREATE TABLE workflow_instance_stages (
    id SERIAL PRIMARY KEY,
    instance_id INTEGER NOT NULL REFERENCES workflow_instances(id) ON DELETE RESTRICT,
    stage_id INTEGER NOT NULL REFERENCES workflow_stages(id) ON DELETE RESTRICT,
    stage_status VARCHAR(20) DEFAULT 'pending' CHECK (stage_status IN ('pending', 'in_progress', 'approved', 'rejected', 'skipped')),
    assigned_to INTEGER,
    assigned_at TIMESTAMP,
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    remarks TEXT,
    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_workflow_instance_stages_instance ON workflow_instance_stages(instance_id);
CREATE INDEX idx_workflow_instance_stages_stage ON workflow_instance_stages(stage_id);
CREATE INDEX idx_workflow_instance_stages_assigned ON workflow_instance_stages(assigned_to);
CREATE INDEX idx_workflow_instance_stages_status ON workflow_instance_stages(stage_status);

-- ============================================
-- 7. APPROVAL ACTIONS TABLE
-- ============================================
CREATE TABLE approval_actions (
    id SERIAL PRIMARY KEY,
    instance_id INTEGER NOT NULL REFERENCES workflow_instances(id) ON DELETE RESTRICT,
    instance_stage_id INTEGER NOT NULL REFERENCES workflow_instance_stages(id) ON DELETE RESTRICT,
    stage_id INTEGER NOT NULL REFERENCES workflow_stages(id) ON DELETE RESTRICT,
    action_by INTEGER NOT NULL,
    action_type VARCHAR(20) NOT NULL CHECK (action_type IN ('approved', 'rejected', 'returned', 'forwarded', 'cancelled', 'on_hold')),
    action_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    comments TEXT,
    attachments JSONB,
    ip_address VARCHAR(45),
    user_agent VARCHAR(255),
    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_approval_actions_instance ON approval_actions(instance_id);
CREATE INDEX idx_approval_actions_instance_stage ON approval_actions(instance_stage_id);
CREATE INDEX idx_approval_actions_by ON approval_actions(action_by);
CREATE INDEX idx_approval_actions_type ON approval_actions(action_type);
CREATE INDEX idx_approval_actions_date ON approval_actions(action_date);

-- ============================================
-- 8. WORKFLOW NOTIFICATIONS TABLE
-- ============================================
CREATE TABLE workflow_notifications (
    id SERIAL PRIMARY KEY,
    instance_id INTEGER NOT NULL REFERENCES workflow_instances(id) ON DELETE RESTRICT,
    notification_type VARCHAR(20) NOT NULL CHECK (notification_type IN ('assignment', 'approval', 'rejection', 'escalation', 'reminder', 'completion')),
    recipient_id INTEGER NOT NULL,
    subject VARCHAR(255),
    message TEXT,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_read BOOLEAN DEFAULT false,
    read_at TIMESTAMP,
    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_workflow_notifications_instance ON workflow_notifications(instance_id);
CREATE INDEX idx_workflow_notifications_recipient ON workflow_notifications(recipient_id);
CREATE INDEX idx_workflow_notifications_type ON workflow_notifications(notification_type);
CREATE INDEX idx_workflow_notifications_read ON workflow_notifications(is_read);

-- ============================================
-- 9. WORKFLOW ESCALATIONS TABLE
-- ============================================
CREATE TABLE workflow_escalations (
    escalation_id SERIAL PRIMARY KEY,
    instance_id INTEGER NOT NULL REFERENCES workflow_instances(id) ON DELETE RESTRICT,
    instance_stage_id INTEGER NOT NULL REFERENCES workflow_instance_stages(id) ON DELETE RESTRICT,
    escalated_from INTEGER NOT NULL,
    escalated_to INTEGER NOT NULL,
    escalation_reason VARCHAR(255),
    escalated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP,
    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_workflow_escalations_instance ON workflow_escalations(instance_id);
CREATE INDEX idx_workflow_escalations_instance_stage ON workflow_escalations(instance_stage_id);
CREATE INDEX idx_workflow_escalations_from ON workflow_escalations(escalated_from);
CREATE INDEX idx_workflow_escalations_to ON workflow_escalations(escalated_to);

-- ============================================
-- 10. WORKFLOW AUDIT LOG TABLE
-- ============================================
CREATE TABLE workflow_audit_log (
    log_id SERIAL PRIMARY KEY,
    instance_id INTEGER NOT NULL REFERENCES workflow_instances(id) ON DELETE RESTRICT,
    action_type VARCHAR(50) NOT NULL,
    performed_by INTEGER,
    old_value TEXT,
    new_value TEXT,
    field_changed VARCHAR(100),
    ip_address VARCHAR(45),
    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_workflow_audit_log_instance ON workflow_audit_log(instance_id);
CREATE INDEX idx_workflow_audit_log_performed_by ON workflow_audit_log(performed_by);
CREATE INDEX idx_workflow_audit_log_action_type ON workflow_audit_log(action_type);
CREATE INDEX idx_workflow_audit_log_created_at ON workflow_audit_log(created_at);

-- ============================================
-- END OF WORKFLOW MANAGEMENT SYSTEM SCHEMA
-- ============================================

-- ============================================
-- 11. EMPLOYEE SEPARATION WORKFLOW TABLE
-- ============================================

-- ============================================
-- 1. EMPLOYEE SEPARATIONS TABLE
-- ============================================
CREATE TABLE employee_separations (
    id BIGSERIAL PRIMARY KEY,
    employee_id BIGINT NOT NULL,
    separation_type VARCHAR(30) NOT NULL CHECK (separation_type IN ('resignation', 'termination', 'end_of_contract', 'retirement', 'layoff', 'death')),
    submission_date DATE NOT NULL,
    requested_lwd DATE NOT NULL,
    actual_lwd DATE,
    effective_separation_date DATE,
    reason VARCHAR(500),
    resignation_letter_path VARCHAR(255),
    status VARCHAR(30) DEFAULT 'pending' CHECK (status IN ('pending', 'supervisor_approved', 'hr_approved', 'admin_approved', 'rejected', 'withdrawn')),
    current_approver_id BIGINT,
    current_approval_level VARCHAR(20) CHECK (current_approval_level IN ('supervisor', 'hr', 'admin')),
    notice_period_days INTEGER DEFAULT 30,
    notice_waived BOOLEAN DEFAULT false,
    notice_waiver_reason TEXT,
    notice_buyout_amount DECIMAL(10,2) DEFAULT 0.00,
    is_buyout_recovered BOOLEAN DEFAULT false,

    created_by BIGINT NULL,
    last_modified_by BIGINT NULL,
    version INTEGER DEFAULT 1 NOT NULL,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_employee_separations_status ON employee_separations(status);
CREATE INDEX idx_employee_separations_employee ON employee_separations(employee_id);
CREATE INDEX idx_employee_separations_lwd ON employee_separations(actual_lwd);

-- ============================================
-- 2. SEPARATION APPROVALS TABLE
-- ============================================
CREATE TABLE separation_approvals (
    id BIGSERIAL PRIMARY KEY,
    separation_id BIGINT NOT NULL REFERENCES employee_separations(id) ON DELETE CASCADE,
    approval_level VARCHAR(20) NOT NULL CHECK (approval_level IN ('supervisor', 'hr', 'admin')),
    approver_id BIGINT NOT NULL,
    action VARCHAR(20) DEFAULT 'pending' CHECK (action IN ('pending', 'approved', 'rejected', 'returned')),
    remarks TEXT,
    action_date TIMESTAMP,
    sla_deadline TIMESTAMP NOT NULL,
    is_overdue BOOLEAN DEFAULT false,
    sequence_order INTEGER NOT NULL,

    created_by BIGINT NULL,
    last_modified_by BIGINT NULL,
    version INTEGER DEFAULT 1 NOT NULL,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_separation_approvals_separation ON separation_approvals(separation_id);
CREATE INDEX idx_separation_approvals_approver ON separation_approvals(approver_id);
CREATE INDEX idx_separation_approvals_pending ON separation_approvals(action, sla_deadline);

-- ============================================
-- 3. NOTICE PERIOD CONFIG TABLE
-- ============================================
CREATE TABLE notice_period_config (
    id BIGSERIAL PRIMARY KEY,
    employment_type VARCHAR(20) NOT NULL CHECK (employment_type IN ('permanent', 'contract', 'probation', 'intern')),
    grade_level VARCHAR(50),
    default_notice_days INTEGER NOT NULL DEFAULT 30,
    minimum_notice_days INTEGER NOT NULL DEFAULT 15,
    grace_period_days INTEGER DEFAULT 0,
    can_waive BOOLEAN DEFAULT true,
    can_buyout BOOLEAN DEFAULT true,
    status BOOLEAN DEFAULT true,
    created_by BIGINT NULL,
    last_modified_by BIGINT NULL,
    version INTEGER DEFAULT 1 NOT NULL,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_config UNIQUE (employment_type, grade_level)
);

-- ============================================
-- 4. EXIT CLEARANCE TEMPLATES TABLE
-- ============================================
CREATE TABLE exit_clearance_templates (
    id BIGSERIAL PRIMARY KEY,
    template_name VARCHAR(100) NOT NULL,
    description TEXT,
    is_default BOOLEAN DEFAULT false,
    status BOOLEAN DEFAULT true,

    created_by BIGINT NULL,
    last_modified_by BIGINT NULL,
    version INTEGER DEFAULT 1 NOT NULL,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- 5. EXIT CLEARANCE ITEMS TABLE
-- ============================================
CREATE TABLE exit_clearance_items (
    id BIGSERIAL PRIMARY KEY,
    template_id BIGINT NOT NULL REFERENCES exit_clearance_templates(id) ON DELETE CASCADE,
    department VARCHAR(20) NOT NULL CHECK (department IN ('IT', 'Finance', 'Admin', 'Security', 'HR', 'Operations')),
    item_name VARCHAR(200) NOT NULL,
    item_description TEXT,
    is_mandatory BOOLEAN DEFAULT true,
    assignee_role VARCHAR(100),
    sequence_order INTEGER,
    status BOOLEAN DEFAULT true,
    created_by BIGINT NULL,
    last_modified_by BIGINT NULL,
    version INTEGER DEFAULT 1 NOT NULL,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_exit_clearance_items_template ON exit_clearance_items(template_id);

-- ============================================
-- 6. EMPLOYEE CLEARANCE CHECKLIST TABLE
-- ============================================
CREATE TABLE employee_clearance_checklist (
    id BIGSERIAL PRIMARY KEY,
    separation_id BIGINT NOT NULL REFERENCES employee_separations(id) ON DELETE CASCADE,
    clearance_item_id BIGINT NOT NULL REFERENCES exit_clearance_items(id) ON DELETE RESTRICT,
    department VARCHAR(20) NOT NULL CHECK (department IN ('IT', 'Finance', 'Admin', 'Security', 'HR', 'Operations')),
    assigned_to BIGINT,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'cleared', 'not_applicable', 'waived')),
    remarks TEXT,
    evidence_path VARCHAR(255),
    cleared_date TIMESTAMP,
    cleared_by BIGINT,
    sla_deadline TIMESTAMP NOT NULL,
    is_overdue BOOLEAN DEFAULT false,
    created_by BIGINT NULL,
    last_modified_by BIGINT NULL,
    version INTEGER DEFAULT 1 NOT NULL,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_employee_clearance_separation ON employee_clearance_checklist(separation_id);
CREATE INDEX idx_employee_clearance_status ON employee_clearance_checklist(status);
CREATE INDEX idx_employee_clearance_assigned ON employee_clearance_checklist(assigned_to, status);

-- ============================================
-- 7. FINAL SETTLEMENT TABLE
-- ============================================
CREATE TABLE final_settlement (
    id BIGSERIAL PRIMARY KEY,
    separation_id BIGINT NOT NULL UNIQUE REFERENCES employee_separations(id) ON DELETE CASCADE,
    employee_id BIGINT NOT NULL,

    -- Earnings
    unpaid_salary DECIMAL(10,2) DEFAULT 0.00,
    salary_arrears DECIMAL(10,2) DEFAULT 0.00,
    overtime_dues DECIMAL(10,2) DEFAULT 0.00,
    leave_encashment DECIMAL(10,2) DEFAULT 0.00,
    bonus_dues DECIMAL(10,2) DEFAULT 0.00,
    other_earnings DECIMAL(10,2) DEFAULT 0.00,
    total_earnings DECIMAL(10,2) DEFAULT 0.00,

    -- Deductions
    notice_buyout DECIMAL(10,2) DEFAULT 0.00,
    loan_recovery DECIMAL(10,2) DEFAULT 0.00,
    advance_recovery DECIMAL(10,2) DEFAULT 0.00,
    tax_deduction DECIMAL(10,2) DEFAULT 0.00,
    statutory_deductions DECIMAL(10,2) DEFAULT 0.00,
    asset_loss_recovery DECIMAL(10,2) DEFAULT 0.00,
    other_deductions DECIMAL(10,2) DEFAULT 0.00,
    total_deductions DECIMAL(10,2) DEFAULT 0.00,

    net_payable DECIMAL(10,2) DEFAULT 0.00,

    -- Status & Approval
    status VARCHAR(30) DEFAULT 'pending' CHECK (status IN ('pending', 'hr_approved', 'finance_approved', 'disbursed')),
    hr_approved_by BIGINT,
    hr_approved_date TIMESTAMP,
    finance_approved_by BIGINT,
    finance_approved_date TIMESTAMP,

    -- Disbursement
    disbursement_date DATE,
    payment_method VARCHAR(20) DEFAULT 'bank_transfer' CHECK (payment_method IN ('bank_transfer', 'cheque', 'cash')),
    payment_reference VARCHAR(100),
    voucher_number VARCHAR(50),
    statement_path VARCHAR(255),

    sla_deadline DATE NOT NULL,
    is_overdue BOOLEAN DEFAULT false,
    remarks TEXT,

    created_by BIGINT NULL,
    last_modified_by BIGINT NULL,
    version INTEGER DEFAULT 1 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_final_settlement_status ON final_settlement(status);
CREATE INDEX idx_final_settlement_employee ON final_settlement(employee_id);

-- ============================================
-- 8. EXIT INTERVIEW TABLE
-- ============================================
CREATE TABLE exit_interview (
    id BIGSERIAL PRIMARY KEY,
    separation_id BIGINT NOT NULL UNIQUE REFERENCES employee_separations(id) ON DELETE CASCADE,
    employee_id BIGINT NOT NULL,
    interview_mode VARCHAR(20) NOT NULL CHECK (interview_mode IN ('in_person', 'online', 'ess')),
    scheduled_date TIMESTAMP,
    completed_date TIMESTAMP,
    interviewer_id BIGINT,

    -- Ratings (1-5)
    overall_satisfaction_rating INTEGER CHECK (overall_satisfaction_rating BETWEEN 1 AND 5),
    work_environment_rating INTEGER CHECK (work_environment_rating BETWEEN 1 AND 5),
    management_rating INTEGER CHECK (management_rating BETWEEN 1 AND 5),
    growth_opportunity_rating INTEGER CHECK (growth_opportunity_rating BETWEEN 1 AND 5),
    compensation_rating INTEGER CHECK (compensation_rating BETWEEN 1 AND 5),

    primary_reason_leaving VARCHAR(500),
    would_recommend BOOLEAN,
    would_rejoin BOOLEAN,
    additional_comments TEXT,

    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'scheduled', 'completed', 'skipped')),
    confidentiality_level VARCHAR(30) DEFAULT 'hr_only' CHECK (confidentiality_level IN ('hr_only', 'anonymous_to_manager', 'share_all')),
    interview_data JSONB,


    created_by BIGINT NULL,
    last_modified_by BIGINT NULL,
    version INTEGER DEFAULT 1 NOT NULL,

     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON COLUMN exit_interview.overall_satisfaction_rating IS '1-5 rating scale';
COMMENT ON COLUMN exit_interview.work_environment_rating IS '1-5 rating scale';
COMMENT ON COLUMN exit_interview.management_rating IS '1-5 rating scale';
COMMENT ON COLUMN exit_interview.growth_opportunity_rating IS '1-5 rating scale';
COMMENT ON COLUMN exit_interview.compensation_rating IS '1-5 rating scale';

CREATE INDEX idx_exit_interview_employee ON exit_interview(employee_id);
CREATE INDEX idx_exit_interview_status ON exit_interview(status);

-- ============================================
-- 9. SEPARATION DOCUMENTS TABLE
-- ============================================
CREATE TABLE separation_documents (
    id BIGSERIAL PRIMARY KEY,
    separation_id BIGINT NOT NULL REFERENCES employee_separations(id) ON DELETE CASCADE,
    document_type VARCHAR(50) NOT NULL CHECK (document_type IN ('resignation_letter', 'acceptance_letter', 'termination_letter', 'relieving_letter', 'experience_certificate', 'fnf_statement', 'clearance_evidence', 'other')),
    document_name VARCHAR(200) NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    file_size BIGINT,
    mime_type VARCHAR(100),
    generated_by_system BOOLEAN DEFAULT false,
    uploaded_by BIGINT,
    is_signed BOOLEAN DEFAULT false,
    signed_date TIMESTAMP,
    is_employee_accessible BOOLEAN DEFAULT true,

    created_by BIGINT NULL,
    last_modified_by BIGINT NULL,
    version INTEGER DEFAULT 1 NOT NULL,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_separation_documents_separation ON separation_documents(separation_id);
CREATE INDEX idx_separation_documents_type ON separation_documents(document_type);

-- ============================================
-- 10. ACCESS REVOCATION LOG TABLE
-- ============================================
CREATE TABLE access_revocation_log (
    id BIGSERIAL PRIMARY KEY,
    separation_id BIGINT NOT NULL REFERENCES employee_separations(id) ON DELETE CASCADE,
    employee_id BIGINT NOT NULL,
    system_name VARCHAR(20) NOT NULL CHECK (system_name IN ('ess', 'hrm', 'attendance', 'email', 'vpn', 'payroll', 'other')),
    access_type VARCHAR(100),
    revocation_date TIMESTAMP NOT NULL,
    revoked_by BIGINT,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'revoked', 'failed')),
    error_message TEXT,
    retry_count INTEGER DEFAULT 0,

    created_by BIGINT NULL,
    last_modified_by BIGINT NULL,
    version INTEGER DEFAULT 1 NOT NULL,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_access_revocation_separation ON access_revocation_log(separation_id);
CREATE INDEX idx_access_revocation_system ON access_revocation_log(system_name, status);

-- ============================================
-- 11. SEPARATION AUDIT TRAIL TABLE
-- ============================================
CREATE TABLE separation_audit_trail (
    id BIGSERIAL PRIMARY KEY,
    separation_id BIGINT NOT NULL REFERENCES employee_separations(id) ON DELETE CASCADE,
    action VARCHAR(100) NOT NULL,
    performed_by BIGINT NOT NULL,
    action_details JSONB,
    old_values JSONB,
    new_values JSONB,
    ip_address VARCHAR(45),
    user_agent VARCHAR(255),

    created_by BIGINT NULL,
    last_modified_by BIGINT NULL,
    version INTEGER DEFAULT 1 NOT NULL,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_separation_audit_separation ON separation_audit_trail(separation_id);
CREATE INDEX idx_separation_audit_action ON separation_audit_trail(action);
CREATE INDEX idx_separation_audit_date ON separation_audit_trail(created_at);

-- ============================================
-- 12. SEPARATION REASONS TABLE
-- ============================================
CREATE TABLE separation_reasons (
    id BIGSERIAL PRIMARY KEY,
    separation_type VARCHAR(30) NOT NULL CHECK (separation_type IN ('resignation', 'termination', 'end_of_contract', 'retirement', 'layoff', 'death')),
    reason_code VARCHAR(50) NOT NULL UNIQUE,
    reason_text VARCHAR(255) NOT NULL,
    status BOOLEAN DEFAULT true,
    display_order INTEGER,
    created_by BIGINT NULL,
    last_modified_by BIGINT NULL,
    version INTEGER DEFAULT 1 NOT NULL,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_separation_reasons_type ON separation_reasons(separation_type);

-- ============================================
-- 13. EXIT INTERVIEW TEMPLATES TABLE
-- ============================================
CREATE TABLE exit_interview_templates (
    id BIGSERIAL PRIMARY KEY,
    template_name VARCHAR(100) NOT NULL,
    separation_type VARCHAR(20) DEFAULT 'all' CHECK (separation_type IN ('resignation', 'termination', 'all')),
    questions JSONB NOT NULL,
    is_default BOOLEAN DEFAULT false,
    status BOOLEAN DEFAULT true,

    created_by BIGINT NULL,
    last_modified_by BIGINT NULL,
    version INTEGER DEFAULT 1 NOT NULL,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- 14. HANDOVER CHECKLIST TABLE
-- ============================================
CREATE TABLE handover_checklist (
    id BIGSERIAL PRIMARY KEY,
    separation_id BIGINT NOT NULL REFERENCES employee_separations(id) ON DELETE CASCADE,
    item_description VARCHAR(500) NOT NULL,
    handover_to BIGINT,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'not_applicable')),
    completed_date TIMESTAMP,
    remarks TEXT,
    evidence_path VARCHAR(255),

    created_by BIGINT NULL,
    last_modified_by BIGINT NULL,
    version INTEGER DEFAULT 1 NOT NULL,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_handover_checklist_separation ON handover_checklist(separation_id);
