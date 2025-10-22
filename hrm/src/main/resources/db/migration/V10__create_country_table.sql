CREATE TABLE countries (
     id SERIAL PRIMARY KEY,
     code VARCHAR(10) NOT NULL,
     name VARCHAR(100) NOT NULL,
     region VARCHAR(100),
     created_by integer NULL,
     last_modified_by integer NULL,
     version integer DEFAULT 1 NOT NULL,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
     updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);