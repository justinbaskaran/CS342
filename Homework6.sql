-- Justin Baskaran
-- CS 342 A

--1.
-- CASCADE: when you delete a row wiht a primary key
-- then it cascades to related rows in foreign key tables.
USE AP 
GO
--2.
--- Create InvoiceLineItemArchive Table
CREATE TABLE InvoiceLineItemArchive (
	InvoiceID int NOT NULL,
	InvoiceSequence smallint NOT NULL,
	AccountNo int NOT NULL,
	InvoiceLineItemAmount money NOT NULL,
	InvoiceLineItemDescription varchar(100) NOT NULL,
CONSTRAINT PK_ArchieveInvoiceLineItems PRIMARY KEY CLUSTERED (
	InvoiceID ASC,
	InvoiceSequence ASC
 )
);
GO

---Insert Archieved Items from Invoice to InvoiceArchive
INSERT INTO InvoiceArchive
SELECT [InvoiceID]
      ,[VendorID]
      ,[InvoiceNumber]
      ,[InvoiceDate]
      ,[InvoiceTotal]
      ,[PaymentTotal]
      ,[CreditTotal]
      ,[TermsID]
      ,[InvoiceDueDate]
      ,[PaymentDate]
  FROM [AP].[dbo].[Invoices]
  WHERE InvoiceDate <> ''
  AND PaymentTotal = InvoiceTotal;
GO
-- Insert values into Archive Line Items
INSERT INTO InvoiceLineItemArchive
SELECT li.[InvoiceID]
      ,li.[InvoiceSequence]
      ,li.[AccountNo]
      ,li.[InvoiceLineItemAmount]
      ,li.[InvoiceLineItemDescription]
FROM InvoiceLineItems li, InvoiceArchive iv   
WHERE li.InvoiceID = iv.InvoiceID
GO
-- ALTER InvoicesLineItems table and Drop CASCADE constraint
ALTER TABLE InvoiceLineItems DROP CONSTRAINT FK_InvoiceLineItems_GLAccounts;
GO
ALTER TABLE InvoiceLineItems  
WITH NOCHECK ADD  CONSTRAINT FK_InvoiceLineItems_GLAccounts 
FOREIGN KEY(AccountNo)
REFERENCES GLAccounts (AccountNo)
ON DELETE CASCADE
GO



BEGIN TRAN
--- DELETE items from Invoices 
DELETE FROM [AP].[dbo].[Invoices]
  WHERE InvoiceDate <> ''
  AND PaymentTotal = InvoiceTotal;
GO

DELETE FROM InvoiceLineItems
WHERE InvoiceID IN
(SELECT iv.InvoiceID
	FROM InvoiceArchive iv INNER JOIN InvoiceLineItems il ON
		iv.InvoiceID = il.InvoiceID
		)
GO

ALTER TABLE InvoiceArchive
ADD PRIMARY KEY (InvoiceID);
GO

ALTER TABLE InvoicesLineItemArchive  
WITH NOCHECK 
ADD CONSTRAINT FK_InvoicesLineItemArchive_InvoiceArchive
FOREIGN KEY(InvoiceID)
REFERENCES InvoiceArchive (InvoiceID)
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE InvoicesLineItemArchive 
CHECK CONSTRAINT FK_InvoicesLineItemArchive_InvoiceArchive
GO


ROLLBACK TRAN
DELETE From InvoiceArchive
DROP TABLE InvoiceLineItemArchive;
GO

--3. 
/*
Yes, you can update insert, and delete on SINGLE table based views. 
I have not tried with the below one
becuase it is not a single table based view, it has two tables joined together. 
*/

CREATE VIEW dbo.vAllInvoices
WITH SCHEMABINDING
AS
Select 'C' "Type"
	,inv.InvoiceID
	,ili.InvoiceSequence
	,v.VendorName
	,inv.InvoiceTotal
	,inv.InvoiceDueDate
	,t.TermsDescription
	,ili.InvoiceLineItemDescription
