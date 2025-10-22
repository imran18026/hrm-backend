-- ==============================================
-- V1001__initial_seed_data.sql
-- Purpose: Seed initial reference and structure data
-- ==============================================

-- =====================
-- Countries
-- =====================
INSERT INTO countries (code, name, region, created_by, last_modified_by)
VALUES
    ('BD', 'Bangladesh', 'Asia', 1, 1),
    ('IN', 'India', 'Asia', 1, 1),
    ('US', 'United States', 'North America', 1, 1),
    ('GB', 'United Kingdom', 'Europe', 1, 1),
    ('CA', 'Canada', 'North America', 1, 1),
    ('AU', 'Australia', 'Oceania', 1, 1),
    ('DE', 'Germany', 'Europe', 1, 1),
    ('FR', 'France', 'Europe', 1, 1),
    ('JP', 'Japan', 'Asia', 1, 1),
    ('CN', 'China', 'Asia', 1, 1);

-- =====================
-- Companies
-- =====================
INSERT INTO companies (name, slug, created_by, last_modified_by)
VALUES
    ('Betopia Group', 'betopia-group', 1, 1);

-- =====================
-- Business Units
-- =====================
INSERT INTO business_units (company_id, name, code, description, status, created_by, last_modified_by)
VALUES
    (1, 'Betopia Limited', 'BU-LTD', 'Handles software products and R&D', true, 1, 1),
    (1, 'Supply Chain', 'SC-LTD', 'Handles supply chain operations', true, 1, 1),
    (1, 'Hospitality', 'H-LTD', 'Handles hospitality business', true, 1, 1),
    (1, 'Real Estate', 'RE-LTD', 'Handles real estate operations', true, 1, 1);

-- =====================
-- Workplace Groups
-- =====================
INSERT INTO workplace_groups (business_unit_id, name, code, description, status, created_by, last_modified_by)
VALUES
    (1, 'Softvence', 'WG-DHK', 'Main office in Dhaka', true, 1, 1),
    (2, 'Supply Chain HQ', 'WG-SC', 'Supply Chain main office', true, 1, 1);

-- =====================
-- Workplaces
-- =====================
INSERT INTO workplaces (workplace_group_id, name, code, address, description, status, created_by, last_modified_by)
VALUES
    (1, 'Kaderia Tower', 'WP-DHK-HQ', 'Banani, Dhaka', 'Main office for Betopia Group', true, 1, 1);

-- =====================
-- Departments
-- =====================
INSERT INTO departments (workplace_id, name, code, description, status, created_by, last_modified_by)
VALUES
    (1, 'Software Engineering', 'DEPT-ENG', 'Software engineering and architecture', true, 1, 1);

-- =====================
-- Employee Types
-- =====================
INSERT INTO employee_types (name, description, status, created_by, last_modified_by)
VALUES
    ('Full-Time', 'Permanent full-time employee', true, 1, 1),
    ('Part-Time', 'Part-time employee', true, 1, 1),
    ('Intern', 'Temporary internship program', true, 1, 1),
    ('Contractor', 'External contractor or consultant', true, 1, 1);

-- =====================
-- Grades
-- =====================
INSERT INTO grade (code, name, description, status, created_by, last_modified_by)
VALUES
    ('G1', 'Junior', 'Entry-level grade', true, 1, 1),
    ('G2', 'Mid-Level', 'Intermediate grade', true, 1, 1),
    ('G3', 'Senior', 'Senior professional grade', true, 1, 1),
    ('G4', 'Lead', 'Lead/management grade', true, 1, 1);

-- =====================
-- Designations
-- =====================
INSERT INTO designations (name, description, status, created_by, last_modified_by)
VALUES
    ('Software Engineer', 'Developer responsible for coding and implementation', true, 1, 1),
    ('QA Engineer', 'Responsible for testing and quality assurance', true, 1, 1),
    ('HR Executive', 'Handles HR operations', true, 1, 1),
    ('Project Manager', 'Manages projects and teams', true, 1, 1),
    ('System Administrator', 'Maintains IT infrastructure', true, 1, 1),
    ('Head Of Department', 'Maintains Department', true, 1, 1),
    ('Tech Lead', 'Leads technical teams and projects', true, 1, 1);

-- ============================================== -- Lookup Setup Entry -- ==============================================
INSERT INTO lookup_setup_entry (id, name, status, created_by, last_modified_by)
VALUES
    (1, 'Gender', true, 1, 1),
    (2, 'Religion', true, 1, 1),
    (3, 'Marital Status', true, 1, 1),
    (4, 'Nationality', true, 1, 1),
    (5, 'Payment Type', true, 1, 1),
    (6, 'Probation Duration', true, 1, 1);

-- ==============================================
-- Lookup Setup Details
-- ==============================================

-- =====================
-- Gender Details
-- =====================
INSERT INTO lookup_setup_details (setup_id, name, details, status, created_by, last_modified_by)
VALUES
    (1, 'Male', 'Male gender', true, 1, 1),
    (1, 'Female', 'Female gender', true, 1, 1),
    (1, 'Other', 'Other gender', true, 1, 1);

-- =====================
-- Religion Details
-- =====================
INSERT INTO lookup_setup_details (setup_id, name, details, status, created_by, last_modified_by)
VALUES
    (2, 'Islam', 'Islam religion', true, 1, 1),
    (2, 'Hinduism', 'Hinduism religion', true, 1, 1),
    (2, 'Christianity', 'Christianity religion', true, 1, 1),
    (2, 'Buddhism', 'Buddhism religion', true, 1, 1),
    (2, 'Other', 'Other religions', true, 1, 1);

-- =====================
-- Marital Status Details
-- =====================
INSERT INTO lookup_setup_details (setup_id, name, details, status, created_by, last_modified_by)
VALUES
    (3, 'Single', 'Not married', true, 1, 1),
    (3, 'Married', 'Legally married', true, 1, 1),
    (3, 'Divorced', 'Legally divorced', true, 1, 1),
    (3, 'Widowed', 'Spouse deceased', true, 1, 1);

-- =====================
-- Nationality Details
-- =====================
INSERT INTO lookup_setup_details (setup_id, name, details, status, created_by, last_modified_by)
VALUES
    (4, 'Bangladesh', 'Citizen', true, 1, 1),
    (4, 'British', 'Citizen', true, 1, 1);

-- =====================
-- Payment Type
-- =====================
INSERT INTO lookup_setup_details (setup_id, name, details, status, created_by, last_modified_by)
VALUES
    (5, 'Cash', 'Payment in Cash', true, 1, 1),
    (5, 'Bank', 'Payment in Bank', true, 1, 1);

-- =====================
-- Probation Period
-- =====================
INSERT INTO lookup_setup_details (setup_id, name, details, status, created_by, last_modified_by)
VALUES
    (6, '90', '3 Months probation', true, 1, 1),
    (6, '240', '6 Months probation', true, 1, 1);