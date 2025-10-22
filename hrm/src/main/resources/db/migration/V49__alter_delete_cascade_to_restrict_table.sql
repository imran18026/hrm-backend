-- business_units
ALTER TABLE business_units
DROP CONSTRAINT IF EXISTS fk_company;


ALTER TABLE business_units
ADD CONSTRAINT fk_company
FOREIGN KEY (company_id) REFERENCES companies (id) ON DELETE RESTRICT;

-- leave_policies
ALTER TABLE leave_policies
DROP CONSTRAINT IF EXISTS leave_policies_leave_type_id_fkey;


ALTER TABLE leave_policies
ADD CONSTRAINT fk_leave_policies_leave_type
FOREIGN KEY (leave_type_id) REFERENCES leave_types (id) ON DELETE RESTRICT;

ALTER TABLE leave_policies
DROP CONSTRAINT IF EXISTS fk_leave_policies_leave_group_assign;

ALTER TABLE leave_policies
ADD CONSTRAINT fk_leave_policies_leave_group_assign
FOREIGN KEY (leave_group_assign_id) REFERENCES leave_group_assigns (id) ON DELETE RESTRICT;

-- bank_branches
-- CONSTRAINT fk_bank FOREIGN KEY (bank_id) REFERENCES banks(id) ON DELETE CASCADE,
-- CONSTRAINT fk_location FOREIGN KEY (location_id) REFERENCES locations(id) ON DELETE CASCADE
ALTER TABLE bank_branches
DROP CONSTRAINT IF EXISTS fk_bank;

ALTER TABLE bank_branches
ADD CONSTRAINT fk_bank
FOREIGN KEY (bank_id) REFERENCES banks (id) ON DELETE RESTRICT;

ALTER TABLE bank_branches
DROP CONSTRAINT IF EXISTS fk_location;

ALTER TABLE bank_branches
ADD CONSTRAINT fk_location
FOREIGN KEY (location_id) REFERENCES locations (id) ON DELETE RESTRICT;

-- banks
-- CONSTRAINT fk_country FOREIGN KEY (country_id) REFERENCES countries(id) ON DELETE CASCADE
ALTER TABLE banks
DROP CONSTRAINT IF EXISTS fk_country;

ALTER TABLE banks
ADD CONSTRAINT fk_country
FOREIGN KEY (country_id) REFERENCES countries (id) ON DELETE RESTRICT;

-- leave_requests
-- CONSTRAINT fk_leave_requests_employee FOREIGN KEY (employee_id)
--     REFERENCES employees (id) ON DELETE CASCADE,

-- CONSTRAINT fk_leave_requests_leave_type FOREIGN KEY (leave_type_id)
--     REFERENCES leave_types (id) ON DELETE RESTRICT,

-- CONSTRAINT fk_leave_requests_approved_by FOREIGN KEY (approved_by)
--     REFERENCES employees (id) ON DELETE SET NULL

ALTER TABLE leave_requests
DROP CONSTRAINT IF EXISTS fk_leave_requests_employee;

ALTER TABLE leave_requests
ADD CONSTRAINT fk_leave_requests_employee
FOREIGN KEY (employee_id) REFERENCES employees (id) ON DELETE RESTRICT;

ALTER TABLE leave_requests
DROP CONSTRAINT IF EXISTS fk_leave_requests_leave_type;

ALTER TABLE leave_requests
ADD CONSTRAINT fk_leave_requests_leave_type
FOREIGN KEY (leave_type_id) REFERENCES leave_types (id) ON DELETE RESTRICT;

ALTER TABLE leave_requests
DROP CONSTRAINT IF EXISTS fk_leave_requests_approved_by;

ALTER TABLE leave_requests
ADD CONSTRAINT fk_leave_requests_approved_by
FOREIGN KEY (approved_by) REFERENCES employees (id) ON DELETE RESTRICT;

-- workplace_groups
-- CONSTRAINT fk_business_unit FOREIGN KEY (business_unit_id) REFERENCES business_units(id) ON DELETE CASCADE
ALTER TABLE workplace_groups
DROP CONSTRAINT IF EXISTS fk_business_unit;

