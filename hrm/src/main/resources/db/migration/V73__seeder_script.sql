-- ==============================================
-- TRUNCATE existing data if running a fresh seed
-- ==============================================
TRUNCATE TABLE menus RESTART IDENTITY CASCADE;

-- ==============================================
-- Menus Seeder (from JSON data)
-- ==============================================

-- Level 0 Menus (Parent Menus)
INSERT INTO menus (id, permission_id, parent_id, name, url, icon, header_menu, sidebar_menu, dropdown_menu, children_parent_menu, status, created_by, last_modified_by, created_at, updated_at) VALUES
(26, 1, NULL, 'Dashboard', '/', 'RxDashboard', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-15 11:22:53.111608', '2025-10-18 09:37:58.125293'),
(27, NULL, NULL, 'Administration', '#', 'VscTools', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-15 11:23:57.065975', '2025-10-16 08:29:55.727444'),
(31, NULL, NULL, 'User Management', '#', 'FiUsers', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-15 11:39:48.213203', '2025-10-16 09:08:55.171643'),
(36, NULL, NULL, 'Employee Management', '#', 'MdOutlineManageAccounts', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-15 12:01:10.602328', '2025-10-18 11:01:35.236621'),
(53, NULL, NULL, 'Leave Management', '#', 'TbCalendarStar', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-15 12:22:33.633981', '2025-10-18 11:22:08.595042'),
(80, NULL, NULL, 'Attendence', '#', 'LuUsersRound', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-18 04:40:15.977626', '2025-10-18 04:40:15.977626');

-- Level 1 Menus
INSERT INTO menus (id, permission_id, parent_id, name, url, icon, header_menu, sidebar_menu, dropdown_menu, children_parent_menu, status, created_by, last_modified_by, created_at, updated_at) VALUES
-- Children of Administration (id: 27)
(28, 51, 27, 'Location', '/administration/location', 'CiLocationOn', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-15 11:24:55.124544', '2025-10-18 09:49:40.069810'),
(29, 18, 27, 'Company Config', '/administration/company-config', 'GrConfigure', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-15 11:25:32.732079', '2025-10-18 10:58:09.668049'),
(85, NULL, 27, 'Banks', '/administration/banks', 'CiBank', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-18 10:53:50.008123', '2025-10-18 10:53:50.008123'),
(86, NULL, 27, 'Bank Branch', '/administration/bank-branch', 'CiBank', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-18 10:54:47.329958', '2025-10-18 10:54:47.329958'),
-- Children of User Management (id: 31)
(32, 10, 31, 'Users', '/usermanagement/users', 'FiUsers', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-15 11:40:18.206758', '2025-10-18 09:52:39.841359'),
(33, 14, 31, 'Menu', '/usermanagement/menu', 'CgMenuGridR', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-15 11:41:11.867655', '2025-10-18 09:52:31.745512'),
(34, 6, 31, 'Roles', '/usermanagement/roles', 'CiUser', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-15 11:41:43.092243', '2025-10-18 09:52:22.464174'),
(35, 2, 31, 'Permissions', '/usermanagement/permissions', 'CiLock', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-15 11:42:04.331252', '2025-10-18 09:52:13.433016'),
-- Children of Employee Management (id: 36)
(37, NULL, 36, 'Setup', '#', 'TbSettingsUp', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-15 12:02:36.146162', '2025-10-18 11:05:30.969387'),
(46, NULL, 36, 'Employee Info', '#', 'GrContactInfo', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-15 12:15:44.748635', '2025-10-18 11:03:22.418599'),
(51, NULL, 36, 'Employee Transfer', '#', 'TbTransfer', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-15 12:20:48.987805', '2025-10-18 11:02:35.094372'),
-- Children of Leave Management (id: 53)
(54, NULL, 53, 'Leave Setup', '#', 'TbAdjustmentsCog', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-15 12:23:21.099638', '2025-10-18 11:29:36.514522'),
(59, NULL, 53, 'Leave', '#', 'BsCalendar2Check', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-15 12:27:27.613297', '2025-10-18 11:25:24.708355'),
-- Children of Attendence (id: 80)
(81, NULL, 80, 'Attendence Rule Setup', '/attendance/attendance-rule-setup', 'LuUsersRound', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-18 04:40:45.479955', '2025-10-18 04:44:56.500400'),
(87, NULL, 80, 'Bulk Roster Upload', '/attendance/bulk-roster-upload', 'BsCloudArrowUp', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-19 04:49:10.923472', '2025-10-19 04:50:31.425384'),
(88, NULL, 80, 'Roster Planner', '/attendance/roster-planner', 'IoSettingsOutline', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-19 04:56:22.311706', '2025-10-19 04:56:22.311706'),
(92, NULL, 80, 'Device Management', '#', 'TbDeviceIpadHorizontalCog', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-20 03:14:22.963985', '2025-10-20 03:14:42.678907'),
(96, NULL, 80, 'Shift Configuration', '#', 'MdOutlineFilterTiltShift', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-20 03:45:52.235395', '2025-10-20 03:45:52.235395'),
(101, NULL, 80, 'Employee Shift Assignment', '/attendence/employee-shift-assignment', 'FaRegUser', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-20 05:25:40.629581', '2025-10-20 05:25:40.629581');


-- Level 2 Menus
INSERT INTO menus (id, permission_id, parent_id, name, url, icon, header_menu, sidebar_menu, dropdown_menu, children_parent_menu, status, created_by, last_modified_by, created_at, updated_at) VALUES
-- Children of Setup (id: 37)
(38, NULL, 37, 'Personal Information', '#', 'LiaInfoSolid', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-15 12:04:18.801902', '2025-10-18 11:14:13.308570'),
(42, NULL, 37, 'Work Structure', '/employees/setup/work-structures', 'PiTreeStructure', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-15 12:10:28.787852', '2025-10-18 11:11:48.390508'),
(43, NULL, 37, 'Qualification', '/employees/setup/qualification', 'MdOutlineGrade', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-15 12:13:08.315625', '2025-10-18 11:09:59.790734'),
(44, NULL, 37, 'Employment', '/employees/setup/employment', 'MdOutlineGroups2', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-15 12:14:02.571563', '2025-10-18 11:08:47.599065'),
(45, 46, 37, 'Document Type', '/employees/setup/document-type', 'IoDocumentTextOutline', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-15 12:14:38.699101', '2025-10-18 11:07:15.414356'),
-- Children of Employee Info (id: 46)
(47, NULL, 46, 'Employee Profile', '/employees/employees-profile/profile', 'CgProfile', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-15 12:16:26.701985', '2025-10-18 11:18:49.762685'),
(48, NULL, 46, 'Reporting Hierarchy', '/employees/employees-profile/reporting-hierarchy', 'VscTypeHierarchy', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-15 12:17:32.410730', '2025-10-18 11:16:59.744520'),
(49, NULL, 46, 'Employee List', '/employees/employees-profile/employee-list', 'CiBoxList', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-15 12:18:20.022033', '2025-10-18 11:16:33.184015'),
(50, NULL, 46, 'Document', '/employees/employees-profile/document', 'IoDocumentAttachOutline', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-15 12:18:42.972452', '2025-10-18 11:15:44.128654'),
-- Children of Employee Transfer (id: 51)
(52, NULL, 51, 'Transfer Request', '/employees/transfer/request', 'CiSettings', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-15 12:21:39.243612', '2025-10-15 12:21:39.243612'),
-- Children of Leave Setup (id: 54)
(55, NULL, 54, 'Leave Types', '/leave/types', 'MdOutlineCategory', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-15 12:24:08.535415', '2025-10-18 11:35:22.094231'),
(56, NULL, 54, 'Leave Group Assign', '/leave/group-assign', 'MdOutlineAssignment', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-15 12:24:55.031171', '2025-10-18 11:33:57.632933'),
(57, NULL, 54, 'Leave Policies', '/leave/policies', 'MdOutlinePolicy', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-15 12:26:12.882738', '2025-10-18 11:32:30.758401'),
(58, NULL, 54, 'Leave Group', '/leave/group', 'VscGroupByRefType', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-15 12:26:47.735318', '2025-10-18 11:32:10.362878'),
-- Children of Leave (id: 59)
(60, NULL, 59, 'Leave Apply', '/leave/apply', 'VscRequestChanges', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-15 12:27:57.735510', '2025-10-18 11:28:07.935318'),
(61, NULL, 59, 'Leave Approval', '/leave/approval', 'FaRegCheckCircle', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-15 12:28:48.454634', '2025-10-18 11:26:27.306993'),
(62, NULL, 59, 'Leave Balance', '/leave/balance-employee', 'AiOutlineWallet', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-15 12:29:27.964629', '2025-10-18 11:25:57.238567'),
-- Children of Device Management (id: 92)
(94, NULL, 92, 'Device Category', '/attendance/device-management/device-category', 'TbDeviceGamepad3', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-20 03:20:51.240743', '2025-10-20 03:59:43.289776'),
(95, NULL, 92, 'Attendance Device', '/attendance/device-management/attendance-device', 'MdOutlineDevicesOther', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-20 03:21:59.678570', '2025-10-20 03:59:53.256919'),
-- Children of Shift Configuration (id: 96)
(97, NULL, 96, 'Shift Categories', '/attendance/shift-configuration/shift-categories', 'TbCategoryPlus', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-20 03:51:22.029584', '2025-10-20 03:58:10.575196'),
(98, NULL, 96, 'Shift Definition', '/attendance/shift-configuration/shift-definition', 'BsShift', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-20 03:53:19.214405', '2025-10-20 04:20:33.966104'),
(99, NULL, 96, 'Rotation Pattern', '/attendance/shift-configuration/rotation-pattern', 'MdCropRotate', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-20 03:54:00.657785', '2025-10-20 03:59:12.380840'),
(100, NULL, 96, 'OT Grace Rules', '/attendance/shift-configuration/ot-grace-rules', 'MdOutlineFilterTiltShift', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-20 04:12:42.429581', '2025-10-20 04:13:23.931568');


-- Level 3 Menus
INSERT INTO menus (id, permission_id, parent_id, name, url, icon, header_menu, sidebar_menu, dropdown_menu, children_parent_menu, status, created_by, last_modified_by, created_at, updated_at) VALUES
-- Children of Personal Information (id: 38)
(39, NULL, 38, 'Info Type', '/employees/lookup/setup-entry', 'CiSettings', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-15 12:05:11.233804', '2025-10-15 12:05:11.233804'),
(40, NULL, 38, 'Info Details', '/employees/lookup/setup-entry-details', 'CiSettings', FALSE, FALSE, FALSE, FALSE, TRUE, 1, 1, '2025-10-15 12:06:40.082150', '2025-10-15 12:06:40.082150');


-- Reset the sequence after explicit inserts
SELECT setval('menus_id_seq', (SELECT MAX(id) FROM menus), true);