/****** Script for SelectTopNRows command from SSMS  ******/
SELECT Cost_Center
      ,Sector
	  ,BM.Region
	  ,BM.[Footage Grouping]
	  ,BM.Beds
	  ,BM.[Year Built]
	  ,Cost_Center + Sector AS IndexCode
      ,[Service_Supplies_Labor_Depreciation]
      ,Sum([Amount]) Total
	  ,BM.[Bed Grouping]
	  ,BM.UnionSite


FROM [FM_OPERATIONS].[dbo].[FY17GLDEV]
left join FM_Operations.dbo.Benchmarks BM on BM.[Cost Center] = FY17GLDEV.Cost_Center

where [Service_Supplies_Labor_Depreciation] <> 'Depreciation' and Cost_Center not in (901000) and Trade IS NOT NULL and [IS_ABR] = 'No'

Group by 
       Cost_Center
      ,Sector
      ,[Service_Supplies_Labor_Depreciation]
	  ,BM.Region
	  ,BM.[Footage Grouping]
	  ,BM.Beds
	  ,BM.[Year Built]
	  ,BM.[Bed Grouping]
	  ,BM.UnionSite

order by Cost_Center, Sector