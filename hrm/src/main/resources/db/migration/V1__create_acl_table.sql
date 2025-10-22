-- company table
CREATE TABLE companies (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(255),
    created_by integer NULL,
    last_modified_by integer NULL,
    version integer DEFAULT 1 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- business unit
CREATE TABLE business_units (
    id SERIAL PRIMARY KEY,
    company_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    code VARCHAR(255),
    description VARCHAR(255),
    status BOOLEAN DEFAULT true,

    created_by integer NULL,
    last_modified_by integer NULL,
    version integer DEFAULT 1 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_company FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE
);

-- workplace group
CREATE TABLE workplace_groups (
    id SERIAL PRIMARY KEY,
    business_unit_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    code VARCHAR(255),
    description VARCHAR(255),
    status BOOLEAN DEFAULT true,


    created_by integer NULL,
    last_modified_by integer NULL,
    version integer DEFAULT 1 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,


    CONSTRAINT fk_business_unit FOREIGN KEY (business_unit_id) REFERENCES business_units(id) ON DELETE CASCADE
);

-- workplace
CREATE TABLE workplaces (
    id SERIAL PRIMARY KEY,
    workplace_group_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    code VARCHAR(255),
    address VARCHAR(255),
    description VARCHAR(255),
    status BOOLEAN DEFAULT true,


    created_by integer NULL,
    last_modified_by integer NULL,
    version integer DEFAULT 1 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,


    CONSTRAINT fk_workplace_group FOREIGN KEY (workplace_group_id) REFERENCES workplace_groups(id) ON DELETE CASCADE
);

-- department
CREATE TABLE departments (
    id BIGSERIAL PRIMARY KEY,
    workplace_id BIGINT REFERENCES workplaces(id) ON DELETE SET NULL,
    name VARCHAR(255) NOT NULL,
    code VARCHAR(50) UNIQUE,
    description TEXT,
    status BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	created_by integer NULL,
    last_modified_by integer NULL,
	deleted_at TIMESTAMP NULL,
    version integer DEFAULT 1 NOT NULL
);

-- employee types
CREATE TABLE employee_types(
   id SERIAL PRIMARY KEY,
   name VARCHAR(100) NOT NULL,
   description VARCHAR(500),
   status BOOLEAN DEFAULT true,
   created_by integer NULL,
   last_modified_by integer NULL,
   version integer DEFAULT 1 NOT NULL,
   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- grade
CREATE TABLE grade(
      id SERIAL PRIMARY KEY,
      code VARCHAR(50) NOT NULL,
      name VARCHAR(100),
      description VARCHAR(500),
      status BOOLEAN DEFAULT true,
      created_by integer NULL,
      last_modified_by integer NULL,
      version integer DEFAULT 1 NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- designation
CREATE TABLE designations (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    status BOOLEAN DEFAULT true,

    created_by integer NULL,
    last_modified_by integer NULL,
    version integer DEFAULT 1 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);

-- Employees Table
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    company_id INT,
    business_unit_id INT,
    work_place_group_id INT,
    workplace_id INT,
    department_id INT,
    employment_type_id INT,
    grade_id INT,
    designation_id INT,
    supervisor_id INT,
    line_manager_id INT,
    employee_serial_id INT UNIQUE,
    job_title VARCHAR(100),
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    photo VARCHAR(200),
    dob DATE,
    gender VARCHAR(10) CHECK (gender IN ('male', 'female', 'other')),
    national_id VARCHAR(55) UNIQUE,
    phone VARCHAR(15) UNIQUE,
    email VARCHAR(55) UNIQUE,
    present_address TEXT,
    permanent_address TEXT,
    marital_status VARCHAR(10) CHECK (marital_status IN ('Single', 'Married', 'Divorced', 'Widowed')),
    emergency_contact_name VARCHAR(100),
    emergency_contact_relation VARCHAR(50),
    emergency_contact_phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
    FOREIGN KEY (business_unit_id) REFERENCES business_units(id) ON DELETE CASCADE,
    FOREIGN KEY (work_place_group_id) REFERENCES workplace_groups(id) ON DELETE CASCADE,
    FOREIGN KEY (workplace_id) REFERENCES workplaces(id) ON DELETE CASCADE,
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE,
    FOREIGN KEY (employment_type_id) REFERENCES employee_types(id) ON DELETE CASCADE,
    FOREIGN KEY (grade_id) REFERENCES grade(id) ON DELETE CASCADE,
    FOREIGN KEY (designation_id) REFERENCES designations(id) ON DELETE CASCADE
);

-- Create users table
CREATE TABLE users (
   id SERIAL PRIMARY KEY,
   employee_serial_id integer NULL,
   name VARCHAR(255) NOT NULL,
   email VARCHAR(255) UNIQUE NOT NULL,
   phone VARCHAR(11) UNIQUE NOT NULL,
   user_type VARCHAR(50) NULL,
   email_verified_at TIMESTAMP NULL,
   password VARCHAR(255) NOT NULL,
   remember_token VARCHAR(100) NULL,
   is_active BOOLEAN DEFAULT TRUE NOT NULL,
   created_by integer NULL,
   last_modified_by integer NULL,
   version integer DEFAULT 1 NOT NULL,
   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   FOREIGN KEY (employee_serial_id) REFERENCES employees(employee_serial_id) ON DELETE CASCADE
);

-- Create roles table
CREATE TABLE roles (
   id SERIAL PRIMARY KEY,
   name VARCHAR(255) UNIQUE NOT NULL,
   guard_name VARCHAR(255) NOT NULL,
   created_by integer NULL,
   last_modified_by integer NULL,
   version integer DEFAULT 1 NOT NULL,
   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create permissions table
CREATE TABLE permissions (
     id SERIAL PRIMARY KEY,
     name VARCHAR(255) UNIQUE NOT NULL,
     guard_name VARCHAR(255) NOT NULL,
     created_by integer NULL,
     last_modified_by integer NULL,
     version integer DEFAULT 1 NOT NULL,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
     updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create role_has_permission join table
CREATE TABLE role_has_permission (
     role_id INT NOT NULL,
     permission_id INT NOT NULL,
     PRIMARY KEY (role_id, permission_id),
     FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
     FOREIGN KEY (permission_id) REFERENCES permissions(id) ON DELETE CASCADE
);

-- Create model_has_role join table
CREATE TABLE model_has_role (
    user_id INT NOT NULL,
    role_id INT NOT NULL,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
);

-- Insert roles (✅ fixed)
INSERT INTO roles (name, guard_name) VALUES
('SuperAdmin', 'api'),
('Admin', 'api'),
('Manager', 'api');

-- Insert permissions (✅ fixed)
INSERT INTO permissions (name, guard_name) VALUES
('Dashboard', 'api'),
('permission-list', 'api'),
('permission-create', 'api'),
('permission-edit', 'api'),
('permission-delete', 'api'),
('role-list', 'api'),
('role-create', 'api'),
('role-edit', 'api'),
('role-delete', 'api'),
('user-list', 'api'),
('user-create', 'api'),
('user-edit', 'api'),
('user-delete', 'api'),
('menu-list', 'api'),
('menu-create', 'api'),
('menu-edit', 'api'),
('menu-delete', 'api');

-- Insert users (✅ fixed ; instead of ,)
INSERT INTO users (name, email, phone, password, user_type) VALUES
('super-admin', 'superadmin@gmail.com', '01772119941','$2a$10$GJJsH9YA/zw8tuWEPw6xb.qns6BPk14N6tkNrb6kZ8bEGVTXjppS6', 'SuperAdmin'), -- password: password
('super-admin2', 'superadmin2@gmail.com', '01772119942','$2a$10$GJJsH9YA/zw8tuWEPw6xb.qns6BPk14N6tkNrb6kZ8bEGVTXjppS6', 'SuperAdmin'), -- password: password
('admin', 'admin@gmail.com', '01845932261', '$2a$10$GJJsH9YA/zw8tuWEPw6xb.qns6BPk14N6tkNrb6kZ8bEGVTXjppS6', 'Admin'),       -- password: password
('manager', 'manager@gmail.com', '01845932262', '$2a$10$GJJsH9YA/zw8tuWEPw6xb.qns6BPk14N6tkNrb6kZ8bEGVTXjppS6', 'Employee');     -- password: password

-- Assign roles to users (✅ fixed ; instead of ,)
INSERT INTO model_has_role (user_id, role_id) VALUES
(1, 1), -- super-admin -> SuperAdmin
(2, 1), -- super-admin -> SuperAdmin
(3, 2), -- admin -> Admin
(4, 3); -- manager -> Manager

-- Assign permissions to roles (SuperAdmin gets all permissions)
INSERT INTO role_has_permission (role_id, permission_id)
SELECT 1, id FROM permissions;

-- Example of Admin having specific permissions
INSERT INTO role_has_permission (role_id, permission_id) VALUES
(2, 5), -- Admin -> role-list
(2, 6), -- Admin -> role-create
(2, 7), -- Admin -> role-edit
(2, 8), -- Admin -> role-delete
(2, 9), -- Admin -> user-list
(2, 10), -- Admin -> user-create
(2, 11), -- Admin -> user-edit
(2, 12); -- Admin -> user-delete

-- Example of Manager having specific permissions
INSERT INTO role_has_permission (role_id, permission_id) VALUES
(3, 1), -- Manager -> permission-list
(3, 3), -- Manager -> permission-edit
(3, 9), -- Manager -> user-list
(3, 11); -- Manager -> user-edit