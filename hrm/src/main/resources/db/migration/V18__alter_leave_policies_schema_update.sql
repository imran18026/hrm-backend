--V30__alter_leave_policies_schema_update.sql

ALTER TABLE leave_policies
    ADD COLUMN overlap_allowed BOOLEAN DEFAULT FALSE NOT NULL,
    ADD COLUMN justification_required_for_overlap BOOLEAN DEFAULT FALSE NOT NULL;