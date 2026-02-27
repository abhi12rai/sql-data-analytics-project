# 📊 End-to-End SQL Data Analytics & Business Intelligence Portfolio

## 🚀 Project Overview
This project showcases a complete, end-to-end data analytics workflow using **Microsoft SQL Server**. The primary objective is to demonstrate the ability to take raw, messy data from multiple sources (ERP and CRM systems), clean and model it, and ultimately generate actionable business intelligence. 

I built this project to showcase a comprehensive understanding of the SQL Server ecosystem, utilizing everything from fundamental DDL/DML commands to advanced analytical functions, stored procedures, data validation, and views.

---

## 🏗️ Data Preparation & Architecture
To ensure data integrity and reporting accuracy, I implemented a Medallion Architecture (Bronze, Silver, Gold) to process the data before analysis. 

* **Bronze Layer (Raw):** Ingested raw CSV files directly into SQL Server. Focus: *Database & Schema creation, Bulk Insert operations.*
* **Silver Layer (Cleansed & Validated):** Standardized date formats, handled NULL values, and resolved inconsistencies. 
    * **Data Quality Checks:** Wrote rigorous SQL test scripts to identify duplicate primary keys, remove unwanted spaces (`TRIM`), validate date ranges, and mathematically verify data consistency (e.g., `Sales = Quantity * Price`).
* **Gold Layer (Analytics-Ready):** Transformed the cleaned data into a **Star Schema** (Fact and Dimension tables) to serve as the single source of truth. 
    * **Integrity Checks:** Validated surrogate key uniqueness and ensured perfect referential integrity between Fact and Dimension tables before running analytics.

---

## 🛠️ The Analytics Workflow
Once the data was modeled and validated, I conducted a systematic two-phase analytical deep dive.

### Phase 1: Exploratory Data Analysis (EDA)
Using SQL, I systematically interrogated the database to understand data distributions, validate data health, and establish baselines before diving into deeper analysis:

* **`01_database_exploration`**: Explored the overall
