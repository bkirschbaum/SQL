/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [DISPLAYVALUE]
      ,[DEFAULTDIMENSION]
      ,DAE.[PARTITION]
      ,DAE.[RECID]
      ,[ENTITYINSTANCE]
      ,[PARTITION#2]
      ,DAE.[REPORTCOLUMNNAME]
      ,[DIMENSIONATTRIBUTEID]
      ,[BACKINGENTITYTYPE]
      ,[KEYATTRIBUTE]
      ,[NAMEATTRIBUTE]
      ,[NAME]
      ,[PARTITION#3]
  FROM [AxDB].[dbo].[DEFAULTDIMENSIONVIEW]
  inner join DIMENSIONATTRIBUTEENTITY DAE on DAE.DIMENSIONATTRIBUTERECID = [DEFAULTDIMENSIONVIEW].DIMENSIONATTRIBUTEID
  where defaultdimension = 5637145050
