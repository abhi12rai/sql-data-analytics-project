# 📊 End-to-End SQL Data Analytics & Business Intelligence Project  

## 🚀 Project Overview  

This project demonstrates a complete end-to-end Data Analytics workflow using Microsoft SQL Server.

The objective was to transform raw ERP and CRM data into structured, analytics-ready datasets and generate actionable business insights that support data-driven decision-making.

---

## 🎯 Business Objective  

The goal of this project was to:

- Analyze customer purchasing behavior  
- Identify high-performing and underperforming products  
- Track revenue trends over time  
- Segment customers based on value and activity  
- Generate KPIs to support strategic business decisions  

---

## 🏗️ Data Architecture (Medallion Framework)

To ensure data accuracy and reliability, I implemented a **Bronze → Silver → Gold** architecture:

### 🥉 Bronze Layer (Raw Data)
- Ingested raw CSV files into SQL Server  
- Created databases, schemas, and base tables  
- Performed bulk insert operations  

### 🥈 Silver Layer (Cleaned & Validated Data)
- Standardized date formats  
- Handled NULL values  
- Removed duplicates and unwanted spaces  
- Performed data quality checks:
  - Primary key validation  
  - Date range validation  
  - Verified calculated fields (Sales = Quantity × Price)  

### 🥇 Gold Layer (Analytics-Ready Model)
- Designed a Star Schema (Fact & Dimension tables)  
- Ensured referential integrity  
- Validated surrogate key uniqueness  
- Created reporting views for analysis  

---

## 🔎 Analytical Approach  

The analysis was conducted in two phases:

### Phase 1: Exploratory Data Analysis (EDA)
- Database and schema exploration  
- Dimension profiling  
- Date range validation  
- Baseline KPI calculations  
- Ranking products and customers  

### Phase 2: Advanced Analytics
- Change-over-time trend analysis  
- Running totals and moving averages  
- Customer and product segmentation  
- Performance benchmarking using window functions  
- Part-to-whole contribution analysis  

---

## 📈 Key Insights Generated  

- Identified top revenue-generating customers and categorized them as VIP, Regular, and New.  
- Measured customer Recency, Average Order Value (AOV), and Average Monthly Spend.  
- Segmented products into High, Mid, and Low revenue tiers.  
- Analyzed revenue growth trends and seasonality patterns.  
- Evaluated product contribution to total sales for performance optimization.  

---

## 🛠 Skills & SQL Techniques Demonstrated  

- Database Management (CREATE, ALTER, TRUNCATE, DROP)  
- Complex JOINs, Subqueries, and CTEs  
- Window Functions:  
  `ROW_NUMBER()`, `RANK()`, `LAG()`, `SUM() OVER()`, `AVG() OVER()`  
- Stored Procedures for ETL automation  
- Data Validation & Quality Assurance  
- Business segmentation using `CASE WHEN`  
- Reporting Views for BI tools  

---

## 🧰 Tools & Technologies  

- Microsoft SQL Server  
- SQL Server Management Studio (SSMS)  
- Star Schema Data Modeling  
- Medallion Architecture  
- Git & GitHub  

---

## 📂 Repository Structure  

- `/datasets` → Raw source files  
- `/docs` → Data dictionaries & architecture diagrams  
- `/tests` → Data validation scripts  
- `/sql/transformation` → ETL & modeling scripts  
- `/sql/analytics` → EDA & advanced analytics queries  

---

## 👤 Author  

**Abhishek Rai**  

📎 LinkedIn: [linkedin.com/in/abhishek-rai-5054001b7](https://www.linkedin.com/in/your-linkedin-username)  

📧 Email: [abhishek566rai@gmail.com](mailto:yourname@email.com)
