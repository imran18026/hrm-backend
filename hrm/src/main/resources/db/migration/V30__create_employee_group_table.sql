
-- Create employee group table
CREATE TABLE employee_groups (
    id SERIAL PRIMARY KEY,
    version integer DEFAULT 1 NOT NULL,

    company_id INT NOT NULL,
    workplace_id INT,
    group_name VARCHAR(255) NOT NULL,
    group_code VARCHAR(255),
    description VARCHAR(255),
    status BOOLEAN DEFAULT true,

    created_by integer NULL,
    last_modified_by integer NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_company FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
    CONSTRAINT fk_workplace FOREIGN KEY (workplace_id) REFERENCES workplaces(id) ON DELETE CASCADE
);

