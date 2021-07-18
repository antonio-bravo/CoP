CREATE PROCEDURE [TestBasic].[test If procedure dbo.Vessel_Create has the correct parameters]  
AS  
/*  
<documentation>  
  <author>ABM040</author>  
  <summary>test if dbo.Vessel_Create has the correct parameters</summary>  
  <returns>nothing</returns>  
</documentation>  
  
Changes:  
Date  Who      Notes  
---------- ---      --------------------------------------------------------------  
20210714 ABM040        Creation  
*/  
    SET NOCOUNT ON;  
  
    ----- ASSEMBLE -----------------------------------------------  
    -- Create the tables  
    CREATE TABLE #actual  
    (  
        [ParameterName] NVARCHAR(128) NOT NULL,  
        [DataType] sysname NOT NULL,  
        [LengthSize] SMALLINT NOT NULL,  
        [Precision] TINYINT NOT NULL  
    );  
  
    CREATE TABLE #expected  
    (  
        [ParameterName] NVARCHAR(128) NOT NULL,  
        [DataType] sysname NOT NULL,  
        [LengthSize] SMALLINT NOT NULL,  
        [Precision] TINYINT NOT NULL  
    );  
  
    INSERT INTO #expected  
    (  
        ParameterName,  
        DataType,  
        LengthSize,  
        Precision  
    )  
    VALUES  
    (   N'@VesselID',   -- ParameterName - nvarchar(128)  
        'int',          -- DataType - sysname  
        4,              -- LengthSize - smallint  
        10              -- Precision - tinyint  
        ),  
    (   N'@VesselCode', -- ParameterName - nvarchar(128)  
        'char',         -- DataType - sysname  
        3,              -- LengthSize - smallint  
        0               -- Precision - tinyint  
    ),  
    (   N'@VesselName', -- ParameterName - nvarchar(128)  
        'varchar',      -- DataType - sysname  
        30,             -- LengthSize - smallint  
        0               -- Precision - tinyint  
    ),  
    (   N'@TEU',        -- ParameterName - nvarchar(128)  
        'int',          -- DataType - sysname  
        4,              -- LengthSize - smallint  
        10              -- Precision - tinyint  
    ),  
    (   N'@Plug',       -- ParameterName - nvarchar(128)  
        'int',          -- DataType - sysname  
        4,              -- LengthSize - smallint  
        10              -- Precision - tinyint  
    ),  
    (   N'@OperatorID', -- ParameterName - nvarchar(128)  
        'int',          -- DataType - sysname  
        4,              -- LengthSize - smallint  
        10              -- Precision - tinyint  
    );  
    ----- ACT ----------------------------------------------------  
  
    INSERT INTO #actual  
    (  
        ParameterName,  
        DataType,  
        LengthSize,  
        Precision  
    )  
    SELECT pm.name                    AS ParameterName  
        ,t.name                     AS DataType  
        ,pm.max_length              AS LengthSize  
        ,pm.precision               AS [Precision]  
    FROM   sys.parameters             AS pm  
        INNER JOIN sys.procedures  AS ps  
                ON  pm.object_id = ps.object_id  
        INNER JOIN sys.schemas s  
                ON  s.[schema_id] = ps.[schema_id]  
        INNER JOIN sys.types       AS t  
                ON  pm.system_type_id = t.system_type_id  
                AND pm.user_type_id = t.user_type_id  
    WHERE  s.name = 'dbo'  
        AND ps.name = 'Vessel_Create';  
  
  
    ----- ASSERT -------------------------------------------------  
  
    -- Assert to have th same table  
    EXEC tSQLt.AssertEqualsTable @Expected = '#expected', @Actual = '#actual';  
  