



USE FM_Operations;


--- Creating the Base Table ---

Create Table #Base (Cost_Center nvarchar(6),Sector varchar (30))

Insert Into #Base

Select [Cost Center], ST.Sector 
from FM_Operations.dbo.NamingKey NK
Cross Join Sector_Trade ST 
where [Cost Center] <> 0
order by [Cost Center],Sector

--- Creating a Service Only Table

Create Table #Service (Cost_Center nvarchar(6),Sector varchar (30),Amount Float)

Insert Into #Service

SELECT  Cost_Center,Cast(Sector as varchar(30)),Sum(Amount) Amount
/* Add INTO to add to a New Table */
From ( 

Select 

NK.[Cost Center] Cost_Center,Month(VTRANS.LASTSETTLEDATE) Month, Year(VTRANS.LASTSETTLEDATE) Year,VIJ.INVOICEAMOUNT Amount,IDST.Service_Supplies Service_Supplies,IDST.Sector Sector,IDST.Trade Trade,ABRS.ABR,ROW_NUMBER() OVER(PARTITION BY VIJ.RECID ORDER BY VIJ.RECID) duplicateCounter

FROM AX_Target.dbo.VENDINVOICEJOUR VIJ
INNER JOIN AX_Target.dbo.VENDTRANS  VTRANS on VIJ.LEDGERVOUCHER = VTRANS.VOUCHER
LEFT JOIN ConsolidatedReports.dbo.Purchasing_View PV on PV.Purchase_Order = VIJ.PURCHID
LEFT JOIN AX_Target.dbo.PURCHLINE PL on PV.INVENTTRANSID = PL.INVENTTRANSID
LEFT JOIN AX_Target.dbo.PURCHREQTABLE PRT ON PL.PURCHREQID = PRT.PURCHREQID
LEFT JOIN AX_Target.dbo.MXLPurchLine MXLPL ON MXLPL.INVENTTRANSID = PL.INVENTTRANSID 
LEFT JOIN AX_Target.dbo.PURCHTABLE PT ON PV.Purchase_Order = PT.PURCHID 
LEFT JOIN AX_Target.dbo.VENDTABLE VTable ON PV.Vendor_Account = VTable.ACCOUNTNUM 
LEFT JOIN FM_OPERATIONS.dbo.Item_Description_Sector_Trade IDST on PV.Item_description = IDST.Item_Description
LEFT JOIN FM_OPERATIONS.dbo.[NamingKey] NK on NK.INVENTSITEID = PT.INVENTSITEID
LEFT JOIN FM_OPERATIONS.dbo.[Ministry Grouping] MG on NK.Minstry = MG.Ministry
LEFT JOIN FM_OPERATIONS.dbo.ABRs on ABRs.PURCHID = VIJ.PURCHID
LEFT JOIN FM_OPERATIONS.dbo.ServiceRef SR on PV.Service_ref = SR.[Service Ref]
LEFT JOIN FM_OPERATIONS.dbo.Locations L on L.[ID Location] = SR.[Id Location]

WHERE        (VTRANS.LASTSETTLEDATE BETWEEN CONVERT(DATETIME, '2016-07-01 00:00:00', 102) AND CONVERT(DATETIME, '2017-6-30 00:00:00', 102)) AND 
                         (VIJ.PURCHID LIKE N'MFAC%') and PV.Vendor_Name not like '%Grainger%' and IDST.Service_Supplies = 'Service' and ABRS.ABR IS NULL and NK.Site_Name not like '%Properties%' and L.[Is Main Hospital?] = 'Yes'
						 
						 )

a

where duplicateCounter = 1 and Cost_Center > 0 and Cost_Center like '%[0-9]%'

Group by Cost_Center,Sector
order by Cost_Center,Sector

--- Creating a Supplies Only Table

Create Table #Supplies (Cost_Center nvarchar(6),Sector varchar (30),Amount Float)

Insert Into #Supplies

