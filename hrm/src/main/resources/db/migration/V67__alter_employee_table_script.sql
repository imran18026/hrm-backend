-- Add lookup references
ALTER TABLE employees 
ADD COLUMN religion_id BIGINT REFERENCES lookup_setup_details(id) ON DELETE SET NULL,
ADD COLUMN nationality_id BIGINT REFERENCES lookup_setup_details(id) ON DELETE SET NULL,
ADD COLUMN blood_group_id BIGINT REFERENCES lookup_setup_details(id) ON DELETE SET NULL,
ADD COLUMN payment_type_id BIGINT REFERENCES lookup_setup_details(id) ON DELETE SET NULL,
ADD COLUMN probation_duration_id BIGINT REFERENCES lookup_setup_details(id) ON DELETE SET NULL;

-- Other Fields
ALTER TABLE employees
ADD COLUMN birth_certificate_number VARCHAR(100) NULL,
ADD COLUMN passport_number VARCHAR(100) NULL,
ADD COLUMN driving_license_number VARCHAR(100) NULL,
ADD COLUMN tin_number VARCHAR(100) NULL;


ALTER TABLE employees ADD COLUMN office_email VARCHAR(100) NULL;
ALTER TABLE employees ADD COLUMN office_phone VARCHAR(100) NULL;
ALTER TABLE employees ADD COLUMN estimated_confirmation_date TIMESTAMP NULL;
ALTER TABLE employees ADD COLUMN actual_confirmation_date TIMESTAMP NULL;
