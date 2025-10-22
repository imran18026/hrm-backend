CREATE TABLE notification_providers (
    id BIGSERIAL PRIMARY KEY,
    company_id BIGINT NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    channel VARCHAR(20) CHECK (channel IN ('EMAIL', 'PUSH', 'SMS', 'WEBHOOK')),
    provider_key VARCHAR(100) NOT NULL,
    status BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL
);
CREATE TABLE notification_events (
    id BIGSERIAL PRIMARY KEY,
    company_id BIGINT REFERENCES companies(id) ON DELETE CASCADE,
    event_key VARCHAR(255) UNIQUE NOT NULL,
    display_name VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(20) CHECK (category IN ('LEAVE', 'ATTENDANCE', 'AUTH', 'SYSTEM')),
    is_system BOOLEAN DEFAULT FALSE NOT NULL,
    status BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL
);
CREATE TABLE notification_bindings (
    id BIGSERIAL PRIMARY KEY,
    company_id BIGINT NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    event_id BIGINT NOT NULL REFERENCES notification_events(id) ON DELETE CASCADE,
    audience_type VARCHAR(20) CHECK (audience_type IN ('EMPLOYEE', 'SUPERVISOR', 'HR', 'ROLE', 'USER')),
    audience_ref_id UUID NULL,
    priority INT DEFAULT 100 NOT NULL,
    status BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL
);