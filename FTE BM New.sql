/****** Script for SelectTopNRows command from SSMS  ******/

Select a.Trade,a.Employee_Count,a.[Department Code (OrgLvl1)],a.Department,a.AXCostCode,a.[Sq Footage],a.Coverage,a.[Footage Grouping]

from (
SELECT Trade
      ,Count([Employee Number]) Employee_Count
      ,[Department Code (OrgLvl1)]
      ,[Department]
	  ,XREF.AXCostCode
	  ,BM.[Sq Footage]
	  ,[Sq Footage] / Count([Employee Number]) Coverage
	  ,BM.[Footage Grouping]
	  

  FROM [FM_OPERATIONS].[dbo].[NEM]
  
  inner join NewTitles NT on NT.[Job Code] = NEM.[Job Code]
  left join xRef_MasterFile XREF on XREF.NewAXCostCode = NEM.[Department Code (OrgLvl1)]
  left join Benchmarks BM on BM.[Cost Center] = XREF.AXCostCode
  where [Department Code (OrgLvl1)] like '2%' and department not like '%propert%'
  
  group by Trade,[Department Code (OrgLvl1)],Department,XREF.AXCostCode,BM.[Sq Footage],BM.[Footage Grouping]
  ) a
  where a.AXCostCode is not null
  order by a.AXCostCode