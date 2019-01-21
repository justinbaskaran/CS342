-- Justin Baskaran
-- CS 342A
-- Homework 3
USE AP
GO

-- 1a.
SELECT DISTINCT Vendors.VendorName
FROM Vendors INNER JOIN Invoices
ON Vendors.VendorID = Invoices.VendorID;
---34 Rows

--1a Solution 2.
SELECT DISTINCT Vendors.VendorName
FROM Vendors FULL OUTER JOIN Invoices
ON Vendors.VendorID = Invoices.VendorID
WHERE Vendors.VendorID = Invoices.VendorID;
-- 34 Rows.

--1a Solution 3.
SELECT DISTINCT Vendors.VendorName
FROM Vendors LEFT OUTER JOIN Invoices
ON Vendors.VendorID = Invoices.VendorID
WHERE Vendors.VendorID = Invoices.VendorID;
-- 34 Rows.

--1a Solution 4.
SELECT DISTINCT Vendors.VendorName
FROM Vendors RIGHT OUTER JOIN Invoices
ON Vendors.VendorID = Invoices.VendorID
WHERE Vendors.VendorID = Invoices.VendorID;
-- 34 Rows.

--1b.
SELECT InvoiceNumber
    ,InvoiceTotal
    ,PaymentTotal 
FROM Invoices
WHERE PaymentTotal > (SELECT (AVG(PaymentTotal)+MIN(PaymentTotal))/2 FROM Invoices);

--1c.
SELECT DISTINCT a.VendorID 
    ,InvoiceTotal 
    ,a.PaymentTotal
    ,a.InvoiceNumber 
    ,'QuantityInventory'  = (SELECT COUNT(*) FROM Invoices WHERE a.VendorID = VendorID)
FROM Invoices a
WHERE a.PaymentTotal > (SELECT (AVG(PaymentTotal)+MIN(PaymentTotal))/2 FROM Invoices)
GROUP BY a.VendorID,a.PaymentTotal,InvoiceNumber,InvoiceTotal;   

--2.
WITH ProductCTE AS 
(
    -- Intial Step
    SELECT [BillOfMaterialsID]
     ,[BOMLevel]
      ,[ProductAssemblyID]
      ,[ComponentID]
      ,[PerAssemblyQty]
    FROM [AdventureWorks2012].[Production].[BillOfMaterials]
    WHERE ProductAssemblyID = 728
    UNION ALL
        -- Recurisve Step
     SELECT [BillOfMaterials] . [BillOfMaterialsID]
     ,[BillOfMaterials] .[BOMLevel]
      ,[BillOfMaterials] .[ProductAssemblyID]
      ,[BillOfMaterials] .[ComponentID]
      ,[BillOfMaterials] .[PerAssemblyQty]
    FROM [AdventureWorks2012].[Production].[BillOfMaterials] JOIN ProductCTE
    ON BillOfMaterials.ProductAssemblyID = ProductCTE.ComponentID
)
SELECT * FROM ProductCTE;

--Extra Credit:
WITH ProductCTE AS 
(
    -- Intial Step
    SELECT [BillOfMaterialsID]
     ,[BOMLevel]
      ,[ProductAssemblyID]
      ,[ComponentID]
      ,[PerAssemblyQty]
    FROM [AdventureWorks2012].[Production].[BillOfMaterials]
    WHERE ProductAssemblyID = 728
    UNION ALL
        -- Recurisve Step
     SELECT [BillOfMaterials] . [BillOfMaterialsID]
     ,[BillOfMaterials] .[BOMLevel]
      ,[BillOfMaterials] .[ProductAssemblyID]
      ,[BillOfMaterials] .[ComponentID]
      ,[BillOfMaterials] .[PerAssemblyQty]
    FROM [AdventureWorks2012].[Production].[BillOfMaterials] JOIN ProductCTE
    ON BillOfMaterials.ProductAssemblyID = ProductCTE.ComponentID
)
SELECT BOMLevel
    , Product.Name
    ,PerAssemblyQty
 FROM ProductCTE JOIN [AdventureWorks2012].[Production].Product
ON ProductCTE.ProductAssemblyID = Product.ProductID;