ALTER TABLE workplace_groups
ADD CONSTRAINT fk_business_unit
FOREIGN KEY (business_unit_id) REFERENCES business_units (id) ON DELETE RESTRICT;

-- workplaces
-- CONSTRAINT fk_workplace_group FOREIGN KEY (workplace_group_id) REFERENCES workplace_groups(id) ON DELETE CASCADE
ALTER TABLE workplaces
DROP CONSTRAINT IF EXISTS fk_workplace_group;

ALTER TABLE workplaces
ADD CONSTRAINT fk_workplace_group
FOREIGN KEY (workplace_group_id) REFERENCES workplace_groups (id) ON DELETE RESTRICT;

-- employees
-- FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
-- FOREIGN KEY (business_unit_id) REFERENCES business_units(id) ON DELETE CASCADE,
-- FOREIGN KEY (work_place_group_id) REFERENCES workplace_groups(id) ON DELETE CASCADE,
-- FOREIGN KEY (workplace_id) REFERENCES workplaces(id) ON DELETE CASCADE,
-- FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE,
-- FOREIGN KEY (employment_type_id) REFERENCES employee_types(id) ON DELETE CASCADE,
-- FOREIGN KEY (grade_id) REFERENCES grade(id) ON DELETE CASCADE,
-- FOREIGN KEY (designation_id) REFERENCES designations(id) ON DELETE CASCADE
ALTER TABLE employees
DROP CONSTRAINT IF EXISTS employees_company_id_fkey;

ALTER TABLE employees
ADD CONSTRAINT employees_company_id_fkey
FOREIGN KEY (company_id) REFERENCES companies (id) ON DELETE RESTRICT;

ALTER TABLE employees
DROP CONSTRAINT IF EXISTS employees_business_unit_id_fkey;

ALTER TABLE employees
ADD CONSTRAINT employees_business_unit_id_fkey
FOREIGN KEY (business_unit_id) REFERENCES business_units (id) ON DELETE RESTRICT;

ALTER TABLE employees
DROP CONSTRAINT IF EXISTS employees_work_place_group_id_fkey;

ALTER TABLE employees
ADD CONSTRAINT employees_work_place_group_id_fkey
FOREIGN KEY (work_place_group_id) REFERENCES workplace_groups (id) ON DELETE RESTRICT;

ALTER TABLE employees
DROP CONSTRAINT IF EXISTS employees_workplace_id_fkey;

ALTER TABLE employees
ADD CONSTRAINT employees_workplace_id_fkey
FOREIGN KEY (workplace_id) REFERENCES workplaces (id) ON DELETE RESTRICT;

ALTER TABLE employees
DROP CONSTRAINT IF EXISTS employees_department_id_fkey;

ALTER TABLE employees
ADD CONSTRAINT employees_department_id_fkey
FOREIGN KEY (department_id) REFERENCES departments (id) ON DELETE RESTRICT;

ALTER TABLE employees
DROP CONSTRAINT IF EXISTS employees_employment_type_id_fkey;

ALTER TABLE employees
ADD CONSTRAINT employees_employment_type_id_fkey
FOREIGN KEY (employment_type_id) REFERENCES employee_types (id) ON DELETE RESTRICT;

ALTER TABLE employees
DROP CONSTRAINT IF EXISTS employees_grade_id_fkey;

ALTER TABLE employees
ADD CONSTRAINT employees_grade_id_fkey
FOREIGN KEY (grade_id) REFERENCES grade (id) ON DELETE RESTRICT;

ALTER TABLE employees
DROP CONSTRAINT IF EXISTS employees_designation_id_fkey;

ALTER TABLE employees
ADD CONSTRAINT employees_designation_id_fkey
FOREIGN KEY (designation_id) REFERENCES designations (id) ON DELETE RESTRICT;

-- users
-- FOREIGN KEY (employee_serial_id) REFERENCES employees(employee_serial_id) ON DELETE CASCADE
ALTER TABLE users
DROP CONSTRAINT IF EXISTS users_employee_serial_id_fkey;

ALTER TABLE users
ADD CONSTRAINT users_employee_serial_id_fkey
FOREIGN KEY (employee_serial_id) REFERENCES employees (employee_serial_id) ON DELETE RESTRICT;

