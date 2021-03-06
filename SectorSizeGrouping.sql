/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [Sector]
      ,[Cost_Center]
	  ,[sq footage]
      ,Sum([Amount]) Amount
	  ,Sum(Amount/[sq footage]) AmountSqFt
	  ,[Footage Grouping]

  FROM [FM_OPERATIONS].[dbo].[FY17GLDEV]
  inner join Benchmarks BM ON BM.[Cost Center] = FY17GLDEV.Cost_Center
  where [Footage Grouping] IS NOT NULL and [Footage Grouping] <> 'No Sq. Footage' and Sector is not null

  Group by [Sector],[Cost_Center],[Footage Grouping],[sq footage]
  order by [Footage Grouping],Sector,Cost_Center