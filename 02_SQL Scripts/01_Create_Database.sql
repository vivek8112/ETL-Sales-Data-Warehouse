/* 01_Create_Database.sql */
IF DB_ID('ETL_SalesDW') IS NULL
    CREATE DATABASE ETL_SalesDW;
GO
USE ETL_SalesDW;
GO

IF OBJECT_ID('dbo.DimCustomer','U') IS NOT NULL DROP TABLE dbo.DimCustomer;
IF OBJECT_ID('dbo.DimProduct','U') IS NOT NULL DROP TABLE dbo.DimProduct;
IF OBJECT_ID('dbo.DimDate','U') IS NOT NULL DROP TABLE dbo.DimDate;
IF OBJECT_ID('dbo.FactSales','U') IS NOT NULL DROP TABLE dbo.FactSales;
IF OBJECT_ID('dbo.ETL_ErrorLog','U') IS NOT NULL DROP TABLE dbo.ETL_ErrorLog;
IF OBJECT_ID('stg.Sales','U') IS NOT NULL DROP TABLE stg.Sales;
IF OBJECT_ID('stg.Products','U') IS NOT NULL DROP TABLE stg.Products;
IF OBJECT_ID('stg.Customers','U') IS NOT NULL DROP TABLE stg.Customers;
GO

IF SCHEMA_ID('stg') IS NULL EXEC('CREATE SCHEMA stg');
GO

CREATE TABLE stg.Customers (
    CustomerID INT,
    CustomerName VARCHAR(100),
    Email VARCHAR(150),
    City VARCHAR(100),
    State VARCHAR(100),
    CreatedDate DATE
);

CREATE TABLE stg.Products (
    ProductID INT,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    UnitPrice DECIMAL(12,2),
    CreatedDate DATE
);

CREATE TABLE stg.Sales (
    SalesID INT,
    SalesDate DATE,
    CustomerID INT,
    ProductID INT,
    Quantity INT,
    SalesAmount DECIMAL(14,2)
);

CREATE TABLE dbo.DimCustomer (
    CustomerKey INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    CustomerName VARCHAR(100),
    Email VARCHAR(150),
    City VARCHAR(100),
    State VARCHAR(100),
    EffectiveDate DATE NOT NULL,
    ExpiryDate DATE NULL,
    IsCurrent BIT NOT NULL DEFAULT 1
);

CREATE TABLE dbo.DimProduct (
    ProductKey INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    UnitPrice DECIMAL(12,2),
    EffectiveDate DATE NOT NULL,
    ExpiryDate DATE NULL,
    IsCurrent BIT NOT NULL DEFAULT 1
);

CREATE TABLE dbo.DimDate (
    DateKey INT PRIMARY KEY,
    FullDate DATE NOT NULL,
    CalendarYear INT,
    CalendarMonth INT,
    MonthName VARCHAR(20),
    QuarterNo INT,
    DayOfMonth INT,
    DayName VARCHAR(20)
);

CREATE TABLE dbo.FactSales (
    SalesKey INT IDENTITY(1,1) PRIMARY KEY,
    SalesID INT NOT NULL,
    DateKey INT NOT NULL,
    CustomerKey INT NOT NULL,
    ProductKey INT NOT NULL,
    Quantity INT,
    SalesAmount DECIMAL(14,2),
    LoadDate DATETIME2 DEFAULT SYSDATETIME(),
    CONSTRAINT FK_FactSales_Date FOREIGN KEY(DateKey) REFERENCES dbo.DimDate(DateKey),
    CONSTRAINT FK_FactSales_Customer FOREIGN KEY(CustomerKey) REFERENCES dbo.DimCustomer(CustomerKey),
    CONSTRAINT FK_FactSales_Product FOREIGN KEY(ProductKey) REFERENCES dbo.DimProduct(ProductKey)
);

CREATE TABLE dbo.ETL_ErrorLog (
    ErrorID INT IDENTITY(1,1) PRIMARY KEY,
    PackageName VARCHAR(200),
    TaskName VARCHAR(200),
    ErrorMessage VARCHAR(4000),
    ErrorDate DATETIME2 DEFAULT SYSDATETIME()
);
GO
