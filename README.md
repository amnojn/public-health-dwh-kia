## Project Phases & Status

This project is developed incrementally following a Medallion Architecture
(Bronze → Silver → Gold) and professional Data Warehouse best practices.

### Phase 1 — Requirements Analysis
**Status:** Completed  
**Output:**
- Business requirements document
- Defined health service & KIA analytical scope

---

### Phase 2 — Data Architecture Design
**Status:** Completed  
**Output:**
- Medallion architecture design
- Data flow and system mapping
- High-level data model planning

---

### Phase 3 — Project Initialization
**Status:** Completed  
**Output:**
- Git repository setup
- Naming conventions
- Folder structure aligned with DW architecture

---

### Phase 4 — Bronze Layer (Raw Data)
**Status:** Completed  
**Objective:**  
Ingest raw, unprocessed health service and KIA data as-is for traceability and debugging.

**Key Deliverables:**
- Bronze schema creation
- Raw tables for:
  - Health visits (`raw_kunjungan`)
  - ANC records (`raw_anc`)
  - Maternal data (`raw_ibu`)
  - Health facilities (`raw_fasilitas`)
- Data completeness & schema validation
- Bronze data flow documentation

📁 Reference:
- `sql/bronze/`
- `docs/bronze_schema.md`
- `diagrams/data_flow_bronze.drawio`

---

### Phase 5 — Silver Layer
**Status:** Planned  
**Objective:**  
Data cleansing, standardization, and preparation for analytics.

---

### Phase 6 — Gold Layer
**Status:** Planned  
**Objective:**  
Star schema modeling and business-ready analytical views.
