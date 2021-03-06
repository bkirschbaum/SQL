/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [Org Level 1 Code] Cost_Center
      ,Month([Pay Date]) Month
	  ,Year([Pay Date]) Year
 	  ,[Ops Category]
	  ,TAK.Sector
	  ,TAK.Trade
	  ,Sum([Current Amount])*1.3/BM.[Sq Footage]*12 as 'Current Amount w/Benefits'
	  ,BM.[Sq Footage]
	  ,BM.[Footage Grouping]
	  ,BM.Beds
	  ,BM.Region
	  ,BM.[Year Built]

  FROM [FM_OPERATIONS].[dbo].[Labor]
  inner join [FM_OPERATIONS].[dbo].[LaborCategory_OpsCategory] CAT on CAT.[Labor Category] = Labor.Category
 left join [FM_OPERATIONS].[dbo].[TitleAsheKey] TAK on TAK.[Position Title] = Labor.[Job Title]
 left join FM_Operations.dbo.NamingKey NK on NK.[Cost Center] = Labor.[Org Level 1 Code]
 left join FM_Operations.dbo.[Ministry Grouping] MG on MG.Ministry = NK.Minstry 
 left join FM_Operations.dbo.Benchmarks BM on BM.[Cost Center] = Labor.[Org Level 1 Code]

  where [Pay Date] between '7-1-2016' and '5-31-2017' and  [Org Level 1 Code] >= '810100'

  Group by [Org Level 1 Code], Year([Pay Date]), Month([Pay Date]), [Ops Category]	,TAK.Sector,TAK.Trade,BM.[Sq Footage],BM.[Footage Grouping],BM.Beds,BM.Region,BM.[Year Built]
  order by [Org Level 1 Code], Year([Pay Date]), Month([Pay Date])

