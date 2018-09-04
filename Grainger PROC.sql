USE ConsolidatedReports;

SELECT [Acct Number] as 'Sold-to-party'
      ,GSM.[Sold to Name]
	  ,GSM.Street
	  ,GSM.City
	  ,GSM.State
	  ,GSM.[Zip Code]
      ,[Bill Date]
	  ,Material
	  ,[Material Description] as Description
	  ,[Brand Name]
	  ,Case when [Material Segment] IS NULL Then 'Misc'
	  Else [Material Segment] END AS 'Material Segment'
	  ,Case when [Material Family Name PIT] IS NULL THEN 'Misc'
	  Else [Material Family Name PIT] END AS 'Material Family'
	  ,[Sales Order Number]
	  ,[PO Type]
	  ,[PO Type Description]
      ,[KeepStock] as 'Keepstock (Yes/No)'
      ,[Sales Office]
      ,[E-Commerce] as 'E-Commerce (Yes)'
      ,[UOM Quantity]
      ,[UOM Name] as UOM
	  ,[Bill Qty] as ' Order Quantity'
	  ,[Purchase Amt] / [Bill Qty] as 'Unit Price'
      ,[Purchase Amt] as 'Ext Price Amt'
      ,[Gr_Site_Code]
      ,[MFM_Site_Code]
      ,[MFM_Site_Name]
      ,[State2]
      ,MG.[Regional Director] as 'Regional_Director'
      ,MG.[AVP]
	  ,Case when PGM.[FM_Mapping_Segment] IS NULL Then 'Misc'
	        when [Material Family Name PIT] = 'Air Filters' Then 'Filters' --- Fix for filters not being in material segment ---
	   else PGM.[FM_Mapping_Segment] END AS 'FM_Mapping_Segment'
	  ,Case when PGM.[Summary_Mapping] IS NULL Then 'Misc'
	        when [Material Family Name PIT] = 'Air Filters' Then 'Filters' --- Fix for filters not being in material segment ---
	   else PGM.Summary_Mapping END AS 'Summary_Mapping'
  FROM [ConsolidatedReports].[dbo].[GraingerSpend]
  left join [ConsolidatedReports].[dbo].[Grainger - Site Mapping] GSM 
       on GSM.[Sold-to-Party] = [ConsolidatedReports].[dbo].[GraingerSpend].[Acct Number]
  left join [ConsolidatedReports].[dbo].[Grainger - Part Group Mapping] PGM 
       on PGM.Grainger_Material_Segment = GraingerSpend.[Material Segment]
  left join FM_Operations.dbo.NamingKey NK 
       on NK.INVENTSITEID = GSM.[MFM_Site_Code]
  left join FM_Operations.dbo.[Ministry Grouping] MG on MG.Ministry = NK.Minstry
	  
	  where [Bill Date] between @BeginDate and @EndDate