-- role_has_permission
-- FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
-- FOREIGN KEY (permission_id) REFERENCES permissions(id) ON DELETE CASCADE
ALTER TABLE role_has_permission
DROP CONSTRAINT IF EXISTS role_has_permission_role_id_fkey;

ALTER TABLE role_has_permission
ADD CONSTRAINT role_has_permission_role_id_fkey
FOREIGN KEY (role_id) REFERENCES roles (id) ON DELETE RESTRICT;

ALTER TABLE role_has_permission
DROP CONSTRAINT IF EXISTS role_has_permission_permission_id_fkey;

ALTER TABLE role_has_permission
ADD CONSTRAINT role_has_permission_permission_id_fkey
FOREIGN KEY (permission_id) REFERENCES permissions (id) ON DELETE RESTRICT;

-- model_has_role
-- FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
-- FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
ALTER TABLE model_has_role
DROP CONSTRAINT IF EXISTS model_has_role_user_id_fkey;

ALTER TABLE model_has_role
ADD CONSTRAINT model_has_role_user_id_fkey
FOREIGN KEY (user_id) REFERENCES permissions (id) ON DELETE RESTRICT;

ALTER TABLE model_has_role
DROP CONSTRAINT IF EXISTS model_has_role_role_id_fkey;

ALTER TABLE model_has_role
ADD CONSTRAINT model_has_role_role_id_fkey
FOREIGN KEY (role_id) REFERENCES roles (id) ON DELETE RESTRICT;

-- leave_balance_employee
-- FOREIGN KEY (leave_type_id) REFERENCES leave_types(id),
-- FOREIGN KEY (employee_id) REFERENCES employees(id)
ALTER TABLE leave_balance_employee
DROP CONSTRAINT IF EXISTS leave_balance_employee_leave_type_id_fkey;

ALTER TABLE leave_balance_employee
ADD CONSTRAINT leave_balance_employee_leave_type_id_fkey
FOREIGN KEY (leave_type_id) REFERENCES leave_types (id) ON DELETE RESTRICT;

ALTER TABLE leave_balance_employee
DROP CONSTRAINT IF EXISTS leave_balance_employee_employee_id_fkey;

ALTER TABLE leave_balance_employee
ADD CONSTRAINT leave_balance_employee_employee_id_fkey
FOREIGN KEY (employee_id) REFERENCES employees (id) ON DELETE RESTRICT;

-- leave_requests
-- ADD CONSTRAINT fk_leave_requests_covering_employee FOREIGN KEY (covering_employee_id) REFERENCES employees(id) ON DELETE SET NULL;
ALTER TABLE leave_requests
DROP CONSTRAINT IF EXISTS fk_leave_requests_covering_employee;

ALTER TABLE leave_requests
ADD CONSTRAINT fk_leave_requests_covering_employee
FOREIGN KEY (covering_employee_id) REFERENCES employees (id) ON DELETE RESTRICT;

-- qualification_rating_methods_details
--     CONSTRAINT fk_qrmd_method FOREIGN KEY (qualification_rating_methods_id) REFERENCES qualification_rating_methods(id) ON DELETE CASCADE
ALTER TABLE qualification_rating_methods_details
DROP CONSTRAINT IF EXISTS fk_qrmd_method;

ALTER TABLE qualification_rating_methods_details
ADD CONSTRAINT fk_qrmd_method
FOREIGN KEY (qualification_rating_methods_id) REFERENCES qualification_rating_methods (id) ON DELETE RESTRICT;

-- locations
-- FOREIGN KEY (country_id) REFERENCES countries(id),
-- FOREIGN KEY (parent_id) REFERENCES locations(id)
ALTER TABLE locations
DROP CONSTRAINT IF EXISTS locations_country_id_fkey;

ALTER TABLE locations
ADD CONSTRAINT locations_country_id_fkey
FOREIGN KEY (country_id) REFERENCES countries (id) ON DELETE RESTRICT;

-- leave_type_rules
-- leave_type_id BIGINT NOT NULL REFERENCES leave_types(id) ON DELETE CASCADE,
ALTER TABLE leave_type_rules
DROP CONSTRAINT IF EXISTS leave_type_rules_leave_type_id_fkey;

