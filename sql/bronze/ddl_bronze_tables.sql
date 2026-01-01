-- =====================================================
-- BRONZE LAYER SCHEMA
-- Raw data as-is from source systems
-- Domain: Pelayanan Kesehatan + KIA
-- =====================================================

CREATE SCHEMA IF NOT EXISTS bronze;

CREATE TABLE IF NOT EXISTS bronze.raw_kunjungan (
    kunjungan_id        TEXT,
    pasien_id           TEXT,
    tanggal_kunjungan   TEXT,
    jenis_kunjungan     TEXT,
    fasilitas_id        TEXT,
    created_at          TEXT,
    ingested_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS bronze.raw_anc (
    anc_id                  TEXT,
    ibu_id                  TEXT,
    kunjungan_id             TEXT,
    usia_kehamilan           TEXT,
    tekanan_darah            TEXT,
    berat_badan              TEXT,
    tanggal_pemeriksaan      TEXT,
    created_at               TEXT,
    ingested_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS bronze.raw_ibu (
    ibu_id              TEXT,
    nama_ibu            TEXT,
    tanggal_lahir       TEXT,
    pendidikan          TEXT,
    pekerjaan           TEXT,
    alamat              TEXT,
    ingested_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS bronze.raw_fasilitas (
    fasilitas_id        TEXT,
    nama_fasilitas      TEXT,
    jenis_fasilitas     TEXT,
    kecamatan           TEXT,
    kabupaten           TEXT,
    ingested_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
