-- Justin Baskaran
-- CS 342 A
-- Ocotober 27, 2018
-- Take Home Excersie

/*
Write a trigger named stLog for AdventureWorks2012 
that will record when rows in the table Person.StateProvince have been added, changed or deleted.  
Here are a few constraints:

The name of the trigger should start with ‘st’ and then your initials.
The trigger must note the type of change with a single letter of either I, D, or U (insert, delete, update)
The trigger must record the time of the change
The trigger must capture who made the change using the system call of SYSTEM_USER
HINT: Except for the first three columns mentioned, the rest of the table structure 
reflects the Person.StateProvince table with a few changes.
*/

USE AdventureWorks2012
GO 

IF (SELECT object_id('Person.stLogJB')) IS NOT NULL
    DROP TRIGGER Person.stLogJB;
    GO

IF OBJECT_ID('dbo.changesMade') IS NOT NULL
    BEGIN
        DROP TABLE dbo.changesMade;
    END
    GO

CREATE TABLE dbo.changesMade( 
changed DATETIME,
typeChanged varchar(1),
sysUser varchar,
[StateProvinceID] [int] NOT NULL,
[StateProvinceCode] [nchar](3) NOT NULL,
[CountryRegionCode] [nvarchar](3) NOT NULL,
[IsOnlyStateProvinceFlag] [dbo].[Flag] NOT NULL,
[Name] [dbo].[Name] NOT NULL,
[TerritoryID] [int] NOT NULL,
[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
[ModifiedDate] [datetime] NOT NULL
);
GO

CREATE TRIGGER Person.stLogJB
ON Person.StateProvince
AFTER INSERT, UPDATE, DELETE 
AS
BEGIN

    DECLARE @activity varchar(1);

    DECLARE @sys_usr varchar;  
    SET @sys_usr = SYSTEM_USER;  

    if exists(SELECT 1 from Inserted) and exists (SELECT 1 from Deleted)
    begin
    SET @activity = 'U';
    INSERT INTO dbo.changesMade
    SELECT TOP 1 GETDATE()
            ,@activity
            ,@sys_usr
            , [StateProvinceID]
            ,[StateProvinceCode]
            ,[CountryRegionCode]
            ,[IsOnlyStateProvinceFlag]
            ,[Name]
            ,[TerritoryID]
            ,[rowguid]
            ,[ModifiedDate]
    FROM Inserted;
   
    end

    else If exists (Select 1 from Inserted) and not exists(Select 1 from Deleted)
    begin
    SET @activity = 'I';
    INSERT INTO dbo.changesMade
    SELECT TOP 1 GETDATE()
            ,@activity
            ,@sys_usr
            , [StateProvinceID]
            ,[StateProvinceCode]
            ,[CountryRegionCode]
            ,[IsOnlyStateProvinceFlag]
            ,[Name]
            ,[TerritoryID]
            ,[rowguid]
            ,[ModifiedDate]
    FROM Inserted;
    end

    else If exists(select 1 from Deleted) and not exists(Select 1 from Inserted)
    begin 
    SET @activity = 'D';
    INSERT INTO dbo.changesMade
    SELECT TOP 1 GETDATE()
            ,@activity
            ,@sys_usr
            , [StateProvinceID]
            ,[StateProvinceCode]
            ,[CountryRegionCode]
            ,[IsOnlyStateProvinceFlag]
            ,[Name]
            ,[TerritoryID]
            ,[rowguid]
            ,[ModifiedDate]
    FROM Deleted;
    end
END
GO
ALTER TABLE Sales.SalesTaxRate   
DROP CONSTRAINT FK_SalesTaxRate_StateProvince_StateProvinceID; 
DELETE Person.StateProvince WHERE StateProvinceID=1;
 


