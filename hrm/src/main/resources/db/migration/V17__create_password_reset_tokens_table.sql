CREATE TABLE password_reset_tokens (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(150) NOT NULL,          -- user’s email (must match employee/user table)
    token VARCHAR(255) NOT NULL,          -- secure reset token (can be hashed)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NOT NULL,        -- when the token becomes invalid
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    created_by INTEGER NULL,
    last_modified_by INTEGER NULL,
    version INTEGER DEFAULT 1 NOT NULL
);
