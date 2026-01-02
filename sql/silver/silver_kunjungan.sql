-- =====================================================
-- SILVER LAYER: HEALTHCARE VISIT DATA
-- Table: silver.kunjungan
-- =====================================================

CREATE SCHEMA IF NOT EXISTS silver;

DROP TABLE IF EXISTS silver.kunjungan;

CREATE TABLE silver.kunjungan AS
WITH cleaned AS (
    SELECT
        LOWER(TRIM(kunjungan_id)) AS kunjungan_id,
        LOWER(TRIM(pasien_id)) AS pasien_id,
        LOWER(TRIM(fasilitas_id)) AS fasilitas_id,

        -- Standardize visit date
        CASE
            WHEN tanggal_kunjungan ~ '^\d{4}-\d{2}-\d{2}$'
                THEN tanggal_kunjungan::DATE
            ELSE NULL
        END AS tanggal_kunjungan,

        -- Standardize visit type
        CASE
            WHEN LOWER(jenis_kunjungan) LIKE '%anc%' THEN 'ANC'
            WHEN LOWER(jenis_kunjungan) LIKE '%imun%' THEN 'Immunization'
            WHEN LOWER(jenis_kunjungan) LIKE '%umum%' THEN 'General'
            ELSE 'Other'
        END AS jenis_kunjungan,

        ingested_at AS created_at
    FROM bronze.raw_kunjungan
    WHERE kunjungan_id IS NOT NULL
      AND TRIM(kunjungan_id) <> ''
),

validated AS (
    SELECT *
    FROM cleaned
    WHERE tanggal_kunjungan IS NOT NULL
      AND tanggal_kunjungan <= CURRENT_DATE
),

deduplicated AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY kunjungan_id
            ORDER BY created_at
        ) AS row_num
    FROM validated
)

SELECT
    kunjungan_id,
    pasien_id,
    fasilitas_id,
    tanggal_kunjungan,
    jenis_kunjungan,
    created_at
FROM deduplicated
WHERE row_num = 1;
