CREATE TABLE locations (
     id SERIAL PRIMARY KEY,
     country_id INTEGER,
     parent_id INTEGER,
     name VARCHAR(100),
     type VARCHAR(100),
     geo_hash VARCHAR(100),
     status BOOLEAN DEFAULT true,
     created_by integer NULL,
     last_modified_by integer NULL,
     version integer DEFAULT 1 NOT NULL,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
     updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
     FOREIGN KEY (country_id) REFERENCES countries(id),
     FOREIGN KEY (parent_id) REFERENCES locations(id)
);