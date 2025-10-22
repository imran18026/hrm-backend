CREATE TABLE leave_assigns (
    id BIGSERIAL PRIMARY KEY,

    leave_type_id BIGINT REFERENCES leave_types(id) ON DELETE SET NULL,
    leave_group_id BIGINT REFERENCES leave_groups(id) ON DELETE SET NULL,
    company_id BIGINT REFERENCES companies(id) ON DELETE SET NULL,
    business_unit_id BIGINT REFERENCES business_units(id) ON DELETE SET NULL,
    work_place_group_id BIGINT REFERENCES workplace_groups(id) ON DELETE SET NULL,
    work_place_id BIGINT REFERENCES workplaces(id) ON DELETE SET NULL,
    department_id BIGINT REFERENCES departments(id) ON DELETE SET NULL,
    team_id BIGINT REFERENCES teams(id) ON DELETE SET NULL,

    description TEXT,
    status BOOLEAN DEFAULT true,

    created_by integer NULL,
    last_modified_by integer NULL,
    version integer DEFAULT 1 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);