USE master
GO

-- DROP DATABASE MRP;

CREATE DATABASE MRP
GO

use MRP
GO



CREATE TABLE Inventory
(
    ProductId int PRIMARY KEY NOT NULL
    , OnHandQty int NOT NULL
    , OnOrderQty int NOT NULL
    , CommittedQty int NOT NULL
);
GO

CREATE TABLE InventoryLocation
(
    ProductId int NOT NULL
    , Location varchar(10) NOT NULL
    , Qty int NOT NULL
    PRIMARY KEY (ProductID, Location)
);
GO

CREATE TABLE Customer
(
    CustomerId int Primary Key  NOT NULL
    , AccountName varchar(25) NOT NULL
    , CompanyName varchar(25) NOT NULL
    , CustomerAccountName varchar(25) NOT NULL
    , BillToAddress varchar(40) NOT NULL
    , ShippingAddress varchar(40) NOT NULL
    , CreditCardNo varchar(16) NOT NULL
);
GO

CREATE TABLE CustomerOrderHead (
    corderId int IDENTITY(1,1) PRIMARY KEY NOT NULL
    , CustomerId int FOREIGN KEY REFERENCES Customer(CustomerID)    
    , DateSubmitted datetime NOT NULL
    , StatusCode int NOT NULL -- 1 Pending; 2 Approved; 3 Rejected; 4 Complete
    , PaymentTotal money NOT NULL
    , PamentReceived money NULL
    , SplitShipmentsAvailible bit NULL
    , DateUpdated datetime NULL,
    
   CONSTRAINT validStatus
   CHECK (StatusCode BETWEEN 0 and 5)
)
GO

CREATE TABLE CreditHistory
(
    CustomerId int FOREIGN KEY REFERENCES Customer(CustomerId) NOT NULL
    , CreditorName varchar(25)NOT NULL
    , CreditorAccNo varchar(20)NOT NULL
    , CurrentBalance int NOT NULL
);

GO

CREATE TABLE Vendor
(
    VendorId int IDENTITY(1, 1) PRIMARY KEY NOT NULL
    , CompanyName varchar(20) NOT NULL
    , mainContactName varchar(40) NOT NULL
    , phoneNumber varchar(40) NOT NULL
    , paymentAddress varchar (200)  NOT NULL
    , rating varchar(2)  NOT NULL
)
GO

CREATE TABLE Parts (
    partsID int IDENTITY(1, 1) PRIMARY KEY NOT NULL
    , partName varchar(100) NOT NULL
    , description varchar(100) NOT NULL
    , unit varchar(100) NOT NULL
    , orderLeadTime datetime NULL 
    , safetyStock int NULL
    , maxLevelOnHand int NULL 
    , UnitCost money NOT NULL
    , UnitType varchar(100) NOT NULL
    , PartPicture varchar(100) NULL
    , HoursofAssembly real NOT NULL
    , VendorID int FOREIGN KEY REFERENCES Vendor(VendorId)
);

GO

CREATE TABLE CustomerOrderDetail
(
    OrderId int FOREIGN KEY REFERENCES CustomerOrderHead(COrderId) NOT NULL
    , ProductId int FOREIGN KEY REFERENCES Parts(PartsId) NOT NULL
    , Qty real NOT NULL 
    , PricePer money NOT NULL
)

CREATE TABLE Resources
(
    InventoryId int Primary Key NOT NULL
    , NumOfOperators int NOT NULL
    , MaintenanceDesc varchar(200) NOT NULL
    , MaintenanceFrequency varchar(20) NOT NULL
    , LastServiced varchar(20) NOT NULL
    , ResourceStatus varchar(100) NOT NULL

)
GO

CREATE TABLE BoM (
    ParentID int FOREIGN KEY REFERENCES Parts(partsID) NOT NULL
    , ChildID int FOREIGN KEY REFERENCES Parts(partsID) NOT NULL
    , Qty real NOT NULL
    , UnitMeasureCode varchar(10) NOT NULL
)
GO

CREATE TABLE VendorOrderHead (
    VendorOrderID int IDENTITY(1, 1) PRIMARY KEY NOT NULL
    , VendorID int FOREIGN KEY REFERENCES Vendor(VendorId) NOT NULL
    , DateSubmitted datetime NOT NULL
    , Status int NOT NULL
    , Total int  NOT NULL
    , splitShipmentsAvaliable Bit NOT NULL
    , DateUpdated datetime  NOT NULL
)

CREATE TABLE VendorOrderDetail (
     VendorOrderDetail int FOREIGN KEY REFERENCES VendorOrderHead(VendorOrderId)
    , ProductID int NOT NULL
    , Qty int NOT NULL
    , PricePer int NOT NULL
)

USE MRP
GO

CREATE PROCEDURE spCreateVendor
    @companyName varchar(100)
    , @mainContactName varchar(100)
    , @phoneNumber varchar(100)
    , @paymentAddress varchar(100)

    , @partName varchar(100)
    , @description varchar(100)
    , @unit varchar(100)
    , @unitCost money
    , @unitType varchar(100)
    , @hoursofAssembly real
AS
BEGIN
INSERT INTO dbo.Vendor (CompanyName, mainContactName, phoneNumber, paymentAddress, rating)
VALUES (@companyName, @mainContactName, @phoneNumber, @paymentAddress, 'A')
INSERT INTO dbo.Parts (partName, description, unit, UnitCost, UnitType, HoursofAssembly, VendorID)
VALUES (@partName, @description, @unit, @unitCost, @unitType, @hoursofAssembly, (SELECT VendorId FROM Vendor 
                                                            WHERE CompanyName = @companyName AND mainContactName = @mainContactName))
END
GO

--DROP PROCEDURE spCreateVendor


INSERT INTO Vendor VALUES ('Calvin','Caleb Boraby','616-526-1031','35042 Burton St. Grand Rapids MI','A');

INSERT INTO Vendor VALUES ('Hope is evil','Justin Baskaran','666-666-6666','6666 Diablo St. Hell 66666','F');

INSERT INTO Vendor VALUES ('Apple','Steve Jobs','123-456-7890','1234 Mountain View. California 1234','A');

USE MRP
GO


-- 1. Parts
CREATE UNIQUE INDEX indx_Parts
ON Parts (partsID);

-- 2. Inventory 
CREATE UNIQUE INDEX indx_Inventory
ON Inventory (ProductId);

--3. Resources
CREATE UNIQUE INDEX indx_Resources
ON Resources(InventoryId,ResourceStatus);


-- 4. CustomerOrderHead
CREATE UNIQUE INDEX indx_CustomerOrderHead
ON CustomerOrderHead(corderId,CustomerId,StatusCode);

-- 5. CustomerOrderDetail
CREATE UNIQUE INDEX indx_CustomerOrderDetail
ON CustomerOrderDetail(OrderId,ProductId);
