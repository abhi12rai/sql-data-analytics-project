-- Database Exploration

-- Explore ALL Objects in the Database

SELECT * FROM INFORMATION_SCHEMA.TABLES;

-- Explore ALL Columns in the Database

SELECT * FROM INFORMATION_SCHEMA.COLUMNS;

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';

