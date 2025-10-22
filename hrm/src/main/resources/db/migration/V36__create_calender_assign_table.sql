CREATE TABLE calendar_assigns (
    id BIGSERIAL PRIMARY KEY,

    calendar_id BIGINT NOT NULL,
    company_id BIGINT NOT NULL,
    business_unit_id BIGINT,
    work_place_group_id BIGINT,
    work_place_id BIGINT,
    department_id BIGINT,
    team_id BIGINT,

    description TEXT,
    status BOOLEAN DEFAULT true,

    created_by integer NULL,
    last_modified_by integer NULL,
    version integer DEFAULT 1 NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Foreign Keys
    CONSTRAINT fk_calendar_assigns_company
        FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,

    CONSTRAINT fk_calendar_assigns_business_unit
        FOREIGN KEY (business_unit_id) REFERENCES business_units(id) ON DELETE SET NULL,

    CONSTRAINT fk_calendar_assigns_work_place_group
        FOREIGN KEY (work_place_group_id) REFERENCES workplace_groups(id) ON DELETE SET NULL,

    CONSTRAINT fk_calendar_assigns_work_place
        FOREIGN KEY (work_place_id) REFERENCES workplaces(id) ON DELETE SET NULL,

    CONSTRAINT fk_calendar_assigns_department
        FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL,

    CONSTRAINT fk_calendar_assigns_team
        FOREIGN KEY (team_id) REFERENCES teams(id) ON DELETE SET NULL
);
