-- Dimension Exploration

SELECT *
FROM gold.dim_customers;

-- Explore All Countries our Customers come from.
SELECT DISTINCT 
    country 
FROM gold.dim_customers
ORDER BY country;

-- Explore All Categories "The Major Divisions"
SELECT DISTINCT 
    category,               -- 4
    subcategory,            -- 36 
    product_name            -- 295
FROM gold.dim_products
ORDER BY 1, 2, 3; -- Exclude NULL