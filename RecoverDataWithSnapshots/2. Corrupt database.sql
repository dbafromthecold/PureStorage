USE [AdventureWorks2019];
GO


--check data
SELECT * FROM [AdventureWorks2019].[HumanResources].[Employee];
GO


--simulate incorrect data update
UPDATE [AdventureWorks2019].[HumanResources].[Employee]
SET JobTitle = 'Sales Representative';
GO


--confirm
SELECT * FROM [AdventureWorks2019].[HumanResources].[Employee];
GO