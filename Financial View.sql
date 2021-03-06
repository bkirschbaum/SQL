/****** ALL AX ACCOUNTS  ******/
SELECT Distinct 1000 [KEY_]
      ,[CATEGORY]
      ,[VALUE]
      ,[NAME]
      ,[PARTITION]
      ,[RECID]
      ,[PARTITION#3]
      ,[TRANSLATEDNAME]
  FROM [AX_Target].[dbo].[DIMATTRTRANSLFINANCIALTAG]
  where Category = 5637144827
  order by Value ASC




  /****** Just AX COST CENTERS ******/
SELECT Distinct 1000 [KEY_]
      ,[CATEGORY]
      ,[VALUE]
      ,[NAME]
      ,[PARTITION]
      ,[RECID]
      ,[PARTITION#3]
      ,[TRANSLATEDNAME]
  FROM [AX_Target].[dbo].[DIMATTRTRANSLFINANCIALTAG]

  where Category = 5637144827 and [VALUE] >='810100' and [VALUE]  like '%[0-9]%' and [VALUE] NOT IN ('820300','820400','901000','901001')
  order by Value ASC

