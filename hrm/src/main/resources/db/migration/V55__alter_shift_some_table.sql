-- shift_categories table
ALTER TABLE shift_category
ADD COLUMN type VARCHAR(255);

-- shifts table: নতুন columns add করুন
ALTER TABLE shifts
ADD COLUMN weekly_off VARCHAR(255),
ADD COLUMN department_id INTEGER NULL DEFAULT NULL,
ADD COLUMN team_id INTEGER NULL DEFAULT NULL;

-- shifts table: existing columns এর data type change করুন (যদি দরকার হয়)
ALTER TABLE shifts
ALTER COLUMN company_id TYPE BIGINT,
ALTER COLUMN business_unit_id TYPE BIGINT,
ALTER COLUMN work_place_group_id TYPE BIGINT,
ALTER COLUMN work_place_id TYPE BIGINT;

-- shifts table: foreign key constraints (সঠিক column names দিয়ে)
ALTER TABLE shifts
ADD CONSTRAINT fk_shift_company
    FOREIGN KEY (company_id)
    REFERENCES companies(id)
    ON DELETE RESTRICT;

ALTER TABLE shifts
ADD CONSTRAINT fk_shift_business_unit
    FOREIGN KEY (business_unit_id)
    REFERENCES business_units(id)
    ON DELETE RESTRICT;

ALTER TABLE shifts
ADD CONSTRAINT fk_shift_workplace_group
    FOREIGN KEY (work_place_group_id)  -- এখানে work_place_group_id
    REFERENCES workplace_groups(id)
    ON DELETE RESTRICT;

ALTER TABLE shifts
ADD CONSTRAINT fk_shift_workplace
    FOREIGN KEY (work_place_id)  -- এখানে work_place_id
    REFERENCES workplaces(id)
    ON DELETE RESTRICT;

ALTER TABLE shifts
ADD CONSTRAINT fk_shift_department
    FOREIGN KEY (department_id)
    REFERENCES departments(id)
    ON DELETE RESTRICT;

ALTER TABLE shifts
ADD CONSTRAINT fk_shift_team
    FOREIGN KEY (team_id)
    REFERENCES teams(id)
    ON DELETE RESTRICT;

-- shift_rotation_patterns table
ALTER TABLE shift_rotation_patterns
ADD COLUMN workplace_group_id BIGINT NULL DEFAULT NULL,
ADD COLUMN workplace_id BIGINT NULL DEFAULT NULL,
ADD COLUMN department_id BIGINT NULL DEFAULT NULL,
ADD COLUMN team_id BIGINT NULL DEFAULT NULL;

ALTER TABLE shift_rotation_patterns
ADD CONSTRAINT fk_shift_rotation_workplace_group
    FOREIGN KEY (workplace_group_id)
    REFERENCES workplace_groups(id)
    ON DELETE RESTRICT;

ALTER TABLE shift_rotation_patterns
ADD CONSTRAINT fk_shift_rotation_workplace
    FOREIGN KEY (workplace_id)
    REFERENCES workplaces(id)
    ON DELETE RESTRICT;

ALTER TABLE shift_rotation_patterns
ADD CONSTRAINT fk_shift_rotation_department
    FOREIGN KEY (department_id)
    REFERENCES departments(id)
    ON DELETE RESTRICT;

ALTER TABLE shift_rotation_patterns
ADD CONSTRAINT fk_shift_rotation_team
    FOREIGN KEY (team_id)
    REFERENCES teams(id)
    ON DELETE RESTRICT;

ALTER TABLE shift_rotation_patterns
ADD CONSTRAINT fk_shift_rotation_company
    FOREIGN KEY (company_id)
    REFERENCES companies(id)
    ON DELETE RESTRICT;

ALTER TABLE shift_rotation_patterns
ADD CONSTRAINT fk_shift_rotation_business_unit
    FOREIGN KEY (business_unit_id)
    REFERENCES business_units(id)
    ON DELETE RESTRICT;