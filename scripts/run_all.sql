/*
===============================================================================
Master Execution Script - Complete Data Warehouse Setup
===============================================================================

HOW TO RUN THIS SCRIPT:

1. Open this file in SQL Server Management Studio (SSMS)

2. Enable SQLCMD Mode:
   - Go to: Query Menu → SQLCMD Mode
   - Or press: Ctrl + Shift + M
   - You'll see "SQLCMD" indicator in the status bar

3. Execute the script (F5 or click Execute)

4. Wait for completion (approximately 2-3 minutes)

IMPORTANT:
- This script will DROP and recreate the DataWarehouse database
- All existing data will be lost
- Ensure CSV files are accessible at: C:\DataWarehouse\datasets\
  (or update path in: 01_bronze/proc_load_bronze.sql)

===============================================================================
*/

USE master;
GO

PRINT '=========================================='
PRINT 'Data Warehouse Setup - Master Script'
PRINT '=========================================='
PRINT ''

-- =====================================================================
-- STEP 1: Initialize Database
-- =====================================================================
PRINT 'STEP 1: Initializing Database...'
PRINT ''

:r 00_init\init_database.sql

PRINT '✓ Database initialized'
PRINT ''
GO

-- =====================================================================
-- STEP 2: Create Bronze Layer
-- =====================================================================
PRINT '=========================================='
PRINT 'STEP 2: Creating Bronze Layer...'
PRINT '=========================================='
PRINT ''

:r 01_bronze\ddl_bronze.sql

PRINT '✓ Bronze tables created'
PRINT ''
GO

-- =====================================================================
-- STEP 3: Load Bronze Layer
-- =====================================================================
PRINT 'STEP 3: Loading Bronze Layer...'
PRINT ''

:r 01_bronze\proc_load_bronze.sql

PRINT '✓ Bronze load procedure created'
PRINT ''
GO

:r 01_bronze\run_load_bronze.sql

PRINT '✓ Bronze data loaded'
PRINT ''
GO

-- =====================================================================
-- STEP 4: Create Silver Layer
-- =====================================================================
PRINT '=========================================='
PRINT 'STEP 4: Creating Silver Layer...'
PRINT '=========================================='
PRINT ''

:r 02_silver\ddl_silver.sql

PRINT '✓ Silver tables created'
PRINT ''
GO

-- =====================================================================
-- STEP 5: Load Silver Layer (ETL)
-- =====================================================================
PRINT 'STEP 5: Loading Silver Layer (ETL)...'
PRINT ''

:r 02_silver\proc_load_silver.sql

PRINT '✓ Silver load procedure created'
PRINT ''
GO

:r 02_silver\run_load_silver.sql

PRINT '✓ Silver data loaded'
PRINT ''
GO

-- =====================================================================
-- STEP 6: Create Gold Layer
-- =====================================================================
PRINT '=========================================='
PRINT 'STEP 6: Creating Gold Layer (Star Schema)...'
PRINT '=========================================='
PRINT ''

:r 03_gold\ddl_gold.sql

PRINT '✓ Gold views created'
PRINT ''
GO

-- =====================================================================
-- STEP 7: Verify Gold Layer
-- =====================================================================
PRINT 'STEP 7: Verifying Gold Layer...'
PRINT ''

:r 03_gold\run_gold.sql

PRINT '✓ Gold layer verified'
PRINT ''
GO

-- =====================================================================
-- STEP 8: Quality Checks (Optional)
-- =====================================================================
PRINT '=========================================='
PRINT 'STEP 8: Running Quality Checks...'
PRINT '=========================================='
PRINT ''

PRINT 'Bronze quality checks...'
:r 04_quality_checks\quality_checks_bronze.sql
PRINT ''

PRINT 'Silver quality checks...'
:r 04_quality_checks\quality_checks_silver.sql
PRINT ''

PRINT 'Gold quality checks...'
:r 04_quality_checks\quality_checks_gold.sql
PRINT ''

PRINT 'Transformation validation...'
:r 04_quality_checks\transformation_validation.sql
PRINT ''

PRINT '✓ Quality checks completed'
PRINT ''
GO

-- =====================================================================
-- COMPLETION
-- =====================================================================
PRINT ''
PRINT '=========================================='
PRINT '🎉 DATA WAREHOUSE SETUP COMPLETE! 🎉'
PRINT '=========================================='
PRINT ''
PRINT 'Summary:'
PRINT '--------'
PRINT '✓ Database initialized'
PRINT '✓ Bronze layer created and loaded'
PRINT '✓ Silver layer created and loaded (ETL)'
PRINT '✓ Gold layer created (Star Schema)'
PRINT '✓ Quality checks executed'
PRINT ''
PRINT 'Gold Layer Views:'
PRINT '- gold.dim_customers'
PRINT '- gold.dim_products'
PRINT '- gold.fact_sales'
PRINT ''
PRINT 'Ready for analytics and reporting!'
PRINT '=========================================='
GO
