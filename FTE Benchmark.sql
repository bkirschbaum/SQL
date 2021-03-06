/****** Script for SelectTopNRows command from SSMS  ******/



Select a.[Department Code (OrgLvl1)],Count(a.[Employee Number]) as FTE_Count,a.Trade,a.[ASHE Footage Grouping],a.[Footage Grouping]
      
from 

(

SELECT Case when NPT.Trade IS NULL then TAK.Trade else NPT.Trade end as 'Trade'
      ,[Job]
      ,[Last Name]
      ,[First Name]
      ,[Preferred First Name]
      ,[Employee Number]
      ,[Department Code (OrgLvl1)]
      ,[ICIMS Replacing]
      ,[Position ID]
      ,[Employee Number (INT)]
	  ,BM.[Footage Grouping]
	  ,BM.[ASHE Footage Grouping]
	  ,BM.[Sq Footage]
  FROM [FM_OPERATIONS].[dbo].[Position Master]
  left join FM_OPERATIONS.dbo.[New Position Titles] NPT 
  on NPT.[Job Title] = [Position Master].Job
  left join TitleAsheKey TAK
  on TAK.[Position Title] = [Position Master].Job
  left join Benchmarks BM on BM.[Cost Center] = [Position Master].[Department Code (OrgLvl1)]

  where [Department Code (OrgLvl1)] >= 810100 and BM.[Footage Grouping] <> 'No Sq. Footage'

  ) a where a.Trade is not null

  Group by a.Trade , a.[Department Code (OrgLvl1)],a.[ASHE Footage Grouping],a.[Footage Grouping]
  order by a.[Department Code (OrgLvl1)]