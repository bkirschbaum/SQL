/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [Cost_Center]
      ,NK.Site_Name
      ,BM.Region
      ,BM.[Sq Footage]
	  ,BM.Accred_Type_Tier1
	  ,BM.[Bed Grouping]
	  ,BM.UnionSite
	  ,BM.[Footage Grouping]
      ,[Service_Supplies_Labor_Depreciation]
      
      ,Sum([Amount]/BM.[Sq Footage]) Total

  FROM [FM_OPERATIONS].[dbo].[FY17GLDEV]
  left join NamingKey NK on NK.[Cost Center] = FY17GLDEV.Cost_Center
  left join Benchmarks BM on BM.[Cost Center] = FY17GLDEV.Cost_Center
  where [IS_ABR] = 'No' and ([Is Main Hospital?] = 'Yes' or [Is Main Hospital?] IS NULL)  and [Service_Supplies_Labor_Depreciation] IN ('Service','Supplies', 'Labor','Other Expenses') and Trade IN ('Life Safety')
  Group by [Cost_Center]
      ,BM.Region
	  ,BM.Accred_Type_Tier1
	  ,BM.[Bed Grouping]
	  ,BM.UnionSite
	  ,BM.[Footage Grouping]
      ,[Service_Supplies_Labor_Depreciation]
	  ,NK.Site_Name
          ,BM.[Sq Footage]
  Order by Cost_Center


