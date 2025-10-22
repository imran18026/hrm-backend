-- Create bank branch table
CREATE TABLE bank_branches (
    id SERIAL PRIMARY KEY,
    version integer DEFAULT 1 NOT NULL,

    bank_id INT NOT NULL,
    location_id INT,
    branch_name VARCHAR(255) NOT NULL,
    branch_code VARCHAR(255),
    routing_no VARCHAR(255),
    swift_code VARCHAR(255),
    email VARCHAR(255),
    address_line1 VARCHAR(255),
    address_line2 VARCHAR(255),
    district VARCHAR(255),
    status BOOLEAN DEFAULT true,

    created_by integer NULL,
    last_modified_by integer NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,


    CONSTRAINT fk_bank FOREIGN KEY (bank_id) REFERENCES banks(id) ON DELETE CASCADE,
    CONSTRAINT fk_location FOREIGN KEY (location_id) REFERENCES locations(id) ON DELETE CASCADE
);

