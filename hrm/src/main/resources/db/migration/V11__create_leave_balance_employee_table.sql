-- V12__create_leave_balance_employee_table.sql
CREATE TABLE leave_balance_employee (
    id SERIAL PRIMARY KEY,
    version INT DEFAULT 1 NOT NULL,
    employee_id BIGINT NOT NULL,
    leave_type_id BIGINT NOT NULL,
    year INT NOT NULL,

    entitled_days INT DEFAULT 0 NOT NULL,
    carried_forward INT DEFAULT 0 NOT NULL,
    encashed INT DEFAULT 0 NOT NULL,
    used_days INT DEFAULT 0 NOT NULL,
    balance INT DEFAULT 0 NOT NULL,

    deleted_at TIMESTAMP NULL,
    created_by INT NULL,
    last_modified_by INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (leave_type_id) REFERENCES leave_types(id),
    FOREIGN KEY (employee_id) REFERENCES employees(id)
);

