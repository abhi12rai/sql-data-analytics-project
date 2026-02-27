-- Performance Analysis (Year-over-Year, Month-over-Month)
/*
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.
===============================================================================

Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */


SELECT * FROM gold.fact_sales;
GO

SELECT 
    YEAR(f.order_date) AS order_year,
    p.product_name,        -- product_name = product_number = product_key (dim_products is dimesnion table)
    SUM(f.sales_amount) AS sales_amount,
    AVG(f.sales_amount) AS avg_amount
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY p.product_name, YEAR(f.order_date)
ORDER BY 1, 2
--============

WITH yearly_product_sales AS (
SELECT 
    YEAR(f.order_date) AS order_year,
    p.product_name, 
    SUM(f.sales_amount) AS current_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY p.product_name, YEAR(f.order_date)
)
SELECT 
    *,
    AVG(current_sales) OVER(PARTITION BY product_name) AS avg_sales,
    current_sales - AVG(current_sales) OVER(PARTITION BY product_name) AS diff_avg,
    CASE WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above Avg'
         WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN'Below Avg'
         ELSE 'Avg'
    END AS avg_change,
--  YoY Change
    LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS py_sales,
    current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS diff_py,
    CASE WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
         WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
         ELSE 'No Change'
    END AS py_change
FROM yearly_product_sales
ORDER BY product_name, order_year;