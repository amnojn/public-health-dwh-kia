-- =====================================================
-- SILVER LAYER: ANTENATAL CARE (ANC) DATA
-- Table: silver.anc
-- =====================================================

CREATE SCHEMA IF NOT EXISTS silver;

DROP TABLE IF EXISTS silver.anc;

CREATE TABLE silver.anc AS
WITH cleaned AS (
    SELECT
        LOWER(TRIM(anc_id)) AS anc_id,
        LOWER(TRIM(ibu_id)) AS ibu_id,
        LOWER(TRIM(kunjungan_id)) AS kunjungan_id,

        -- Pregnancy age (weeks)
        CASE
            WHEN usia_kehamilan ~ '^\d+$'
                THEN usia_kehamilan::INTEGER
            ELSE NULL
        END AS usia_kehamilan_minggu,

        -- Parse blood pressure: systolic/diastolic
        CASE
            WHEN tekanan_darah ~ '^\d+/\d+$'
                THEN SPLIT_PART(tekanan_darah, '/', 1)::INTEGER
            ELSE NULL
        END AS tekanan_darah_sistolik,

        CASE
            WHEN tekanan_darah ~ '^\d+/\d+$'
                THEN SPLIT_PART(tekanan_darah, '/', 2)::INTEGER
            ELSE NULL
        END AS tekanan_darah_diastolik,

        -- Weight (kg)
        CASE
            WHEN berat_badan ~ '^\d+(\.\d+)?$'
                THEN berat_badan::NUMERIC(5,2)
            ELSE NULL
        END AS berat_badan_kg,

        -- Examination date
        CASE
            WHEN tanggal_pemeriksaan ~ '^\d{4}-\d{2}-\d{2}$'
                THEN tanggal_pemeriksaan::DATE
            ELSE NULL
        END AS tanggal_pemeriksaan,

        ingested_at AS created_at
    FROM bronze.raw_anc
    WHERE anc_id IS NOT NULL
      AND TRIM(anc_id) <> ''
),

validated AS (
    SELECT *
    FROM cleaned
    WHERE tanggal_pemeriksaan IS NOT NULL
      AND tanggal_pemeriksaan <= CURRENT_DATE
      AND (usia_kehamilan_minggu BETWEEN 1 AND 45 OR usia_kehamilan_minggu IS NULL)
      AND (berat_badan_kg > 0 OR berat_badan_kg IS NULL)
),

deduplicated AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY anc_id
            ORDER BY created_at
        ) AS row_num
    FROM validated
)

SELECT
    anc_id,
    ibu_id,
    kunjungan_id,
    usia_kehamilan_minggu,
    tekanan_darah_sistolik,
    tekanan_darah_diastolik,
    berat_badan_kg,
    tanggal_pemeriksaan,
    created_at
FROM deduplicated
WHERE row_num = 1;