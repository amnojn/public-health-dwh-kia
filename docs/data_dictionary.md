## Overview

This data dictionary documents the structure and meaning of tables and columns
in the Silver Layer of the Public Health Data Warehouse for Maternal and Child
Health (KIA).

The Silver Layer represents cleaned, standardized, and integrated data derived
from the Bronze Layer. It serves as a reliable foundation for analytical
modeling in the Gold Layer.

## Overview

This data dictionary documents the structure and meaning of tables and columns
in the Silver Layer of the Public Health Data Warehouse for Maternal and Child
Health (KIA).

The Silver Layer represents cleaned, standardized, and integrated data derived
from the Bronze Layer. It serves as a reliable foundation for analytical
modeling in the Gold Layer.

## Naming Conventions

- Table names use lowercase and snake_case.
- Column names are descriptive and domain-oriented.
- Primary identifiers use the `_id` suffix.
- Date columns use the `DATE` data type where applicable.
- Numeric measurements are stored using appropriate numeric types.

### silver.fasilitas

Master data for healthcare facilities providing maternal and child health
services.

| Column Name     | Data Type | Description |
|---------------|----------|-------------|
| fasilitas_id  | TEXT     | Unique identifier of the healthcare facility |
| nama_fasilitas| TEXT     | Name of the healthcare facility |
| jenis_fasilitas| TEXT    | Type of facility (e.g., puskesmas, clinic, hospital) |
| kecamatan     | TEXT     | Sub-district where the facility is located |
| kabupaten     | TEXT     | District name (Jember) |

### silver.ibu

Master data for mothers receiving maternal health services.

| Column Name     | Data Type | Description |
|---------------|----------|-------------|
| ibu_id        | TEXT     | Unique identifier of the mother |
| nama_ibu      | TEXT     | Full name of the mother |
| tanggal_lahir | DATE     | Date of birth |
| pendidikan    | TEXT     | Highest education level |
| pekerjaan     | TEXT     | Occupation |
| alamat        | TEXT     | Residential address |

### silver.kunjungan

Records of healthcare service visits related to maternal and child health.

| Column Name       | Data Type | Description |
|------------------|----------|-------------|
| kunjungan_id    | TEXT     | Unique identifier of the healthcare visit |
| pasien_id       | TEXT     | Identifier of the patient |
| fasilitas_id    | TEXT     | Reference to healthcare facility |
| tanggal_kunjungan| DATE    | Date of the visit |
| jenis_kunjungan | TEXT     | Type of visit (e.g., anc, imunisasi, umum) |

### silver.anc

Standardized Antenatal Care (ANC) examination records.

| Column Name        | Data Type | Description |
|-------------------|----------|-------------|
| anc_id            | TEXT     | Unique identifier of the ANC record |
| ibu_id            | TEXT     | Reference to mother |
| kunjungan_id      | TEXT     | Reference to healthcare visit |
| usia_kehamilan    | INTEGER  | Gestational age in weeks |
| tekanan_darah_sys | INTEGER  | Systolic blood pressure |
| tekanan_darah_dia | INTEGER  | Diastolic blood pressure |
| berat_badan       | NUMERIC  | Maternal weight (kg) |
| tanggal_pemeriksaan| DATE    | Date of ANC examination |

## Notes on Data Lineage

All Silver Layer tables are derived directly from Bronze raw tables through
deterministic transformation logic.

No business aggregations or analytical metrics are introduced in the Silver
Layer. Each record can be traced back to its original raw source for auditing
and debugging purposes.

# Silver Layer Data Dictionary

This section documents the structure and semantics of all tables in the Silver Layer.
The Silver Layer contains cleansed, standardized, and deduplicated data derived from
the Bronze Layer and serves as the trusted foundation for analytical modeling.

---

## silver.fasilitas

Master reference table for healthcare facilities.

| Column Name     | Data Type  | Description |
|-----------------|------------|-------------|
| fasilitas_id    | TEXT       | Unique identifier of the healthcare facility |
| nama_fasilitas  | TEXT       | Standardized facility name |
| jenis_fasilitas | TEXT       | Facility type (Puskesmas, Rumah Sakit, Klinik, Other) |
| kecamatan       | TEXT       | Sub-district name |
| kabupaten       | TEXT       | District name |
| created_at      | TIMESTAMP  | Record creation timestamp inherited from ingestion |

**Source Table:** `bronze.raw_fasilitas`

**Transformation Notes:**
- Facility ID normalized (lowercase, trimmed)
- Text attributes standardized
- Facility types categorized into controlled values
- Duplicate records removed using earliest ingestion timestamp