ALTER TABLE leave_type_rules
ADD CONSTRAINT leave_type_rules_leave_type_id_fkey
FOREIGN KEY (leave_type_id) REFERENCES leave_types (id) ON DELETE RESTRICT;

-- leave_group_assigns
-- leave_type_id BIGINT REFERENCES leave_types(id) ON DELETE SET NULL,
-- leave_group_id BIGINT REFERENCES leave_groups(id) ON DELETE SET NULL,
-- company_id BIGINT REFERENCES companies(id) ON DELETE SET NULL,
-- business_unit_id BIGINT REFERENCES business_units(id) ON DELETE SET NULL,
-- work_place_group_id BIGINT REFERENCES workplace_groups(id) ON DELETE SET NULL,
-- work_place_id BIGINT REFERENCES workplaces(id) ON DELETE SET NULL,
-- department_id BIGINT REFERENCES departments(id) ON DELETE SET NULL,
-- team_id BIGINT REFERENCES teams(id) ON DELETE SET NULL,
ALTER TABLE leave_group_assigns
DROP CONSTRAINT IF EXISTS leave_assigns_leave_type_id_fkey;

ALTER TABLE leave_group_assigns
ADD CONSTRAINT leave_assigns_leave_type_id_fkey
FOREIGN KEY (leave_type_id) REFERENCES leave_types (id) ON DELETE RESTRICT;

ALTER TABLE leave_group_assigns
DROP CONSTRAINT IF EXISTS leave_assigns_leave_group_id_fkey;

ALTER TABLE leave_group_assigns
ADD CONSTRAINT leave_assigns_leave_group_id_fkey
FOREIGN KEY (leave_group_id) REFERENCES leave_groups (id) ON DELETE RESTRICT;

ALTER TABLE leave_group_assigns
DROP CONSTRAINT IF EXISTS leave_assigns_company_id_fkey;

ALTER TABLE leave_group_assigns
ADD CONSTRAINT leave_assigns_company_id_fkey
FOREIGN KEY (company_id) REFERENCES companies (id) ON DELETE RESTRICT;

ALTER TABLE leave_group_assigns
DROP CONSTRAINT IF EXISTS leave_assigns_business_unit_id_fkey;

ALTER TABLE leave_group_assigns
ADD CONSTRAINT leave_assigns_business_unit_id_fkey
FOREIGN KEY (business_unit_id) REFERENCES business_units (id) ON DELETE RESTRICT;

ALTER TABLE leave_group_assigns
DROP CONSTRAINT IF EXISTS leave_assigns_work_place_group_id_fkey;

ALTER TABLE leave_group_assigns
ADD CONSTRAINT leave_assigns_work_place_group_id_fkey
FOREIGN KEY (work_place_group_id) REFERENCES workplace_groups (id) ON DELETE RESTRICT;

ALTER TABLE leave_group_assigns
DROP CONSTRAINT IF EXISTS leave_assigns_work_place_id_fkey;

ALTER TABLE leave_group_assigns
ADD CONSTRAINT leave_assigns_work_place_id_fkey
FOREIGN KEY (work_place_id) REFERENCES workplaces (id) ON DELETE RESTRICT;

ALTER TABLE leave_group_assigns
DROP CONSTRAINT IF EXISTS leave_assigns_department_id_fkey;

ALTER TABLE leave_group_assigns
ADD CONSTRAINT leave_assigns_department_id_fkey
FOREIGN KEY (department_id) REFERENCES departments (id) ON DELETE RESTRICT;

ALTER TABLE leave_group_assigns
DROP CONSTRAINT IF EXISTS leave_assigns_team_id_fkey;

ALTER TABLE leave_group_assigns
ADD CONSTRAINT leave_assigns_team_id_fkey
FOREIGN KEY (team_id) REFERENCES teams (id) ON DELETE RESTRICT;

-- calendar_holidays
-- calendar_id BIGINT NOT NULL REFERENCES calendars(id) ON DELETE CASCADE,
ALTER TABLE calendar_holidays
DROP CONSTRAINT IF EXISTS calendar_holidays_calendar_id_fkey;

