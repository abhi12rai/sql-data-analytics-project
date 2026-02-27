-- Measure Exploration

-- Find the Total Sales
SELECT SUM(sales_amount) AS total_sales FROM gold.fact_sales;

-- Find how many items are sold

SELECT * FROM gold.fact_sales;

SELECT 
    SUM(quantity) AS total_quantity
FROM gold.fact_sales;

-- Find the average selling price
SELECT AVG(price) AS avg_price FROM gold.fact_sales

-- Find the Total number of Orders
SELECT * FROM gold.fact_sales;

SELECT COUNT(order_number) AS total_orders FROM gold.fact_sales; -- 60398

SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales; -- 27659

--====================================================================================
SELECT order_number, COUNT(*) AS CNT
FROM (
SELECT * FROM gold.fact_sales
) t 
GROUP BY order_number
HAVING COUNT(*) > 1
ORDER BY order_number; --17991

SELECT order_number, customer_key, COUNT(*) AS CNT
FROM (
SELECT * FROM gold.fact_sales
) t 
GROUP BY order_number, customer_key
HAVING COUNT(*) > 1     --17991
ORDER BY 1, 2; -- It means one customer generate unique order_number, 
               -- if he order 4 times then same 4 order_number generated,
--====================================================================================

-- Find the total number of products
SELECT * FROM gold.dim_products;

SELECT COUNT(product_name) AS total_products FROM gold.dim_products;
SELECT COUNT(DISTINCT product_name) AS total_products FROM gold.dim_products;

-- Find the total number of customers
SELECT * FROM gold.dim_customers;

SELECT COUNT(customer_id) AS total_customers FROM gold.dim_customers; -- 18484


-- Find the total number of customers that has placed an order
SELECT * FROM gold.fact_sales;

SELECT COUNT(DISTINCT customer_key) FROM gold.fact_sales; -- 18484, All customers placed an order

-- Generate a Report that shows all key metrics of the business

SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Products', COUNT(DISTINCT product_name) FROM gold.dim_products
UNION ALL
SELECT 'Total Customers', COUNT(customer_key) FROM gold.dim_customers;