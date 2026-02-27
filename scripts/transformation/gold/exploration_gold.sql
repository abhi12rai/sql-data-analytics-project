/*
===============================================================================
Script: Data Discovery & Transformation Logic
===============================================================================
Purpose: 
    - Test joins between Silver layer tables.
    - Perform Data Quality (DQ) checks (duplicates, nulls).
    - Prototype transformations and business logic.
    - Validate results before moving to final Gold Layer Views.
===============================================================================
*/

===============================================================================
-- DDL Script: Create Gold Views (Raw Scripts)
===============================================================================

-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================  
SELECT 
    ci.cst_id,
    ci.cst_key,
    ci.cst_firstname,
    ci.cst_lastname,
    ci.cst_marital_status,
    ci.cst_gndr,  
    ci.cst_create_date,    
    ca.bdate,
    ca.gen,
    la.cntry             
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid;

-- After Joining Table, Check if any duplicates were introduced by the join logic
SELECT 
cst_id, COUNT(*) AS CNT
FROM (
    SELECT 
        ci.cst_id,
        ci.cst_key,
        ci.cst_firstname,
        ci.cst_lastname,
        ci.cst_marital_status,
        ci.cst_gndr,  
        ci.cst_create_date,    
        ca.bdate,
        ca.gen,
        la.cntry             
    FROM silver.crm_cust_info ci
    LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key = ca.cid
    LEFT JOIN silver.erp_loc_a101 la
    ON ci.cst_key = la.cid
) t
GROUP BY cst_id
HAVING COUNT(*) > 1;

-- Data Integration 

SELECT DISTINCT
    ci.cst_gndr,  
    ca.gen
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid  -- NULL often comes from joined table
ORDER BY 1, 2;          -- NULL will apear id SQL finds no match

--Note: Master Source of Customer Data is CRM

SELECT DISTINCT
    ci.cst_gndr,  
    ca.gen,
    CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
        ELSE COALESCE(ca.gen, 'n/a')
    END AS new_gen
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid 
ORDER BY 1, 2;    

-- Rename columns to friendly, meaningful names

SELECT 
    ci.cst_id AS customer_id,
    ci.cst_key AS customer_key,
    ci.cst_firstname AS first_name,
    ci.cst_lastname AS last_name,
    ci.cst_marital_status AS marital_status,
    CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
        ELSE COALESCE(ca.gen, 'n/a')
    END AS gender,  
    ci.cst_create_date AS create_date,    
    ca.bdate AS birthdate,
    la.cntry AS country             
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid;

-- Sort the columns into logical groups to improve readability

SELECT 
    ci.cst_id AS customer_id,
    ci.cst_key AS customer_number,
    ci.cst_firstname AS first_name,
    ci.cst_lastname AS last_name,
    la.cntry AS country,
    ci.cst_marital_status AS marital_status,
    CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
        ELSE COALESCE(ca.gen, 'n/a')
    END AS gender,  
    ca.bdate AS birthdate,
    ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid;

-- This is Dimension Table, need a Primary Key
-- Generate a Surrogate Key using Window Function

SELECT 
    ROW_NUMBER() OVER(ORDER BY ci.cst_id) AS custome_key,
    ci.cst_id AS customer_id,
    ci.cst_key AS customer_number,
    ci.cst_firstname AS first_name,
    ci.cst_lastname AS last_name,
    la.cntry AS country,
    ci.cst_marital_status AS marital_status,
    CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
        ELSE COALESCE(ca.gen, 'n/a')
    END AS gender,  
    ca.bdate AS birthdate,
    ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid;

--Create Object 
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO
CREATE VIEW gold.dim_customers AS
SELECT 
    ROW_NUMBER() OVER(ORDER BY ci.cst_id) AS customer_key,
    ci.cst_id AS customer_id,
    ci.cst_key AS customer_number,
    ci.cst_firstname AS first_name,
    ci.cst_lastname AS last_name,
    la.cntry AS country,
    ci.cst_marital_status AS marital_status,
    CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
        ELSE COALESCE(ca.gen, 'n/a')
    END AS gender,  
    ca.bdate AS birthdate,
    ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid;


