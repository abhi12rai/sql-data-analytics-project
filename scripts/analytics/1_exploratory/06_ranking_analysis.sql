-- Ranking Analysis

-- Which 5 products Generating the Highest Revenue?
-- Simple Ranking
SELECT TOP 5
    p.product_name,               -- can be used to get other measures like for cat, subcat .....
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;

-- Complex but Flexibly Ranking Using Window Functions
SELECT * 
FROM(
SELECT
    p.product_name,              
    SUM(f.sales_amount) AS total_revenue,
    ROW_NUMBER() OVER (ORDER BY SUM(f.sales_amount) DESC) AS product_rank
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON f.product_key = p.product_key
GROUP BY p.product_name) t
WHERE product_rank <= 5; 

-- What are the 5 worst-performing products in terms of sales?
SELECT TOP 5
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue;

-- Find the top 10 customers who have generated the highest revenue
SELECT TOP 10
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC;

-- The 3 customers with the fewest orders placed
/*
    Analytic logic:
    order_number = The Receipt (Header)
    product_id   = The Item (Line detail)
*/

-- 1. Counting ROWS (Items)
SELECT TOP 3
    c.customer_key,
    c.first_name,
    c.last_name,
    COUNT(f.order_number) AS total_items --If Question is "Which customer bought the fewest total items?"
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_items;  -- 17434, 609, 11803

-- 2. Counting UNIQUE Receipts (Orders)
--    This is the business "visit"
SELECT TOP 3
    c.customer_key,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT f.order_number) AS total_orders -- Which customer visited us the fewest times?
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_orders;  -- 16, 17, 21 
-- In a dataset where thousands of customers have only placed 1 order, 
-- TOP 3 will just grab the first three it finds.

SELECT * FROM gold.fact_sales
WHERE customer_key IN (16, 17, 21, 17434, 609, 11803);