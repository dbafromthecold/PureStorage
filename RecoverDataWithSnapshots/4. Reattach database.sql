USE [master];
GO

-- attach database from files on restored volume
CREATE DATABASE [AdventureWorks2019_REATTACH]
 ON  PRIMARY 
( NAME = N'AdventureWorks2017', FILENAME = N'F:\SQLData1\AdventureWorks2019.mdf')
 LOG ON 
( NAME = N'AdventureWorks2017_log', FILENAME = N'F:\SQLTLog1\AdventureWorks2019_log.ldf')
 FOR ATTACH
GO


-- confirm database
SELECT [name] FROM sys.databases;
GO


--confirm data is correct in newly attached database
SELECT * FROM [AdventureWorks2019_REATTACH].[HumanResources].[Employee];
GO


--reset data to correct values
UPDATE e
SET e.JobTitle = e1.JobTitle
FROM [AdventureWorks2019].[HumanResources].[Employee] e
INNER JOIN [AdventureWorks2019_REATTACH].[HumanResources].[Employee] e1
ON e.BusinessEntityID = e1.BusinessEntityID


--confirm data is correct
SELECT * FROM [AdventureWorks2019].[HumanResources].[Employee];
GO