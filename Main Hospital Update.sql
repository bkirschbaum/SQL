/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [ID]
      ,[AXCostCode]
      ,[SegmentName]
      ,[IdCustomerSegment]
      ,[LocationDescription]
      ,[Address]
      ,[Comments]
      ,[ID Location]
      ,[Is Main Hospital?]
  FROM [FM_OPERATIONS].[dbo].[Locations]
  where [ID Location] = 150418
 --- where AXCostCode = 830500
  order by [ID Location]



  Begin Tran

  Update Locations
  Set [Is Main Hospital?] = 'Yes'
  where LocationDescription like '%Plant%'

  Commit Tran
