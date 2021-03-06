/****** Script for SelectTopNRows command from SSMS  ******/
Use AX_Target;

Select c.Insourcing_Year,c.ledgeraccount,c.Service_Supplies_Labor_Depreciation Service_Supply_Labor, Sum(Amount)

from

(


Select CASE WHEN  CAST(b.AccountingDate - GL.[Go Live] AS INT) < 365 THEN 'Year 1'
	             WHEN  CAST(b.AccountingDate - GL.[Go Live] AS INT) < 730 THEN 'Year 2'
				 WHEN  CAST(b.AccountingDate - GL.[Go Live] AS INT) < 1095 THEN 'Year 3'
				 WHEN  CAST(b.AccountingDate - GL.[Go Live] AS INT) < 1460 THEN 'Year 4'
				 WHEN  CAST(b.AccountingDate - GL.[Go Live] AS INT) < 1825 THEN 'Year 5'
				 WHEN  CAST(b.AccountingDate - GL.[Go Live] AS INT) < 2190 THEN 'Year 6'
				 WHEN  CAST(b.AccountingDate - GL.[Go Live] AS INT) < 0 THEN 'Prior To Go-Live'
            ELSE 'INVALID' END AS Insourcing_Year




,SUBSTRING(b.ledgeraccount,7,6) ledgeraccount,b.Service_Supplies_Labor_Depreciation , Amount

From

(

Select Case when ABRs.ABR IS Null then 'No'
else 'Yes' END AS IS_ABR

,


Case when a.Benchmarking = 'Other Expenses' Then 'Administration'
else IDST2.sector End As Sector
,

Case when a.Benchmarking = 'Other Expenses' Then 'Administration'
      when IDST2.Trade IS NOT NULL then IDST2.Trade 
else  AOK.[Ops Trade] End As Trade,


Case when a.text like ('%grainger%') then 'Supplies'
     when Substring(a.LEDGERACCOUNT,1,5) IN ('55000','54000','54500') then 'Service'
	 when Substring(a.LEDGERACCOUNT,1,5) IN ('50000','51000','52000','52005','52050','52100','52125','53000','53100','53200','57500','58500') then 'Supplies'
	 when Substring(a.LEDGERACCOUNT,1,5) = '67100' then 'Depreciation'
	 when a.Labor_Type IS NOT NUll THEN 'Labor'
Else IDST2.service_supplies END As Service_Supplies_Labor_Depreciation

,a.*

From

(

SELECT        PNL.Benchmarking,GJAE.recid,GJE.LEDGERENTRYJOURNAL,GJE.DOCUMENTNUMBER,GJE.JOURNALNUMBER,GJE.CREATEDBY, UI.NAME,VIJ.PURCHID,PV.Vendor_Name,VPT.ITEMID,

--- Item Description Exceptions ---
Case when VPT.ITEMID IS NULL THEN PV.Item_description
     WHEN VPT.ITEMID IS NOT NULL THEN VPT.NAME
     else NULL END AS Item_Description

,
--- Labor Categorization ---
Case when Substring(LEDGERACCOUNT,1,5) in (Select [Main Account] from FM_OPERATIONS.dbo.PnLMap where PnLGrouping = 'Salaries & Wages')  THEN 'Labor'
     when Substring(LEDGERACCOUNT,1,5) in (Select [Main Account] from FM_OPERATIONS.dbo.PnLMap where PnLGrouping = 'Benefits')  THEN 'Benefits'
     when Substring(LEDGERACCOUNT,1,5) in (Select [Main Account] from FM_OPERATIONS.dbo.PnLMap where PnLGrouping = 'Overtime')  THEN 'Overtime'
	 when Substring(LEDGERACCOUNT,1,5) in (Select [Main Account] from FM_OPERATIONS.dbo.PnLMap where PnLGrouping = 'On-Call')  THEN 'On-Call'
	 else NULL END as Labor_Type 

, GJE.AccountingDate,GJAE.LEDGERACCOUNT,GJAE.TEXT,GJAE.ISCREDIT,GJE.SUBLEDGERVOUCHER,Month(GJE.AccountingDate) Month,Year(GJE.AccountingDate) Year,SUBSTRING(GJAE.ledgeraccount,1,5) Main_Account,SUBSTRING(GJAE.ledgeraccount,7,6) Cost_Center,ROUND(Cast(GJAE.ReportingCurrencyAmount as decimal(15,2)),2) Amount,NK.Minstry,MG.[Ministry Grouping],MG.[Regional Director],MG.AVP,PV.PSANotes,
              ROW_NUMBER() OVER(PARTITION BY GJAE.RECID ORDER BY GJAE.RECID) duplicateCounter

FROM            dbo.GENERALJOURNALENTRY GJE 
                                          INNER JOIN
                                         dbo.GENERALJOURNALACCOUNTENTRY GJAE 
                                          on GJE.RECID = GJAE.GENERALJOURNALENTRY 
										 left join 
										 FM_Operations.dbo.NamingKey NK on Cast(NK.[Cost Center] as nvarchar) =  SUBSTRING(GJAE.ledgeraccount,7,6)
										 left join
										 FM_Operations.dbo.[Ministry Grouping] MG on MG.Ministry = NK.Minstry
										 left join VENDINVOICEJOUR VIJ on GJE.SUBLEDGERVOUCHER = VIJ.LEDGERVOUCHER
										 left join ConsolidatedReports.dbo.Purchasing_View PV on PV.Purchase_Order= VIJ.PURCHID
										 left join FM_OPERATIONS.dbo.Item_Description_Sector_Trade IDST on PV.Item_description = IDST.Item_Description
										 left join USERINFO UI on UI.ID = GJE.CREATEDBY
										 left join AX_Target.dbo.VENDPACKINGSLIPTRANS VPT on VPT.COSTLEDGERVOUCHER = GJE.SUBLEDGERVOUCHER
										 left join FM_Operations.dbo.PnLMap PNL on PNL.[Main Account] = SUBSTRING(GJAE.ledgeraccount,1,5)
 where GJE.Accountingdate between '8-1-2017' and '8-1-2017'  and SUBSTRING(GJAE.ledgeraccount,1,5) NOT like '4%' and SUBSTRING(GJAE.ledgeraccount,1,5) > '399999'  and SUBSTRING(GJAE.ledgeraccount,7,6) >= '810100' and SUBSTRING(GJAE.ledgeraccount,7,6) NOT IN ('820300','820400')


 )
 a
 left join FM_OPERATIONS.dbo.Item_Description_Sector_Trade IDST2 on IDST2.item_description = a.Item_Description
 left join FM_OPERATIONS.dbo.ABRs on ABRs.PURCHID = a.PURCHID
 left join FM_OPERATIONS.dbo.AX_OPS_Key AOK on AOK.[AX Trade] = REPLACE(Right(a.ledgeraccount,7),'-','')

 

 where duplicateCounter = 1  

 ) b
 left join FM_OPERATIONS.dbo.[Go Live] GL on GL.Ministry = b.Minstry

 

 where b.Service_Supplies_Labor_Depreciation <> 'Depreciation' 

 ) c


 group by c.Insourcing_Year,c.ledgeraccount,c.Service_Supplies_Labor_Depreciation

 




