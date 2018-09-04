


SELECT Sum([Purchase Amt]) as 'Ext Price Amt'
      ,[Gr_Site_Code]
	  ,MFM_Site_Code
	  ,NK.[Cost Center]
	  ,xREF.CMSSegmentID

  FROM [ConsolidatedReports].[dbo].[GraingerSpend]
  left join [ConsolidatedReports].[dbo].[Grainger - Site Mapping] GSM 
       on GSM.[Sold-to-Party] = [ConsolidatedReports].[dbo].[GraingerSpend].[Acct Number]
  left join [ConsolidatedReports].[dbo].[Grainger - Part Group Mapping] PGM 
       on PGM.Grainger_Material_Segment = GraingerSpend.[Material Segment]
  left join FM_Operations.dbo.NamingKey NK 
       on NK.INVENTSITEID = GSM.[MFM_Site_Code]
  left join FM_Operations.dbo.[Ministry Grouping] MG 
	   on MG.Ministry = NK.Minstry
  left join FM_OPERATIONS.dbo.xRef_MasterFile xREF
	   on xREF.AXCostCode = NK.[Cost Center]
	    
  where [Bill Date] between '7-1-2016' and '6-30-2017' and CMSSegmentID IS NOT NULL

  Group by [Gr_Site_Code]
	  ,NK.[Cost Center]
	  ,MFM_Site_Code
	  ,xREF.CMSSegmentID