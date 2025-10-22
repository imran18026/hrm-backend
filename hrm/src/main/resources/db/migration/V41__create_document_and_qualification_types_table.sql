ALTER TABLE leave_requests
    ALTER COLUMN days_requested TYPE NUMERIC(4,1) USING days_requested::NUMERIC,
    ALTER COLUMN days_requested SET DEFAULT 0,
    ALTER COLUMN days_requested SET NOT NULL,
    ADD COLUMN covering_employee_id BIGINT,
    ADD CONSTRAINT fk_leave_requests_covering_employee FOREIGN KEY (covering_employee_id) REFERENCES employees(id) ON DELETE SET NULL;

CREATE TABLE document_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(20) NOT NULL,
    description VARCHAR(255),
    is_required BOOLEAN NOT NULL DEFAULT FALSE,
    is_time_bound BOOLEAN NOT NULL DEFAULT FALSE,
    default_validity_months integer,

    deleted_at TIMESTAMP NULL,
    created_by integer NULL,
    last_modified_by integer NULL,
    version integer DEFAULT 1 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_category_type CHECK (category IN ('IDENTITY', 'COMPLIANCE','CERTIFICATION','VISA','LICENSE','CONTRACT','MISCELLANEOUS'))
);

-- Qualification Type
CREATE TABLE qualification_type (
    id SERIAL PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL,
    created_by integer NULL,
    last_modified_by integer NULL,
    version integer DEFAULT 1 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE qualification_level (
    id SERIAL PRIMARY KEY,
    qualification_type_id BIGINT NOT NULL,
    lavel_name VARCHAR(50) NOT NULL,
    created_by integer NULL,
    last_modified_by integer NULL,
    version integer DEFAULT 1 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE field_study (
    id SERIAL PRIMARY KEY,
    qualification_level_id BIGINT NOT NULL,
    field_study_name VARCHAR(100) NOT NULL,
    created_by integer NULL,
    last_modified_by integer NULL,
    version integer DEFAULT 1 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE qualification_rating_methods (
    id SERIAL PRIMARY KEY,
    code VARCHAR(50) NOT NULL,
    method_name VARCHAR(100),
    created_by integer NULL,
    last_modified_by integer NULL,
    version integer DEFAULT 1 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE qualification_rating_methods_details (
    id SERIAL PRIMARY KEY,
    qualification_rating_methods_id BIGINT,
    grade VARCHAR(10),
    maximum_mark BIGINT NOT NULL,
    minimum_mark BIGINT NOT NULL,
    average_mark  DOUBLE PRECISION,
    created_by integer NULL,
    last_modified_by integer NULL,
    version integer DEFAULT 1 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_qrmd_method FOREIGN KEY (qualification_rating_methods_id) REFERENCES qualification_rating_methods(id) ON DELETE CASCADE
);