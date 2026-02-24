
/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the 'silver' layer. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/
-- ====================================================================
--  Clean, Load & Check CRM Table
-- ====================================================================
-- ====================================================================
--1. Checking 'silver.crm_cust_info'
-- ====================================================================
-- Check For NULL or Duplicates in Primary Key
-- Expectation: No Result

SELECT * FROM bronze.crm_cust_info;

SELECT 
cst_id,
COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- 

SELECT 
*
FROM (
    SELECT 
    *,
    ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_test
    FROM
    bronze.crm_cust_info
    WHERE cst_id IS NOT NULL
)t WHERE flag_test = 1;

-- Check For Unwanted Spaces
-- Expectation: No Result

SELECT * FROM bronze.crm_cust_info;

SELECT 
    cst_id,
    cst_key,
    TRIM(cst_firstname) AS cst_firstname,
    TRIM(cst_lastname) AS cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
FROM (
    SELECT 
    *,
    ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_test
    FROM
    bronze.crm_cust_info
    WHERE cst_id IS NOT NULL
)t WHERE flag_test = 1;

-- Data Standarization & Consistency

SELECT 
    cst_id,
    cst_key,
    TRIM(cst_firstname) AS cst_firstname,
    TRIM(cst_lastname) AS cst_lastname,
    CASE
        WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
        WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
        ELSE 'n/a'
    END AS cst_marital_status,
    CASE
        WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
        WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
        ELSE 'n/a'
    END AS cst_gndr,
    cst_create_date
FROM (
    SELECT 
    *,
    ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_test
    FROM
    bronze.crm_cust_info
    WHERE cst_id IS NOT NULL
)t WHERE flag_test = 1;
--=======================================================================================

-- Insert Data Into silver.crm_cust_info

IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_cust_info;

INSERT INTO silver.crm_cust_info (
	cst_id, 
	cst_key, 
	cst_firstname, 
	cst_lastname, 
	cst_marital_status, 
	cst_gndr,
	cst_create_date
)
SELECT 
    cst_id,
    cst_key,
    TRIM(cst_firstname) AS cst_firstname,
    TRIM(cst_lastname) AS cst_lastname,
    CASE
        WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
        WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
        ELSE 'n/a'
    END AS cst_marital_status,
    CASE
        WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
        WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
        ELSE 'n/a'
    END AS cst_gndr,
    cst_create_date
FROM (
    SELECT 
    *,
    ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_test
    FROM
    bronze.crm_cust_info
    WHERE cst_id IS NOT NULL
)t WHERE flag_test = 1; 

--================================================================================
SELECT 
* 
FROM silver.crm_cust_info;

--1
SELECT 
cst_id,
COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

--2
SELECT 
* 
FROM silver.crm_cust_info
WHERE cst_marital_status != TRIM(cst_marital_status);

SELECT 
* 
FROM silver.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr);

--3
SELECT 
DISTINCT cst_marital_status
FROM silver.crm_cust_info;

SELECT 
DISTINCT cst_gndr
FROM silver.crm_cust_info;


-- ====================================================================
--2. Checking 'silver.crm_prd_info'
-- ====================================================================

-- Data Cleaning of bronze.crm_prd_info
--=====================================================================================

-- Check For NULL or Duplicates in Primary Key
-- Expectation: No Result
SELECT * FROM bronze.crm_prd_info;

SELECT 
prd_id,
COUNT(*) AS CNT
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;


-- Check For Unwanted Spaces
-- Expectation: No Result

SELECT * FROM bronze.crm_prd_info;
GO

SELECT 
*
FROM bronze.crm_prd_info
WHERE prd_key != TRIM(prd_key);
GO

SELECT 
*
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Extract Category Id From prd_key

SELECT * FROM bronze.crm_prd_info;
GO
SELECT * FROM bronze.erp_px_cat_g1v2;
GO

SELECT 
	prd_id,
	prd_key,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id, --Extract cat_id
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
FROM bronze.crm_prd_info
-- WHERE REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') NOT IN (SELECT DISTINCT id FROM bronze.erp_px_cat_g1v2);

--========================================================================
SELECT * FROM bronze.crm_prd_info;
GO
SELECT * FROM bronze.crm_sales_details;