SELECT  Cost_Center,Cast(Sector as varchar(30)),Sum(Amount) Amount
/* Add INTO to add to a New Table */
From ( 

Select 

NK.[Cost Center] Cost_Center,Month(VTRANS.LASTSETTLEDATE) Month, Year(VTRANS.LASTSETTLEDATE) Year,VIJ.INVOICEAMOUNT Amount,IDST.Service_Supplies Service_Supplies,IDST.Sector Sector,IDST.Trade Trade,ABRS.ABR,ROW_NUMBER() OVER(PARTITION BY VIJ.RECID ORDER BY VIJ.RECID) duplicateCounter

FROM AX_Target.dbo.VENDINVOICEJOUR VIJ
INNER JOIN AX_Target.dbo.VENDTRANS  VTRANS on VIJ.LEDGERVOUCHER = VTRANS.VOUCHER
LEFT JOIN ConsolidatedReports.dbo.Purchasing_View PV on PV.Purchase_Order = VIJ.PURCHID
LEFT JOIN AX_Target.dbo.PURCHLINE PL on PV.INVENTTRANSID = PL.INVENTTRANSID
LEFT JOIN AX_Target.dbo.PURCHREQTABLE PRT ON PL.PURCHREQID = PRT.PURCHREQID
LEFT JOIN AX_Target.dbo.MXLPurchLine MXLPL ON MXLPL.INVENTTRANSID = PL.INVENTTRANSID 
LEFT JOIN AX_Target.dbo.PURCHTABLE PT ON PV.Purchase_Order = PT.PURCHID 
LEFT JOIN AX_Target.dbo.VENDTABLE VTable ON PV.Vendor_Account = VTable.ACCOUNTNUM 
LEFT JOIN FM_OPERATIONS.dbo.Item_Description_Sector_Trade IDST on PV.Item_description = IDST.Item_Description
LEFT JOIN FM_OPERATIONS.dbo.[NamingKey] NK on NK.INVENTSITEID = PT.INVENTSITEID
LEFT JOIN FM_OPERATIONS.dbo.[Ministry Grouping] MG on NK.Minstry = MG.Ministry
LEFT JOIN FM_OPERATIONS.dbo.ABRs on ABRs.PURCHID = VIJ.PURCHID
LEFT JOIN FM_OPERATIONS.dbo.ServiceRef SR on PV.Service_ref = SR.[Service Ref]
LEFT JOIN FM_OPERATIONS.dbo.Locations L on L.[ID Location] = SR.[Id Location]

WHERE        (VTRANS.LASTSETTLEDATE BETWEEN CONVERT(DATETIME, '2016-07-01 00:00:00', 102) AND CONVERT(DATETIME, '2017-6-30 00:00:00', 102)) AND 
                         (VIJ.PURCHID LIKE N'MFAC%') and PV.Vendor_Name not like '%Grainger%' and IDST.Service_Supplies = 'Supplies' and ABRS.ABR IS NULL and NK.Site_Name not like '%Properties%' and L.[Is Main Hospital?] = 'Yes'
)

a

where duplicateCounter = 1 and Cost_Center > 0 and Cost_Center like '%[0-9]%'

Group by Cost_Center,Sector
order by Cost_Center,Sector


--- Grainger Expenses Tracked here ---

Create Table #Grainger (Cost_Center nvarchar(6),Sector varchar (30),Amount Float)

Insert Into #Grainger

SELECT       NK.[Cost Center],GMS.Sector,Sum([Ext Price Amt])
FROM		 GraingerSpend
left join Grainger_Material_Sector_Trade GMS on GMS.[Material Segment] =GraingerSpend.[Material Segment]
left join Sector_Trade STRel on STRel.Sector = GMS.Sector
left join NamingKey NK on NK.INVENTSITEID = GraingerSpend.MFM_Site_Code
inner join [Ministry Grouping] MG on MG.Ministry = NK.Minstry
where [Bill Date] between '7-1-2016' and '6-30-2017' and [Cost Center] > 0

Group by [Cost Center],GMS.Sector
order by [Cost Center],GMS.Sector


--- Service Contract Additions ---

