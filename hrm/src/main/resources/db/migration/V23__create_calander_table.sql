-- =========================
-- Table: calendars
-- =========================
CREATE TABLE calendars (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    type VARCHAR(20) NOT NULL CHECK (type IN ('HOLIDAY','ATTENDANCE','PAYROLL')),
    year INT NOT NULL,
    is_default BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL
);

-- =========================
-- Table: calendar_holidays
-- =========================
CREATE TABLE calendar_holidays (
    id BIGSERIAL PRIMARY KEY,
    calendar_id BIGINT NOT NULL REFERENCES calendars(id) ON DELETE CASCADE,
    working_type INT NOT NULL, -- 0 = working, 1 = weekend, 2 = public holiday
    name VARCHAR(100) NOT NULL, -- day name / holiday name
    holiday_date DATE NOT NULL,
    is_holiday BOOLEAN DEFAULT TRUE, -- 0 = working, 1 = holiday
    color_code VARCHAR(50),
    description TEXT,
    status BOOLEAN DEFAULT true, -- 0 = inactive, 1 = active
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL
);

-- =========================
-- Table: calendar_attendances
-- =========================
CREATE TABLE calendar_attendances (
    id BIGSERIAL PRIMARY KEY,
    calendar_id BIGINT NOT NULL REFERENCES calendars(id) ON DELETE CASCADE,
    employee_id BIGINT NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
    attendance_date DATE NOT NULL,
    check_in TIME,
    check_out TIME,
    status VARCHAR(20), -- Present, Absent, Late, Leave
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- =========================
-- Table: calendar_payrolls
-- =========================
CREATE TABLE calendar_payrolls (
    id BIGSERIAL PRIMARY KEY,
    calendar_id BIGINT NOT NULL REFERENCES calendars(id) ON DELETE CASCADE,
    payroll_month INT NOT NULL CHECK (payroll_month BETWEEN 1 AND 12),
    payroll_year INT NOT NULL,
    disburse_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
