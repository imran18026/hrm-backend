-- create table advance_salary_config

CREATE TABLE advance_salary_config (
                                       id SERIAL PRIMARY KEY,
                                       minimum_woking_days INT,
                                       employee_type_id BIGINT,
                                       advance_limit_percent NUMERIC(4,2),
                                       advance_limit_amount NUMERIC(18,2),
                                       service_charge_percent NUMERIC(4,2),
                                       service_charge_amount NUMERIC(18,2),
                                       is_approved_amount_change BOOLEAN NOT NULL DEFAULT FALSE,
                                       status BOOLEAN NOT NULL DEFAULT FALSE,
                                       created_by INT NULL,
                                       last_modified_by INT NULL,
                                       version INT DEFAULT 1 NOT NULL,
                                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                       updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                       CONSTRAINT fk_advance_salary_config FOREIGN KEY (employee_type_id) REFERENCES employee_types(id) ON DELETE RESTRICT
);

-- ==============================================

-- create table advance_salary_request

CREATE TABLE advance_salary_request (
                                        id SERIAL PRIMARY KEY,
                                        request_id  BIGINT NOT NULL,
                                        employee_id  BIGINT NOT NULL,
                                        employee_name VARCHAR(150),
                                        department_id BIGINT,
                                        designation_id BIGINT,
                                        employee_type_id BIGINT,
                                        request_date  Date,
                                        requested_amount_percent NUMERIC(4,2),
                                        requested_amount NUMERIC(18,2),
                                        reason VARCHAR(500),
                                        remarks VARCHAR(500),
                                        status VARCHAR(15) CHECK (status IN ('PENDING', 'REJECT', 'APPROVED','FORWARD')),
                                        created_by INT NULL,
                                        last_modified_by INT NULL,
                                        version INT DEFAULT 1 NOT NULL,
                                        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                        CONSTRAINT fk_advance_salary_request_employees FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE RESTRICT,
                                        CONSTRAINT fk_advance_salary_request_departments FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE RESTRICT,
                                        CONSTRAINT fk_advance_salary_request_designations FOREIGN KEY (designation_id) REFERENCES designations(id) ON DELETE RESTRICT,
                                        CONSTRAINT fk_advance_salary_request_employee_types FOREIGN KEY (employee_type_id) REFERENCES employee_types(id) ON DELETE RESTRICT
);


-- ==============================================

--create sequence for generating cash advance request id

CREATE SEQUENCE IF NOT EXISTS advance_cash_request_seq START 100000 INCREMENT 1 MINVALUE 1 MAXVALUE 999999;