# SSIS Package Design

## Package: `Sales_ETL.dtsx`

### Control Flow
1. Execute SQL Task - `Truncate Staging Tables`
2. Data Flow Task - `Load Customers`
3. Data Flow Task - `Load Products`
4. Data Flow Task - `Load Sales`
5. Execute SQL Task - `Load Dimensions and Fact`
6. Execute SQL Task - `Run Validation Queries` (optional)
7. Send Mail Task / logging step (optional)

### Data Flow: Customers
Flat File Source (Customers.csv)
→ Data Conversion (if required)
→ Derived Column / Conditional Split for basic validation
→ OLE DB Destination: `stg.Customers`

### Data Flow: Products
Flat File Source (Products.csv)
→ Data Conversion
→ Lookup (optional product validation)
→ OLE DB Destination: `stg.Products`

### Data Flow: Sales
Flat File Source (Sales.csv)
→ Data Conversion
→ Lookup: CustomerID → DimCustomer
→ Lookup: ProductID → DimProduct
→ Derived Column
→ Conditional Split (valid vs rejected rows)
→ OLE DB Destination: `stg.Sales`

### Recommended SSIS components
- Flat File Connection Manager
- OLE DB Connection Manager
- Execute SQL Task
- Data Flow Task
- Flat File Source
- Data Conversion
- Derived Column
- Conditional Split
- Lookup
- OLE DB Destination

### Error handling
Configure precedence constraints so the package stops when a critical task fails.
For rejected rows, use a Conditional Split and send invalid records to an error destination or log table.

## Important
The `.dtsx` package must be created in Visual Studio with the SSIS extension. This project supplies the source data, SQL warehouse, transformation design and exact package flow; create the package locally so you can explain every component in an interview.