ALTER TABLE calendar_holidays
ADD CONSTRAINT calendar_holidays_calendar_id_fkey
FOREIGN KEY (calendar_id) REFERENCES calendars (id) ON DELETE RESTRICT;

-- calendar_attendances
-- calendar_id BIGINT NOT NULL REFERENCES calendars(id) ON DELETE CASCADE,
-- employee_id BIGINT NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
ALTER TABLE calendar_attendances
DROP CONSTRAINT IF EXISTS calendar_attendances_calendar_id_fkey;

ALTER TABLE calendar_attendances
ADD CONSTRAINT calendar_attendances_calendar_id_fkey
FOREIGN KEY (calendar_id) REFERENCES calendars (id) ON DELETE RESTRICT;

ALTER TABLE calendar_attendances
DROP CONSTRAINT IF EXISTS calendar_attendances_employee_id_fkey;

ALTER TABLE calendar_attendances
ADD CONSTRAINT calendar_attendances_employee_id_fkey
FOREIGN KEY (employee_id) REFERENCES employees (id) ON DELETE RESTRICT;

-- calendar_payrolls
-- calendar_id BIGINT NOT NULL REFERENCES calendars(id) ON DELETE CASCADE,
ALTER TABLE calendar_payrolls
DROP CONSTRAINT IF EXISTS calendar_payrolls_calendar_id_fkey;

ALTER TABLE calendar_payrolls
ADD CONSTRAINT calendar_payrolls_calendar_id_fkey
FOREIGN KEY (calendar_id) REFERENCES calendars (id) ON DELETE RESTRICT;

-- leave_request_document
-- leave_request_id BIGINT REFERENCES leave_requests(id) ON DELETE CASCADE
ALTER TABLE leave_request_document
DROP CONSTRAINT IF EXISTS leave_request_document_leave_request_id_fkey;

ALTER TABLE leave_request_document
ADD CONSTRAINT leave_request_document_leave_request_id_fkey
FOREIGN KEY (leave_request_id) REFERENCES leave_requests (id) ON DELETE RESTRICT;

-- employee_groups
-- CONSTRAINT fk_company FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
-- CONSTRAINT fk_workplace FOREIGN KEY (workplace_id) REFERENCES workplaces(id) ON DELETE CASCADE
ALTER TABLE employee_groups
DROP CONSTRAINT IF EXISTS fk_company;

ALTER TABLE employee_groups
ADD CONSTRAINT fk_company
FOREIGN KEY (company_id) REFERENCES companies (id) ON DELETE RESTRICT;

ALTER TABLE employee_groups
DROP CONSTRAINT IF EXISTS fk_workplace;

ALTER TABLE employee_groups
ADD CONSTRAINT fk_workplace
FOREIGN KEY (workplace_id) REFERENCES workplaces (id) ON DELETE RESTRICT;

-- leave_eligibility_rules
-- leave_type_id BIGINT NOT NULL REFERENCES leave_types(id) ON DELETE CASCADE,
-- group_id BIGINT REFERENCES leave_groups(id)  ON DELETE CASCADE,
ALTER TABLE leave_eligibility_rules
DROP CONSTRAINT IF EXISTS leave_eligibility_rules_leave_type_id_fkey;

ALTER TABLE leave_eligibility_rules
ADD CONSTRAINT leave_eligibility_rules_leave_type_id_fkey
FOREIGN KEY (leave_type_id) REFERENCES leave_types (id) ON DELETE RESTRICT;

ALTER TABLE leave_eligibility_rules
DROP CONSTRAINT IF EXISTS leave_eligibility_rules_group_id_fkey;

ALTER TABLE leave_eligibility_rules
ADD CONSTRAINT leave_eligibility_rules_group_id_fkey
FOREIGN KEY (group_id) REFERENCES leave_groups (id) ON DELETE RESTRICT;

-- lookup_setup_details
-- setup_id BIGINT REFERENCES lookup_setup_entry(id) ON DELETE SET NULL,
ALTER TABLE lookup_setup_details
DROP CONSTRAINT IF EXISTS lookup_setup_details_setup_id_fkey;

ALTER TABLE lookup_setup_details
ADD CONSTRAINT lookup_setup_details_setup_id_fkey
FOREIGN KEY (setup_id) REFERENCES lookup_setup_entry (id) ON DELETE RESTRICT;

