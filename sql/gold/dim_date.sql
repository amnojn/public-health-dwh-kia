-- =====================================================
-- GOLD LAYER: DATE DIMENSION
-- Domain: Public Health - Maternal & Child Health (KIA)
-- =====================================================

CREATE SCHEMA IF NOT EXISTS gold;

CREATE OR REPLACE VIEW gold.dim_date AS
WITH date_source AS (
    -- Collect all distinct dates from Silver Layer
    SELECT DISTINCT tanggal_kunjungan AS full_date
    FROM silver.kunjungan
    WHERE tanggal_kunjungan IS NOT NULL

    UNION

    SELECT DISTINCT tanggal_pemeriksaan AS full_date
    FROM silver.anc
    WHERE tanggal_pemeriksaan IS NOT NULL
),
date_enriched AS (
    SELECT
        full_date,
        EXTRACT(DAY FROM full_date)::INT AS day,
        EXTRACT(MONTH FROM full_date)::INT AS month,
        TO_CHAR(full_date, 'Month') AS month_name,
        EXTRACT(QUARTER FROM full_date)::INT AS quarter,
        EXTRACT(YEAR FROM full_date)::INT AS year,
        EXTRACT(WEEK FROM full_date)::INT AS week_of_year,
        CASE
            WHEN EXTRACT(ISODOW FROM full_date) IN (6, 7) THEN TRUE
            ELSE FALSE
        END AS is_weekend
    FROM date_source
)
SELECT
    (year * 10000 + month * 100 + day) AS date_key,
    full_date,
    day,
    month,
    TRIM(month_name) AS month_name,
    quarter,
    year,
    week_of_year,
    is_weekend
FROM date_enriched;