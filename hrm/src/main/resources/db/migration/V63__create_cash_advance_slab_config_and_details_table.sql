	---------------------------------------cash_advance_slab_config-----------------------------------------------------------------
	CREATE TABLE cash_advance_slab_config (
                                        id SERIAL PRIMARY KEY,
                                        advance_request_day  INTEGER NOT NULL,
                                        employee_type_id  BIGINT NOT NULL,
                                        department_id BIGINT,
                                        designation_id BIGINT,
                                        company_id BIGINT,
                                        business_units_id BIGINT,
                                        workplace_group_id  BIGINT,
										workplace_id BIGINT,
										team_id BIGINT,
										effective_from_date DATE,
										effective_to_date DATE,
                                        remarks VARCHAR(500),
                                        is_approved_amount_change boolean NOT NULL DEFAULT FALSE,
                                        status boolean NOT NULL DEFAULT FALSE,
                                        created_by INT NULL,
                                        last_modified_by INT NULL,
                                        version INT DEFAULT 1 NOT NULL,
                                        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

                                        CONSTRAINT fk_cash_advance_slab_config_departments FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE RESTRICT,
                                        CONSTRAINT fk_cash_advance_slab_config_designations FOREIGN KEY (designation_id) REFERENCES designations(id) ON DELETE RESTRICT,
                                        CONSTRAINT fk_cash_advance_slab_config_employee_types FOREIGN KEY (employee_type_id) REFERENCES employee_types(id) ON DELETE RESTRICT,

										CONSTRAINT fk_cash_advance_slab_config_companies FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE RESTRICT,
										CONSTRAINT fk_cash_advance_slab_config_business_units FOREIGN KEY (business_units_id) REFERENCES business_units(id) ON DELETE RESTRICT,
										CONSTRAINT fk_cash_advance_slab_config_workplace_groups FOREIGN KEY (workplace_group_id) REFERENCES workplace_groups(id) ON DELETE RESTRICT,
										CONSTRAINT fk_cash_advance_slab_config_workplaces FOREIGN KEY (workplace_id) REFERENCES workplaces(id) ON DELETE RESTRICT,
										CONSTRAINT fk_cash_advance_slab_config_teams FOREIGN KEY (team_id) REFERENCES teams(id) ON DELETE RESTRICT
             );

		-- ==============================================

        ----------------------------- create table advance_salary_request------------------------------------------------------------
			CREATE TABLE cash_advance_slab_config_details (
                                        id SERIAL PRIMARY KEY,
                                        cash_advance_slab_config_id  BIGINT NOT NULL,
                                        advance_amount_type  VARCHAR,
                                        advance_amount NUMERIC(18,2),
                                        service_charge_type VARCHAR,
                                        service_charge_amount NUMERIC(18,2),
                                        from_amount NUMERIC(18,2),
                                        to_amount  NUMERIC(18,2),
                                        created_by INT NULL,
                                        last_modified_by INT NULL,
                                        version INT DEFAULT 1 NOT NULL,
                                        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP


             );

