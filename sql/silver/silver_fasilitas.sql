-- =====================================================
-- SILVER LAYER: FACILITY MASTER DATA
-- Source: bronze.raw_fasilitas
-- =====================================================

CREATE SCHEMA IF NOT EXISTS silver;

DROP TABLE IF EXISTS silver.fasilitas;

CREATE TABLE silver.fasilitas AS
WITH cleaned AS (
    SELECT
        LOWER(TRIM(fasilitas_id)) AS fasilitas_id,
        INITCAP(TRIM(nama_fasilitas)) AS nama_fasilitas,
        CASE
            WHEN LOWER(jenis_fasilitas) LIKE '%puskesmas%' THEN 'Puskesmas'
            WHEN LOWER(jenis_fasilitas) LIKE '%rumah sakit%' THEN 'Rumah Sakit'
            WHEN LOWER(jenis_fasilitas) LIKE '%klinik%' THEN 'Klinik'
            ELSE 'Other'
        END AS jenis_fasilitas,
        INITCAP(TRIM(kecamatan)) AS kecamatan,
        INITCAP(TRIM(kabupaten)) AS kabupaten,
        ingested_at AS created_at
    FROM bronze.raw_fasilitas
    WHERE fasilitas_id IS NOT NULL
      AND TRIM(fasilitas_id) <> ''
),
deduplicated AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY fasilitas_id
            ORDER BY created_at
        ) AS row_num
    FROM cleaned
)
SELECT
    fasilitas_id,
    nama_fasilitas,
    jenis_fasilitas,
    kecamatan,
    kabupaten,
    created_at
FROM deduplicated
WHERE row_num = 1;