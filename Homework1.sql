-- Justin Baskaran
-- Homework 1 SQL

-- Setup
USE AP
GO

--1.
SELECT[VendorContactFName]
      ,[VendorContactLName]
      ,[VendorName]
      ,[VendorCity]
      ,[VendorState]
  FROM [AP].[dbo].[Vendors]
  ORDER BY [VendorCity]
          ,[VendorState]
          ,[VendorContactLName]
          ,[VendorContactFName];
-- 2.
SELECT CONCAT(VendorContactLName,
              ','
              ,VendorContactFName) as "Full Name"
  FROM [AP].[dbo].[Vendors]
  WHERE [VendorState] = 'OH'
  ORDER BY [VendorContactLName]
          ,[VendorContactFName];


--3.
SELECT [InvoiceID]
      ,InvoiceTotal * 25/100 + InvoiceTotal
  FROM [AP].[dbo].[Invoices]
  WHERE InvoiceTotal > 1000
  ORDER BY InvoiceTotal desc;


--4.
SELECT CONCAT(VendorContactLName
              ,','
              ,VendorContactFName) as "Full Name"
  FROM [AP].[dbo].[Vendors]
  WHERE [VendorState] = 'OH'
  AND SUBSTRING(VendorContactLName, 1, 1) = 'A'
  OR SUBSTRING(VendorContactLName, 1, 1) = 'D'
  OR SUBSTRING(VendorContactLName, 1, 1) = 'E'
  OR SUBSTRING(VendorContactLName, 1, 1) = 'L'
  ORDER BY [VendorContactLName]
            ,[VendorContactFName];

-- 4. Solution 2
SELECT CONCAT(VendorContactLName
              ,','
              ,VendorContactFName) as "Full Name"
  FROM [AP].[dbo].[Vendors]
  WHERE [VendorState] = 'OH'
  AND LEFT(VendorContactLName, 1) = 'A'
  OR LEFT(VendorContactLName, 1) = 'D'
  OR LEFT(VendorContactLName, 1) = 'E'
  OR LEFT(VendorContactLName, 1) = 'L'
  ORDER BY [VendorContactLName]
            ,[VendorContactFName];


--5.
SELECT [PaymentTotal]
      ,[PaymentDate]
  FROM [AP].[dbo].[Invoices]
  WHERE [PaymentTotal] <> 0
  AND [PaymentDate] = NULL;


  --6.
  SELECT
    *
  FROM
    [AP].[dbo].[Invoices]
    INNER JOIN
    [AP].[dbo].[Vendors]
    ON [AP].[dbo].[Invoices].VendorID = [AP].[dbo].[Vendors].VendorID
  WHERE
    [AP].[dbo].[Vendors].VendorState = 'NY';


 -- 7.
 SELECT
 DISTINCT InvoiceNumber
 ,VendorName
 ,InvoiceDate
 ,InvoiceTotal- (PaymentTotal + CreditTotal) as Balance
FROM
 [AP].[dbo].[Invoices]
 INNER JOIN
 [AP].[dbo].[Vendors]
 ON [AP].[dbo].[Invoices].VendorID = [AP].[dbo].[Vendors].VendorID
WHERE
 InvoiceTotal- (PaymentTotal + CreditTotal) != 0
ORDER BY InvoiceTotal- (PaymentTotal + CreditTotal) desc;


-- 8.
SELECT
  DISTINCT VendorName
  ,VendorState
  ,DefaultAccountNo
  ,AccountDescription
FROM
  [AP].[dbo].[Vendors]
  INNER JOIN
  [AP].[dbo].[GLAccounts]
  ON [AP].[dbo].[Vendors].DefaultAccountNo = [AP].[dbo].[GLAccounts].AccountNo
ORDER BY AccountDescription,VendorName;

--9.
SELECT *
  FROM [pubs].[dbo].[authors]
WHERE SUBSTRING([phone],1,3) = '801';

--10.
SELECT DISTINCT CONCAT ([au_lname]
        , ' , '
     ,[au_fname]) as AuthorName
      ,title as Title
  FROM [pubs].[dbo].[authors]
  LEFT JOIN  [pubs].[dbo].[titleauthor]
  ON [pubs].[dbo].[authors].au_id = [pubs].[dbo].[titleauthor].[au_id]
LEFT JOIN [pubs].[dbo].[titles]
  ON [pubs].[dbo].[titleauthor].title_id = [pubs].[dbo].[titles].[title_id];

  --11.
  SELECT 'Publisher' as Type
        , [pubs].[dbo].[publishers].pub_name as Name
        ,[pubs].[dbo].[publishers].[state] as "State"
  FROM [pubs].[dbo].[publishers]
  UNION ALL
SELECT 'Vendor' as Type
        , [AP].[dbo].[Vendors].VendorName as Name
        ,[AP].[dbo].[Vendors].VendorState as "State"
   FROM [AP].[dbo].[Vendors];

-- 12.
SELECT DISTINCT CONCAT ([au_lname]
        , ' , '
     ,[au_fname]) as 'Author'
      ,title as Title
      ,[pubs].[dbo].[stores].stor_name as 'Store Name'
      ,[pubs].[dbo].[stores].[state] as 'Store State'
  FROM [pubs].[dbo].[authors]
INNER JOIN  [pubs].[dbo].[titleauthor]
  ON [pubs].[dbo].[authors].au_id = [pubs].[dbo].[titleauthor].[au_id]
INNER JOIN [pubs].[dbo].[titles]
  ON [pubs].[dbo].[titleauthor].title_id = [pubs].[dbo].[titles].[title_id]
INNER JOIN [pubs].[dbo].[sales]
  ON [pubs].[dbo].[sales].title_id = [pubs].[dbo].[titles].[title_id]
INNER JOIN [pubs].[dbo].[stores]
  ON [pubs].[dbo].[sales].[stor_id] = [pubs].[dbo].[stores].stor_id;
