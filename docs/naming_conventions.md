docs/naming_conventions.md
# Naming Conventions

## 1. Purpose

This document defines the **official naming conventions** used throughout the  
**Public Health Data Warehouse – Maternal and Child Health (KIA)** project.

The objectives of these conventions are to:

- Ensure consistency across all data layers
- Improve readability and maintainability
- Support scalability and collaboration
- Align with professional data engineering standards
- Reduce ambiguity in analytical and engineering workflows

All database objects, SQL scripts, datasets, documentation, and diagrams MUST follow these conventions.

---

## 2. Global Naming Rules (Applies to Everything)

The following rules apply universally:

- Use **snake_case**
- Use **lowercase letters only**
- Use **English language**
- Avoid unnecessary abbreviations
- Names must be **descriptive and unambiguous**
- One name = one meaning (no overload)

### Examples

✅ Correct:


raw_kunjungan
tanggal_pemeriksaan
fact_anc_visit
data_quality


❌ Incorrect:


RawKunjungan
tgl_periksa
fact1
dq


---

## 3. Schema Naming Conventions

Each layer in the Medallion Architecture uses a dedicated schema.

| Layer | Schema Name | Description |
|------|------------|-------------|
| Bronze | `bronze` | Raw, unprocessed source data |
| Silver | `silver` | Cleaned and standardized data |
| Gold | `gold` | Business-ready analytical data |

📌 Rules:
- Schema names must NOT be abbreviated
- Schema names must reflect logical data layers
- One schema = one responsibility

---

## 4. Table Naming Conventions

### 4.1 Bronze Layer Tables

**Pattern:**


raw_<entity_name>


**Examples:**
- `bronze.raw_kunjungan`
- `bronze.raw_anc`
- `bronze.raw_ibu`
- `bronze.raw_fasilitas`

**Characteristics:**
- Data stored as-is
- Minimal constraints
- Mostly TEXT data types
- Full traceability to source data

📌 Bronze tables NEVER contain business logic.

---

### 4.2 Silver Layer Tables

**Pattern:**


<entity_name>


**Examples:**
- `silver.kunjungan`
- `silver.anc`
- `silver.ibu`
- `silver.fasilitas`

**Characteristics:**
- Cleaned and standardized
- Proper data types
- Deduplicated
- Ready for integration

📌 Silver layer acts as the **Single Source of Truth**.

---

### 4.3 Gold Layer Tables and Views

Gold Layer follows **Star Schema conventions** and is primarily implemented as **views**.

#### Dimension Tables

**Pattern:**


dim_<entity_name>


**Examples:**
- `gold.dim_date`
- `gold.dim_ibu`
- `gold.dim_fasilitas`

#### Fact Tables

**Pattern:**


fact_<business_event>


**Examples:**
- `gold.fact_anc_visit`

📌 Rules:
- Fact tables store measurable events
- Dimension tables store descriptive attributes
- Grain must be clearly defined

---

## 5. Column Naming Conventions

### 5.1 Identifier Columns

**Pattern:**


<entity>_id


**Examples:**
- `ibu_id`
- `fasilitas_id`
- `kunjungan_id`
- `date_id`

Rules:
- Must be unique per entity
- Must not encode business meaning
- Consistent across layers

---

### 5.2 Date and Timestamp Columns

| Type | Naming Pattern |
|----|----------------|
| Date | `tanggal_<event>` |
| Timestamp | `<event>_at` |

**Examples:**
- `tanggal_kunjungan`
- `tanggal_pemeriksaan`
- `created_at`
- `ingested_at`

---

### 5.3 Boolean Columns

**Pattern:**


is_<condition>


**Examples:**
- `is_valid_record`
- `is_active`
- `is_complete`

---

### 5.4 Numeric and Measurement Columns

Rules:
- Avoid unit ambiguity
- Include unit if necessary
- Be explicit and descriptive

**Examples:**
- `usia_kehamilan_minggu`
- `usia_ibu_tahun`
- `berat_badan_kg`
- `tekanan_darah_sistolik`
- `tekanan_darah_diastolik`

---

### 5.5 Derived Columns

Rules:
- Clearly labeled as derived
- Allowed in Silver and Gold only
- No KPIs in Silver layer

**Examples:**
- `usia_ibu`
- `gestational_age_weeks`

---

## 6. SQL File Naming Conventions

All SQL scripts must follow:



<layer>.<object_name>.sql


### Examples

**Bronze**
- `bronze.ddl_raw_tables.sql`

**Silver**
- `silver.fasilitas.sql`
- `silver.ibu.sql`
- `silver.kunjungan.sql`
- `silver.anc.sql`

**Gold**
- `gold.dim_date.sql`
- `gold.dim_ibu.sql`
- `gold.dim_fasilitas.sql`
- `gold.fact_anc_visit.sql`

📌 This ensures:
- Clear execution order
- Easy version control
- Predictable structure

---

## 7. Dataset (CSV) Naming Conventions

Synthetic and raw datasets stored under `data/raw/` must match Bronze tables.

**Pattern:**


raw_<entity>.csv


**Examples:**
- `raw_fasilitas.csv`
- `raw_ibu.csv`
- `raw_kunjungan.csv`
- `raw_anc.csv`

📌 Column names MUST exactly match Bronze table columns.

---

## 8. Documentation Naming Conventions

All documentation files:

- Use Markdown format
- Use lowercase snake_case

**Examples:**
- `requirements.md`
- `architecture.md`
- `data_dictionary.md`
- `data_quality.md`
- `naming_conventions.md`

---

## 9. Diagram Naming Conventions

Diagrams stored in `diagrams/` must clearly describe their purpose.

**Examples:**
- `data_architecture_overview.drawio`
- `data_flow_bronze.drawio`
- `data_integration_silver.drawio`
- `star_schema_kia.drawio`

---

## 10. Git Branch & Commit Naming (Supporting Convention)

### Branch Naming



feature/<layer>-layer


Examples:
- `feature/bronze-layer`
- `feature/silver-layer`
- `feature/gold-layer`

### Commit Message Format



[LAYER] short descriptive message


Examples:
- `[BRONZE] create raw tables`
- `[SILVER] clean and standardize fasilitas`
- `[GOLD] build fact_anc_visit`

---

## 11. Governance and Enforcement

- These conventions are mandatory
- All new objects must comply
- Deviations must be documented explicitly
- Consistency is prioritized over brevity

---

## Summary

These naming conventions establish a strong foundation for:

- Professional data engineering practices
- Clear analytical communication
- Long-term maintainability
- Portfolio-level project quality

Strict adherence to this document ensures that the Data Warehouse remains robust, scalable, and easy to understa