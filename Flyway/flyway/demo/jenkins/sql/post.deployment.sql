/*
This is script will remove permissions granted temporaly for the deployment
*/
DECLARE @SQL NVARCHAR(max) = ''
SELECT 
	@SQL += 'ALTER ROLE ['+dp1.name+'] DROP MEMBER ['+dp2.name+'];'
--dp1.name  AS RoleName
--,dp2.name  AS MemberName

FROM sys.database_role_members drm
JOIN sys.database_principals dp1 ON dp1.principal_id = drm.role_principal_id 
JOIN sys.database_principals dp2 ON dp2.principal_id = drm.member_principal_id 
WHERE dp1.name = '$(RoleName)' 

PRINT @SQL

BEGIN TRY
    EXEC sp_executesql @SQL
END TRY
BEGIN CATCH
    THROW
END CATCH