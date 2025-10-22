CREATE TABLE working_types(
     id SERIAL PRIMARY KEY,
     name VARCHAR(100),
     status BOOLEAN DEFAULT true,
     created_by integer NULL,
     last_modified_by integer NULL,
     version integer DEFAULT 1 NOT NULL,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
     updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);