CREATE PROC [TestBasic].[test If table dbo.Operator exists]  
AS  
/*  
<documentation>  
  <author>ABM040</author>  
  <summary>test if dbo.Operator exists</summary>  
  <returns>nothing</returns>  
</documentation>  
  
Changes:  
Date  Who      Notes  
---------- ---      --------------------------------------------------------------  
20210714 ABM040        Creation  
*/  
    SET NOCOUNT ON;  
  
    ----- ASSERT -------------------------------------------------  
    EXEC tSQLt.AssertObjectExists @ObjectName = N'dbo.Operator';  