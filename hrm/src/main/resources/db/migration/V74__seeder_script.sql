-- ==============================================
-- TRUNCATE existing data if running a fresh seed
-- (Uncomment if you want to clear existing permission assignments for roles)
-- ==============================================
-- TRUNCATE TABLE role_has_permission; -- No SERIAL ID, so RESTART IDENTITY is not needed.

-- ==============================================
-- Role Has Permission Seeder (Assign permissions to roles)
-- ==============================================

-- Assign all permissions to SuperAdmin (role_id = 1)
INSERT INTO role_has_permission (role_id, permission_id)
SELECT 1, id FROM permissions;

-- Example of Admin having specific permissions (role_id = 2)
-- Note: Adjust permission IDs based on your actual `permissions` table data
INSERT INTO role_has_permission (role_id, permission_id) VALUES
(2, 5), -- Admin -> permission-delete (example, ensure this matches actual permission ID)
(2, 6), -- Admin -> role-list
(2, 7), -- Admin -> role-create
(2, 8), -- Admin -> role-edit
(2, 9), -- Admin -> role-delete
(2, 10), -- Admin -> user-list
(2, 11), -- Admin -> user-create
(2, 12); -- Admin -> user-edit

-- Example of Manager having specific permissions (role_id = 3)
-- Note: Adjust permission IDs based on your actual `permissions` table data
INSERT INTO role_has_permission (role_id, permission_id) VALUES
(3, 1), -- Manager -> Dashboard
(3, 3), -- Manager -> permission-create (example, ensure this matches actual permission ID)
(3, 9), -- Manager -> role-delete (example, ensure this matches actual permission ID)
(3, 11); -- Manager -> user-create (example, ensure this matches actual permission ID)

-- No sequence to reset as 'role_has_permission' is a join table without its own SERIAL ID.


-- ==============================================
-- TRUNCATE existing data if running a fresh seed
-- (Uncomment if you want to clear existing role assignments for users)
-- ==============================================
-- TRUNCATE TABLE model_has_role; -- No SERIAL ID, so RESTART IDENTITY is not needed.

-- ==============================================
-- Model Has Role Seeder (Assign roles to users)
-- ==============================================
INSERT INTO model_has_role (user_id, role_id) VALUES
(1, 1), -- super-admin (ID 1) -> SuperAdmin (ID 1)
(2, 1), -- super-admin2 (ID 2) -> SuperAdmin (ID 1)
(3, 2), -- admin (ID 3) -> Admin (ID 2)
(4, 3); -- manager (ID 4) -> Manager (ID 3)

-- No sequence to reset as 'model_has_role' is a join table without its own SERIAL ID.