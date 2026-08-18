/* 02_Load_Dimensions_And_Fact.sql
Run after SSIS has loaded the staging tables.
*/
USE ETL_SalesDW;
GO

-- SCD Type 2 example for customers
UPDATE d
SET ExpiryDate = DATEADD(DAY,-1,CAST(GETDATE() AS DATE)),
    IsCurrent = 0
FROM dbo.DimCustomer d
JOIN stg.Customers s ON s.CustomerID=d.CustomerID
WHERE d.IsCurrent=1
  AND (ISNULL(d.CustomerName,'')<>ISNULL(s.CustomerName,'')
    OR ISNULL(d.Email,'')<>ISNULL(s.Email,'')
    OR ISNULL(d.City,'')<>ISNULL(s.City,'')
    OR ISNULL(d.State,'')<>ISNULL(s.State,'')); 

INSERT INTO dbo.DimCustomer(CustomerID,CustomerName,Email,City,State,EffectiveDate,IsCurrent)
SELECT s.CustomerID,s.CustomerName,s.Email,s.City,s.State,CAST(GETDATE() AS DATE),1
FROM stg.Customers s
LEFT JOIN dbo.DimCustomer d
  ON d.CustomerID=s.CustomerID AND d.IsCurrent=1
WHERE d.CustomerKey IS NULL;

-- SCD Type 2 example for products
UPDATE d
SET ExpiryDate = DATEADD(DAY,-1,CAST(GETDATE() AS DATE)),
    IsCurrent = 0
FROM dbo.DimProduct d
JOIN stg.Products s ON s.ProductID=d.ProductID
WHERE d.IsCurrent=1
  AND (ISNULL(d.ProductName,'')<>ISNULL(s.ProductName,'')
    OR ISNULL(d.Category,'')<>ISNULL(s.Category,'')
    OR ISNULL(d.UnitPrice,0)<>ISNULL(s.UnitPrice,0));

INSERT INTO dbo.DimProduct(ProductID,ProductName,Category,UnitPrice,EffectiveDate,IsCurrent)
SELECT s.ProductID,s.ProductName,s.Category,s.UnitPrice,CAST(GETDATE() AS DATE),1
FROM stg.Products s
LEFT JOIN dbo.DimProduct d
  ON d.ProductID=s.ProductID AND d.IsCurrent=1
WHERE d.ProductKey IS NULL;

-- Date dimension
DECLARE @StartDate DATE='2025-01-01', @EndDate DATE='2025-12-31';
;WITH d AS (
    SELECT @StartDate AS FullDate
    UNION ALL SELECT DATEADD(DAY,1,FullDate) FROM d WHERE FullDate<@EndDate
)
INSERT INTO dbo.DimDate(DateKey,FullDate,CalendarYear,CalendarMonth,MonthName,QuarterNo,DayOfMonth,DayName)
SELECT CONVERT(INT,CONVERT(CHAR(8),FullDate,112)), FullDate,
       YEAR(FullDate),MONTH(FullDate),DATENAME(MONTH,FullDate),
       DATEPART(QUARTER,FullDate),DAY(FullDate),DATENAME(WEEKDAY,FullDate)
FROM d
WHERE NOT EXISTS (SELECT 1 FROM dbo.DimDate x WHERE x.FullDate=d.FullDate)
OPTION (MAXRECURSION 400);

-- Fact load
INSERT INTO dbo.FactSales(SalesID,DateKey,CustomerKey,ProductKey,Quantity,SalesAmount)
SELECT s.SalesID,
       CONVERT(INT,CONVERT(CHAR(8),s.SalesDate,112)),
       c.CustomerKey,
       p.ProductKey,
       s.Quantity,
       s.SalesAmount
FROM stg.Sales s
JOIN dbo.DimCustomer c ON c.CustomerID=s.CustomerID AND c.IsCurrent=1
JOIN dbo.DimProduct p ON p.ProductID=s.ProductID AND p.IsCurrent=1
WHERE NOT EXISTS (SELECT 1 FROM dbo.FactSales f WHERE f.SalesID=s.SalesID);
GO
