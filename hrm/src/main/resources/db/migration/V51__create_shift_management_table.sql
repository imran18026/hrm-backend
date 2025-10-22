-- ============================================
-- SHIFT MANAGEMENT SYSTEM - PostgreSQL Schema
-- ============================================

-- ============================================
-- 1. SHIFT CATEGORY TABLE
-- ============================================
CREATE TABLE shift_category (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    status BOOLEAN DEFAULT true,

    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- 2. SHIFTS TABLE (Shift Definition)
-- ============================================
CREATE TABLE shifts (
    id SERIAL PRIMARY KEY,
    shift_category_id INTEGER REFERENCES shift_category(id) ON DELETE RESTRICT,
    shift_name VARCHAR(100) NOT NULL,
    shift_code VARCHAR(50) UNIQUE NOT NULL,
    company_id INTEGER,
    business_unit_id INTEGER,
    work_place_group_id INTEGER,
    work_place_id INTEGER,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    break_minutes INTEGER DEFAULT 0,
    is_night_shift BOOLEAN DEFAULT false,
    grace_in_minutes INTEGER DEFAULT 0,
    grace_out_minutes INTEGER DEFAULT 0,
    status BOOLEAN DEFAULT true,

    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL,

     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- 3. SHIFT ROSTER/SCHEDULE TABLE
-- ============================================
CREATE TABLE shift_rosters (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL,
    shift_id INTEGER NOT NULL REFERENCES shifts(id) ON DELETE RESTRICT,
    work_date DATE NOT NULL,
    is_weekly_off BOOLEAN DEFAULT false,
    is_holiday BOOLEAN DEFAULT false,
    is_planned_leave BOOLEAN DEFAULT false,
    roster_type VARCHAR(20) DEFAULT 'regular' CHECK (roster_type IN ('regular', 'rotation', 'flexible', 'oncall')),
    approved_by INTEGER,
    approved_at TIMESTAMP,

    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_employee_work_date UNIQUE (employee_id, work_date)
);

CREATE INDEX idx_shift_rosters_work_date ON shift_rosters(work_date);
CREATE INDEX idx_shift_rosters_shift_id ON shift_rosters(shift_id);
CREATE INDEX idx_shift_rosters_employee_id ON shift_rosters(employee_id);

-- ============================================
-- 4. SHIFT ROTATION PATTERNS TABLE
-- ============================================
CREATE TABLE shift_rotation_patterns (
    id SERIAL PRIMARY KEY,
    pattern_name VARCHAR(100) NOT NULL,
    company_id INTEGER,
    business_unit_id INTEGER,
    description TEXT,
    rotation_days INTEGER DEFAULT 7,
    status BOOLEAN DEFAULT true,

    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON COLUMN shift_rotation_patterns.rotation_days IS 'Number of days in one cycle';

-- ============================================
-- 5. SHIFT ROTATION PATTERN DETAILS TABLE
-- ============================================
CREATE TABLE shift_rotation_pattern_details (
    id SERIAL PRIMARY KEY,
    pattern_id INTEGER NOT NULL REFERENCES shift_rotation_patterns(id) ON DELETE RESTRICT,
    day_number INTEGER NOT NULL,
    shift_id INTEGER REFERENCES shifts(id) ON DELETE RESTRICT,
    is_off_day BOOLEAN DEFAULT false,

    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_pattern_day UNIQUE (pattern_id, day_number)
);

COMMENT ON COLUMN shift_rotation_pattern_details.day_number IS 'Day 1, 2, 3... in rotation cycle';

CREATE INDEX idx_shift_rotation_pattern_details_pattern ON shift_rotation_pattern_details(pattern_id);

-- ============================================
-- 6. EMPLOYEE SHIFT ROTATION ASSIGNMENT TABLE
-- ============================================
CREATE TABLE employee_shift_rotations (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL,
    pattern_id INTEGER NOT NULL REFERENCES shift_rotation_patterns(id) ON DELETE RESTRICT,
    start_date DATE NOT NULL,
    end_date DATE,
    cycle_start_day INTEGER DEFAULT 1,
    status BOOLEAN DEFAULT true,

    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON COLUMN employee_shift_rotations.cycle_start_day IS 'Which day of pattern to start from';

CREATE INDEX idx_employee_shift_rotations_employee ON employee_shift_rotations(employee_id);
CREATE INDEX idx_employee_shift_rotations_emp_start ON employee_shift_rotations(employee_id, start_date);

-- ============================================
-- 7. SHIFT SWAP/EXCHANGE REQUESTS TABLE
-- ============================================
CREATE TABLE shift_swap_requests (
    id SERIAL PRIMARY KEY,
    requester_employee_id INTEGER NOT NULL,
    requester_roster_id INTEGER NOT NULL REFERENCES shift_rosters(id) ON DELETE RESTRICT,
    target_employee_id INTEGER NOT NULL,
    target_roster_id INTEGER REFERENCES shift_rosters(id) ON DELETE RESTRICT,
    swap_type VARCHAR(20) DEFAULT 'swap' CHECK (swap_type IN ('swap', 'give', 'take')),
    reason TEXT,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'cancelled')),
    approved_by INTEGER,
    approved_at TIMESTAMP,
    rejection_reason TEXT,
    workflow_instance_id INTEGER,

    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_shift_swap_requester ON shift_swap_requests(requester_employee_id);
CREATE INDEX idx_shift_swap_target ON shift_swap_requests(target_employee_id);
CREATE INDEX idx_shift_swap_status ON shift_swap_requests(status);

-- ============================================
-- 8. SHIFT CHANGE REQUESTS TABLE
-- ============================================
CREATE TABLE shift_change_requests (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL,
    work_date DATE NOT NULL,
    current_shift_id INTEGER NOT NULL REFERENCES shifts(id) ON DELETE RESTRICT,
    requested_shift_id INTEGER NOT NULL REFERENCES shifts(id) ON DELETE RESTRICT,
    change_type VARCHAR(20) DEFAULT 'temporary' CHECK (change_type IN ('temporary', 'permanent')),
    reason TEXT NOT NULL,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'cancelled')),
    approved_by INTEGER,
    approved_at TIMESTAMP,
    rejection_reason TEXT,
    workflow_instance_id INTEGER,

    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_shift_change_employee ON shift_change_requests(employee_id);
CREATE INDEX idx_shift_change_status ON shift_change_requests(status);
CREATE INDEX idx_shift_change_work_date ON shift_change_requests(work_date);

-- ============================================
-- 9. SHIFT ASSIGNMENT RULES TABLE
-- ============================================
CREATE TABLE shift_assignment_rules (
    id SERIAL PRIMARY KEY,
    rule_name VARCHAR(100) NOT NULL,
    company_id INTEGER,
    business_unit_id INTEGER,
    department_id INTEGER,
    designation_id INTEGER,
    default_shift_id INTEGER REFERENCES shifts(id) ON DELETE RESTRICT,
    auto_assign BOOLEAN DEFAULT false,
    days_advance INTEGER DEFAULT 7,
    rule_priority INTEGER DEFAULT 1,
    is_active BOOLEAN DEFAULT true,

    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON COLUMN shift_assignment_rules.days_advance IS 'How many days in advance to create roster';

-- ============================================
-- 10. SHIFT TEMPLATES TABLE (Weekly/Monthly patterns)
-- ============================================
CREATE TABLE shift_templates (
    id SERIAL PRIMARY KEY,
    template_name VARCHAR(100) NOT NULL,
    company_id INTEGER,
    business_unit_id INTEGER,
    template_type VARCHAR(20) DEFAULT 'weekly' CHECK (template_type IN ('weekly', 'monthly', 'custom')),
    description TEXT,
    is_active BOOLEAN DEFAULT true,

    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- 11. SHIFT TEMPLATE DETAILS TABLE
-- ============================================
CREATE TABLE shift_template_details (
    id SERIAL PRIMARY KEY,
    template_id INTEGER NOT NULL REFERENCES shift_templates(id) ON DELETE RESTRICT,
    day_of_week INTEGER,
    day_of_month INTEGER,
    shift_id INTEGER REFERENCES shifts(id) ON DELETE RESTRICT,
    is_off_day BOOLEAN DEFAULT false,
    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON COLUMN shift_template_details.day_of_week IS '0=Sunday, 1=Monday... 6=Saturday';
COMMENT ON COLUMN shift_template_details.day_of_month IS 'For monthly templates';

CREATE INDEX idx_shift_template_details_template ON shift_template_details(template_id);

-- ============================================
-- 12. EMPLOYEE SHIFT TEMPLATE ASSIGNMENT TABLE
-- ============================================
CREATE TABLE employee_shift_templates (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL,
    template_id INTEGER NOT NULL REFERENCES shift_templates(id) ON DELETE RESTRICT,
    effective_from DATE NOT NULL,
    effective_to DATE,
    status BOOLEAN DEFAULT true,

    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_employee_shift_templates_employee ON employee_shift_templates(employee_id);
CREATE INDEX idx_employee_shift_templates_emp_from ON employee_shift_templates(employee_id, effective_from);

-- ============================================
-- 13. SHIFT ALLOWANCES/PREMIUMS TABLE
-- ============================================
CREATE TABLE shift_allowances (
    id SERIAL PRIMARY KEY,
    shift_id INTEGER NOT NULL REFERENCES shifts(id) ON DELETE RESTRICT,
    allowance_name VARCHAR(100) NOT NULL,
    allowance_type VARCHAR(20) DEFAULT 'fixed' CHECK (allowance_type IN ('fixed', 'percentage', 'hourly')),
    amount DECIMAL(10,2),
    percentage DECIMAL(5,2),
    applicable_days VARCHAR(20) DEFAULT 'all' CHECK (applicable_days IN ('all', 'weekday', 'weekend', 'holiday')),
    status BOOLEAN DEFAULT true,

    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_shift_allowances_shift ON shift_allowances(shift_id);

-- ============================================
-- 14. SHIFT COVERAGE REQUIREMENTS TABLE
-- ============================================
CREATE TABLE shift_coverage_requirements (
    id SERIAL PRIMARY KEY,
    company_id INTEGER,
    business_unit_id INTEGER,
    department_id INTEGER,
    shift_id INTEGER NOT NULL REFERENCES shifts(id) ON DELETE RESTRICT,
    work_date DATE,
    day_of_week INTEGER,
    min_employees INTEGER NOT NULL DEFAULT 1,
    max_employees INTEGER,
    required_skills JSONB,
    status BOOLEAN DEFAULT true,

    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON COLUMN shift_coverage_requirements.day_of_week IS '0-6, NULL means all days';
COMMENT ON COLUMN shift_coverage_requirements.required_skills IS 'Array of skill IDs required';

CREATE INDEX idx_shift_coverage_shift_date ON shift_coverage_requirements(shift_id, work_date);
CREATE INDEX idx_shift_coverage_day_of_week ON shift_coverage_requirements(day_of_week);

-- ============================================
-- 15. SHIFT BREAKS TABLE (Detailed break rules per shift)
-- ============================================
CREATE TABLE shift_breaks (
    id SERIAL PRIMARY KEY,
    shift_id INTEGER NOT NULL REFERENCES shifts(id) ON DELETE RESTRICT,
    break_name VARCHAR(100) NOT NULL,
    break_type VARCHAR(20) DEFAULT 'lunch' CHECK (break_type IN ('lunch', 'tea', 'prayer', 'rest', 'other')),
    break_duration_minutes INTEGER NOT NULL,
    is_paid BOOLEAN DEFAULT true,
    is_mandatory BOOLEAN DEFAULT false,
    start_after_minutes INTEGER,
    display_order INTEGER DEFAULT 1,

    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON COLUMN shift_breaks.start_after_minutes IS 'Break starts after X minutes of shift start';

CREATE INDEX idx_shift_breaks_shift ON shift_breaks(shift_id);

-- ============================================
-- 16. OVERTIME SHIFT RULES TABLE
-- ============================================
CREATE TABLE shift_overtime_rules (
    id SERIAL PRIMARY KEY,
    shift_id INTEGER NOT NULL REFERENCES shifts(id) ON DELETE RESTRICT,
    rule_name VARCHAR(100),
    before_shift_minutes INTEGER DEFAULT 0,
    after_shift_minutes INTEGER DEFAULT 0,
    min_overtime_minutes INTEGER DEFAULT 30,
    max_overtime_minutes INTEGER DEFAULT 180,
    requires_approval BOOLEAN DEFAULT true,
    overtime_rate_multiplier DECIMAL(3,2) DEFAULT 1.5,
    weekend_rate_multiplier DECIMAL(3,2) DEFAULT 2.0,
    holiday_rate_multiplier DECIMAL(3,2) DEFAULT 2.5,
    status BOOLEAN DEFAULT true,

    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON COLUMN shift_overtime_rules.before_shift_minutes IS 'OT allowed before shift start';
COMMENT ON COLUMN shift_overtime_rules.after_shift_minutes IS 'OT allowed after shift end';

CREATE INDEX idx_shift_overtime_rules_shift ON shift_overtime_rules(shift_id);

-- ============================================
-- 17. ON-CALL SHIFTS TABLE
-- ============================================
CREATE TABLE oncall_shifts (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL,
    oncall_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    oncall_type VARCHAR(20) DEFAULT 'standby' CHECK (oncall_type IN ('standby', 'remote', 'on_premise')),
    allowance_amount DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'active', 'completed', 'cancelled')),
    actual_call_minutes INTEGER DEFAULT 0,
    remarks TEXT,

    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_oncall_shifts_employee ON oncall_shifts(employee_id);
CREATE INDEX idx_oncall_shifts_date ON oncall_shifts(oncall_date);
CREATE INDEX idx_oncall_shifts_status ON oncall_shifts(status);

-- ============================================
-- 18. SHIFT CONFLICTS/VIOLATIONS LOG TABLE
-- ============================================
CREATE TABLE shift_conflicts (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL,
    conflict_date DATE NOT NULL,
    conflict_type VARCHAR(30) NOT NULL CHECK (conflict_type IN ('double_booking', 'insufficient_rest', 'max_hours_exceeded', 'skill_mismatch', 'other')),
    description TEXT,
    roster_id_1 INTEGER REFERENCES shift_rosters(id) ON DELETE RESTRICT,
    roster_id_2 INTEGER REFERENCES shift_rosters(id) ON DELETE RESTRICT,
    severity VARCHAR(20) DEFAULT 'medium' CHECK (severity IN ('low', 'medium', 'high', 'critical')),
    is_resolved BOOLEAN DEFAULT false,
    resolved_by INTEGER,
    resolved_at TIMESTAMP,
    resolution_note TEXT,
    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_shift_conflicts_employee ON shift_conflicts(employee_id);
CREATE INDEX idx_shift_conflicts_date ON shift_conflicts(conflict_date);
CREATE INDEX idx_shift_conflicts_resolved ON shift_conflicts(is_resolved);

-- ============================================
-- TRIGGERS FOR UPDATED_AT AND VERSION
-- ============================================