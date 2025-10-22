-- Create menus table
CREATE TABLE menus (
    id SERIAL PRIMARY KEY,
    permission_id BIGINT  NULL,
    parent_id INT NULL,
    name VARCHAR(125) NOT NULL,
    url VARCHAR(255) NULL,
    icon VARCHAR(255) NULL,
    header_menu BOOLEAN DEFAULT FALSE,
    sidebar_menu BOOLEAN DEFAULT FALSE,
    dropdown_menu BOOLEAN DEFAULT FALSE,
    children_parent_menu BOOLEAN DEFAULT FALSE,
    status BOOLEAN DEFAULT FALSE,
    created_by INT NULL,
    last_modified_by INT NULL,
    version INT DEFAULT 1 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_permission FOREIGN KEY (permission_id) REFERENCES permissions(id) ON DELETE SET NULL,
    CONSTRAINT fk_parent FOREIGN KEY (parent_id) REFERENCES menus(id) ON DELETE SET NULL
);