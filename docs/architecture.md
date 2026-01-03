# Data Warehouse Architecture  
Project: Public Health Data Warehouse – Maternal and Child Health (KIA)

---

## 1. Architecture Overview

This project implements a modern analytical Data Warehouse designed to support Maternal and Child Health (MCH/KIA) services in the public health domain. The primary objective of the architecture is to provide a centralized, reliable, and scalable data foundation for monitoring healthcare visits, Antenatal Care (ANC) services, maternal demographics, and healthcare facility performance.

The architecture follows a layered approach to separate raw data ingestion, data cleansing, and business-ready analytics. This separation ensures data traceability, data quality control, and maintainability, which are critical requirements for public health analytics.

---

## 2. Data Management Approach

This Data Warehouse adopts the **Medallion Architecture** (Bronze, Silver, Gold) as the core data management approach.

The Medallion Architecture is chosen because it:

- Preserves raw data for auditability and debugging.
- Isolates data quality issues from analytical consumption.
- Enables scalable and incremental transformation logic.
- Aligns with industry best practices in modern data engineering.

Each layer has a clear responsibility and transformation boundary, ensuring that data processing logic remains transparent and manageable.

---

## 3. Medallion Architecture Design

The architecture consists of three logical layers:

- **Bronze Layer**  
  Stores raw data ingested from source systems without transformation.

- **Silver Layer**  
  Contains cleaned, standardized, and normalized data suitable for further integration.

- **Gold Layer**  
  Provides business-ready analytical data modeled for reporting and analysis.

Data flows sequentially from Bronze to Silver to Gold, with each layer adding structure and quality while maintaining lineage back to the original source data.

---

## 4. Data Layers Description

### 4.1 Bronze Layer

**Purpose:**  
The Bronze Layer stores raw, unprocessed data exactly as received from the source systems.

**Key Characteristics:**
- Data is ingested as-is without transformation.
- All fields are stored as text where applicable to avoid data loss.
- Full load ingestion strategy (truncate and insert).
- Includes ingestion metadata for traceability.

**Target Users:**  
- Data Engineers

**Examples of Bronze Tables:**
- `bronze.raw_kunjungan`
- `bronze.raw_anc`
- `bronze.raw_ibu`
- `bronze.raw_fasilitas`

---

### 4.2 Silver Layer

**Purpose:**  
The Silver Layer prepares data for analytical use by applying data cleansing, standardization, and normalization.

**Key Characteristics:**
- Data type standardization (dates, numeric fields).
- Removal of duplicates and invalid records.
- Handling of missing and inconsistent values.
- Derived and enriched columns when necessary.
- Still table-based (not dimensional modeling yet).

The Silver Layer enforces data quality through explicit cleansing rules,
standardization logic, deduplication processes, and logical referential
integrity validation. This layer represents the single trusted and integrated
source of data prior to dimensional modeling in the Gold Layer.

**Target Users:**  
- Data Engineers  
- Data Analysts

### Data Integration & Entity Relationships

In the Silver Layer, raw healthcare data from multiple Bronze tables is
logically integrated to reflect real-world Maternal and Child Health (KIA)
service workflows.

The integration focuses on establishing clear and consistent relationships
between core healthcare entities:

- Healthcare visits (kunjungan)
- Antenatal Care examinations (ANC)
- Mothers (ibu)
- Healthcare facilities (fasilitas)

#### Core Integration Logic

The following relationships define the Silver integration model:

- Each ANC examination (`raw_anc`) is linked to exactly one healthcare visit
  (`raw_kunjungan`) via `kunjungan_id`.

- Each healthcare visit (`raw_kunjungan`) occurs at one healthcare facility
  (`raw_fasilitas`) via `fasilitas_id`.

- Each ANC examination (`raw_anc`) is associated with one mother
  (`raw_ibu`) via `ibu_id`.

This structure ensures that clinical measurements can always be traced back
to:
1. The service event (kunjungan)
2. The patient (ibu)
3. The physical location of care (fasilitas)

#### Integration Diagram

The logical relationships between Silver entities are documented in the
following diagram:

- `diagrams/data_integration_silver.drawio`

This diagram serves as the authoritative reference for join logic and
referential integrity enforcement during Silver transformations.


---

### 4.3 Gold Layer

**Purpose:**  
The Gold Layer provides business-ready data optimized for reporting and analytical queries.

**Key Characteristics:**
- Dimensional data modeling using Star Schema.
- Fact and dimension tables exposed as views.
- Application of business logic and aggregation.
- Designed for analytical performance and usability.