SELECT 
	prd_id,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
    SUBSTRING(prd_key, 7, LEN(PRD_KEY)) AS prd_key,  -- Extract prd_key
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
FROM bronze.crm_prd_info
-- WHERE SUBSTRING(prd_key, 5, LEN(PRD_KEY)) NOT IN (SELECT DISTINCT sls_prd_key FROM bronze.crm_sales_details)
;

--==================================================================================

-- Check For NULL or Negative Number (prd_cost)
-- Expectation: No Result

SELECT 
prd_cost
FROM BRONZE.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost < 0;

-- Replace NULL with 0

SELECT 
	prd_id,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
    SUBSTRING(prd_key, 7, LEN(PRD_KEY)) AS prd_key,
	prd_nm,
	ISNULL(prd_cost, 0) AS prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
FROM bronze.crm_prd_info;

-- Data Standarization & Consistency

SELECT 
	prd_id,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
    SUBSTRING(prd_key, 7, LEN(PRD_KEY)) AS prd_key,
	prd_nm,
	ISNULL(prd_cost, 0) AS prd_cost,
	CASE 
        WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
        WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
        WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
        WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
        ELSE 'n/a'
    END AS prd_line,
	prd_start_dt,
	prd_end_dt
FROM bronze.crm_prd_info;

--Check for Invalid Date Orders
-- End date must not be earlier than start date

SELECT *
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

SELECT *
FROM bronze.crm_prd_info
WHERE prd_key IN ('AC-HE-HL-U509-R', 'AC-HE-HL-U509');

-- End Date = Start Date of the 'Next' Record- 1

SELECT 
*,
LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt) - 1 AS prd_end_dt_test
FROM bronze.crm_prd_info
WHERE prd_key IN ('AC-HE-HL-U509-R', 'AC-HE-HL-U509');
--==============
SELECT 
	prd_id,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
    SUBSTRING(prd_key, 7, LEN(PRD_KEY)) AS prd_key,
	prd_nm,
	ISNULL(prd_cost, 0) AS prd_cost,
	CASE UPPER(TRIM(prd_line))
        WHEN 'M' THEN 'Mountain'
        WHEN 'R' THEN 'Road'
        WHEN 'S' THEN 'Other Sales'
        WHEN 'T' THEN 'Touring'
        ELSE 'n/a'
    END AS prd_line,
	CAST(prd_start_dt AS DATE) AS prd_start_dt,
	CAST(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt) - 1 AS DATE) AS prd_end_dt
FROM bronze.crm_prd_info;

--========================================================================================================

-- Insert Clean Data From bronze.crm_prd_info to silver.crm_prd_info
-- Update Meta Data of The Table silver.crm_prd_info
IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prd_info;

 CREATE TABLE silver.crm_prd_info (
      prd_id            INT,
      cat_id            NVARCHAR(50),
      prd_key           NVARCHAR(50),
      prd_nm            NVARCHAR(50),
      prd_cost          INT,
      prd_line          NVARCHAR(50),
      prd_start_dt      DATE,
      prd_end_dt        DATE,
      dwh_creat_date    DATETIME2 DEFAULT GETDATE()
);
--===================================================================================

INSERT INTO silver.crm_prd_info (
    prd_id,        
    cat_id,        
    prd_key,     
    prd_nm,        
    prd_cost,      
    prd_line,      
    prd_start_dt,  
    prd_end_dt
)
SELECT 
	prd_id,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
    SUBSTRING(prd_key, 7, LEN(PRD_KEY)) AS prd_key,
	prd_nm,
	ISNULL(prd_cost, 0) AS prd_cost,
	CASE UPPER(TRIM(prd_line))
        WHEN 'M' THEN 'Mountain'
        WHEN 'R' THEN 'Road'
        WHEN 'S' THEN 'Other Sales'
        WHEN 'T' THEN 'Touring'
        ELSE 'n/a'
    END AS prd_line,
	CAST(prd_start_dt AS DATE) AS prd_start_dt,
	CAST(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt) - 1 AS DATE) AS prd_end_dt
FROM bronze.crm_prd_info;

-- Verify silver.crm_prd_info

SELECT * FROM silver.crm_prd_info;
--1.
SELECT 
prd_id,
COUNT(*) AS CNT
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

