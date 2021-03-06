/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [ID]
      ,[Cost Center]
      ,[SubID]
      ,[Site Name]
      ,[Turf (SQFT)]
      ,[Tree(EA)]
      ,[Parking Lot (SQFT)]
      ,[Beds(SQFT)]
      ,[Sidewalk]
      ,[Ponds]
      ,[Roadway]
      ,[Native]
      ,[Construction Turf]
      ,[Comments]
	  INTO #T1
  FROM [FM_OPERATIONS].[dbo].[Landscaping]
  where SubID = 0 and [Turf (SQFT)] is not null

SELECT FY17GL.[Cost_Center]
      ,NK.Site_Name
      ,Sum([Amount]) Amount
	  ,Sum([Amount]/[Turf (SQFT)]) as 'Amount / Turf SQFT'
	  ,[Turf (SQFT)]
      ,FY17GL.[Minstry]
      ,[Ministry Grouping]
      ,[Regional Director]
      ,[AVP]
	  
  FROM [FM_OPERATIONS].[dbo].[FY17GL]
  left join NamingKey NK on NK.[Cost Center] = FY17GL.Cost_Center
  left join #T1 on #T1.[Cost Center] = FY17GL.Cost_Center
  where  Trade = 'Landscaping' and [IS_ABR] = 'No' and Cost_Center 
  
  IN (SELECT [Cost Center]

  FROM [FM_OPERATIONS].[dbo].[Landscaping]
  where [Turf (SQFT)] is not null and SubID = 0)

  Group by FY17GL.[Minstry]
      ,[Ministry Grouping]
      ,[Regional Director]
      ,[AVP]
	  ,FY17GL.[Cost_Center]
	  ,NK.Site_Name
	  ,[Turf (SQFT)]

	  order by FY17GL.Cost_Center
