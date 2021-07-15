﻿CREATE FUNCTION tSQLt.[@tSQLt:MaxSqlMajorVersion](@MaxVersion INT)
RETURNS TABLE
AS
RETURN
  SELECT AF.*
    FROM (SELECT PSSV.Major FROM tSQLt.Private_SqlVersion() AS PSV CROSS APPLY tSQLt.Private_SplitSqlVersion(PSV.ProductVersion) AS PSSV) AV
   CROSS APPLY tSQLt.[@tSQLt:SkipTest]('Maximum allowed version is '+
                                       CAST(@MaxVersion AS NVARCHAR(MAX))+
                                       ', but current version is '+
                                       CAST(AV.Major AS NVARCHAR(MAX))+'.'
                                      ) AS AF
   WHERE @MaxVersion < AV.Major