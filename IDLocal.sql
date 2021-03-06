/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [LocationDescription]
      ,IDCustomerSegment
      ,Replace([Hierarchy],'.','') [ID Location]
	  ,AXCostCode

  FROM [CMS].[dbo].[Location]
  left join FM_OPERATIONS.dbo.xRef_MasterFile XREF 
			on XREF.CMSSegmentID = Location.IDCustomerSegment
 where level = 0