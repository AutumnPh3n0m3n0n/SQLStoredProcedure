

--The Adventure works 2014 database is being used here
USE AdventureWorks2014
GO

--If the procedures uspGetAddress and uspGetAddressCount already exist, drop these procedures
--Otherwise, skip and ignore this code
DROP PROCEDURE dbo.uspGetAddress
DROP PROCEDURE dbo.uspGetAddressCount
DROP PROCEDURE dbo.uspTryCatchTest
--GO

--Setting the null and quoted identifiers on
--This can be helpful in lots of SQL projects
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Creating the procedure uspGetAdress that takes two : city and address
--Execute data based on all addresses in Chicago
--There should be 11 addresses
--The NULL feature allows blanks in the tables and replaces them with NULL
--The ISNULL looks for any possible data left empty of blank
--There is a full outer join to connect the business entity table to the address table and
--an inner join that connects the person table to the other two tables as they share the same primary keys
CREATE PROCEDURE dbo.uspGetAddress @City nvarchar(30) = NULL, @AddressLine1 nvarchar(60) = NULL
AS SELECT *, Person.Person.FirstName as 'FirstName', Person.Person.LastName as 'Last Name:',
Person.Person.Title as 'Title:'  FROM Person.Address
FULL OUTER JOIN Person.BusinessEntityAddress ON Person.BusinessEntityAddress.AddressID = Person.Address.AddressID
INNER JOIN Person.Person ON Person.Person.BusinessEntityID = Person.BusinessEntityAddress.BusinessEntityID
WHERE City = ISNULL(@City,City)
AND AddressLine1 LIKE '%' + ISNULL(@AddressLine1 ,AddressLine1) + '%'
GO
EXEC dbo.uspGetAddress @City = 'Chicago'

/*---------------------------------------------------------------------------------*/

--Outputting the results from the addresses from Chicago
--uspGetAddressCount get the number of addresses but not the addresses themselves
--Declare the address count query as integer as it is a scalar variable
--Execute the uspGetAddressCount procedure which will count all the locations in Chicago
--The table should return 11 as there are 11 locations
CREATE PROCEDURE dbo.uspGetAddressCount @City nvarchar(30), @AddressCount int OUTPUT
AS SELECT @AddressCount = count(*) 
FROM AdventureWorks2014.Person.Address 
WHERE City = @City
GO

DECLARE @AddressCount int
EXEC dbo.uspGetAddressCount @City = 'Chicago', @AddressCount = @AddressCount OUTPUT
SELECT @AddressCount
GO

/*----------------------------------------------------------------------------------*/
--The try and catch blocks
CREATE PROCEDURE dbo.uspTryCatchTest
AS
BEGIN TRY
    SELECT 1/0
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS ErrorNumber
     ,ERROR_SEVERITY() AS ErrorSeverity
     ,ERROR_STATE() AS ErrorState
     ,ERROR_PROCEDURE() AS ErrorProcedure
     ,ERROR_LINE() AS ErrorLine
     ,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO


CREATE SCHEMA [HumanResources] AUTHORIZATION [dbo]
GO

--DROP PROCEDURE dbo.uspGetAddress --dbo.uspInsertAddress, dbo.uspDeleteAddress
--GO

--Alter is used to change something in a procedure
/*
ALTER PROCEDURE dbo.uspGetAddress @City nvarchar(30)
AS
SELECT * 
FROM Person.Address
WHERE City LIKE @City + '%'
GO*/