Create Table #Contracts (Cost_Center nvarchar(6),Sector varchar (30),Amount Float)

Insert Into #Contracts

Select LEFT(SCI.[CC -CAMPUS DESCRIPTION],6) Cost_Center,STR.Sector Sector,Sum([GL Amount]) Amount
FROM	     Contracts CONT
left join ServiceContractInfo SCI on SCI.[Contract ID] = CONT.[Contract ID]
inner join Sector_Trade STR on STR.Sector = SCI.[Updated Sector]
inner join NamingKey NK on NK.[Cost Center] = LEFT(SCI.[CC -CAMPUS DESCRIPTION],6)
inner join [Ministry Grouping] MG on MG.Ministry = NK.Minstry
WHERE        [GL Date] between '7-1-2016' and '6-30-2017' and Source = 'Payments'

Group by LEFT(SCI.[CC -CAMPUS DESCRIPTION],6),Sector
order by LEFT(SCI.[CC -CAMPUS DESCRIPTION],6),Sector

--- Labor ---

Create Table #Labor (Cost_Center nvarchar(100),Sector varchar (30),Amount Float)

Insert into #Labor

SELECT [Org Level 1 Code]
	  ,TAK.Sector
	  ,Sum([Current Amount])

FROM [FM_OPERATIONS].[dbo].[Labor]
inner join [FM_OPERATIONS].[dbo].[LaborCategory_OpsCategory] CAT on CAT.[Labor Category] = Labor.Category
left join [FM_OPERATIONS].[dbo].[TitleAsheKey] TAK on TAK.[Position Title] = Labor.[Job Title]

where [Pay Date] between '7-1-2016' and '6-30-2017' and  [Org Level 1 Code] >= '810100' and [Org Level 1 Code] not in ('820300','820400')

Group by [Org Level 1 Code], TAK.Sector
order by [Org Level 1 Code], TAK.Sector

Create Table #Allocations (Cost_Center nvarchar(100),Sector varchar (30),Amount Float)

Insert into #Allocations

Select [Cost Center],Sector,[Salary Allocation]
from [FM_OPERATIONS].[dbo].CorporateAllocations
order by [Cost Center],Sector

Create Table #UnionLabor (Cost_Center nvarchar(6),Sector varchar (30),Amount Float)

Insert into #UnionLabor

Select a.Cost_Center,'Administration' Sector,Sum(a.Amount)
FROM 
(
SELECT        Month(GJE.AccountingDate) Month,Year(GJE.AccountingDate) Year,NK.Site_Name,SUBSTRING(GJAE.ledgeraccount,1,5) Main_Account,SUBSTRING(GJAE.ledgeraccount,7,6) Cost_Center,ROUND(Cast(GJAE.ReportingCurrencyAmount as decimal(15,0)),0) Amount,NK.Minstry,MG.[Ministry Grouping],MG.[Regional Director],MG.AVP,PnL.PnLGrouping
FROM            AX_Target.dbo.GENERALJOURNALENTRY GJE 
                                          INNER JOIN
                                         AX_Target.dbo.GENERALJOURNALACCOUNTENTRY GJAE 
                                          on GJE.RECID = GJAE.GENERALJOURNALENTRY 
										 left join 
										 FM_Operations.dbo.NamingKey NK on Cast(NK.[Cost Center] as nvarchar) =  SUBSTRING(GJAE.ledgeraccount,7,6)
										 left join
										 FM_Operations.dbo.[Ministry Grouping] MG on MG.Ministry = NK.Minstry
										 left join FM_Operations.dbo.PnLMap PnL on PnL.[Main Account] = SUBSTRING(GJAE.ledgeraccount,1,5)
 where Accountingdate between '7-1-2016' and '6-30-2017'and SUBSTRING(GJAE.ledgeraccount,1,5) between '62000' and '62455' or Accountingdate between '7-1-2016' and '6-30-2017' and SUBSTRING(GJAE.ledgeraccount,1,5) IN ('62500','62650','62460','62950','62550','68400') or Accountingdate between '7-1-2016' and '6-30-2017' and SUBSTRING(GJAE.ledgeraccount,1,5) between '62700' and '62810'
 )
 a
  where  a.Cost_Center in ('845500','845501','845502','845503','845504','845505','845506','845507','885000','846100','841100','836100')  and a.Cost_Center NOT IN ('820300','820400','901001') /* Account Range */ and a.Cost_Center Like '%[0-9]%' and a.Site_Name <> 'Borgess Woodbridge'
  Group by A.Cost_Center
 order by Cost_Center




