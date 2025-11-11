/*
===============================================================================
Execute Script: Verify Gold Layer
===============================================================================
Script Purpose:
    This script verifies that the Gold layer views are created successfully
    and displays sample data and basic analytics for quick validation.

Prerequisites:
    - Database 'DataWarehouse' must exist
    - Gold views must be created (run ddl_gold.sql first)
    - Silver and Bronze layers must be loaded with data

Usage:
    Run this script to verify Gold layer after creating views
===============================================================================
*/

USE DataWarehouse;
GO

PRINT '=========================================='
PRINT 'Gold Layer Verification'
PRINT '=========================================='
PRINT ''

-- =====================================================================
-- Row Counts
-- =====================================================================

PRINT 'Row Counts:'
PRINT '----------'

SELECT 'dim_customers' AS [View], COUNT(*) AS [Rows] FROM gold.dim_customers
UNION ALL SELECT 'dim_products', COUNT(*) FROM gold.dim_products
UNION ALL SELECT 'fact_sales', COUNT(*) FROM gold.fact_sales;

PRINT ''

-- =====================================================================
-- Sample Data from Dimensions
-- =====================================================================

PRINT 'Sample Customers (Top 5):'
PRINT '-------------------------'
SELECT TOP 5 
    customer_key,
    customer_id,
    first_name,
    last_name,
    country,
    marital_status,
    gender
FROM gold.dim_customers
ORDER BY customer_key;

PRINT ''
PRINT 'Sample Products (Top 5):'
PRINT '------------------------'
SELECT TOP 5 
    product_key,
    product_id,
    product_name,
    category,
    subcategory,
    product_line,
    cost
FROM gold.dim_products
ORDER BY product_key;

PRINT ''
PRINT 'Sample Sales (Top 5):'
PRINT '---------------------'
SELECT TOP 5 
    order_number,
    product_key,
    customer_key,
    order_date,
    sales_amount,
    quantity,
    price
FROM gold.fact_sales
ORDER BY order_date DESC;

PRINT ''

-- =====================================================================
-- Basic Analytical Queries
-- =====================================================================

PRINT '=========================================='
PRINT 'Basic Analytics'
PRINT '=========================================='
PRINT ''

-- Total Sales Summary
PRINT 'Total Sales Summary:'
PRINT '-------------------'
SELECT 
    COUNT(DISTINCT order_number) AS total_orders,
    COUNT(*) AS total_line_items,
    SUM(sales_amount) AS total_sales,
    AVG(sales_amount) AS avg_sale_amount,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales;

PRINT ''

-- Sales by Product Category
PRINT 'Sales by Product Category:'
PRINT '-------------------------'
SELECT 
    p.category,
    COUNT(DISTINCT f.order_number) AS order_count,
    SUM(f.sales_amount) AS total_sales,
    AVG(f.sales_amount) AS avg_sale_amount
FROM gold.fact_sales f
INNER JOIN gold.dim_products p ON f.product_key = p.product_key
GROUP BY p.category
ORDER BY total_sales DESC;

PRINT ''

-- Top 10 Customers by Sales
PRINT 'Top 10 Customers by Sales:'
PRINT '-------------------------'
SELECT TOP 10
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    c.country,
    COUNT(DISTINCT f.order_number) AS order_count,
    SUM(f.sales_amount) AS total_sales
FROM gold.fact_sales f
INNER JOIN gold.dim_customers c ON f.customer_key = c.customer_key
GROUP BY c.customer_id, c.first_name, c.last_name, c.country
ORDER BY total_sales DESC;

PRINT ''

-- Sales by Country
PRINT 'Sales by Country:'
PRINT '----------------'
SELECT 
    c.country,
    COUNT(DISTINCT c.customer_id) AS customer_count,
    COUNT(DISTINCT f.order_number) AS order_count,
    SUM(f.sales_amount) AS total_sales
FROM gold.fact_sales f
INNER JOIN gold.dim_customers c ON f.customer_key = c.customer_key
GROUP BY c.country
ORDER BY total_sales DESC;

PRINT ''

-- Monthly Sales Trend (All Data)
SELECT 
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    COUNT(DISTINCT order_number) AS order_count,
    SUM(sales_amount) AS total_sales,
    AVG(sales_amount) AS avg_sale
FROM gold.fact_sales
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY year DESC, month DESC;

PRINT ''
PRINT '=========================================='
PRINT 'Gold Layer Verification Complete!'
PRINT '=========================================='
GO