-- menus
-- CONSTRAINT fk_permission FOREIGN KEY (permission_id) REFERENCES permissions(id) ON DELETE SET NULL,
-- CONSTRAINT fk_parent FOREIGN KEY (parent_id) REFERENCES menus(id) ON DELETE SET NULL
ALTER TABLE menus
DROP CONSTRAINT IF EXISTS fk_permission;

ALTER TABLE menus
ADD CONSTRAINT fk_permission
FOREIGN KEY (permission_id) REFERENCES permissions (id) ON DELETE RESTRICT;

ALTER TABLE menus
DROP CONSTRAINT IF EXISTS fk_parent;

ALTER TABLE menus
ADD CONSTRAINT fk_parent
FOREIGN KEY (parent_id) REFERENCES menus (id) ON DELETE RESTRICT;

-- tokens
-- FOREIGN KEY (user_id) REFERENCES users(id)
ALTER TABLE tokens
DROP CONSTRAINT IF EXISTS tokens_user_id_fkey;

ALTER TABLE tokens
ADD CONSTRAINT tokens_user_id_fkey
FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE RESTRICT;

-- teams
-- department_id BIGINT NOT NULL REFERENCES departments(id) ON DELETE CASCADE,
ALTER TABLE teams
DROP CONSTRAINT IF EXISTS teams_department_id_fkey;

ALTER TABLE teams
ADD CONSTRAINT teams_department_id_fkey
FOREIGN KEY (department_id) REFERENCES departments (id) ON DELETE RESTRICT;

-- calendar_assigns
-- ONSTRAINT fk_calendar_assigns_company
--     FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,

-- CONSTRAINT fk_calendar_assigns_business_unit
--     FOREIGN KEY (business_unit_id) REFERENCES business_units(id) ON DELETE SET NULL,

-- CONSTRAINT fk_calendar_assigns_work_place_group
--     FOREIGN KEY (work_place_group_id) REFERENCES workplace_groups(id) ON DELETE SET NULL,

-- CONSTRAINT fk_calendar_assigns_work_place
--     FOREIGN KEY (work_place_id) REFERENCES workplaces(id) ON DELETE SET NULL,

-- CONSTRAINT fk_calendar_assigns_department
--     FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL,

-- CONSTRAINT fk_calendar_assigns_team
--     FOREIGN KEY (team_id) REFERENCES teams(id) ON DELETE SET NULL
ALTER TABLE calendar_assigns
DROP CONSTRAINT IF EXISTS fk_calendar_assigns_company;

ALTER TABLE calendar_assigns
ADD CONSTRAINT fk_calendar_assigns_company
FOREIGN KEY (company_id) REFERENCES companies (id) ON DELETE RESTRICT;

ALTER TABLE calendar_assigns
DROP CONSTRAINT IF EXISTS fk_calendar_assigns_business_unit;

ALTER TABLE calendar_assigns
ADD CONSTRAINT fk_calendar_assigns_business_unit
FOREIGN KEY (business_unit_id) REFERENCES business_units (id) ON DELETE RESTRICT;

ALTER TABLE calendar_assigns
DROP CONSTRAINT IF EXISTS fk_calendar_assigns_work_place_group;

ALTER TABLE calendar_assigns
ADD CONSTRAINT fk_calendar_assigns_work_place_group
FOREIGN KEY (work_place_group_id) REFERENCES workplace_groups (id) ON DELETE RESTRICT;

ALTER TABLE calendar_assigns
DROP CONSTRAINT IF EXISTS fk_calendar_assigns_work_place;

ALTER TABLE calendar_assigns
ADD CONSTRAINT fk_calendar_assigns_work_place
FOREIGN KEY (work_place_id) REFERENCES workplaces (id) ON DELETE RESTRICT;

ALTER TABLE calendar_assigns
DROP CONSTRAINT IF EXISTS fk_calendar_assigns_department;

ALTER TABLE calendar_assigns
ADD CONSTRAINT fk_calendar_assigns_department
FOREIGN KEY (department_id) REFERENCES departments (id) ON DELETE RESTRICT;

