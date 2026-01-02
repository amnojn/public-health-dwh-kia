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