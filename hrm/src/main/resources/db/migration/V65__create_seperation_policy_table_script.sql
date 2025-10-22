
CREATE TABLE separation_policies (
    id SERIAL PRIMARY KEY,
    company_id INT NOT NULL,
    workplace_id INT,
    name VARCHAR(255) NOT NULL,
    code VARCHAR(10) NOT NULL UNIQUE,
    description VARCHAR(255),
    effective_from DATE,
    effective_to DATE,
    separation_policy_status VARCHAR(20) NOT NULL,
    previous_version_id INT,
    approved_by INT,
    status BOOLEAN DEFAULT true,

    created_by integer NULL,
    last_modified_by integer NULL,
    version integer DEFAULT 1 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CHECK (separation_policy_status IN ('DRAFT','VALIDATED','PUBLISHED','ARCHIVED')),
    CONSTRAINT fk_company FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
    CONSTRAINT fk_workplace FOREIGN KEY (workplace_id) REFERENCES workplaces(id) ON DELETE CASCADE
);


CREATE TABLE separation_policy_versions (
    id SERIAL PRIMARY KEY,
     company_id INT NOT NULL,
    workplace_id INT,
    name VARCHAR(255) NOT NULL,
    code VARCHAR(10) NOT NULL,
    description VARCHAR(255),
    effective_from DATE,
    effective_to DATE,
    separation_policy_status VARCHAR(20) NOT NULL,
    previous_version_id BIGINT NULL,
    separation_policy_id BIGINT NOT NULL,
    approved_by BIGINT NULL,
    created_by integer NULL,
    last_modified_by integer NULL,
    version integer DEFAULT 1 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_separation_policy FOREIGN KEY (separation_policy_id) REFERENCES separation_policies(id),
    CONSTRAINT fk_company FOREIGN KEY (company_id) REFERENCES companies(id),
    CONSTRAINT fk_workplace FOREIGN KEY (workplace_id) REFERENCES workplaces(id)
);

ALTER TABLE employees add column device_user_id VARCHAR(25);