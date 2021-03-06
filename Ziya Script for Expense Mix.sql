/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [Service_Supplies_Labor_Depreciation]
      ,FY17GL.[Cost_Center]
      ,Sum(FY17GL.[Amount]/#T1.Amount) Amount
  FROM [FM_OPERATIONS].[dbo].[FY17GL]
  inner join #T1 on #T1.Cost_Center = FY17GL.Cost_Center
  where [Service_Supplies_Labor_Depreciation] not in ('Depreciation') and [IS_ABR] = 'No'

  Group by [Service_Supplies_Labor_Depreciation]
           ,FY17GL.[Cost_Center]
  order by FY17GL.Cost_Center


SELECT [Cost_Center]
      ,Sum([Amount]) Amount
INTO #T1
  FROM [FM_OPERATIONS].[dbo].[FY17GL]
  where [Service_Supplies_Labor_Depreciation] not in ('Depreciation') and [IS_ABR] = 'No'

  Group by Cost_Center
  order by Cost_Center


Select * from #T1



