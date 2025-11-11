/*
===============================================================================
Quality Checks: Bronze Layer
===============================================================================
Script Purpose:
    This script performs quality checks on raw data loaded into the bronze layer.
    These checks help identify data quality issues at the source before 
    transformation, including:
    - Missing or invalid data
    - Format inconsistencies
    - Duplicate records
    - Out-of-range values

Usage Notes:
    - Run these checks after loading Bronze Layer
    - Issues found here should be investigated at the source system
    - Critical issues may require data re-extraction
===============================================================================
*/

USE DataWarehouse;
GO

-- =====================================================================
-- Checking 'bronze.crm_cust_info'
-- =====================================================================

-- Check for NULL Customer IDs
-- Expectation: No Results
SELECT 
    *
FROM bronze.crm_cust_info
WHERE cst_id IS NULL;

-- Check for Duplicate Customer Records
SELECT 
    cst_id,
    COUNT(*) AS duplicate_count
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1;

-- Check for Missing Required Fields
-- Expectation: No Results
SELECT 
    *
FROM bronze.crm_cust_info
WHERE cst_key IS NULL 
   OR cst_firstname IS NULL 
   OR cst_lastname IS NULL;

-- =====================================================================
-- Checking 'bronze.crm_prd_info'
-- =====================================================================

-- Check for NULL Product IDs
-- Expectation: No Results
SELECT 
    *
FROM bronze.crm_prd_info
WHERE prd_id IS NULL OR prd_key IS NULL;

-- Check for Negative or Zero Costs
SELECT 
    *
FROM bronze.crm_prd_info
WHERE prd_cost <= 0;

-- =====================================================================
-- Checking 'bronze.crm_sales_details'
-- =====================================================================

-- Check for Invalid Date Formats (INT dates should be YYYYMMDD)
-- Expectation: All dates should be 8 digits in valid range
SELECT 
    sls_ord_num,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt
FROM bronze.crm_sales_details
WHERE LEN(sls_order_dt) != 8 
   OR LEN(sls_ship_dt) != 8 
   OR LEN(sls_due_dt) != 8
   OR sls_order_dt < 19000101 
   OR sls_order_dt > 20500101
   OR sls_ship_dt < 19000101 
   OR sls_ship_dt > 20500101
   OR sls_due_dt < 19000101 
   OR sls_due_dt > 20500101;

-- Check for NULL or Zero Values in Sales Metrics
-- Expectation: No Results
SELECT 
    *
FROM bronze.crm_sales_details
WHERE sls_sales IS NULL 
   OR sls_quantity IS NULL 
   OR sls_price IS NULL
   OR sls_sales = 0 
   OR sls_quantity = 0;

-- Check for Missing Foreign Keys
-- Expectation: No Results
SELECT 
    *
FROM bronze.crm_sales_details
WHERE sls_prd_key IS NULL 
   OR sls_cust_id IS NULL;

-- =====================================================================
-- Checking 'bronze.erp_cust_az12'
-- =====================================================================

-- Check for NULL Customer IDs
-- Expectation: No Results
SELECT 
    *
FROM bronze.erp_cust_az12
WHERE cid IS NULL;

-- Check for Invalid or Future Birthdates
SELECT 
    *
FROM bronze.erp_cust_az12
WHERE bdate > GETDATE() 
   OR bdate < '1900-01-01';

-- =====================================================================
-- Checking 'bronze.erp_loc_a101'
-- =====================================================================

-- Check for Missing Location Data
-- Expectation: No Results
SELECT 
    *
FROM bronze.erp_loc_a101
WHERE cid IS NULL 
   OR cntry IS NULL 
   OR TRIM(cntry) = '';

-- =====================================================================
-- Checking 'bronze.erp_px_cat_g1v2'
-- =====================================================================

-- Check for Missing Category Data
-- Expectation: No Results
SELECT 
    *
FROM bronze.erp_px_cat_g1v2
WHERE id IS NULL 
   OR cat IS NULL 
   OR subcat IS NULL;