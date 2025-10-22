-- insert permissions
INSERT INTO permissions (name, guard_name) VALUES
('company-list', 'api'),
('company-create', 'api'),
('company-edit', 'api'),
('company-delete', 'api'),

('business-unit-list', 'api'),
('business-unit-create', 'api'),
('business-unit-edit', 'api'),
('business-unit-delete', 'api'),

('work-place-group-list', 'api'),
('work-place-group-create', 'api'),
('work-place-group-edit', 'api'),
('work-place-group-delete', 'api'),

('work-place-list', 'api'),
('work-place-create', 'api'),
('work-place-edit', 'api'),
('work-place-delete', 'api'),

('department-list', 'api'),
('department-create', 'api'),
('department-edit', 'api'),
('department-delete', 'api');

-- assign all permissions to role_id 1 and 2
INSERT INTO role_has_permission (role_id, permission_id)
SELECT r.role_id, p.id
FROM permissions p
CROSS JOIN (SELECT 1 AS role_id UNION ALL SELECT 2) r
WHERE NOT EXISTS (
    SELECT 1
    FROM role_has_permission rhp
    WHERE rhp.role_id = r.role_id
      AND rhp.permission_id = p.id
);
