/*
===============================================================================
Transformation Validation: Bronze → Silver ETL
===============================================================================
Script Purpose:
    This script validates that ETL transformations correctly handle data quality
    issues when moving data from Bronze to Silver layer. It compares:
    - Before transformation (Bronze issues)
    - After transformation (Silver issues)
    - Transformation effectiveness

Usage Notes:
    - Run this after both Bronze and Silver layers are loaded
    - Helps measure ETL success rate and identify transformation gaps
    - Use results to improve ETL logic if needed
===============================================================================
*/

USE DataWarehouse;
GO

-- =====================================================================
-- Date Transformation Validation
-- =====================================================================

PRINT '=== Date Transformation Validation ===';
PRINT '';

-- Invalid dates in Bronze (INT format issues)
SELECT 
    'Bronze: Invalid date formats' AS check_type,
    COUNT(*) AS issue_count
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 
   OR LEN(sls_order_dt) != 8 
   OR sls_order_dt > 20500101 
   OR sls_order_dt < 19000101;

-- NULL dates in Silver (after transformation)
SELECT 
    'Silver: NULL dates (transformed from invalid)' AS check_type,
    COUNT(*) AS issue_count
FROM silver.crm_sales_details
WHERE sls_order_dt IS NULL 
   OR sls_ship_dt IS NULL 
   OR sls_due_dt IS NULL;

-- =====================================================================
-- Sales Calculation Validation
-- =====================================================================

PRINT '';
PRINT '=== Sales Calculation Validation ===';
PRINT '';

-- Incorrect sales calculations in Bronze
SELECT 
    'Bronze: Incorrect sales calculations' AS check_type,
    COUNT(*) AS issue_count
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL 
   OR sls_sales <= 0;

-- Remaining issues in Silver (should be fixed by ETL)
SELECT 
    'Silver: Remaining calculation issues' AS check_type,
    COUNT(*) AS issue_count
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL 
   OR sls_sales <= 0;

-- =====================================================================
-- Data Standardization Validation
-- =====================================================================

PRINT '';
PRINT '=== Data Standardization Validation ===';
PRINT '';

-- Unstandardized gender values in Bronze
SELECT 
    'Bronze: Unique gender values' AS check_type,
    COUNT(DISTINCT cst_gndr) AS value_count
FROM bronze.crm_cust_info;

-- Standardized gender values in Silver (should be: Male, Female, n/a)
SELECT 
    'Silver: Standardized gender values' AS check_type,
    COUNT(DISTINCT cst_gndr) AS value_count
FROM silver.crm_cust_info;

-- =====================================================================
-- Duplicate Handling Validation
-- =====================================================================

PRINT '';
PRINT '=== Duplicate Handling Validation ===';
PRINT '';

-- Duplicate customers in Bronze
SELECT 
    'Bronze: Duplicate customer records' AS check_type,
    COUNT(*) AS duplicate_count
FROM (
    SELECT cst_id, COUNT(*) AS cnt
    FROM bronze.crm_cust_info
    GROUP BY cst_id
    HAVING COUNT(*) > 1
) duplicates;

-- Should be deduplicated in Silver (most recent record kept)
SELECT 
    'Silver: Duplicate customer records' AS check_type,
    COUNT(*) AS duplicate_count
FROM (
    SELECT cst_id, COUNT(*) AS cnt
    FROM silver.crm_cust_info
    GROUP BY cst_id
    HAVING COUNT(*) > 1
) duplicates;

-- =====================================================================
-- Summary Report
-- =====================================================================

PRINT '';
PRINT '=== Transformation Summary ===';
PRINT '';

SELECT 
    'Total Bronze records' AS metric,
    COUNT(*) AS value
FROM bronze.crm_sales_details
UNION ALL
SELECT 
    'Total Silver records',
    COUNT(*)
FROM silver.crm_sales_details
UNION ALL
SELECT 
    'Records with issues in Bronze',
    COUNT(*)
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 
   OR sls_sales IS NULL
   OR sls_sales != sls_quantity * sls_price
UNION ALL
SELECT 
    'Records with issues in Silver',
    COUNT(*)
FROM silver.crm_sales_details
WHERE sls_order_dt IS NULL 
   OR sls_sales IS NULL
   OR sls_sales != sls_quantity * sls_price;