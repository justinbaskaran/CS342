-- Caleb Boraby, Justin Baskaran, Gavin Martin
-- Take Home Quiz 10-12-2018

USE AP
GO

-- 2a.
IF OBJECT_ID('dbo.ALog') IS NOT NULL
	DROP TABLE ALog
GO
CREATE TABLE ALog (
	LogId int IDENTITY (1, 1)
	, TableName varchar(255)
	, ReportDate date
	, NumberofUpdates int
);

-- 2b.
UPDATE Invoices
SET PaymentTotal = 0
WHERE PaymentTotal IS NULL

DECLARE @rows_changed int = @@ROWCOUNT;

INSERT INTO ALog
VALUES ('Invoices', GETDATE(), @rows_changed);

SELECT * FROM Invoices WHERE PaymentTotal IS NULL

SELECT * FROM ALog

--USE master

--DROP DATABASE AP
--GO