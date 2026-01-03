-- =====================================================
-- GOLD LAYER: FACT ANC VISIT
-- Grain: One row per ANC visit
-- =====================================================

CREATE OR REPLACE VIEW gold.fact_anc_visit AS
SELECT
    -- Dimension Keys
    d.date_key,
    i.ibu_key,
    f.fasilitas_key,

    -- Business Keys
    a.anc_id,
    k.kunjungan_id,

    -- Measures
    a.usia_kehamilan_minggu,
    a.berat_badan_kg,
    a.tekanan_darah_sistolik,
    a.tekanan_darah_diastolik,

    -- Countable Fact
    1 AS anc_visit_count

FROM silver.anc a
JOIN silver.kunjungan k
    ON a.kunjungan_id = k.kunjungan_id

JOIN gold.dim_date d
    ON a.tanggal_pemeriksaan = d.full_date

JOIN gold.dim_ibu i
    ON a.ibu_id = i.ibu_id

JOIN gold.dim_fasilitas f
    ON k.fasilitas_id = f.fasilitas_id;