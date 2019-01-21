-- Justin Baskaran
-- Homework 2
USE AP;
GO

-- -- 1.
SELECT Invoices.[VendorID] AS 'VendorID'
, SUM(Invoices.PaymentTotal) AS 'PaymentSum'
,  Vendors.[VendorName] as 'Name'
, Vendors.VendorState as 'State' 
FROM Invoices INNER JOIN Vendors
ON Invoices.[VendorID] = Vendors.[VendorID]
GROUP BY Invoices.[VendorID]
	,Vendors.VendorName
	,Vendors.VendorState; 


--2. 
SELECT GLAccounts.AccountDescription
    , COUNT(*) AS LineItemCount
    ,SUM(InvoiceLineItemAmount) AS LineItemSum
	, AVG(InvoiceLineItemAmount) as AverageLineItem
FROM GLAccounts JOIN InvoiceLineItems
  ON GLAccounts.AccountNo = InvoiceLineItems.AccountNo
GROUP BY GLAccounts.AccountDescription
HAVING COUNT(*) > 1
ORDER BY LineItemCount DESC;

USE Pubs
GO

--3.
SELECT 
	j.job_desc
	, COUNT(*) 'Quantity'
  FROM [pubs].[dbo].[employee] e JOIN  [pubs].[dbo].jobs  j
  ON  e.job_id = j.job_id
  GROUP BY j.job_id
            ,j.job_desc
  ORDER BY COUNT(*) desc;

--4.
SELECT 
	j.job_desc
    ,MIN(e.hire_date) 'Oldest Hire Date'
  FROM [pubs].[dbo].[employee] e JOIN  [pubs].[dbo].jobs  j
  ON  e.job_id = j.job_id
  GROUP BY j.job_id
            ,j.job_desc
  HAVING COUNT(*) >= 3
  ORDER BY MIN(e.hire_date) asc;

