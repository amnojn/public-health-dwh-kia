-- =====================================================
-- GOLD LAYER: DIMENSION FASILITAS
-- Domain: Public Health - Maternal & Child Health (KIA)
-- =====================================================

CREATE SCHEMA IF NOT EXISTS gold;

CREATE OR REPLACE VIEW gold.dim_fasilitas AS
SELECT
    ROW_NUMBER() OVER (ORDER BY fasilitas_id) AS fasilitas_key,
    fasilitas_id,
    nama_fasilitas,
    jenis_fasilitas,
    kecamatan,
    kabupaten,
    created_at
FROM silver.fasilitas
WHERE fasilitas_id IS NOT NULL;