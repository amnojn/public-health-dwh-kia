# Public Health Data Warehouse – Maternal and Child Health (KIA)

## 📌 Project Overview

This project implements an **end-to-end Data Warehouse** for the **Public Health domain**, with a specific focus on **Maternal and Child Health (Kesehatan Ibu dan Anak / KIA)**.

The objective of this project is to demonstrate **professional data engineering practices**, including data modeling, data quality management, layered architecture, and analytical data preparation using SQL.

The Data Warehouse is designed to support analysis of:
- Antenatal Care (ANC) visits
- Maternal demographics
- Healthcare facility performance
- Public health service utilization

This project is built as a **portfolio-grade implementation**, not a toy example.

---

## 🏗️ Architecture Overview

The project follows the **Medallion Architecture**:

- **Bronze Layer** – Raw, unprocessed data (as-is ingestion)
- **Silver Layer** – Cleaned, standardized, and validated data
- **Gold Layer** – Business-ready analytical data (Star Schema)

Each layer has a clearly defined responsibility to ensure:
- Data traceability
- Data quality isolation
- Maintainability and scalability

📌 All transformations are implemented using **pure SQL on PostgreSQL**.

---

## 📂 Repository Structure

```text
public-health-dwh-kia/
│
├── data/
│   ├── raw/                # Synthetic raw CSV datasets
│   ├── bronze/
│   ├── silver/
│   └── gold/
│
├── sql/
│   ├── bronze/             # Bronze DDL scripts
│   ├── silver/             # Silver cleansing & standardization
│   └── gold/               # Gold dimensional models
│
├── docs/
│   ├── requirements.md
│   ├── architecture.md
│   ├── naming_conventions.md
│   ├── data_dictionary.md
│   └── data_quality.md
│
├── diagrams/
│   ├── data_architecture.drawio
│   ├── data_flow.drawio
│   ├── data_integration_silver.drawio
│   └── star_schema_kia.drawio
│
├── README.md
└── .gitignore

## 🧱 Data Layers Description

### Bronze Layer
- Stores raw source data without transformation  
- Preserves original formats for traceability  
- All fields stored as `TEXT` where applicable  
- Includes ingestion metadata (`ingested_at`)  

### Silver Layer
- Cleans and standardizes data from Bronze  
- Applies data type conversion  
- Handles missing values and duplicates  
- Enforces data quality rules  
- Acts as the **Single Source of Truth**  

### Gold Layer
- Implements **Star Schema**  
- Uses dimension and fact **views**  
- Applies business logic and data integration  
- Optimized for analytical queries  

---

## ⭐ Gold Layer – Business Focus

### Business Process
- **Antenatal Care (ANC) Visits**

### Fact Table
- `fact_anc_visit`  
- **Grain:** one ANC visit per mother per date per facility  

### Dimensions
- `dim_date`  
- `dim_ibu`  
- `dim_fasilitas`  

### Example Analytical Questions
- How many ANC visits occur per month?  
- What is the distribution of gestational age at visit?  
- Which facilities serve the highest ANC volume?  
- How does ANC utilization vary across districts?  

---

## 📊 Data Quality & Governance

This project enforces explicit data quality rules:

- No duplicate primary identifiers  
- Valid date ranges  
- Valid numeric ranges (e.g., gestational age, weight)  
- Standardized categorical values  
- Referential integrity between facts and dimensions  

All rules are documented in:
- `docs/data_quality.md`  
- `docs/data_dictionary.md`  

---

## 🗺️ Data Scope

- **Geographic Scope:** Kabupaten Jember, Indonesia  
- **Facilities:** Realistic but synthetic healthcare facilities  
- **Data Type:** Fully synthetic (no real personal data)  
- **Volume:** Medium-scale datasets suitable for analytical workloads  

📌 This project uses **synthetic data** for ethical and privacy reasons.

---

## 🛠️ Technology Stack

- **Database:** PostgreSQL  
- **Transformation:** SQL  
- **Architecture:** Medallion Architecture  
- **Modeling:** Star Schema  
- **Version Control:** Git & GitHub  
- **Documentation:** Markdown  
- **Diagramming:** Draw.io  

---

## 🎯 Project Goals

This project demonstrates:
- End-to-end Data Warehouse design  
- Professional SQL transformation patterns  
- Data quality enforcement  
- Clear documentation and governance  
- Realistic public health analytics use case  

---

## 🚀 Potential Extensions

- Incremental loading strategies  
- Slowly Changing Dimensions (SCD)  
- BI tool integration (Power BI, Tableau)  
- Additional public health domains  
- Automated data validation tests 