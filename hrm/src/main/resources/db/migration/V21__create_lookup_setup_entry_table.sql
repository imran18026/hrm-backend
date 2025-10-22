CREATE TABLE lookup_setup_entry (
    id BIGSERIAL PRIMARY KEY,                          -- Auto increment PK
    name VARCHAR(100) NOT NULL,                        -- e.g., Annual Leave, Sick Leave
    status BOOLEAN DEFAULT true,                       -- Active by default
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,    -- Auto set on insert
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,    -- Auto set on insert (can be updated later via trigger)
    deleted_at TIMESTAMP NULL,                         -- Soft delete (null = not deleted)
    created_by INTEGER NULL,                           -- User ID who created
    last_modified_by INTEGER NULL,                     -- User ID who modified
    version INTEGER DEFAULT 1 NOT NULL                 -- Version control
);