--2.
SELECT 
*
FROM silver.crm_prd_info
WHERE prd_key != TRIM(prd_key);
GO

SELECT 
*
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

--3.
SELECT 
prd_cost
FROM silver.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost < 0;

--4.
SELECT 
DISTINCT prd_line
FROM silver.crm_prd_info;

--5.
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- ====================================================================
--3. Checking 'silver.crm_sales_details'
-- ====================================================================
-- Check For Unwanted Spaces
-- Expectation: No Result 
SELECT 
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
FROM bronze.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num);

SELECT 
*
FROM bronze.crm_sales_details
WHERE sls_prd_key != TRIM(sls_prd_key);

-- ======================================
SELECT *
FROM bronze.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info)
;
--=========================================

SELECT * 
FROM bronze.crm_sales_details
WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info)
;

-- Check for Invalid Dates

-- Negative numbers or 0 can't be cast as a Date  
SELECT 
sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0; 
-- Length of date must be 8 '20101229'

SELECT 
sls_order_dt,
NULLIF(sls_order_dt, 0) AS sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 OR LEN(sls_order_dt) != 8;

-- Check for outliers by validating the boundaries of the date range

SELECT 
NULLIF(sls_order_dt, 0) AS sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt > 20500101 OR sls_order_dt < 19000101;

-- sls_order_dt

SELECT 
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
    CASE WHEN sls_order_dt <= 0 OR LEN(sls_order_dt) != 8 THEN NULL
        ELSE CAST(CAST(sls_order_dt AS varchar) AS date) -- Fisrt convert INT to Varchar then convert into Date
    END sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
FROM bronze.crm_sales_details;

-- sls_ship_dt

SELECT 
NULLIF(sls_ship_dt, 0) AS sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt <= 0 
OR LEN(sls_ship_dt) != 8
OR sls_ship_dt > 20500101 
OR sls_ship_dt < 19000101;
--
-- sls_due_dt

SELECT 
NULLIF(sls_due_dt, 0) AS sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 
OR LEN(sls_due_dt) != 8
OR sls_due_dt > 20500101 
OR sls_due_dt < 19000101;
-- ===============================================
SELECT 
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
    CASE WHEN sls_order_dt <= 0 OR LEN(sls_order_dt) != 8 THEN NULL
        ELSE CAST(CAST(sls_order_dt AS varchar) AS date) -- Fisrt convert INT to Varchar then convert into Date
    END sls_order_dt,
    CASE WHEN sls_ship_dt <= 0 OR LEN(sls_ship_dt) != 8 THEN NULL
        ELSE CAST(CAST(sls_ship_dt AS varchar) AS date) 
    END sls_ship_dt,
    CASE WHEN sls_due_dt <= 0 OR LEN(sls_due_dt) != 8 THEN NULL
        ELSE CAST(CAST(sls_due_dt AS varchar) AS date) 
    END sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
FROM bronze.crm_sales_details;


-- Check for Invalid Date Orders
-- >> Order Date must always be earlier than the Shiping Date or Due Date
SELECT * 
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;

-- Check Data Consistency: Between Sales, Quantity & Price
-- Business Rules
-- >> Sales = Quantity * Price     
-- >> All Sales, Quantity & Price aren't allowed Zero, Negative & NULL

SELECT 
sls_sales,
sls_quantity,
sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales <= 0 OR sls_sales IS NULL
OR sls_quantity <= 0 OR sls_quantity IS NULL
OR sls_price <= 0 OR sls_price IS NULL

/*
Rules: 
If Sales is negative, zero or NULL, derive it from Quantity & Price.
If Price is zero or NULL, calculate it using Sales & Quantity.
If Price is negative, convert it to a positive value.
*/

SELECT 
    sls_sales AS old_sls_sales,
    sls_quantity AS old_sls_quantity,
    sls_price AS old_sls_price,
    CASE WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END AS sls_sales,
    sls_quantity,
    CASE WHEN sls_price <= 0 OR sls_price IS NULL THEN sls_sales / NULLIF(sls_quantity, 0)
        ELSE sls_price
    END AS sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
    OR sls_sales <= 0 OR sls_sales IS NULL
    OR sls_quantity <= 0 OR sls_quantity IS NULL
    OR sls_price <= 0 OR sls_price IS NULL
