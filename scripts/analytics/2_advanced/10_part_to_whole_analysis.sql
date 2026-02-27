-- Part-to-Whole Analysis

/*
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.
*/

-- Which categories contribute the most to overall sales?

SELECT 
    p.category,
    SUM(f.sales_amount) AS total_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY p.category
ORDER BY total_sales DESC;

--


WITH category_sales AS (
SELECT 
    p.category,
    SUM(f.sales_amount) AS total_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY p.category
)
SELECT 
    category,
    total_sales,
    SUM(total_sales) OVER() AS overall_sales,
    CONCAT(ROUND((CAST(total_sales AS float) / SUM(total_sales) OVER()) * 100, 2), '%') AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;