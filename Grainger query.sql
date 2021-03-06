/****** Script for SelectTopNRows command from SSMS  ******/



Select a.*, PGM.[FM_Mapping_Segment],PGM.[Summary_Mapping]


From 

(

SELECT  GSM.[Sold-to-party]
      ,GSM.[Sold to Name]
	  ,GSM.Street,GSM.City,GSM.State,GSM.[Zip Code]
      ,[Bill Date]
	  ,[Bill Date] AS Month
      ,[Material]
      ,[Material Description] Description
      ,[Brand Name]
      ,Case When [Material Segment] IS NULL Then 'Misc'
	        When [Material Segment] = 'UNCATEGORIZED' Then 'Misc'
	  Else [Material Segment] END AS [Material Segment]
	  ,'Material Family???' as Material_Family
      ,[Sales Order Number]
	  ,'PO Type?' AS PO_Type
	  ,'PO Type Description?' AS PO_Description/* This will be a case statement 12 = Grainger.com, 24 = VMI GCOM  There are more apparently*/
	  ,'Keepstock (Yes/No)' AS Keepstock
	  ,'Sales Office' AS Sales_Office
	  ,'E-Commerce (Yes)' AS E_Commerce
	  ,[UOM Quantity]
      ,[UOM Name] UOM
      ,[Bill Qty] as 'Order Quantity'
	  ,[Purchase Amt]/[UOM Quantity] as 'Unit Price'
      ,[Purchase Amt] as 'Ext Price Amt'
	  ,GSM.[Gr_Site_Code]
	  ,GSM.[MFM_Site_Code]
	  ,GSM.[MFM_Site_Name]
	  ,GSM.State2
	  ,GSM.Regional_Director
	  ,GSM.AVP
	  

  FROM [ConsolidatedReports].[dbo].[Grainger]
  left join [ConsolidatedReports].[dbo].[Grainger - Site Mapping] GSM on GSM.[Sold-to-party] = [ConsolidatedReports].[dbo].[Grainger].[Acct Number]

  ) a
 
 left join [ConsolidatedReports].[dbo].[Grainger - Part Group Mapping] PGM on PGM.[Grainger_Material_Segment] = a.[Material Segment]
 where a.[MFM_Site_Name] NOT IN ('Medxcel CO','Medxcel Construction')
