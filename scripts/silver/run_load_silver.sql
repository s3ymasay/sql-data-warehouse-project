/*
===============================================================================
Execute Script: Load Silver Layer
===============================================================================
Script Purpose:
    Executes the silver.load_silver stored procedure to load transformed and
    cleansed data from bronze tables into silver tables, then displays row counts
    for quick verification.

Prerequisites:
    - Database 'DataWarehouse' must exist
    - Silver schema and tables must be created (run ddl_silver.sql first)
    - Stored procedure silver.load_silver must exist (run proc_load_silver.sql first)
    - Bronze layer must be loaded with data

Usage:
    Run this script whenever you need to refresh silver layer data
===============================================================================
*/

USE DataWarehouse;
GO

-- Execute the silver load procedure
EXEC silver.load_silver;
GO

-- Quick verification: Display row counts
SELECT 'crm_cust_info' AS [Table], COUNT(*) AS [Rows] FROM silver.crm_cust_info
UNION ALL SELECT 'crm_prd_info', COUNT(*) FROM silver.crm_prd_info
UNION ALL SELECT 'crm_sales_details', COUNT(*) FROM silver.crm_sales_details
UNION ALL SELECT 'erp_loc_a101', COUNT(*) FROM silver.erp_loc_a101
UNION ALL SELECT 'erp_cust_az12', COUNT(*) FROM silver.erp_cust_az12
UNION ALL SELECT 'erp_px_cat_g1v2', COUNT(*) FROM silver.erp_px_cat_g1v2;
GO
