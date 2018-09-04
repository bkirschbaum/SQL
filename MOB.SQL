USE FM_OPERATIONS




/*With more key words*/

SELECT Minstry AS Ministry,Cost_Center, idlocation,l.LocationDescription,l.Address,SUM(Amount) AS [Total Cost],l.[Is Main Hospital?]
INTO #T1
FROM [FM_OPERATIONS].[dbo].[FY17GLDEV]
left join Locations L on L.[ID Location] = FY17GLDEV.idlocation
WHERE (location LIKE '%mob%' OR location LIKE '%center%'OR location LIKE '%pavillion%' OR location LIKE '%therapy%' 
      OR location LIKE '%surgery%' OR location LIKE '%clinic%'OR location LIKE '%office%' OR location LIKE '%immediate%'OR location LIKE '%urgent%'
	  OR location LIKE '%practice%' OR location LIKE '%rehab%'OR location LIKE '%medicine%' OR location LIKE '%pediatric%'OR location LIKE '%health%'
	  OR location LIKE '%plaza%' OR location LIKE '%lab%'OR location LIKE '%institute%' OR location LIKE '%physical%'OR location LIKE '%hospice%'
	  OR location LIKE  '%house%') AND IS_ABR = 'No' AND l.[Is Main Hospital?] <> 'Yes' and Cost_Center <> 901000
GROUP BY Minstry,Cost_Center,idlocation,l.LocationDescription,l.Address,l.[Is Main Hospital?]
ORDER BY [total cost] DESC




--- Looks at #T1 to determine if there are any duplicates via address or service refs in more than one cost center
SELECT *,ROW_NUMBER() OVER(PARTITION BY #T1.Address ORDER BY #T1.Address) duplicateCounter

FROM #T1 LEFT OUTER JOIN [FM_OPERATIONS].[dbo].[MOB Inventory] ON #T1.LocationDescription =[FM_OPERATIONS].[dbo].[MOB Inventory].[Off Site Name]
WHERE Cost_Center <> 901000


--- Throws the duplicate Counter into a table to eliminate all idlocations that are duplicated via cost center and address ---
SELECT *,ROW_NUMBER() OVER(PARTITION BY #T1.Address ORDER BY #T1.Address) duplicateCounter

FROM #T1 LEFT OUTER JOIN [FM_OPERATIONS].[dbo].[MOB Inventory] ON #T1.Address =[FM_OPERATIONS].[dbo].[MOB Inventory].[Off Site Address]
WHERE Cost_Center <> 901000 and Cost_Center like '8705%'




--- Eliminates any rows that seem to be duplicated uses the duplicateCounter created in Line 31 ---
Select L.SegmentName as 'Segment Name',#T2.idlocation, L.IdCustomerSegment, [Total Cost] as 'Service Cost',Case when #T2.[Building SF] IS NULL then '' else #T2.[Building SF] end as 'Sq. Footage', L.LocationDescription as 'Location Name'

from #T2
left join Locations L on L.[ID Location] = #T2.idlocation

where #T2.idlocation not in (Select Distinct idlocation from #T1 where duplicateCounter = 2) order by #T2.[Total Cost] DESC



 