ORDER BY old_sls_sales, sls_quantity, old_sls_price;

-- >>
SELECT 
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
    CASE WHEN sls_order_dt <= 0 OR LEN(sls_order_dt) != 8 THEN NULL
        ELSE CAST(CAST(sls_order_dt AS varchar) AS date) 
    END sls_order_dt,
    CASE WHEN sls_ship_dt <= 0 OR LEN(sls_ship_dt) != 8 THEN NULL
        ELSE CAST(CAST(sls_ship_dt AS varchar) AS date) 
    END sls_ship_dt,
    CASE WHEN sls_due_dt <= 0 OR LEN(sls_due_dt) != 8 THEN NULL
        ELSE CAST(CAST(sls_due_dt AS varchar) AS date) 
    END sls_due_dt,
    CASE WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END AS sls_sales,
    sls_quantity,
    CASE WHEN sls_price <= 0 OR sls_price IS NULL THEN sls_sales / NULLIF(sls_quantity, 0)
        ELSE sls_price
    END AS sls_price
FROM bronze.crm_sales_details;

-- DDL Script of silver.crm_sales_details Required Changes

IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;
GO

CREATE TABLE silver.crm_sales_details (
    sls_ord_num         NVARCHAR(50),
    sls_prd_key         NVARCHAR(50),
    sls_cust_id         INT,
    sls_order_dt        Date,
    sls_ship_dt         Date,
    sls_due_dt          Date,
    sls_sales           INT,
    sls_quantity        INT,
    sls_price           INT,
    dwh_creat_date      DATETIME2 DEFAULT GETDATE() 
);
--=======================================================================================

-- >> Insert Data
INSERT INTO silver.crm_sales_details (
    sls_ord_num,   
    sls_prd_key,   
    sls_cust_id,   
    sls_order_dt, 
    sls_ship_dt,   
    sls_due_dt,    
    sls_sales,     
    sls_quantity,  
    sls_price     
)
SELECT 
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
    CASE WHEN sls_order_dt <= 0 OR LEN(sls_order_dt) != 8 THEN NULL
        ELSE CAST(CAST(sls_order_dt AS varchar) AS date) 
    END sls_order_dt,
    CASE WHEN sls_ship_dt <= 0 OR LEN(sls_ship_dt) != 8 THEN NULL
        ELSE CAST(CAST(sls_ship_dt AS varchar) AS date) 
    END sls_ship_dt,
    CASE WHEN sls_due_dt <= 0 OR LEN(sls_due_dt) != 8 THEN NULL
        ELSE CAST(CAST(sls_due_dt AS varchar) AS date) 
    END sls_due_dt,
    CASE WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END AS sls_sales,
    sls_quantity,
    CASE WHEN sls_price <= 0 OR sls_price IS NULL THEN sls_sales / NULLIF(sls_quantity, 0)
        ELSE sls_price
    END AS sls_price
FROM bronze.crm_sales_details;

-- Quality Check
--1.
SELECT *
FROM silver.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num);

--2.
SELECT * 
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;

--3.
SELECT *
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales <= 0 OR sls_sales IS NULL
OR sls_quantity <= 0 OR sls_quantity IS NULL
OR sls_price <= 0 OR sls_price IS NULL
  
-- ====================================================================
-- Clean, Load & Check ERP Table
-- ====================================================================
-- ====================================================================
--4. Checking 'silver.erp_cust_az12'
-- ====================================================================
SELECT * FROM bronze.erp_cust_az12;
GO
SELECT * FROM silver.crm_cust_info;

SELECT * FROM bronze.erp_cust_az12
WHERE cid LIKE 'AW%';

SELECT * FROM silver.crm_cust_info
WHERE cst_key LIKE 'NAS%';

SELECT * FROM bronze.erp_cust_az12
WHERE cid NOT IN (SELECT cst_key FROM silver.crm_cust_info);

-- Remove Extra String from cid in bronze.erp_cust_az12

SELECT  
cid,
CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid)) 
    ELSE cid
END AS cid
FROM bronze.erp_cust_az12
WHERE 
(CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid)) 
    ELSE cid
END) NOT IN (SELECT cst_key FROM silver.crm_cust_info);

--==========================
SELECT
CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid)) 
    ELSE cid
