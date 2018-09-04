USE FM_OPERATIONS

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [LocationDescription]
      ,IDCustomerSegment
      ,Replace([Hierarchy],'.','') [ID Location]
	  ,AXCostCode
	  into #T1
  FROM [CMS].[dbo].[Location]
  join FM_OPERATIONS.dbo.xRef_MasterFile XREF 
			on XREF.CMSSegmentID = Location.IDCustomerSegment
 where level = 0


SELECT DISTINCT [VALUE]
               ,[NAME]
INTO #T2
FROM [AX_Target].[dbo].[DIMATTRTRANSLFINANCIALTAG]

where Category = 5637144827 and [VALUE] >='810100' and [VALUE]  like '%[0-9]%' and [VALUE] NOT IN ('820300','820400','901000','901001')
order by Value ASC



-- DataSet

SELECT [MOB FTE].[ID Location]
      ,Sum([Time Charge Hours]) [Total Hours]
	  ,Sum([Time Charge Hours]/2080) FTE
	  ,#T1.LocationDescription
	  ,#T1.AXCostCode
	  ,[Is Main Hospital?]
	  ,#T2.NAME
	  ,LOC.Address
	  ,MOBI.[Building SF]

	  
  FROM [FM_OPERATIONS].[dbo].[MOB FTE]
  
  inner join  #T1 on #T1.[ID Location] = [MOB FTE].[ID Location]
  left join Locations LOC on LOC.[ID Location] = [MOB FTE].[ID Location]
  left join #T2 on #T2.VALUE = #T1.AXCostCode
  left join [FM_OPERATIONS].[dbo].[MOB Inventory] MOBI on MOBI.[Off Site Address] = LOC.Address
  
  where  ((#T1.LocationDescription LIKE '%mob%' OR #T1.LocationDescription LIKE '%center%'OR #T1.LocationDescription LIKE '%pavillion%' OR #T1.LocationDescription LIKE '%therapy%' 
      OR #T1.LocationDescription LIKE '%surgery%' OR #T1.LocationDescription LIKE '%clinic%'OR #T1.LocationDescription LIKE '%office%' OR #T1.LocationDescription LIKE '%immediate%'OR #T1.LocationDescription LIKE '%urgent%'
	  OR #T1.LocationDescription LIKE '%practice%' OR #T1.LocationDescription LIKE '%rehab%'OR #T1.LocationDescription LIKE '%medicine%' OR #T1.LocationDescription LIKE '%pediatric%'OR #T1.LocationDescription LIKE '%health%'
	  OR #T1.LocationDescription LIKE '%plaza%' OR #T1.LocationDescription LIKE '%lab%'OR #T1.LocationDescription LIKE '%institute%' OR #T1.LocationDescription LIKE '%physical%'OR #T1.LocationDescription LIKE '%hospice%'
	  OR #T1.LocationDescription LIKE  '%house%') and [Is Main Hospital?] = 'No' and [Time Charge Hours] between 500 and 2500 /*and #T1.AXCostCode like '8705%'  <----- Just MOBs in Oklahoma */)
 
  group by [MOB FTE].[ID Location],#T1.LocationDescription,#T1.AXCostCode,[Is Main Hospital?],#T2.NAME,LOC.Address,MOBI.[Building SF]
  
  order by [Total Hours] DESC