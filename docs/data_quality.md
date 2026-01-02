# Data Quality Management  
Project: Public Health Data Warehouse – Maternal and Child Health (KIA)

---

## 1. Purpose

This document defines data quality rules and validation checks applied in the  
Public Health Data Warehouse project, with a focus on the **Silver Layer**.

The objective of data quality enforcement in the Silver Layer is to ensure that data is:

- Accurate
- Consistent
- Complete
- Ready for analytical modeling

The Silver Layer represents the first point where **business-relevant data correctness**
is enforced.

---

## 2. Scope of Data Quality Checks

| Layer  | Quality Focus |
|------|---------------|
| Bronze | Structural integrity, schema consistency |
| Silver | Logical correctness, standardization, referential validity |
| Gold | Business metric accuracy (out of scope for this document) |

This document covers **Silver Layer data quality rules only**.

---

## 3. General Silver Layer Quality Rules (Global)

The following rules apply to **all Silver tables**:

### 3.1 Identifier Rules
- Primary identifiers (`*_id`) must not be `NULL`.
- Identifiers must be unique within their respective tables.
- Identifiers must be trimmed and standardized.

### 3.2 Date Rules
- All date fields must use the `DATE` data type.
- Dates must not be in the future unless explicitly allowed.
- Invalid or malformed dates are set to `NULL` or excluded.

### 3.3 Numeric Rules
- Numeric fields must use appropriate numeric data types.
- Negative values are not allowed unless explicitly justified.
- Non-numeric raw values are converted or excluded.

### 3.4 Text Standardization
- Text fields must be trimmed.
- Inconsistent casing is normalized.
- Value domains are standardized where applicable.

---

## 4. Table-Level Data Quality Rules

---

### 4.1 `silver.fasilitas`

**Quality Objective:**  
Ensure healthcare facility master data is consistent and uniquely identifiable.

**Rules:**
- `fasilitas_id` must be unique and not `NULL`.
- `jenis_fasilitas` must belong to an allowed domain:
  - `puskesmas`
  - `clinic`
  - `hospital`
- `kabupaten` must be populated and standardized.

**Validation Examples:**
- Duplicate facility identifiers.
- Missing or inconsistent location values.

---

### 4.2 `silver.ibu`

**Quality Objective:**  
Ensure maternal demographic data is valid and analytically usable.

**Rules:**
- `ibu_id` must be unique and not `NULL`.
- `tanggal_lahir` must be a valid date and not in the future.
- Derived age (if calculated) must fall within a realistic range (10–60 years).

**Validation Examples:**
- Invalid birth dates.
- Missing demographic attributes.

---

### 4.3 `silver.kunjungan`

**Quality Objective:**  
Ensure healthcare visit records accurately represent service events.

**Rules:**
- `kunjungan_id` must be unique and not `NULL`.
- `tanggal_kunjungan` must not be in the future.
- `jenis_kunjungan` must belong to a controlled domain:
  - `anc`
  - `immunization`
  - `general`
- `fasilitas_id` must reference an existing record in `silver.fasilitas`.

**Validation Examples:**
- Visits without valid facility references.
- Invalid visit type values.

---

### 4.4 `silver.anc`

**Quality Objective:**  
Ensure Antenatal Care (ANC) records are clinically plausible and consistent.

**Rules:**
- `anc_id` must be unique and not `NULL`.
- `usia_kehamilan` must be between **1 and 45 weeks**.
- `berat_badan` must be greater than `0`.
- Blood pressure values must follow valid systolic/diastolic patterns.
- `ibu_id` must reference `silver.ibu`.
- `kunjungan_id` must reference `silver.kunjungan`.

**Validation Examples:**
- Out-of-range gestational age.
- Invalid blood pressure formats.
- Orphan ANC records without valid parent references.

---

## 5. Referential Integrity Rules

The Silver Layer enforces logical referential integrity through transformation
logic and validation checks.

| Child Table | Column | Parent Table | Column |
|-----------|--------|-------------|--------|
| `silver.kunjungan` | `fasilitas_id` | `silver.fasilitas` | `fasilitas_id` |
| `silver.anc` | `ibu_id` | `silver.ibu` | `ibu_id` |
| `silver.anc` | `kunjungan_id` | `silver.kunjungan` | `kunjungan_id` |

Records violating referential rules are excluded or flagged during transformation.

---

## 6. Handling Invalid Records

Invalid records are handled using one or more of the following strategies:

- Exclusion from Silver tables
- Conversion to standardized `NULL` values
- Logging for audit and debugging purposes

The chosen strategy depends on the severity and analytical impact of the issue.

---

## 7. Auditability & Traceability

All Silver Layer records are traceable back to their Bronze source tables.

Transformation logic is deterministic, documented, and version-controlled to
ensure reproducibility and audit readiness.

---

## 8. Out of Scope

The following are intentionally excluded from Silver Layer data quality checks:

- Business KPIs
- Aggregated metrics
- Analytical thresholds
- Performance indicators

These elements will be addressed in the Gold Layer.

# Silver Layer Data Quality Rules

This section defines the data quality standards applied to the Silver Layer to ensure
that data is consistent, reliable, and ready for analytical consumption.

---

## Global Quality Rules

The following rules apply to all Silver tables:

- Primary identifiers must not be NULL
- Primary identifiers must be unique
- Duplicate logical records must be removed
- All dates must be valid and not exceed the current date
- Numeric values must fall within reasonable domain ranges
- Text fields must be trimmed and standardized

---

## Table-Specific Quality Rules

### silver.fasilitas

- fasilitas_id must be unique and not NULL
- jenis_fasilitas must be one of:
  - Puskesmas
  - Rumah Sakit
  - Klinik
  - Other
- kecamatan and kabupaten must not be empty

---

### silver.ibu

- ibu_id must be unique
- tanggal_lahir must be earlier than the current date
- usia_ibu must be a positive and reasonable value
- Duplicate maternal records are not allowed

---

### silver.kunjungan

- kunjungan_id must be unique
- tanggal_kunjungan must not be in the future
- fasilitas_id must exist in silver.fasilitas
- Each record represents a single healthcare visit

---

### silver.anc

- anc_id must be unique
- usia_kehamilan_minggu must be between 1 and 45
- berat_badan_kg must be greater than zero
- Blood pressure values must be successfully parsed
- kunjungan_id must exist in silver.kunjungan
- ibu_id must exist in silver.ibu

---

## Referential Integrity Validation

Logical referential integrity is enforced through validation queries rather than
physical foreign key constraints.

Validated relationships include:
- ANC → Kunjungan
- Kunjungan → Fasilitas
- ANC → Ibu

All validations must pass before data is promoted to the Gold Layer.