CREATE PROCEDURE [TestBasic].[test If table dbo.Vessel has the correct columns]  
AS  
/*  
<documentation>  
  <author>ABM040</author>  
  <summary>test if dbo.Vessel has the correct columns</summary>  
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
        [ColumnName] sysname NOT NULL,  
        [DataType] sysname NOT NULL,  
        [LengthSize] SMALLINT NOT NULL,  
        [Precision] TINYINT NOT NULL  
    );  
  
    CREATE TABLE #expected  
    (  
        [ColumnName] sysname NOT NULL,  
        [DataType] sysname NOT NULL,  
        [LengthSize] SMALLINT NOT NULL,  
        [Precision] TINYINT NOT NULL  
    );  
  
    INSERT INTO #expected  
    (  
        ColumnName  
    ,DataType  
    ,LengthSize  
    ,Precision  
    )  
    VALUES  
    (  
        'VesselID'  -- ColumnName - sysname  
        ,'int'   -- DataType - sysname  
        ,4    -- LengthSize - smallint  
        ,10    -- Precision - tinyint  
    ),  
    (  
        'VesselCode' -- ColumnName - sysname  
    ,'char'   -- DataType - sysname  
    ,3    -- LengthSize - smallint  
    ,0    -- Precision - tinyint  
    ),  
    (  
        'VesselName' -- ColumnName - sysname  
    ,'varchar'  -- DataType - sysname  
    ,30    -- LengthSize - smallint  
    ,0    -- Precision - tinyint  
    ),  
    (  
        'TEU'   -- ColumnName - sysname  
    ,'int'   -- DataType - sysname  
    ,4    -- LengthSize - smallint  
    ,10    -- Precision - tinyint  
    ),  
    (  
        'Plug'   -- ColumnName - sysname  
    ,'int'   -- DataType - sysname  
    ,4    -- LengthSize - smallint  
    ,10    -- Precision - tinyint  
    ),  
    (  
        'OperatorID' -- ColumnName - sysname  
    ,'int'   -- DataType - sysname  
    ,4    -- LengthSize - smallint  
    ,10    -- Precision - tinyint  
    );  
    ----- ACT ----------------------------------------------------  
  
    INSERT INTO #actual  
    (  
        ColumnName  
    ,DataType  
    ,LengthSize  
    ,Precision  
    )  
    SELECT c.name                  AS ColumnName  
        ,st.name                 AS DataType  
        ,c.max_length            AS LengthSize  
        ,c.precision             AS [Precision]  
    FROM   sys.columns             AS c  
        INNER JOIN sys.tables   AS t ON  t.object_id = c.object_id  
        INNER JOIN sys.schemas  AS s ON  s.schema_id = t.schema_id  
        LEFT JOIN sys.types     AS st ON  st.user_type_id = c.user_type_id  
    WHERE  t.type = 'U'  
        AND s.name = 'dbo'  
        AND t.name = 'Vessel'  
    ORDER BY  
        t.name  
        ,c.name  
  
  
    ----- ASSERT -------------------------------------------------  
  
    -- Assert to have th same table  
    EXEC tSQLt.AssertEqualsTable @Expected = '#expected', @Actual = '#actual';  
  