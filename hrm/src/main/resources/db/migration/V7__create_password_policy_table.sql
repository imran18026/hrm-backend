--create password policy
CREATE TABLE password_policy (
    id SERIAL PRIMARY KEY,
    min_length VARCHAR(15) NOT NULL,
    max_length VARCHAR(25) NOT NULL,
    expiration INTEGER,
    rotation   INTEGER,
    grace_period INTEGER,
    pass_recovery_param VARCHAR(50),
    token_validity INTEGER,
    login_attempt_allowed INTEGER,
    password_lock_duration INTEGER,
    brute_force_protection INTEGER,
    throttle_attempt INTEGER,
    created_by integer NULL,
    last_modified_by integer NULL,
    version integer DEFAULT 1 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);