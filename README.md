# SQL Data Warehouse Project

A data warehousing solution implementing Medallion Architecture (Bronze → Silver → Gold) with comprehensive ETL pipelines, data quality checks, and analytical queries.

Built with Microsoft SQL Server and T-SQL, focusing on data engineering best practices and dimensional modeling.

---

## Architecture

**Medallion Architecture** with three layers:

- **Bronze**: Raw data from source systems (CRM + ERP)
  - No transformations
  - Preserves original formats
  
- **Silver**: Cleansed and standardized data
  - Data type conversions
  - Deduplication
  - Business rules applied
  
- **Gold**: Analytical data model (Star Schema)
  - `dim_customers` - Customer dimension
  - `dim_products` - Product dimension  
  - `fact_sales` - Sales fact table

---

## Project Structure

```
sql-data-warehouse-project/
├── README.md
├── .gitignore
│
├── datasets/                           # Source data files
│   ├── source_crm/                     # CRM system exports
│   │   ├── cust_info.csv              # Customer information
│   │   ├── prd_info.csv               # Product information
│   │   └── sales_details.csv          # Sales transactions
│   └── source_erp/                     # ERP system exports
│       ├── CUST_AZ12.csv              # Customer demographics
│       ├── LOC_A101.csv               # Location data
│       └── PX_CAT_G1V2.csv            # Product categories
│
├── docs/                               # Documentation and diagrams
│   ├── data_architecture.png          # Medallion layers diagram
│   ├── star_schema.png                # Star schema diagram
│   └── data_flow.png                  # Data flow diagram
│
└── scripts/                            # SQL scripts
    ├── 00_init/                       # Database initialization
    │   └── init_database.sql          # Create database and schemas
    │
    ├── 01_bronze/                     # Bronze layer (raw data)
    │   ├── ddl_bronze.sql             # Create bronze tables
    │   ├── proc_load_bronze.sql       # Data loading procedure
    │   └── run_load_bronze.sql        # Execute and verify
    │
    ├── 02_silver/                     # Silver layer (cleansed data)
    │   ├── ddl_silver.sql             # Create silver tables
    │   ├── proc_load_silver.sql       # ETL procedure
    │   └── run_load_silver.sql        # Execute and verify
    │
    ├── 03_gold/                       # Gold layer (star schema)
    │   ├── ddl_gold.sql               # Create gold views
    │   └── run_gold.sql               # Verification and analytics
    │
    └── 04_quality_checks/             # Data quality validation
        ├── quality_checks_bronze.sql  # Bronze layer validation
        ├── quality_checks_silver.sql  # Silver layer validation
        ├── quality_checks_gold.sql    # Gold layer validation
        └── transformation_validation.sql  # ETL effectiveness check
```

---

## Technologies Used

- **Database**: Microsoft SQL Server
- **Language**: T-SQL
- **Architecture**: Medallion (Bronze/Silver/Gold)
- **Data Modeling**: Star Schema (Kimball methodology)
- **Tools**: SQL Server Management Studio (SSMS)

---

## Getting Started

### Prerequisites

- Microsoft SQL Server (2016 or later)
- SQL Server Management Studio (SSMS)

### Setup

**Step 1: Configure Data Path**

Update the file path in `scripts/01_bronze/proc_load_bronze.sql`:

- Default path: `C:\DataWarehouse\datasets\`
- Use Find & Replace to update to your path
- Or copy datasets to the default location

**Step 2: Run Scripts in Order**

Execute the following scripts in SQL Server Management Studio:

1. **Initialize database:**
   ```sql
   scripts/00_init/init_database.sql
   ```

2. **Create and load Bronze layer:**
   ```sql
   scripts/01_bronze/ddl_bronze.sql
   scripts/01_bronze/proc_load_bronze.sql
   scripts/01_bronze/run_load_bronze.sql
   ```

3. **Create and load Silver layer:**
   ```sql
   scripts/02_silver/ddl_silver.sql
   scripts/02_silver/proc_load_silver.sql
   scripts/02_silver/run_load_silver.sql
   ```

4. **Create Gold layer:**
   ```sql
   scripts/03_gold/ddl_gold.sql
   scripts/03_gold/run_gold.sql
   ```

5. **Run quality checks (optional):**
   ```sql
   scripts/04_quality_checks/quality_checks_bronze.sql
   scripts/04_quality_checks/quality_checks_silver.sql
   scripts/04_quality_checks/quality_checks_gold.sql
   scripts/04_quality_checks/transformation_validation.sql
   ```

---

## Features

- **Medallion Architecture**: Bronze, Silver, and Gold layers for data quality and transformation
- **ETL Pipelines**: Automated stored procedures for data loading and transformation
- **Star Schema**: Dimensional modeling with fact and dimension tables
- **Data Quality Checks**: Comprehensive validation at each layer
- **Transformation Validation**: Before/after ETL comparison and effectiveness tracking
- **Deduplication**: Automatic handling of duplicate records
- **Data Standardization**: Consistent formatting and business rules
- **Sample Analytics**: Pre-built queries for common business questions

---

## Acknowledgments

This project was inspired by the SQL Data Warehouse course by Baraa Khatib Salkini. The implementation has been significantly modified and enhanced with additional quality checks, validation scripts, and standardized documentation.
