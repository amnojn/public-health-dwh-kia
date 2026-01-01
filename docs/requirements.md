# Requirements Document  
Project: Public Health Data Warehouse – Maternal and Child Health (KIA)

---

## 1. Background & Context

Maternal and Child Health (MCH) services are a critical component of public health systems, particularly in efforts to reduce maternal mortality and improve pregnancy outcomes. One of the key interventions in MCH services is Antenatal Care (ANC), which consists of routine health check-ups provided to pregnant women throughout the pregnancy period.

In many public health settings, operational data related to MCH services—such as health visits, ANC examinations, maternal demographic data, and healthcare facility information—are stored across multiple source systems and formats. These data are often not standardized, making it difficult to perform consistent analysis, monitoring, and evaluation.

This data warehouse project is designed to provide a centralized, integrated, and reliable data foundation to support analytics and reporting for Maternal and Child Health services.

---

## 2. Project Objectives

The main objectives of the Public Health Data Warehouse for Maternal and Child Health are:

1. To provide an integrated and consistent data source for Maternal and Child Health services.
2. To support analysis of ANC visit compliance based on healthcare standards.
3. To enable performance analysis of healthcare facilities delivering MCH services.
4. To provide business-ready data for reporting and public health analysis.
5. To establish a scalable data foundation for future analytical and research use cases.

---

## 3. Project Scope

The scope of this project includes:

- Domain: Public Health with a focus on Maternal and Child Health (KIA).
- Core data entities:
  - Healthcare visits
  - Antenatal Care (ANC) examinations
  - Maternal demographic information
  - Healthcare facility information
- Type of analysis:
  - Operational reporting
  - Basic analytical aggregation
- Data architecture approach:
  - Medallion Architecture (Bronze, Silver, Gold layers)

---

## 4. Stakeholders

The primary stakeholders for this data warehouse include:

- Local and regional Public Health Offices
- Maternal and Child Health program managers
- Primary healthcare facilities (Puskesmas)
- Public health data analysts
- Epidemiologists and public health researchers

---

## 5. Business Questions

The data warehouse is designed to answer the following key business questions:

1. How many Maternal and Child Health service visits occurred within a given period?
2. What percentage of pregnant women comply with the recommended ANC visit standards?
3. How are ANC visits distributed across healthcare facilities?
4. Are there differences in ANC compliance based on maternal characteristics (e.g., age, education)?
5. What are the trends of ANC visits over time?
6. Which healthcare facilities deliver the highest volume of MCH services?

---

## 6. Key Metrics Definition

The primary metrics produced by this data warehouse include:

- **Total MCH Visits**  
  The total number of healthcare service visits related to Maternal and Child Health.

- **Total ANC Visits**  
  The total number of Antenatal Care examinations conducted.

- **ANC Compliance Rate**  
  The percentage of pregnant women who meet the minimum recommended ANC visit standard.

- **Number of Mothers Served**  
  The total number of individual mothers receiving healthcare services.

- **Visits per Healthcare Facility**  
  The total number of MCH-related visits performed by each healthcare facility.

---

## 7. Data Granularity

The defined data granularity is as follows:

- Healthcare Visits:  
  One record represents one healthcare service visit.

- ANC Examinations:  
  One record represents one ANC examination event.

- Maternal Data:  
  One record represents one individual mother.

- Healthcare Facilities:  
  One record represents one healthcare facility.

---

## 8. Assumptions & Constraints

### Assumptions
- The dataset used in this project is synthetic and designed to resemble real-world public health data.
- Not all mothers have complete ANC visit histories.
- Each ANC examination is associated with one mother and one healthcare facility.

### Constraints
- The data is not updated in real time.
- There is no direct integration with external operational healthcare systems.
- Data related to childbirth and neonatal outcomes is not included.

---

## 9. Out of Scope

The following items are explicitly out of scope for this project:

- Advanced clinical or medical diagnosis analysis.
- Childbirth and neonatal datasets.
- Business Intelligence dashboards or visualizations.
- Direct integration with hospital or clinical operational systems.
