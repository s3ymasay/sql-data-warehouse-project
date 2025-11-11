/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. This stored procedure does not accept parameters.
    Path configuration is done via Find & Replace (see IMPORTANT section below).

IMPORTANT - Path Configuration:
    The data files are expected to be in: C:\DataWarehouse\datasets\
    
    If your files are in a different location, update the file paths below
    using Find & Replace:
        Find:    'C:\DataWarehouse\datasets\'
        Replace: 'YOUR_PATH_HERE\'
    
    Expected folder structure:
        C:\DataWarehouse\datasets\
        ├── source_crm\
        │   ├── cust_info.csv
        │   ├── prd_info.csv
        │   └── sales_details.csv
        └── source_erp\
            ├── CUST_AZ12.csv
            ├── LOC_A101.csv
            └── PX_CAT_G1V2.csv

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

USE DataWarehouse;  
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	 SET NOCOUNT ON;
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		
		PRINT 'Loading Bronze Layer';
		PRINT '';

			PRINT 'Loading CRM Tables';
		PRINT '------------------';

		SET @start_time = GETDATE();
		PRINT ' Truncating Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;
		PRINT ' Inserting Data Into: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\DataWarehouse\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT ' Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '';

        SET @start_time = GETDATE();
		PRINT ' Truncating Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT ' Inserting Data Into: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\DataWarehouse\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT ' Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '';

        SET @start_time = GETDATE();
		PRINT ' Truncating Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;
		PRINT ' Inserting Data Into: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\DataWarehouse\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT ' Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '';

		PRINT '';
		PRINT 'Loading ERP Tables';
		PRINT '------------------';
		
		SET @start_time = GETDATE();
		PRINT ' Truncating Table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;
		PRINT ' Inserting Data Into: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\DataWarehouse\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT ' Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT ' ';

		SET @start_time = GETDATE();
		PRINT ' Truncating Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;
		PRINT ' Inserting Data Into: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\DataWarehouse\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT ' Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT ' ';

		SET @start_time = GETDATE();
		PRINT ' Truncating Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		PRINT ' Inserting Data Into: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\DataWarehouse\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT ' Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT ' ';

		SET @batch_end_time = GETDATE();
		PRINT ''
		PRINT 'Loading Bronze Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT ''
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
        PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER'
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END
GO