ALTER TABLE calendar_assigns
DROP CONSTRAINT IF EXISTS fk_calendar_assigns_team;

ALTER TABLE calendar_assigns
ADD CONSTRAINT fk_calendar_assigns_team
FOREIGN KEY (team_id) REFERENCES teams (id) ON DELETE RESTRICT;

-- notification_providers
-- company_id BIGINT NOT NULL REFERENCES companies(id) ON DELETE CASCADE,

ALTER TABLE notification_providers
DROP CONSTRAINT IF EXISTS notification_providers_company_id_fkey;

ALTER TABLE notification_providers
ADD CONSTRAINT notification_providers_company_id_fkey
FOREIGN KEY (company_id) REFERENCES companies (id) ON DELETE RESTRICT;

-- notification_events
-- company_id BIGINT REFERENCES companies(id) ON DELETE CASCADE,
ALTER TABLE notification_events
DROP CONSTRAINT IF EXISTS notification_events_company_id_fkey;

ALTER TABLE notification_events
ADD CONSTRAINT notification_events_company_id_fkey
FOREIGN KEY (company_id) REFERENCES companies (id) ON DELETE RESTRICT;

-- notification_bindings
-- company_id BIGINT NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
-- event_id BIGINT NOT NULL REFERENCES notification_events(id) ON DELETE CASCADE,
ALTER TABLE notification_bindings
DROP CONSTRAINT IF EXISTS notification_bindings_company_id_fkey;

ALTER TABLE notification_bindings
ADD CONSTRAINT notification_bindings_company_id_fkey
FOREIGN KEY (company_id) REFERENCES companies (id) ON DELETE RESTRICT;

ALTER TABLE notification_bindings
DROP CONSTRAINT IF EXISTS notification_bindings_event_id_fkey;

ALTER TABLE notification_bindings
ADD CONSTRAINT notification_bindings_event_id_fkey
FOREIGN KEY (event_id) REFERENCES notification_events (id) ON DELETE RESTRICT;

-- employment_status
-- company_id BIGINT NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
ALTER TABLE employment_status
DROP CONSTRAINT IF EXISTS employment_status_company_id_fkey;

ALTER TABLE employment_status
ADD CONSTRAINT employment_status_company_id_fkey
FOREIGN KEY (company_id) REFERENCES companies (id) ON DELETE RESTRICT;

-- employment_status_history
-- company_id BIGINT NOT NULL REFERENCES companies(id),
-- employee_id BIGINT NOT NULL REFERENCES employees(id),
-- status_id BIGINT NOT NULL REFERENCES employment_status(id),
ALTER TABLE employment_status_history
DROP CONSTRAINT IF EXISTS employment_status_history_company_id_fkey;

ALTER TABLE employment_status_history
ADD CONSTRAINT employment_status_history_company_id_fkey
FOREIGN KEY (company_id) REFERENCES companies (id) ON DELETE RESTRICT;

ALTER TABLE employment_status_history
DROP CONSTRAINT IF EXISTS employment_status_history_employee_id_fkey;

ALTER TABLE employment_status_history
ADD CONSTRAINT employment_status_history_employee_id_fkey
FOREIGN KEY (employee_id) REFERENCES employees (id) ON DELETE RESTRICT;

ALTER TABLE employment_status_history
DROP CONSTRAINT IF EXISTS employment_status_history_status_id_fkey;

ALTER TABLE employment_status_history
ADD CONSTRAINT employment_status_history_status_id_fkey
FOREIGN KEY (status_id) REFERENCES employment_status (id) ON DELETE RESTRICT;

-- employee_documents
--     CONSTRAINT fk_employee_documents_employee
--     FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE,

--     CONSTRAINT fk_employee_documents_type
--     FOREIGN KEY (document_type_id) REFERENCES document_types(id) ON DELETE RESTRICT);

--     ALTER TABLE employee_documents ADD CONSTRAINT fk_employee_documents_current_version
--     FOREIGN KEY (current_version_id) REFERENCES employee_document_versions(id) ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE employee_documents
DROP CONSTRAINT IF EXISTS fk_employee_documents_employee;

ALTER TABLE employee_documents
ADD CONSTRAINT fk_employee_documents_employee
FOREIGN KEY (employee_id) REFERENCES employees (id) ON DELETE RESTRICT;

