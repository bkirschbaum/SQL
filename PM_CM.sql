USE CMS


--- PMs ---

SELECT  

xref.AXCostCode as 'Cost Center',
month(wod.dateCreated) Month,
year(wod.dateCreated) Year,  
'PM' Type,
count(distinct woa.idworkorder) as TotalWOs, 
sum(case when idwostatus not in (107) then 1 else 0 end) as WOOpen, 
sum(case when idwostatus in (107) then 1.0 else 0.0 end) /  count(woa.idworkorder) as PercentageComplete,
C2.[Description] AS Classification

FROM
CMS.dbo.Asset AC2 WITH(NOLOCK)

right outer join CMS.dbo.Classification C2 WITH(NOLOCK)  on  AC2.IDClassification = CAST(C2.IDClassification AS VARCHAR)
and description is not null
right outer JOIN CMS.dbo.WorkOrderAsset WOA WITH(NOLOCK) on WOA.IDAsset = AC2.IDAsset
left outer join cms.dbo.WorkOrderdates wod with (nolock) on wod.idworkorder = woa.idworkorder
JOIN CMS.DBO.WorkOrder wo with (nolock) on wo.idworkorder = wod.idworkorder and idwostatus not in (114)
join FM_OPERATIONS.dbo.CMSAXWalk xref on xref.cmssegmentid = ac2.idcustomersegment

where (month(wod.dateCreated)>9 and year(wod.dateCreated)=2017)
and (idWoCategory is not null and idWoCategory =530)

group by  c2.description,month(wod.dateCreated) ,year(wod.dateCreated), xref.AXCostCode
order by  c2.description



SELECT  
xref.AXCostCode as 'Cost Center',
month(wod.dateCreated) Month,
year(wod.dateCreated) Year,
'CM' Type,  
count(distinct wo.idworkorder) as TotalWOs, 
sum(case when idwostatus not in (107) then 1 else 0 end) as WOOpen, 
sum(case when idwostatus in (107) then 1.0 else 0.0 end) /  count(wo.idworkorder) as PercentageComplete,
Concat('Priority ',LEFT(PRI.PriorityDescription,1)) AS Priority


FROM
CMS.DBO.WorkOrder wo  
left outer join cms.dbo.WorkOrderdates wod with (nolock) on wod.idworkorder = wo.idworkorder
join FM_OPERATIONS.dbo.xref_masterfile xref on xref.cmssegmentid = wo.idcustomersegment
join CMS.dbo.Category CAT on CAT.IDCategory = wo.idWoCategory
join (Select * from CMS.dbo.Priority where IDCustomer = 11) PRI on PRI.IDPriority = wo.IDWOPriority
where (month(wod.dateCreated)>6 and year(wod.dateCreated)=2017)
and idwostatus not in (114)

and CAT.HierarchyString like '%Corrective%'

group by xref.AXCostCode,  month(wod.dateCreated) ,year(wod.dateCreated), Concat('Priority ',LEFT(PRI.PriorityDescription,1))
order by xref.AXCostCode, month(wod.dateCreated),Concat('Priority ',LEFT(PRI.PriorityDescription,1))


