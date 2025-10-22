-- 1. Drop the location column
ALTER TABLE attendance_devices
DROP COLUMN IF EXISTS location;

ALTER TABLE attendance_devices
ALTER COLUMN status DROP DEFAULT;

-- 2. Convert status column to BOOLEAN
-- Assign TRUE if not NULL, otherwise FALSE (or all TRUE if you want)
ALTER TABLE attendance_devices
ALTER COLUMN status TYPE BOOLEAN USING TRUE;

-- 3. Set default to TRUE
ALTER TABLE attendance_devices
ALTER COLUMN status SET DEFAULT TRUE;