/****** Script for SelectTopNRows command from SSMS  ******/
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
	  ,[Material Segment]
	  ,[Material Family Name PIT] as 'Material Family'
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
	  ,Case when PGM.[FM_Mapping_Segment] IS NULL Then 'Misc'
	   else PGM.[FM_Mapping_Segment] END AS 'FM_Mapping_Segment'
	  ,Case when PGM.[Summary_Mapping] IS NULL Then 'Misc'
	   else PGM.Summary_Mapping END AS 'Summary_Mapping'
  FROM [ConsolidatedReports].[dbo].[GraingerSpend]
  left join [ConsolidatedReports].[dbo].[Grainger - Site Mapping] GSM 
       on GSM.[Sold-to-Party] = [ConsolidatedReports].[dbo].[GraingerSpend].[Acct Number]
  left join [ConsolidatedReports].[dbo].[Grainger - Part Group Mapping] PGM 
       on PGM.Grainger_Material_Segment = GraingerSpend.[Material Segment]