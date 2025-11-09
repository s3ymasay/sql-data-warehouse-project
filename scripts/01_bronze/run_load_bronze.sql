/*
===============================================================================
Execute Script: Load Bronze Layer
===============================================================================
Script Purpose:
    Executes the bronze.load_bronze stored procedure to load data from CSV files
    into bronze tables, then displays row counts for quick verification.

Prerequisites:
    - Database 'DataWarehouse' must exist
    - Bronze schema and tables must be created (run ddl_bronze.sql first)
    - Stored procedure bronze.load_bronze must exist (run proc_load_bronze.sql first)
    - CSV files must be accessible at the specified paths

Usage:
    Run this script whenever you need to refresh bronze layer data
===============================================================================
*/

USE DataWarehouse;
GO

-- Execute the bronze load procedure
EXEC bronze.load_bronze;
GO

-- Quick verification: Display row counts
SELECT 'crm_cust_info' AS [Table], COUNT(*) AS [Rows] FROM bronze.crm_cust_info
UNION ALL SELECT 'crm_prd_info', COUNT(*) FROM bronze.crm_prd_info
UNION ALL SELECT 'crm_sales_details', COUNT(*) FROM bronze.crm_sales_details
UNION ALL SELECT 'erp_loc_a101', COUNT(*) FROM bronze.erp_loc_a101
UNION ALL SELECT 'erp_cust_az12', COUNT(*) FROM bronze.erp_cust_az12
UNION ALL SELECT 'erp_px_cat_g1v2', COUNT(*) FROM bronze.erp_px_cat_g1v2;
GO
