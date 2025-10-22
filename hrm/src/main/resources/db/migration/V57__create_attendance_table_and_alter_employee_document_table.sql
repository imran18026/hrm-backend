-- ==============================================
-- ATTENDANCE DEVICE CATEGORY TABLE
-- ==============================================
CREATE TABLE attendance_device_category (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    communication_type VARCHAR(20),
    biometric_mode VARCHAR(20),
    description TEXT,
    status BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==============================================
-- ATTENDANCE DEVICES TABLE
-- ==============================================
CREATE TABLE attendance_devices (
    id SERIAL PRIMARY KEY,
    category_id INT REFERENCES attendance_device_category(id) ON DELETE SET NULL,
    location_id INT,
    device_name VARCHAR(100) NOT NULL,
    device_type VARCHAR(100),
    serial_number VARCHAR(100),
    location VARCHAR(255),
    ip_address VARCHAR(50),
    mac_address VARCHAR(50),
    firmware_version VARCHAR(50),
    device_count INT DEFAULT 0,
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==============================================
-- ATTENDANCE DEVICE ASSIGN TABLE
-- ==============================================
CREATE TABLE attendance_device_assign (
    id SERIAL PRIMARY KEY,
    device_id INT REFERENCES attendance_devices(id) ON DELETE CASCADE,
    employee_id INT,
    device_user_id INT,
    assigned_by INT,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    status BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE employee_documents
ALTER COLUMN file_path TYPE TEXT;