--- Actual Cost Pull ---


Select B.Cost_Center,B.Sector,B.Cost_Center + B.Sector IndexCode,Bm.Region,BM.[Footage Grouping],BM.Beds,BM.[Year Built],BM.[Sq Footage],isnull(coalesce(Serv.Amount + Cont.Amount,Serv.Amount,Cont.Amount),0) Service_Cost, isnull(coalesce(Sup.Amount+g.Amount,Sup.Amount,g.Amount),0) Supplies_Cost,isnull(Lab.Amount,0)+isnull(allo.Amount,0)+isnull(UL.amount,0) Labor_Cost,BM.[Bed Grouping],BM.UnionSite
From #Base B
left join #Service Serv on B.Cost_Center = Serv.Cost_Center and B.Sector = Serv.Sector
left join #Supplies Sup on B.Cost_Center = Sup.Cost_Center and B.Sector = Sup.Sector
left join #Contracts Cont on B.Cost_Center = Cont.Cost_Center and B.Sector = Cont.Sector
left join #Labor Lab on B.Cost_Center = Lab.Cost_Center and B.Sector = Lab.Sector
left join #Allocations Allo on Allo.Cost_Center = B.Cost_Center and allo.Sector = b.Sector
left join #UnionLabor UL on UL.Cost_Center = B.Cost_Center and UL.Sector = b.Sector
left join #Grainger G on B.Cost_Center = G.Cost_Center and B.Sector = G.Sector
left join FM_OPERATIONS.dbo.Benchmarks BM on BM.[Cost Center] = B.Cost_Center


where BM.[Sq Footage] IS NOT NULL and B.Cost_Center <> '891407'

order by B.Cost_Center,B.Sector


--- Cost Sq. Ft Pull ---

Select B.Cost_Center,B.Sector,B.Cost_Center + B.Sector IndexCode,Bm.Region,BM.[Footage Grouping],BM.Beds,BM.[Year Built],BM.[Sq Footage],isnull(coalesce(Serv.Amount + Cont.Amount,Serv.Amount,Cont.Amount),0)/BM.[Sq Footage] Service_Cost, isnull(coalesce(Sup.Amount+g.Amount+UL.Amount,Sup.Amount,g.Amount,UL.Amount)/BM.[Sq Footage],0) Supplies_Cost,(isnull(Lab.Amount,0)+isnull(allo.Amount,0)+isnull(UL.amount,0))/BM.[Sq Footage] Labor_Cost,BM.[Bed Grouping],BM.UnionSite
From #Base B
left join #Service Serv on B.Cost_Center = Serv.Cost_Center and B.Sector = Serv.Sector
left join #Supplies Sup on B.Cost_Center = Sup.Cost_Center and B.Sector = Sup.Sector
left join #Contracts Cont on B.Cost_Center = Cont.Cost_Center and B.Sector = Cont.Sector
left join #Labor Lab on B.Cost_Center = Lab.Cost_Center and B.Sector = Lab.Sector
left join #Allocations Allo on Allo.Cost_Center = B.Cost_Center and allo.Sector = b.Sector
left join #UnionLabor UL on UL.Cost_Center = B.Cost_Center and UL.Sector = b.Sector
left join #Grainger G on B.Cost_Center = G.Cost_Center and B.Sector = G.Sector
left join FM_OPERATIONS.dbo.Benchmarks BM on BM.[Cost Center] = B.Cost_Center

where BM.[Sq Footage] IS NOT NULL and B.Cost_Center <> '891407'

order by B.Cost_Center,B.Sector





