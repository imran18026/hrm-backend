CREATE OR REPLACE FUNCTION generate_calendar(
  p_year INT,
  p_name TEXT DEFAULT 'Company Calendar',
  p_type TEXT DEFAULT 'HOLIDAY',
  p_force BOOLEAN DEFAULT FALSE
)
RETURNS BIGINT AS $$
DECLARE
  v_calendar_id BIGINT;
  v_count INT;
BEGIN
  -- Validate year
  IF p_year < 2000 OR p_year > 2100 THEN
    RAISE EXCEPTION 'Invalid year: %. Must be between 2000 and 2100', p_year;
  END IF;

  -- Check existing calendar
  SELECT id INTO v_calendar_id
  FROM calendars
  WHERE year = p_year AND type = p_type
  LIMIT 1;

  IF FOUND THEN
    IF NOT p_force THEN
      RAISE NOTICE 'Calendar for year % and type % already exists with id %', p_year, p_type, v_calendar_id;
      RETURN v_calendar_id;
    ELSE
      -- Force recreation
      RAISE NOTICE 'Force flag enabled. Recreating calendar for year %', p_year;
      DELETE FROM calendar_holidays WHERE calendar_id = v_calendar_id;
      DELETE FROM calendars WHERE id = v_calendar_id;
      v_calendar_id := NULL;
    END IF;
  END IF;

  -- Create new calendar
  INSERT INTO calendars (name, description, type, year, is_default, created_at, updated_at)
  VALUES (
    p_name || ' ' || p_year,
    'Auto-generated calendar for year ' || p_year,
    p_type,
    p_year,
    FALSE,
    NOW(),
    NOW()
  )
  RETURNING id INTO v_calendar_id;

  -- Generate all days of the year
  INSERT INTO calendar_holidays (
    calendar_id,
    working_type,
    name,
    holiday_date,
    is_holiday,
    color_code,
    description,
    status,
    created_at,
    updated_at
  )
  SELECT
    v_calendar_id,
    CASE WHEN EXTRACT(ISODOW FROM d)::INT IN (6,7) THEN 1 ELSE 0 END AS working_type,
    TRIM(TO_CHAR(d, 'Day')) AS name,
    d AS holiday_date,
    CASE WHEN EXTRACT(ISODOW FROM d)::INT IN (6,7) THEN TRUE ELSE FALSE END AS is_holiday,
    CASE
      WHEN EXTRACT(ISODOW FROM d)::INT = 6 THEN '#FF9800'  -- Saturday - Orange
      WHEN EXTRACT(ISODOW FROM d)::INT = 7 THEN '#F44336'  -- Sunday - Red
      ELSE NULL
    END AS color_code,
    'Auto-generated' AS description,
    TRUE AS status,
    NOW(),
    NOW()
  FROM generate_series(
    make_date(p_year, 1, 1),
    make_date(p_year, 12, 31),
    interval '1 day'
  ) AS gs(d);

  -- Get count of generated days
  GET DIAGNOSTICS v_count = ROW_COUNT;

  RAISE NOTICE 'Successfully generated % days for calendar year %', v_count, p_year;

  RETURN v_calendar_id;

EXCEPTION
  WHEN OTHERS THEN
    RAISE EXCEPTION 'Error generating calendar: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;