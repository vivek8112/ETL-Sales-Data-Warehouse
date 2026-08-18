/* 03_Validation_Queries.sql */
USE ETL_SalesDW;
GO

-- Row counts
SELECT 'stg.Customers' AS TableName, COUNT(*) AS RowCount FROM stg.Customers
UNION ALL SELECT 'stg.Products', COUNT(*) FROM stg.Products
UNION ALL SELECT 'stg.Sales', COUNT(*) FROM stg.Sales
UNION ALL SELECT 'DimCustomer', COUNT(*) FROM dbo.DimCustomer
UNION ALL SELECT 'DimProduct', COUNT(*) FROM dbo.DimProduct
UNION ALL SELECT 'FactSales', COUNT(*) FROM dbo.FactSales;

-- Total sales
SELECT SUM(SalesAmount) AS TotalSales
FROM dbo.FactSales;

-- Sales by category
SELECT p.Category, SUM(f.SalesAmount) AS TotalSales
FROM dbo.FactSales f
JOIN dbo.DimProduct p ON p.ProductKey=f.ProductKey
GROUP BY p.Category
ORDER BY TotalSales DESC;

-- Sales by customer
SELECT c.CustomerName, SUM(f.SalesAmount) AS TotalSales
FROM dbo.FactSales f
JOIN dbo.DimCustomer c ON c.CustomerKey=f.CustomerKey
GROUP BY c.CustomerName
ORDER BY TotalSales DESC;

-- Check duplicate SalesID
SELECT SalesID, COUNT(*) AS Cnt
FROM dbo.FactSales
GROUP BY SalesID
HAVING COUNT(*)>1;

-- Check orphan/missing dimension records
SELECT COUNT(*) AS MissingCustomerKeys
FROM dbo.FactSales f
LEFT JOIN dbo.DimCustomer c ON f.CustomerKey=c.CustomerKey
WHERE c.CustomerKey IS NULL;
GO
