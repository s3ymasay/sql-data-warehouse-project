# sql-data-warehouse-project

This project demonstrates a comprehensive data warehousing and analytics solution, from building a data warehouse to generating actionable insights. Designed as a portfolio project, it highlights industry best practices in data engineering and analytics.

## Data Architecture
The data architecture follows the Medallion Architecture with Bronze, Silver, and Gold layers:

1. **Bronze Layer**: Stores raw data as-is from source systems. Data is ingested from CSV files into SQL Server Database.
2. **Silver Layer**: Includes data cleansing, standardization, and normalization processes.
3. **Gold Layer**: Houses business-ready data modeled into a star schema for reporting and analytics.

## Project Overview
This project involves:

1-Data Architecture: Designing a Modern Data Warehouse Using Medallion Architecture Bronze, Silver, and Gold layers.
2-ETL Pipelines: Extracting, transforming, and loading data from source systems into the warehouse.
3-Data Modeling: Developing fact and dimension tables optimized for analytical queries.
4-Analytics & Reporting: Creating SQL-based reports and dashboards for actionable insights.

## Repository Structure
```
data-warehouse-project/
│
├── datasets/                           # Raw datasets used for the project (ERP and CRM data)
│
├── docs/                               # Project documentation and architecture details
│   ├── etl.drawio                      # Draw.io file shows all different techniquies and methods of ETL
│   ├── data_architecture.drawio        # Draw.io file shows the project's architecture
│   ├── data_catalog.md                 # Catalog of datasets, including field descriptions and metadata
│   ├── data_flow.drawio                # Draw.io file for the data flow diagram
│   ├── data_models.drawio              # Draw.io file for data models (star schema)
│   ├── naming-conventions.md           # Consistent naming guidelines for tables, columns, and files
│
├── scripts/                            # SQL scripts for ETL and transformations
│   ├── bronze/                         # Scripts for extracting and loading raw data
│   ├── silver/                         # Scripts for cleaning and transforming data
│   ├── gold/                           # Scripts for creating analytical models
│
├── tests/                              # Test scripts and quality files
│
├── README.md                           # Project overview and instructions
├── LICENSE                             # License information for the repository
├── .gitignore                          # Files and directories to be ignored by Git
└── requirements.txt                    # Dependencies and requirements for the project
```

## Technologies Used
- SQL Server
- T-SQL
- Draw.io (for documentation)
- Medallion Architecture

## Acknowledgments
This project was developed as part of a SQL course by Baraa Khatib Salkini, applying the concepts and best practices learned throughout the training.