END AS cid
FROM bronze.erp_cust_az12;

--Identify Out-of-Range Dates

SELECT * 
, DATEDIFF(YEAR, GETDATE(), BDATE)
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE();

SELECT
    CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid)) 
        ELSE cid
    END AS cid,
    CASE 
        WHEN bdate > GETDATE() THEN NULL
        ELSE bdate
    END AS bdate,
    gen
FROM bronze.erp_cust_az12;

-- Data Standardization and Consistency

SELECT DISTINCT gen
FROM bronze.erp_cust_az12;

SELECT DISTINCT gen,
CASE 
    WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
    WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
    ELSE 'n/a'
END as gen
FROM bronze.erp_cust_az12;

SELECT
    CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid)) 
        ELSE cid
    END AS cid,
    CASE 
        WHEN bdate > GETDATE() THEN NULL
        ELSE bdate
    END AS bdate,
    CASE 
        WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
        WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
        ELSE 'n/a'
END as gen
FROM bronze.erp_cust_az12;

--============================================================

INSERT INTO silver.erp_cust_az12 (
        cid,
        bdate,
        gen
)
SELECT
    CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid)) 
        ELSE cid
    END AS cid,
    CASE 
        WHEN bdate > GETDATE() THEN NULL
        ELSE bdate
    END AS bdate,
    CASE 
        WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
        WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
        ELSE 'n/a'
END as gen
FROM bronze.erp_cust_az12;


-- Quality Check

SELECT * FROM silver.erp_cust_az12;

--1
SELECT bdate 
FROM silver.erp_cust_az12
WHERE bdate > GETDATE();

--2
SELECT DISTINCT gen
FROM silver.erp_cust_az12;


-- ====================================================================
--5. Checking 'silver.erp_loc_a101'
-- ====================================================================
SELECT *
FROM bronze.erp_loc_a101;
GO
SELECT *
FROM silver.crm_cust_info;

SELECT *
FROM bronze.erp_loc_a101
WHERE REPLACE(cid, '-', '') NOT IN (SELECT cst_key FROM silver.crm_cust_info);

SELECT 
REPLACE(cid, '-', '') AS cid,
cntry
FROM bronze.erp_loc_a101;

-- Data Standardization and Consistency

SELECT DISTINCT cntry
FROM bronze.erp_loc_a101
ORDER BY cntry;

SELECT DISTINCT cntry AS Old_cntry,
CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany' 
     WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
     WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
     ELSE TRIM(cntry)
END AS cntry
FROM bronze.erp_loc_a101
ORDER BY Old_cntry;

-- >>>
SELECT
    REPLACE(cid, '-', '') AS cid,
    CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany' 
         WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
         WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
         ELSE TRIM(cntry)
    END AS cntry
FROM bronze.erp_loc_a101;

--===============================================

INSERT INTO silver.erp_loc_a101 (
    cid,
    cntry
)
SELECT
    REPLACE(cid, '-', '') AS cid,
    CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany' 
         WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
         WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
         ELSE TRIM(cntry)
    END AS cntry --Normalise and Handle missing or blank country codes
FROM bronze.erp_loc_a101;


-- Quality Check

SELECT DISTINCT cntry
FROM silver.erp_loc_a101
ORDER BY cntry;

SELECT * FROM silver.erp_loc_a101;


-- ====================================================================
--6. Checking 'silver.erp_px_cat_g1v2'
-- ====================================================================

SELECT * FROM bronze.erp_px_cat_g1v2;
GO
SELECT * FROM silver.crm_prd_info; -- id = cat_id

-- Check for Unwanted Spaces

SELECT * 
FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance);

-- Data Standardization and Consistency

SELECT DISTINCT cat 
FROM bronze.erp_px_cat_g1v2;

SELECT DISTINCT subcat 
FROM bronze.erp_px_cat_g1v2;

SELECT DISTINCT maintenance 
FROM bronze.erp_px_cat_g1v2;

-- Everything is correct 

--==============================
INSERT INTO silver.erp_px_cat_g1v2 (
    id,
    cat,
    subcat,
    maintenance
)
SELECT 
    id,
    cat,
    subcat,
    maintenance
FROM bronze.erp_px_cat_g1v2;

SELECT * FROM silver.erp_px_cat_g1v2;
