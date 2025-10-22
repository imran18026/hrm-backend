CREATE TABLE employment_status (
    id BIGSERIAL PRIMARY KEY,
    company_id BIGINT NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    status_code VARCHAR(50) NOT NULL UNIQUE,
    status_name VARCHAR(100) NOT NULL,
    description TEXT,
    is_system BOOLEAN DEFAULT FALSE,
    status BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL
);

CREATE TABLE employment_status_history (
    id BIGSERIAL PRIMARY KEY,
    company_id BIGINT NOT NULL REFERENCES companies(id),
    employee_id BIGINT NOT NULL REFERENCES employees(id),
    status_id BIGINT NOT NULL REFERENCES employment_status(id),
    effective_from DATE NOT NULL,
    effective_to DATE,
    reason_code VARCHAR(100),
    remarks TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL
);

ALTER TABLE employees ADD COLUMN team_id INT;

CREATE TABLE employee_document_versions (
    id SERIAL PRIMARY KEY,
    employee_document_id BIGINT NOT NULL,
    uploaded_by BIGINT NULL,
    version_no INTEGER NOT NULL,
    file_path VARCHAR(255),
    uploaded_at TIMESTAMP,
    remarks TEXT,
    is_current BOOLEAN NOT NULL DEFAULT FALSE,

    deleted_at TIMESTAMP NULL,
    created_by integer NULL,
    version integer DEFAULT 1 NOT NULL,
    last_modified_by integer NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

    CREATE UNIQUE INDEX IF NOT EXISTS uq_document_version_no
        ON employee_document_versions (employee_document_id, version_no);

CREATE TABLE IF NOT EXISTS employee_documents (
    id SERIAL PRIMARY KEY,
    employee_id BIGINT NOT NULL,
    document_type_id BIGINT NOT NULL,
    current_version_id BIGINT UNIQUE,
    file_path VARCHAR(100),
    issue_date DATE,
    expiry_date DATE,
    status VARCHAR(10) NOT NULL DEFAULT 'ACTIVE'
    CHECK (status IN ('ACTIVE','EXPIRED','ARCHIVED')),

    deleted_at TIMESTAMP NULL,
    created_by integer NULL,
    version integer DEFAULT 1 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_modified_by integer NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_employee_documents_employee
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE,

    CONSTRAINT fk_employee_documents_type
    FOREIGN KEY (document_type_id) REFERENCES document_types(id) ON DELETE RESTRICT
);

    ALTER TABLE employee_document_versions ADD CONSTRAINT fk_employee_document
    FOREIGN KEY (employee_document_id) REFERENCES employee_documents(id) ON DELETE CASCADE;

    ALTER TABLE employee_documents ADD CONSTRAINT fk_employee_documents_current_version
    FOREIGN KEY (current_version_id) REFERENCES employee_document_versions(id) ON UPDATE CASCADE ON DELETE SET NULL;

    ALTER TABLE employee_document_versions ADD CONSTRAINT fk_document_versions_uploaded_by
    FOREIGN KEY (uploaded_by) REFERENCES users(id);