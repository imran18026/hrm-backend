-- ============================================== -- Lookup Setup Entry -- ==============================================
INSERT INTO lookup_setup_entry (id, name, status, created_by, last_modified_by)
VALUES
    (7, 'Blood Group', true, 1, 1);

-- =====================
-- Lookup Setup: Blood Group Details
-- setup_id = 7 corresponds to 'Blood Group'
-- =====================
INSERT INTO lookup_setup_details (setup_id, name, details, status, created_by, last_modified_by)
VALUES
    (7, 'A+',  'A Rh-positive blood group',  true, 1, 1),
    (7, 'A-',  'A Rh-negative blood group',  true, 1, 1),
    (7, 'B+',  'B Rh-positive blood group',  true, 1, 1),
    (7, 'B-',  'B Rh-negative blood group',  true, 1, 1),
    (7, 'AB+', 'AB Rh-positive blood group', true, 1, 1),
    (7, 'AB-', 'AB Rh-negative blood group', true, 1, 1),
    (7, 'O+',  'O Rh-positive blood group',  true, 1, 1),
    (7, 'O-',  'O Rh-negative blood group',  true, 1, 1);