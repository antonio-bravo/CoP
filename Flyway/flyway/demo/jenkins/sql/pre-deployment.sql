/*
This is script will be used to grant temporal permissions to the account that it will do the deployment
*/
--Create Role if does not exists
IF NOT EXISTS(SELECT 1 FROM sys.database_principals dp WHERE dp.type = 'R' AND dp.name = '$(RoleName)')
BEGIN
	CREATE ROLE [$(RoleName)]	
END
GO
--Grant ALTER permissions to role on schema dbo
GRANT ALTER ON SCHEMA::[dbo] TO [$(RoleName)];
GO
--Create user if not exists for DB
IF NOT EXISTS(SELECT 1 FROM sys.database_principals dp WHERE dp.name = '$(UserName)')
BEGIN
	CREATE USER [$(UserName)] FOR LOGIN [$(UserName)] WITH DEFAULT_SCHEMA=[dbo]
END
GO
--Add user to role
ALTER ROLE [$(RoleName)] ADD MEMBER [$(UserName)];