ALTER TABLE employee_documents
DROP CONSTRAINT IF EXISTS fk_employee_documents_type;

ALTER TABLE employee_documents
ADD CONSTRAINT fk_employee_documents_type
FOREIGN KEY (document_type_id) REFERENCES document_types (id) ON DELETE RESTRICT;

ALTER TABLE employee_documents
DROP CONSTRAINT IF EXISTS fk_employee_documents_current_version;

ALTER TABLE employee_documents
ADD CONSTRAINT fk_employee_documents_current_version
FOREIGN KEY (current_version_id) REFERENCES employee_document_versions (id) ON DELETE RESTRICT;

-- employee_document_versions
-- ALTER TABLE employee_document_versions ADD CONSTRAINT fk_employee_document
-- FOREIGN KEY (employee_document_id) REFERENCES employee_documents(id) ON DELETE CASCADE;

-- ALTER TABLE employee_document_versions ADD CONSTRAINT fk_document_versions_uploaded_by
-- FOREIGN KEY (uploaded_by) REFERENCES users(id);
ALTER TABLE employee_document_versions
DROP CONSTRAINT IF EXISTS fk_employee_document;

ALTER TABLE employee_document_versions
ADD CONSTRAINT fk_employee_document
FOREIGN KEY (employee_document_id) REFERENCES employee_documents (id) ON DELETE RESTRICT;

ALTER TABLE employee_document_versions
DROP CONSTRAINT IF EXISTS fk_document_versions_uploaded_by;

ALTER TABLE employee_document_versions
ADD CONSTRAINT fk_document_versions_uploaded_by
FOREIGN KEY (uploaded_by) REFERENCES users (id) ON DELETE RESTRICT;


-- document_verifications
-- CONSTRAINT fk_employee_document
--     FOREIGN KEY (employee_document_id)
--     REFERENCES employee_documents (id)
--     ON DELETE CASCADE,

-- CONSTRAINT fk_document_version
--     FOREIGN KEY (version_id)
--     REFERENCES employee_document_versions (id)
--     ON DELETE CASCADE,

-- CONSTRAINT fk_verified_by
--     FOREIGN KEY (verified_by)
--     REFERENCES users (id)
--     ON DELETE CASCADE

ALTER TABLE document_verifications
DROP CONSTRAINT IF EXISTS fk_employee_document;

ALTER TABLE document_verifications
ADD CONSTRAINT fk_employee_document
FOREIGN KEY (employee_document_id) REFERENCES employee_documents (id) ON DELETE RESTRICT;

ALTER TABLE document_verifications
DROP CONSTRAINT IF EXISTS fk_document_version;

ALTER TABLE document_verifications
ADD CONSTRAINT fk_document_version
FOREIGN KEY (version_id) REFERENCES employee_document_versions (id) ON DELETE RESTRICT;

ALTER TABLE document_verifications
DROP CONSTRAINT IF EXISTS fk_verified_by;

ALTER TABLE document_verifications
ADD CONSTRAINT fk_verified_by
FOREIGN KEY (verified_by) REFERENCES users (id) ON DELETE RESTRICT;

-- document_expiry_alerts
-- CONSTRAINT fk_employee_document_alert
--     FOREIGN KEY (employee_document_id)
--     REFERENCES employee_documents (id)
--     ON DELETE CASCADE,

-- CONSTRAINT fk_sent_to_user
--     FOREIGN KEY (sent_to)
--     REFERENCES users (id)
--     ON DELETE CASCADE

ALTER TABLE document_expiry_alerts
DROP CONSTRAINT IF EXISTS fk_employee_document_alert;

ALTER TABLE document_expiry_alerts
ADD CONSTRAINT fk_employee_document_alert
FOREIGN KEY (employee_document_id) REFERENCES employee_documents (id) ON DELETE RESTRICT;

ALTER TABLE document_expiry_alerts
DROP CONSTRAINT IF EXISTS fk_sent_to_user;

ALTER TABLE document_expiry_alerts
ADD CONSTRAINT fk_sent_to_user
FOREIGN KEY (sent_to) REFERENCES users (id) ON DELETE RESTRICT;