CREATE TABLE marts.dim_dates AS
WITH date_range AS (
    SELECT generate_series(
        '2016-01-01'::date,
        '2019-12-31'::date,
        '1 day'::interval
    )::date AS date
)
SELECT
    TO_CHAR(date, 'YYYYMMDD')::int AS date_key,
    date,
    EXTRACT(YEAR FROM date)::int AS year,
    EXTRACT(QUARTER FROM date)::int AS quarter,
    EXTRACT(MONTH FROM date)::int AS month,
    EXTRACT(DAY FROM date)::int AS day,
    EXTRACT(DOW FROM date)::int AS day_of_week,
    CASE WHEN EXTRACT(DOW FROM date) IN (0, 6) THEN TRUE ELSE FALSE END AS is_weekend,
    TO_CHAR(date, 'Month') AS month_name,
    TO_CHAR(date, 'Day') AS day_name
FROM date_range;

ALTER TABLE marts.dim_dates ADD PRIMARY KEY (date_key);
CREATE INDEX idx_dim_dates_date ON marts.dim_dates(date);