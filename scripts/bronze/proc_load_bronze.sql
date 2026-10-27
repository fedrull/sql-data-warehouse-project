
-- =====================================================
-- Bronze Layer: Data Loading Procedure
-- =====================================================
-- Loads CRM and ERP data from CSV files into Bronze.
-- Truncates existing tables before loading fresh data.
-- Tracks individual table and total batch durations.
-- Includes logging and error handling.
-- =====================================================

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
        @start_time DATETIME,
        @end_time DATETIME,
        @batch_start_time DATETIME,
        @batch_end_time DATETIME;

    BEGIN TRY

        SET @batch_start_time = GETDATE();

        PRINT '=========================================';
        PRINT 'Loading Bronze Layer';
        PRINT '=========================================';

        PRINT '-----------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '-----------------------------------------';

        -- =============================================
        -- CRM Customer Information
        -- =============================================

        SET @start_time = GETDATE();

        PRINT '>> TRUNCATING Table: Bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;

        PRINT '>> Inserting Data Into: Bronze.crm_cust_info';
        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\Felix\Desktop\sql-data-warehouse-project\01_datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: ' +
              CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20)) +
              ' seconds';
        PRINT '-----------------------------------------';

        -- =============================================
        -- CRM Product Information
        -- =============================================

        SET @start_time = GETDATE();

        PRINT '>> TRUNCATING Table: Bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT '>> Inserting Data Into: Bronze.crm_prd_info';
        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\Felix\Desktop\sql-data-warehouse-project\01_datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: ' +
              CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20)) +
              ' seconds';
        PRINT '-----------------------------------------';

        -- =============================================
        -- CRM Sales Details
        -- =============================================

        SET @start_time = GETDATE();

        PRINT '>> TRUNCATING Table: Bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;

        PRINT '>> Inserting Data Into: Bronze.crm_sales_details';
        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\Felix\Desktop\sql-data-warehouse-project\01_datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: ' +
              CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20)) +
              ' seconds';
        PRINT '-----------------------------------------';

        -- =============================================
        -- ERP Tables
        -- =============================================

        PRINT '-----------------------------------------';
        PRINT 'Loading ERP Tables';
        PRINT '-----------------------------------------';

        -- =============================================
        -- ERP Customer Information
        -- =============================================

        SET @start_time = GETDATE();

        PRINT '>> TRUNCATING Table: Bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;

        PRINT '>> Inserting Data Into: Bronze.erp_cust_az12';
        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\Users\Felix\Desktop\sql-data-warehouse-project\01_datasets\source_erp\CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: ' +
              CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20)) +
              ' seconds';
        PRINT '-----------------------------------------';

        -- =============================================
        -- ERP Location Information
        -- =============================================

        SET @start_time = GETDATE();

        PRINT '>> TRUNCATING Table: Bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;

        PRINT '>> Inserting Data Into: Bronze.erp_loc_a101';
        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\Users\Felix\Desktop\sql-data-warehouse-project\01_datasets\source_erp\LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: ' +
              CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20)) +
              ' seconds';
        PRINT '-----------------------------------------';

        -- =============================================
        -- ERP Product Categories
        -- =============================================

        SET @start_time = GETDATE();

        PRINT '>> TRUNCATING Table: Bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        PRINT '>> Inserting Data Into: Bronze.erp_px_cat_g1v2';
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\Users\Felix\Desktop\sql-data-warehouse-project\01_datasets\source_erp\PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: ' +
              CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20)) +
              ' seconds';
        PRINT '-----------------------------------------';

        -- =============================================
        -- Total Batch Duration
        -- =============================================

        SET @batch_end_time = GETDATE();

        PRINT '=========================================';
        PRINT 'Bronze Layer Loading Completed Successfully';
        PRINT '>> Total Batch Duration: ' +
              CAST(
                  DATEDIFF(SECOND, @batch_start_time, @batch_end_time)
                  AS NVARCHAR(20)
              ) + ' seconds';
        PRINT '=========================================';

    END TRY

    BEGIN CATCH

        PRINT '=========================================';
        PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' +
              CAST(ERROR_NUMBER() AS NVARCHAR(20));
        PRINT 'Error State: ' +
              CAST(ERROR_STATE() AS NVARCHAR(20));
        PRINT '=========================================';

        THROW;

    END CATCH
END;
GO

-- Execute the Bronze loading procedure
EXEC bronze.load_bronze;
GO
