ALTER TABLE locations
DROP CONSTRAINT locations_parent_id_fkey;

ALTER TABLE calendar_holidays
ADD COLUMN weekend_type VARCHAR(30)
CHECK (weekend_type IN ('OFFDAY', 'HOLIDAY'));

