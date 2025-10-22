-- V31__alter_leave_request_schema_update.sql

ALTER TABLE leave_requests
    ADD COLUMN justification TEXT;