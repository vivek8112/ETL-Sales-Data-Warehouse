# Sales Data Warehouse & ETL Pipeline

## Project Overview
A hands-on ETL and data warehousing project built around SQL Server and SSIS.

**Source:** CSV files  
**ETL:** SQL Server Integration Services (SSIS)  
**Database:** SQL Server  
**Model:** Star Schema  
**Concepts:** Staging, transformations, Lookup, SCD Type 2, fact/dimension loading, validation and error handling.

## Architecture
CSV Sources → SSIS → Staging Tables → Transform/Validate → Dimensions + Fact → Reporting Queries

## Warehouse Tables
- `DimCustomer`
- `DimProduct`
- `DimDate`
- `FactSales`

## How to Run
1. Install SQL Server and SSMS.
2. Open `02_SQL_Scripts/01_Create_Database.sql` and execute it.
3. Create an SSIS project in Visual Studio.
4. Follow `03_SSIS_Design/SSIS_Package_Design.md` to create `Sales_ETL.dtsx`.
5. Point the Flat File Connection Managers to the three CSV files in `01_Source_Data`.
6. Run the package to load the staging tables.
7. Execute `02_Load_Dimensions_And_Fact.sql`.
8. Run `03_Validation_Queries.sql`.
9. Verify row counts, total sales, category sales and duplicate checks.

## Expected Result
The supplied data contains:
- 8 customers
- 6 products
- 16 sales transactions

The initial sales total is ₹278,950.

## Resume Project Title
**Sales Data Warehouse & ETL Pipeline | SQL Server, SSIS, T-SQL**

## Interview Topics to Learn
- What is ETL?
- Why use staging tables?
- Difference between fact and dimension tables
- Star schema
- Lookup transformation
- Data Conversion
- Conditional Split
- SCD Type 2
- Incremental load
- Error handling
- Full load vs incremental load
- Why use surrogate keys?
