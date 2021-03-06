/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) CorporateAllocations.[Cost Center]
      ,[Salary Allocation]/12 Monthly_Allocation
      ,[Sector]
      ,[Trade]
	  ,NK.Minstry
	  ,MG.[Ministry Grouping]
  FROM [FM_OPERATIONS].[dbo].[CorporateAllocations]
  left join NamingKey NK on NK.[Cost Center] = CorporateAllocations.[Cost Center]
  left join [Ministry Grouping] MG on MG.Ministry = NK.Minstry
  where CorporateAllocations.[Cost Center] not in ('800800','800900')
  order by CorporateAllocations.[Cost Center], Sector


 