-- ==============================================
-- V2__add_audit_columns_to_attendance_tables.sql
-- ==============================================

-- ==============================================
-- Add columns to ATTENDANCE DEVICE CATEGORY TABLE
-- ==============================================
ALTER TABLE attendance_device_category
ADD COLUMN created_by INTEGER NULL,
ADD COLUMN last_modified_by INTEGER NULL,
ADD COLUMN version INTEGER DEFAULT 1 NOT NULL;

-- ==============================================
-- Add columns to ATTENDANCE DEVICES TABLE
-- ==============================================
ALTER TABLE attendance_devices
ADD COLUMN created_by INTEGER NULL,
ADD COLUMN last_modified_by INTEGER NULL,
ADD COLUMN version INTEGER DEFAULT 1 NOT NULL;

-- ==============================================
-- Add columns to ATTENDANCE DEVICE ASSIGN TABLE
-- ==============================================
ALTER TABLE attendance_device_assign
ADD COLUMN created_by INTEGER NULL,
ADD COLUMN last_modified_by INTEGER NULL,
ADD COLUMN version INTEGER DEFAULT 1 NOT NULL;
