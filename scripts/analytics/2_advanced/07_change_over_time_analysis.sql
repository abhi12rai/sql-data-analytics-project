-- Change Over Time Analysis

-- Analyse sales performance over time

SELECT * FROM gold.fact_sales;
GO 
--
SELECT 
    order_date, sales_amount 
FROM gold.fact_sales 
ORDER BY order_date;

-- Quick Date Functions
SELECT 
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month, --Change over month
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    COUNT(quantity) AS total_quantity
FROM gold.fact_sales
WHERE YEAR(order_date) IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);

-- DATETRUNC
SELECT 
    DATETRUNC(MONTH, order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    COUNT(quantity) AS total_quantity
FROM gold.fact_sales
WHERE YEAR(order_date) IS NOT NULL
GROUP BY DATETRUNC(MONTH, order_date) 
ORDER BY DATETRUNC(MONTH, order_date);