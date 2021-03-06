USE [FM_OPERATIONS]



--- Invoices Direct Pull ---


Create Table #Invoices (Cost_Center nvarchar(6),Month int, Year int,Service_Supplies  varchar(100),Sector varchar(100),Trade varchar(100),Invoice_Cost Float)

Insert Into #Invoices

Select Cost_Center,Month,Year,Service_Supplies,Sector,Trade,Sum(Amount) Amount from (

SELECT  Cost_Center,Month,Year,Cast(Service_Supplies as varchar(15)) as 'Service_Supplies',Cast(Sector as varchar(15)) as 'Sector',Cast(Trade as varchar(25)) as 'Trade',Amount Amount

From ( 

Select 

NK.[Cost Center] Cost_Center,Month(VTRANS.LASTSETTLEDATE) Month, Year(VTRANS.LASTSETTLEDATE) Year,VIJ.INVOICEAMOUNT Amount,IDST.Service_Supplies Service_Supplies,IDST.Sector Sector,IDST.Trade Trade,ROW_NUMBER() OVER(PARTITION BY VIJ.RECID ORDER BY VIJ.RECID) duplicateCounter

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

WHERE        (VTRANS.LASTSETTLEDATE BETWEEN '7-1-2016' AND '8-31-2016' AND 
                         (VIJ.PURCHID LIKE N'MFAC%') and ABRS.ABR IS NULL and PV.Vendor_Name not like '%Grainger%'
)

a

where duplicateCounter = 1 and Cost_Center > 0 and Cost_Center like '%[0-9]%'

Union All

Select NK.[Cost Center],MONTH([GL Date]) Month, Year([GL Date]) Year,'Service',[Updated Sector] Sector, STR.Trade,[GL Amount]
FROM	     Contracts CONT
inner join ServiceContractInfo SCI on SCI.[Contract ID] = CONT.[Contract ID]
inner join Sector_Trade STR on STR.Sector = SCI.[Updated Sector]
inner join NamingKey NK on NK.[Cost Center] = LEFT(SCI.[CC -CAMPUS DESCRIPTION],6)
inner join [Ministry Grouping] MG on MG.Ministry = NK.Minstry
WHERE        [GL Date] between '7-1-2016' and '8-31-2016' and Source = 'Payments'

Union All

SELECT       NK.[Cost Center],Month([Bill Date]) Month,YEAR([Bill Date]) Year, 'Supplies',GMS.Sector, STRel.Trade,[Ext Price Amt] 
FROM		 GraingerSpend
left join Grainger_Material_Sector_Trade GMS on GMS.[Material Segment] =GraingerSpend.[Material Segment]
left join Sector_Trade STRel on STRel.Sector = GMS.Sector
left join NamingKey NK on NK.INVENTSITEID = GraingerSpend.MFM_Site_Code
inner join [Ministry Grouping] MG on MG.Ministry = NK.Minstry
where [Bill Date] between '7-1-2016' and '8-31-2016'

)

b
where  Cost_Center >= 810100 and Cost_Center not in ('820300','820400')

Group by Cost_Center,Month,Service_Supplies,Sector,Trade,Year
order by Cost_Center,Year,Month,Service_Supplies,Sector,Trade




--- Labor Pull ---

Create Table #Labor (Cost_Center nvarchar(6),Month int, Year int,Sector varchar (100), Trade varchar (100),Labor_Cost Float)


Insert into #Labor

SELECT [Org Level 1 Code]
      ,Month([Pay Date]) Month
	  ,Year([Pay Date]) Year
	  ,TAK.Sector
	  ,TAK.Trade
	  ,Sum([Current Amount]) Amount

  FROM [FM_OPERATIONS].[dbo].[Labor]
 left join [FM_OPERATIONS].[dbo].[TitleAsheKey] TAK on TAK.[Position Title] = Labor.[Job Title]

  where [Pay Date] between '7-1-2016' and '8-31-2016' and  [Org Level 1 Code] >= '810100' and [Org Level 1 Code] not in ('820300','820400')

  Group by [Org Level 1 Code], Year([Pay Date]), Month([Pay Date]),TAK.Sector,TAK.Trade
  order by [Org Level 1 Code], Year([Pay Date]), Month([Pay Date])



  --- Other Expenses Pull ---

Create Table #OtherExpenses (Cost_Center nvarchar(6),Month int, Year int,Amount Float)

Insert into #OtherExpenses

SELECT        Substring(DAVC.DISPLAYVALUE,7,6) Cost_Center,Month(GJE.ACCOUNTINGDATE) Month,Year(GJE.ACCOUNTINGDATE) Year, Sum(GJAE.ReportingCurrencyAmount) Amount

FROM            AX_Target.dbo.GENERALJOURNALENTRY GJE 
                                          INNER JOIN
                                         AX_Target.dbo.GENERALJOURNALACCOUNTENTRY GJAE 
                                          on GJE.RECID = GJAE.GENERALJOURNALENTRY 
                                          INNER JOIN
                                         AX_Target.dbo.DIMENSIONATTRIBUTEVALUEGROUPCOMBINATION DAVGC 
                                          on GJAE.LEDGERDIMENSION = DAVGC.DIMENSIONATTRIBUTEVALUECOMBINATION
                                         INNER JOIN
                                         AX_Target.dbo.DIMENSIONATTRIBUTEVALUECOMBINATION DAVC
                                         on DAVC.RECID = DAVGC.DIMENSIONATTRIBUTEVALUECOMBINATION and DAVC.ACCOUNTSTRUCTURE = 5637149827
										 inner join FM_Operations.dbo.PnLMap PnL on PnL.[Main Account] = SUBSTRING(DAVC.Displayvalue,1,5)

WHERE        ACCOUNTINGDATE between '7-1-2016' and '8-31-2016' and JOURNALNUMBER Like 'MFAC%' and SUBSTRING(DAVC.Displayvalue,7,6) >='810100' and SUBSTRING(DAVC.Displayvalue,7,6)  like '%[0-9]%' and SUBSTRING(DAVC.Displayvalue,7,6) NOT IN ('820300','820400') and  PnL.benchmarking IS NOT NULL

group by Substring(DAVC.DISPLAYVALUE,7,6),Year(GJE.ACCOUNTINGDATE),Month(GJE.ACCOUNTINGDATE)








/*   --- Test Queries ---    */


--- Invoice Test ---
Select * from #Invoices
order by Cost_Center,Year,Month,Service_Supplies,Sector,Trade



--- Labor Test ---
Select * from #labor




Select I.Cost_Center,DateName( month , DateAdd( month , I.Month , -1 ) ) Month_Name,I.Month, I.Year,I.Sector,I.Trade,

(Select I.Invoice_Cost from #Invoices II where II.Service_Supplies = 'Service' and II.Cost_Center = I.Cost_Center and II.Month = I.Month and II.Year = I.Year and II.Sector = I.Sector) 
as Service_Cost,

(Select I.Invoice_Cost from #Invoices III where III.Service_Supplies = 'Supplies' and III.Cost_Center = I.Cost_Center and III.Month = I.Month and III.Year = I.Year and III.Sector = I.Sector) 
as Supplies_Cost,
 L.Labor_Cost
From #Invoices I
left join #labor L on L.Cost_Center = I.Cost_Center and L.Month = I.Month and L.Year = I.Year and L.Sector = I.Sector


Select I.Cost_Center,I.Sector,I.Trade,I.Invoice_Cost from #Invoices I where I.Service_Supplies = 'Service'


--- Other Expenses ---

Select * from #OtherExpenses