**Target Users:**  
- Data Analysts  
- Public Health Stakeholders  
- Decision Makers

**Primary Data Mart:**  
- Maternal and Child Health (ANC-focused) Data Mart

---

## 5. Data Flow Overview

The high-level data flow follows a linear and traceable path:

1. Synthetic source data representing public health operational systems is ingested into the Bronze Layer.
2. Raw Bronze data is cleansed and standardized in the Silver Layer.
3. Integrated and modeled data is exposed in the Gold Layer for analytics and reporting.

Each transformation step is documented and version-controlled to ensure transparency and reproducibility.

---

## 6. Technology Stack

The following technologies are used in this project:

- **Database:** PostgreSQL  
- **Data Modeling:** Star Schema  
- **Transformation Logic:** SQL  
- **Version Control:** Git & GitHub  
- **Documentation & Diagrams:** Markdown, Draw.io  

This technology stack is intentionally kept lightweight and widely adopted to reflect real-world data engineering practices.

---

## 7. Design Principles

The architecture adheres to the following principles:

- **Traceability:** All data can be traced back to its original source.
- **Separation of Concerns:** Each layer has a single, well-defined responsibility.
- **Scalability:** The architecture supports future data growth and new data sources.
- **Maintainability:** Clear structure and documentation enable easy maintenance and extension.
- **Analytics-First Design:** The Gold Layer is optimized for analytical consumption.

---

## 8. Future Enhancements

Potential future extensions of this architecture include:

- Incremental loading strategies.
- Slowly Changing Dimensions (SCD).
- Integration with BI visualization tools.
- Additional public health domains beyond Maternal and Child Health.

## 9. Gold Layer — Business-Oriented Analytics Design

This section describes the analytical design considerations applied in the Gold Layer, focusing on business objects, KPI definitions, and fact table grain selection for Maternal and Child Health (KIA) analytics.

---

### 9.1 Business Object Definition

In the context of this Data Warehouse, a **Business Object** represents a real-world entity that is meaningful for public health analysis and decision-making.

For the Maternal and Child Health (KIA) domain, the primary business objects include:

- **ANC Visit** — a recorded antenatal care examination event
- **Mother (Ibu)** — a pregnant woman receiving maternal healthcare services
- **Healthcare Facility** — a service provider delivering maternal health services
- **Time** — the temporal dimension used for trend analysis and reporting
- **Location** — the geographical context of healthcare service delivery

These business objects form the conceptual foundation of the Gold Layer and directly influence the design of fact and dimension tables.

---

### 9.2 Mapping Business Objects to Data Warehouse Structures

Each business object is mapped to a corresponding analytical structure within the Gold Layer as follows:

| Business Object | Data Warehouse Representation |
|-----------------|-------------------------------|
| ANC Visit | Fact table (`fact_anc_visit`) |
| Mother | Dimension table (`dim_ibu`) |
| Healthcare Facility | Dimension table (`dim_fasilitas`) |
| Time | Dimension table (`dim_date`) |
| Location | Dimension attributes within facility or location dimension |

This mapping ensures a clear and consistent relationship between real-world public health concepts and analytical data structures.

---

### 9.3 Fact Table Grain Definition

The selected grain for the primary fact table is:

> **One ANC visit per mother per date per healthcare facility**

This grain selection is justified because it:

- Reflects how ANC services are operationally recorded
- Preserves visit-level accuracy and traceability
- Enables flexible aggregation across time periods and locations
- Supports downstream KPI calculation without data loss

Choosing a fine-grained fact table avoids premature aggregation and maintains analytical flexibility for future use cases.

---

### 9.4 Key Performance Indicator (KPI) Design Philosophy

All Key Performance Indicators (KPIs) derived in the Gold Layer follow these principles:

- KPIs are explicitly defined before implementation
- Calculations are transparent and reproducible
- Metrics align with maternal health monitoring standards
- KPIs are aggregatable across geography and time dimensions
- Business logic is isolated in the Gold Layer

This approach ensures that analytical outputs remain consistent, auditable, and trusted by public health stakeholders.

---

### 9.5 Gold Layer Readiness Criteria

The Gold Layer is considered analytically ready for implementation when the following conditions are met:

- Business objects are clearly defined
- Fact table grain is finalized and documented
- KPI definitions are formally specified
- Required dimensions are identified
- Data lineage from the Silver Layer is preserved

Only after meeting these criteria should technical implementation of the Gold Layer begin.

---