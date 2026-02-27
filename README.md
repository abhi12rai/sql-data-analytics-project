📊 End-to-End SQL Data Analytics & Business Intelligence Portfolio
🚀 Project Overview
This project showcases a complete, end-to-end data analytics workflow using Microsoft SQL Server. The primary objective is to demonstrate the ability to take raw, messy data from multiple sources (ERP and CRM systems), clean and model it, and ultimately generate actionable business intelligence.

I built this project to showcase a comprehensive understanding of the SQL Server ecosystem, utilizing everything from fundamental DDL/DML commands to advanced analytical functions, stored procedures, data validation, and views.

🏗️ Data Preparation & Architecture
To ensure data integrity and reporting accuracy, I implemented a Medallion Architecture (Bronze, Silver, Gold) to process the data before analysis.

Bronze Layer (Raw): Ingested raw CSV files directly into SQL Server. Focus: Database & Schema creation, Bulk Insert operations.

Silver Layer (Cleansed & Validated): Standardized date formats, handled NULL values, and resolved inconsistencies.

Data Quality Checks: Wrote rigorous SQL test scripts to identify duplicate primary keys, remove unwanted spaces (TRIM), validate date ranges, and mathematically verify data consistency (e.g., Sales = Quantity * Price).

Gold Layer (Analytics-Ready): Transformed the cleaned data into a Star Schema (Fact and Dimension tables) to serve as the single source of truth.

Integrity Checks: Validated surrogate key uniqueness and ensured perfect referential integrity between Fact and Dimension tables before running analytics.

🛠️ The Analytics Workflow
Once the data was modeled and validated, I conducted a systematic two-phase analytical deep dive.

Phase 1: Exploratory Data Analysis (EDA)
Using SQL, I systematically interrogated the database to understand data distributions, validate data health, and establish baselines before diving into deeper analysis:

01_database_exploration: Explored the overall database structure, inspecting table schemas, columns, and metadata to ensure a solid foundational understanding.

02_dimensions_exploration: Profiled the structure of the dimension tables to analyze categorical data and unique values.

03_date_exploration: Determined the temporal boundaries of key data points to understand the exact range of historical data available.

04_measures_exploration: Calculated core aggregated metrics (totals, averages) to establish quick baselines and spot high-level anomalies or trends.

05_magnitude_analysis: Quantified the data and grouped results by specific dimensions to understand distribution and scale across various categories.

06_ranking_analysis: Ranked key entities like products and customers to quickly identify top performers and laggards based on specific performance metrics.

Phase 2: Advanced Analytics & Reporting
I developed a suite of complex SQL scripts to derive deep business intelligence, track KPIs, and build comprehensive entity reports:

07_change_over_time_analysis: Tracked key metric trends, growth, and decline over specific time periods to identify seasonality and historical business patterns.

08_cumulative_analysis: Calculated running totals and moving averages to track cumulative performance and identify long-term growth trends.

09_performance_analysis: Benchmarked the performance of products, customers, and regions against historical data to identify high-performing entities and yearly trends (leveraging advanced SQL like LAG(), AVG() OVER(), and CASE statements).

10_part_to_whole_analysis: Evaluated categorical differences and compared metrics across dimensions to understand proportional contributions (useful for regional comparisons and A/B testing).

11_data_segmentation_analysis: Applied custom logic using CASE and GROUP BY to group data into meaningful categories, allowing for highly targeted customer and product insights.

12_customer_report: Built a comprehensive view of customer behavior. Consolidated essential demographic and transaction data, segmented users (VIP, Regular, New), and aggregated core metrics (lifespan, total sales) to calculate high-value KPIs like Recency, Average Order Value (AOV), and Average Monthly Spend.

13_product_report: Developed a detailed breakdown of inventory and product performance. Segmented products by revenue tier (High, Mid, Low-Performers) and aggregated metrics (unique customers, total sales) to calculate crucial KPIs such as Recency, Average Order Revenue (AOR), and Average Monthly Revenue.

🎯 SQL Skills & Techniques Demonstrated
This project is built entirely in SQL and demonstrates proficiency in:

Database Management: CREATE DATABASE, SCHEMA, TABLE, DROP, TRUNCATE, ALTER.

Data Automation: Writing and executing Stored Procedures to automate the ETL (Extract, Transform, Load) pipelines.

Data Quality Assurance: Writing validation scripts to enforce constraints and data consistency.

Advanced Querying: CTEs (Common Table Expressions), Subqueries, JOINs (Inner, Left, Right).

Window Functions: ROW_NUMBER(), RANK(), LAG(), SUM() OVER(), AVG() OVER().

Business Logic: Complex CASE WHEN statements for dynamic segmentation and data categorization.

Reporting: Creating VIEWS to act as virtual tables for reporting tools (like Power BI/Tableau) to consume.

📂 Repository Navigation
/data - Contains the raw source files.

/docs - Contains Data Dictionaries and architectural diagrams.

/tests - Contains data quality checks and validation scripts for the Silver and Gold layers.

/sql/transformation - Contains the DDL/DML scripts and Stored Procedures for the Bronze, Silver, and Gold layers.

/sql/analytics - Contains the numbered SQL scripts (01 to 13) for EDA and Advanced Analytics.

Author: Abhishek Rai
Connect with me: [linkedin.com/in/abhishek-rai-5054001b7] | [abhishek566rai@gmail.com]
