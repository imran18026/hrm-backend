-- Create bank table
CREATE TABLE banks (
    id SERIAL PRIMARY KEY,
    version integer DEFAULT 1 NOT NULL,

    country_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    short_name VARCHAR(255),
    bank_code VARCHAR(255),
    swift_code VARCHAR(255),
    website VARCHAR(255),
    support_email VARCHAR(255),
    status BOOLEAN DEFAULT true,

    created_by integer NULL,
    last_modified_by integer NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_country FOREIGN KEY (country_id) REFERENCES countries(id) ON DELETE CASCADE
);