-- Quality Check

SELECT * FROM gold.dim_customers;

-- Check for Uniqueness of Customer Key in gold.dim_customers
-- Expectation: No results 
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- Distinct Gender
SELECT DISTINCT gender
FROM gold.dim_customers;

-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================

SELECT 
    pn.prd_id,
    pn.cat_id,
    pn.prd_key,
    pn.prd_nm,
    pn.prd_cost,
    pn.prd_line,
    pn.prd_start_dt,
    pn.prd_end_dt
FROM silver.crm_prd_info pn 

--Filter Out All Historical Data

SELECT 
    pn.prd_id,
    pn.cat_id,
    pn.prd_key,
    pn.prd_nm,
    pn.prd_cost,
    pn.prd_line,
    pn.prd_start_dt
FROM silver.crm_prd_info pn -- If Rnd Date is NULL then 
WHERE pn.prd_end_dt IS NULL; -- It is Current Info of the Product !

-- Join with silver.

SELECT 
    pn.prd_id,
    pn.cat_id,
    pn.prd_key,
    pn.prd_nm,
    pn.prd_cost,
    pn.prd_line,
    pn.prd_start_dt,
    pc.cat,
    pc.subcat,
    pc.maintenance
FROM silver.crm_prd_info pn 
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL; 

-- After Joining Table, Check if any duplicates were introduced by the join logic
SELECT prd_key, COUNT(*)
FROM (
SELECT
    pn.prd_id,
    pn.cat_id,
    pn.prd_key,
    pn.prd_nm,
    pn.prd_cost,
    pn.prd_line,
    pn.prd_start_dt,
    pc.cat,
    pc.subcat,
    pc.maintenance
FROM silver.crm_prd_info pn 
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL
)t 
GROUP BY prd_key
HAVING COUNT(*) > 1; 


-- Sort the columns into logical groups to improve readability

SELECT
    pn.prd_id,
    pn.prd_key,
    pn.prd_nm,
    pn.cat_id,
    pc.cat,
    pc.subcat,
    pc.maintenance,
    pn.prd_cost,
    pn.prd_line,
    pn.prd_start_dt
FROM silver.crm_prd_info pn 
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL;

-- Rename columns to friendly, meaningful names

SELECT
    pn.prd_id AS product_id,
    pn.prd_key AS product_number,
    pn.prd_nm AS product_name,
    pn.cat_id AS category_id,
    pc.cat AS category,
    pc.subcat AS subcategory,
    pc.maintenance,
    pn.prd_cost AS cost,
    pn.prd_line AS product_line,
    pn.prd_start_dt AS start_date
FROM silver.crm_prd_info pn 
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL;

-- This is Dimension Table, need a Primary Key
-- Generate a Surrogate Key using Window Function

IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS 
SELECT
    ROW_NUMBER() OVER(ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,    -- Surrogate Key
    pn.prd_id AS product_id,
    pn.prd_key AS product_number,
    pn.prd_nm AS product_name,
    pn.cat_id AS category_id,
    pc.cat AS category,
    pc.subcat AS subcategory,
    pc.maintenance,
    pn.prd_cost AS cost,
    pn.prd_line AS product_line,
    pn.prd_start_dt AS start_date
FROM silver.crm_prd_info pn 
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL;

-- Check for Uniqueness of Product Key in gold.dim_products
-- Expectation: No results 
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================

IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT 
    sd.sls_ord_num AS order_number,
    pr.product_key,
    cu.customer_key,
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt AS shipping_date,
    sd.sls_due_dt AS due_date,
    sd.sls_sales AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_product pr
ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
ON sd.sls_cust_id = cu.customer_id;

-- Check the data model connectivity between fact and dimensions

SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
WHERE c.customer_key IS NULL OR p.product_key IS NULL;