---

## silver.ibu

Master table containing maternal demographic data.

| Column Name     | Data Type | Description |
|-----------------|-----------|-------------|
| ibu_id          | TEXT      | Unique identifier of the mother |
| nama_ibu        | TEXT      | Standardized mother name |
| tanggal_lahir   | DATE      | Date of birth |
| pendidikan      | TEXT      | Education level |
| pekerjaan       | TEXT      | Occupation |
| alamat          | TEXT      | Residential address |
| usia_ibu        | INTEGER   | Derived age in years |
| created_at      | TIMESTAMP | Record creation timestamp |

**Source Table:** `bronze.raw_ibu`

**Transformation Notes:**
- Date parsing and validation
- Derived age calculation
- Text normalization
- Deduplication based on ibu_id

---

## silver.kunjungan

Cleaned healthcare visit records.

| Column Name        | Data Type | Description |
|--------------------|-----------|-------------|
| kunjungan_id       | TEXT      | Unique visit identifier |
| pasien_id          | TEXT      | Patient identifier |
| fasilitas_id       | TEXT      | Healthcare facility reference |
| tanggal_kunjungan  | DATE      | Date of visit |
| jenis_kunjungan    | TEXT      | Type of healthcare service |
| created_at         | TIMESTAMP | Record creation timestamp |

**Source Table:** `bronze.raw_kunjungan`

**Transformation Notes:**
- Date standardization
- Visit type normalization
- Removal of invalid and duplicate records
- Referential alignment with silver.fasilitas

---

## silver.anc

Antenatal Care (ANC) service records.

| Column Name                | Data Type | Description |
|----------------------------|-----------|-------------|
| anc_id                     | TEXT      | Unique ANC record identifier |
| ibu_id                     | TEXT      | Reference to mother |
| kunjungan_id               | TEXT      | Reference to healthcare visit |
| tanggal_pemeriksaan        | DATE      | ANC examination date |
| usia_kehamilan_minggu      | INTEGER   | Gestational age in weeks |
| berat_badan_kg             | NUMERIC   | Mother's weight |
| tekanan_darah_sistolik     | INTEGER   | Systolic blood pressure |
| tekanan_darah_diastolik    | INTEGER   | Diastolic blood pressure |
| created_at                 | TIMESTAMP | Record creation timestamp |

**Source Table:** `bronze.raw_anc`

**Transformation Notes:**
- Blood pressure parsing and validation
- Numeric domain enforcement
- Date normalization
- Deduplication by anc_id

# Gold Layer Data Dictionary

## gold.dim_date

| Column | Type | Description |
|------|-----|------------|
| date_key | INTEGER | Surrogate key (YYYYMMDD) |
| full_date | DATE | Calendar date |
| year | INTEGER | Year |
| month | INTEGER | Month number |
| month_name | TEXT | Month name |
| day | INTEGER | Day of month |
| day_of_week | INTEGER | ISO day of week |
| day_name | TEXT | Day name |
| quarter | INTEGER | Quarter |

---

## gold.dim_ibu

| Column | Type | Description |
|------|-----|------------|
| ibu_key | SERIAL | Surrogate key |
| ibu_id | TEXT | Business identifier |
| pendidikan | TEXT | Standardized education level |
| pekerjaan | TEXT | Normalized occupation |
| usia_ibu | INTEGER | Age at data snapshot |

---

## gold.dim_fasilitas

| Column | Type | Description |
|------|-----|------------|
| fasilitas_key | SERIAL | Surrogate key |
| fasilitas_id | TEXT | Business identifier |
| nama_fasilitas | TEXT | Facility name |
| jenis_fasilitas | TEXT | Facility type |
| kecamatan | TEXT | District |
| kabupaten | TEXT | Regency |

---

## gold.fact_anc_visit

| Column | Type | Description |
|------|-----|------------|
| date_key | INTEGER | FK → dim_date |
| ibu_key | INTEGER | FK → dim_ibu |
| fasilitas_key | INTEGER | FK → dim_fasilitas |
| anc_id | TEXT | ANC visit identifier |
| kunjungan_id | TEXT | Visit identifier |
| usia_kehamilan_minggu | INTEGER | Pregnancy age |
| berat_badan | NUMERIC | Mother weight |
| tekanan_darah_sistolik | INTEGER | Systolic BP |
| tekanan_darah_diastolik | INTEGER | Diastolic BP |
| anc_visit_count | INTEGER | Always 1 |