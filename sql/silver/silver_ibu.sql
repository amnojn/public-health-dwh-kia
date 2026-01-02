-- =====================================================
-- SILVER LAYER: MOTHER MASTER DATA
-- Table: silver.ibu
-- =====================================================

CREATE SCHEMA IF NOT EXISTS silver;

DROP TABLE IF EXISTS silver.ibu;

CREATE TABLE silver.ibu AS
WITH cleaned AS (
    SELECT
        LOWER(TRIM(ibu_id)) AS ibu_id,
        INITCAP(TRIM(nama_ibu)) AS nama_ibu,

        -- Standardize date of birth
        CASE
            WHEN tanggal_lahir ~ '^\d{4}-\d{2}-\d{2}$'
                THEN tanggal_lahir::DATE
            ELSE NULL
        END AS tanggal_lahir,

        -- Standardize education level
        CASE
            WHEN LOWER(pendidikan) IN ('sd', 'sekolah dasar') THEN 'SD'
            WHEN LOWER(pendidikan) IN ('smp', 'sekolah menengah pertama') THEN 'SMP'
            WHEN LOWER(pendidikan) IN ('sma', 'smk', 'sekolah menengah atas') THEN 'SMA'
            WHEN LOWER(pendidikan) LIKE '%diploma%' THEN 'Diploma'
            WHEN LOWER(pendidikan) LIKE '%sarjana%' THEN 'Sarjana'
            ELSE 'Other'
        END AS pendidikan,

        -- Normalize occupation
        INITCAP(TRIM(pekerjaan)) AS pekerjaan,

        INITCAP(TRIM(alamat)) AS alamat,

        ingested_at AS created_at
    FROM bronze.raw_ibu
    WHERE ibu_id IS NOT NULL
      AND TRIM(ibu_id) <> ''
),

deduplicated AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY ibu_id
            ORDER BY created_at
        ) AS row_num
    FROM cleaned
)

SELECT
    ibu_id,
    nama_ibu,
    tanggal_lahir,

    -- Derived column (non-business)
    CASE
        WHEN tanggal_lahir IS NOT NULL
            THEN DATE_PART('year', AGE(CURRENT_DATE, tanggal_lahir))
        ELSE NULL
    END AS usia_ibu,

    pendidikan,
    pekerjaan,
    alamat,
    created_at
FROM deduplicated
WHERE row_num = 1;