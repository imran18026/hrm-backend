-- Feroz
CREATE TABLE institute_name (
      id SERIAL PRIMARY KEY,
      name VARCHAR(250) NOT NULL,
      created_by integer NULL,
      last_modified_by integer NULL,
      version integer DEFAULT 1 NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE employee_education_info (
    id SERIAL PRIMARY KEY,
	employee_id  BIGINT NOT NULL,
    qualification_type_id BIGINT,
	qualification_level_id BIGINT,
    institute_name_id BIGINT,
	field_study_id  BIGINT,
	subject  VARCHAR(100),
	qualification_rating_method_id BIGINT,
	result  VARCHAR(50),
	passing_year  INT,
    created_by integer NULL,
    last_modified_by integer NULL,
    version integer DEFAULT 1 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

	CONSTRAINT fk_employees FOREIGN KEY (employee_id) REFERENCES employees (id) ON DELETE RESTRICT,

	CONSTRAINT fk_qualification_type FOREIGN KEY (qualification_type_id) REFERENCES qualification_type (id) ON DELETE RESTRICT,
	CONSTRAINT fk_qualification_level FOREIGN KEY (qualification_level_id) REFERENCES qualification_level (id) ON DELETE RESTRICT,
	CONSTRAINT fk_institute_name FOREIGN KEY (institute_name_id) REFERENCES institute_name (id) ON DELETE RESTRICT,
	CONSTRAINT fk_field_study FOREIGN KEY (field_study_id) REFERENCES field_study (id) ON DELETE RESTRICT,
	CONSTRAINT fk_qualification_rating_methods FOREIGN KEY (qualification_rating_method_id) REFERENCES qualification_rating_methods (id) ON DELETE RESTRICT

   );

CREATE TABLE employee_work_experience (
    id SERIAL PRIMARY KEY,
	employee_id   BIGINT NOT NULL,
	company_name  VARCHAR(250) NOT NULL,
    job_title VARCHAR(100),
	location VARCHAR(250),
    job_description VARCHAR(100),
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	tenure NUMERIC(4,2),
    image VARCHAR(250),
	image_url VARCHAR(250),
    created_by integer NULL,
    last_modified_by integer NULL,
    version integer DEFAULT 1 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_employees FOREIGN KEY (employee_id) REFERENCES employees (id) ON DELETE RESTRICT

   );

-- Tafseer
CREATE TABLE transfer_requests (
    id BIGSERIAL PRIMARY KEY,
    employee_id BIGINT NOT NULL REFERENCES employees(id) ON DELETE RESTRICT,
    request_type VARCHAR(20) NOT NULL CHECK (request_type IN ('IntraCompany', 'InterBranch', 'InterCompany')),
    from_company_id BIGINT NOT NULL REFERENCES companies(id) ON DELETE RESTRICT,
    to_company_id BIGINT NOT NULL REFERENCES companies(id) ON DELETE RESTRICT,
    from_workplace_id BIGINT NOT NULL REFERENCES workplaces(id) ON DELETE RESTRICT,
    to_workplace_id BIGINT NOT NULL REFERENCES workplaces(id) ON DELETE RESTRICT,
    from_department_id BIGINT NOT NULL REFERENCES departments(id) ON DELETE RESTRICT,
    to_department_id BIGINT NOT NULL REFERENCES departments(id) ON DELETE RESTRICT,
    from_designation_id BIGINT NOT NULL REFERENCES designations(id) ON DELETE RESTRICT,
    to_designation_id BIGINT NOT NULL REFERENCES designations(id) ON DELETE RESTRICT,
    reason TEXT,
    effective_date DATE NOT NULL,
    approval_status VARCHAR(30) DEFAULT 'Pending'
        CHECK (approval_status IN ('Pending', 'SupervisorApproved', 'HRApproved', 'AdminApproved', 'Rejected')),
    approved_by BIGINT NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    approved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status BOOLEAN,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL
);
CREATE TABLE promotion_requests (
    id BIGSERIAL PRIMARY KEY,
    employee_id BIGINT NOT NULL REFERENCES employees(id) ON DELETE RESTRICT,
    current_grade_id BIGINT REFERENCES grade(id) ON DELETE RESTRICT,
    new_grade_id BIGINT REFERENCES grade(id) ON DELETE RESTRICT,
    current_designation_id BIGINT REFERENCES designations(id),
    new_designation_id BIGINT REFERENCES designations(id),
    appraisal_id BIGINT ,
    justification TEXT,
    promotion_type VARCHAR(20) CHECK (promotion_type IN ('Promotion', 'Demotion')),
    effective_date DATE NOT NULL,
    salary_change DECIMAL(10,2),
    approval_status VARCHAR(30) DEFAULT 'Pending'
      CHECK (approval_status IN ('Pending', 'SupervisorApproved', 'HRApproved', 'AdminApproved', 'Rejected')),
    approved_by BIGINT REFERENCES users(id) ON DELETE RESTRICT,
    approved_at TIMESTAMP,
    status BOOLEAN,
   	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL
);
CREATE TABLE acting_assignments (
    id BIGSERIAL PRIMARY KEY,
    employee_id BIGINT NOT NULL REFERENCES employees(id) ON DELETE RESTRICT,
    acting_role_id BIGINT NOT NULL REFERENCES designations(id) ON DELETE RESTRICT,
    from_department_id BIGINT NOT NULL REFERENCES departments(id) ON DELETE RESTRICT,
    to_department_id BIGINT NOT NULL REFERENCES departments(id) ON DELETE RESTRICT,
    acting_supervisor_id BIGINT NOT NULL REFERENCES employees(id) ON DELETE RESTRICT,
    assignment_type VARCHAR(20) DEFAULT 'Acting Role' CHECK (assignment_type IN ('ActingRole', 'Deputation')),
    start_date DATE NOT NULL,
    end_date DATE,
    remarks TEXT,
    approval_status VARCHAR(20) DEFAULT 'Pending' CHECK (approval_status IN ('Pending', 'Approved', 'Rejected')),
    approved_by BIGINT REFERENCES users(id),
    approved_at TIMESTAMP,
    status BOOLEAN,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL
);
CREATE TABLE employee_assignment_history (
    id BIGSERIAL PRIMARY KEY,
    employee_id BIGINT NOT NULL REFERENCES employees(id) ON DELETE RESTRICT,
    change_type VARCHAR(30) NOT NULL
        CHECK (change_type IN ('Transfer', 'Promotion', 'Demotion', 'ActingAssignment', 'Deputation')),
    from_department_id BIGINT REFERENCES departments(id) ON DELETE RESTRICT,
    to_department_id BIGINT REFERENCES departments(id) ON DELETE RESTRICT,
    from_designation_id BIGINT REFERENCES designations(id) ON DELETE RESTRICT,
    to_designation_id BIGINT REFERENCES designations(id) ON DELETE RESTRICT,
    effective_date DATE NOT NULL,
    approved_by BIGINT REFERENCES users(id) ON DELETE RESTRICT,
    reference_id BIGINT,
    remarks TEXT,
   	status BOOLEAN DEFAULT true,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL
);
CREATE TABLE approval_workflows (
    id BIGSERIAL PRIMARY KEY,
    module VARCHAR(30) NOT NULL CHECK (module IN ('Transfer', 'Promotion', 'ActingAssignment')),
    level INT NOT NULL CHECK (level >= 1),
    approver_role_id BIGINT NOT NULL REFERENCES roles(id) ON DELETE RESTRICT,
    approver_id BIGINT REFERENCES users(id) ON DELETE SET NULL,
    sla_hours INT CHECK (sla_hours >= 0),
    escalation_to BIGINT REFERENCES roles(id) ON DELETE SET NULL,
   	status BOOLEAN DEFAULT true,
  	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL
);

-- Yasir
ALTER TABLE companies
ADD COLUMN IF NOT EXISTS currency VARCHAR(5);

ALTER TABLE companies
ADD COLUMN IF NOT EXISTS time_zone VARCHAR(64);