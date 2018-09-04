

SELECT SUM([Current Amount]) Amount
      ,LCOC.[Ops Category]
	  ,Region



  FROM [FM_OPERATIONS].[dbo].[Labor]
  left join FM_OPERATIONS.dbo.LaborCategory_OpsCategory LCOC on LCOC.[Labor Category] = labor.Category
  left join FM_OPERATIONS.dbo.Benchmarks BM on BM.[Cost Center] = Labor.[Org Level 1 Code]
  where [Pay Date] between '7-2-2016' and '6-30-2017' and Region IS NOT NULL and [Ops Category] IS NOT NULL
  Group by LCOC.[Ops Category], Region



  Select Distinct [Employee Number],AVG(nullif([Current Amount]/[Current Hours],0)) AS 'Hourly Rate',Category,Region


  INTO #T1
  FROM [FM_OPERATIONS].[dbo].[Labor]
  left join FM_OPERATIONS.dbo.LaborCategory_OpsCategory LCOC on LCOC.[Labor Category] = labor.Category
  left join FM_OPERATIONS.dbo.Benchmarks BM on BM.[Cost Center] = Labor.[Org Level 1 Code]
  where [Pay Date] between '7-2-2016' and '6-30-2017' and [Current Hours] <> 0 and Category in ('OT','Regular','On Call') and Region IS NOT NULL
  Group by [Employee Number],Category,Region
  order by [Employee Number]


  Select AVG([Hourly Rate]) Average_Rate,Region,Category

  From #T1
  Group by Region,Category
  order by Region