FROM dbo.Invoices inv JOIN dbo.InvoiceLineItems ili ON
	inv.InvoiceID = ili.InvoiceID
	JOIN dbo.Vendors v ON
	v.VendorID = inv.VendorID
	JOIN dbo.Terms t ON 
	t.TermsID = inv.TermsID
UNION
Select 'A'  "Type"
	,inv.InvoiceID
	,ili.InvoiceSequence
	,v.VendorName
	,inv.InvoiceTotal
	,inv.InvoiceDueDate
	,t.TermsDescription
	,ili.InvoiceLineItemDescription
FROM dbo.InvoiceArchive inv JOIN dbo.InvoiceLineItemArchive ili ON
	inv.InvoiceID = ili.InvoiceID
	JOIN dbo.Vendors v ON
	v.VendorID = inv.VendorID
	JOIN dbo.Terms t ON 
	t.TermsID = inv.TermsID;
GO

Select * from dbo.vAllInvoices;
GO


--4.
USE AdventureWorks2012
GO

--5.
CREATE VIEW [vRetirement] 
WITH SCHEMABINDING AS
SELECT CONCAT(p.FirstName, ' ' , p.LastName )  'Name'
  FROM [AdventureWorks2012].[HumanResources].[Employee] e, [AdventureWorks2012].[Person].[Person] p
  WHERE DATEDIFF(YEAR,CAST (BirthDate as date),GETDATE()) >52
  AND e.BusinessEntityID = p.BusinessEntityID;
  GO
   Select Count(*) as NumberOfRetirees, (Count(*) * 120000) as "TotalCost" FROM vRetirement;
  Go

--6.
  create View dbo.vPayHistMore
  WITH SCHEMABINDING
  AS
  SELECT DISTINCT sub.BusinessEntityID as "ID"
	, e.LoginID
	, sub.Rate as "Highest_Rate_Paid"
	, sub.PayFrequency as "Times_Pay_Has_Changed"
  FROM HumanResources.Employee e JOIN HumanResources.EmployeePayHistory sub
  ON e.BusinessEntityID = sub.BusinessEntityID
WHERE sub.Rate = 
(SELECT TOP 1 MAX(Rate) 
FROM HumanResources.EmployeePayHistory a 
WHERE a.BusinessEntityID = sub.BusinessEntityID  GROUP BY Rate )
GO
  Select * from dbo.vPayHistMore;
  GO

--7.
create view vHRempList
  WITH SCHEMABINDING
  AS
SELECT 
        e.LoginID
        , CONCAT(a.AddressLine1,',',a.AddressLine2,'',a.City,',',sp.Name) "Adress"
  FROM [HumanResources].[Employee] e
  JOIN
    [Person].[BusinessEntityAddress] bea  
    ON bea.BusinessEntityID = e.BusinessEntityID 
  JOIN
    [Person].[Address] a  
    ON bea.AddressID = a.AddressID
  JOIN 
    [Person].[StateProvince] sp
    ON sp.StateProvinceID = a.StateProvinceID
GO

--8.
create View VMultipleAddresses
WITH SCHEMABINDING
AS
SELECT sp.name,
        a.City,
        COUNT(*) 'Count'
FROM [HumanResources].[Employee] e
JOIN
[Person].[BusinessEntityAddress] bea  
ON bea.BusinessEntityID = e.BusinessEntityID 
JOIN
[Person].[Address] a  
ON bea.AddressID = a.AddressID
JOIN 
[Person].[StateProvince] sp
ON sp.StateProvinceID = a.StateProvinceID
GROUP BY sp.Name,City;
GO

 -- DROP VIEWS
Drop View dbo.vHRempList
GO


Drop View dbo.VMultipleAddresses;
GO


Drop View dbo.vPayHistMore;
GO

--- RESET HERE 
DROP VIEW dbo.vRetirement;
GO

USE AP;
Go

DROP VIEW dbo.vAllInvoices;
Go

ROLLBACK TRAN
Go
DELETE From InvoiceArchive;
GO
DROP TABLE InvoiceLineItemArchive;
GO

--9.
USE master
GO
DROP DATABASE AP
GO

