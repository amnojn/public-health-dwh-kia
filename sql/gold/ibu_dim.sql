-- =====================================================
-- GOLD LAYER: DIMENSION IBU
-- Domain: Public Health - Maternal & Child Health (KIA)
-- =====================================================

CREATE SCHEMA IF NOT EXISTS gold;

CREATE OR REPLACE VIEW gold.dim_ibu AS
SELECT
    ROW_NUMBER() OVER (ORDER BY ibu_id) AS ibu_key,
    ibu_id,
    nama_ibu,
    tanggal_lahir,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, tanggal_lahir))::INT AS usia_ibu,
    pendidikan,
    pekerjaan,
    alamat,
    created_at
FROM silver.ibu
WHERE ibu_id IS NOT NULL;