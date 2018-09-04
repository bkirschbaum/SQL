USE [FM_OPERATIONS]
GO
/****** Object:  StoredProcedure [dbo].[GetAXLines]    Script Date: 2/12/2018 1:42:50 PM ******/


/*****
Creator: Brian Kirschbaum
Report: GetAXLines
Purpose: Gather detailed information on General Ledger lines
Development: Serves the purpose, will be optimized after rollover to the new Enterprise Data Warehouse and AX Dynamics 365

*****/

Select b.[MXLORDERNOTES] as 'PSA Notes',b.LTSG,b.IS_ABR,B.Sector
,


B.Trade,


--- Handles MVPs Marked by RDs by giving them a custom Item Description: MVP, CUSTOM ---

Case when b.purchid IN (Select Distinct PURCHID From FM_OPERATIONS.dbo.PURCHIDTracking where [Expense Type] = 'MVP') then 'MVP, CUSTOM'
     else b.item_description_final 
	 end as 'Item_Description',

b.ledgeraccount,b.benchmarking,b.pnlgrouping,b.Service_Supplies_Labor_Depreciation,B.SUBLEDGERVOUCHER,B.PURCHID,B.Service_ref,

--- Handles Vendor Name exceptions ---
case when b.Vendor_Name IS NULL THEN PT.PURCHNAME
else b.Vendor_Name END AS Vendor_Name,

b.Labor_Type,b.Accountingdate,b.TEXT,b.Month,b.Year,b.Main_Account,b.Cost_Center,b.Amount,b.Minstry,b.[Ministry Grouping],b.[Regional Director],b.AVP,b.aduplicatecounter,B.CREATEDBY,

--- Column to track MVP, takes the item descriptions with MVP.... and marks accordingly ---
case when b.item_description_final like 'MVP%' then 'Yes'
else null 
end as IS_MVP
From

(
--- ABRs have become MVPs for better tracking. Keeping ABR column for datasets that are pre FY18 (Full MVP switchover was in August 2017) ---
Select Case when ABRs.ABR IS Null then 'No'
else 'Yes' END AS IS_ABR

,

--- Labels all Other Expenses with Administration Sector ---
Case when a.Benchmarking = 'Other Expenses' and a.PURCHID IS NULL Then 'Administration'
else IDST2.sector End As Sector
,
--- Labels all Other Expenses with Administration Trade ---
Case when a.Benchmarking = 'Other Expenses' and a.PURCHID IS NULL Then 'Administration'
      when IDST2.Trade IS NOT NULL then IDST2.Trade 
else  AOK.[Ops Trade] End As Trade,


--- Clustering of Profit and Loss Types. Takes the Main Account substring in the ledgeraccount and groups into the appropriate buckets: (labor/supply/service/other expenses/depreciation) ---
Case when a.text like ('%grainger%') then 'Supplies'
     when Substring(a.LEDGERACCOUNT,1,5) IN ('55000','54000','54500') then 'Service'
	 when Substring(a.LEDGERACCOUNT,1,5) IN ('50000','51000','52000','52005','52050','52100','52125','53000','53100','53200','57500','58500') then 'Supplies'
	 when Substring(a.LEDGERACCOUNT,1,5) = '67100' then 'Depreciation'
	 When a.Benchmarking = 'Other Expenses' then 'Other Expenses'
	 when a.Labor_Type IS NOT NUll THEN 'Labor'
Else IDST2.service_supplies END As Service_Supplies_Labor_Depreciation
,

--- Clustering of voucher sources ---
Case when a.SUBLEDGERVOUCHER like ('%JE%') Then 'Journal Entry'
     when a.SUBLEDGERVOUCHER like ('FFA%') Then 'Depreciation'
	 when a.SUBLEDGERVOUCHER like ('%API%') Then 'Accounts Payable Adjustment'
	 when a.PURCHID IN (Select PURCHID from FM_Operations.dbo.Blanket_POs) Then 'Blanket'
	 when a.TEXT IN ('Vendor invoice','Vendor product receipt') Then 'Invoice'
     else NULL end as LTSG 
,

--- Looks through text rows that do not have a voucher with a valid Purcahse Order ---
Case when a.SUBLEDGERVOUCHER Not Like ('MFAC-'+ '[0-9]') and a.TEXT like '%MFAC-P%'  THEN APV.Item_Description
     else a.Item_Description
	 END as Item_Description_Final
,
MPT.[MXLORDERNOTES], ROW_NUMBER() OVER(PARTITION BY a.RECID ORDER BY a.RECID) aduplicateCounter
, APV.Service_ref
,
a.*

From

(

SELECT        PNL.PnLGrouping,PNL.Benchmarking,GJAE.recid,GJE.LEDGERENTRYJOURNAL,GJE.DOCUMENTNUMBER,GJE.CREATEDBY, UI.NAME,


--- Cases where API and JE have Purch ID in text, taking Purchid and inserting into PURCHID Column ---
Case when VIJ.PURCHID <> '' Then VIJ.PURCHID
     when GJE.SUBLEDGERVOUCHER Not Like ('MFAC-'+ '[0-9]') and GJAE.TEXT like '%MFAC-P%' Then SUBSTRING(GJAE.TEXT,charindex('MFAC-P',GJAE.TEXT),13)
     else VPT.ORIGPURCHID END AS PURCHID

,PV.Vendor_Name,VPT.ITEMID,



--- Item Description Exceptions ---
Case when VPT.ITEMID IS NULL THEN PV.Item_description
     when VPT.ITEMID IS NOT NULL THEN VPT.NAME
     else NULL end as Item_Description

,
--- Labor Categorization (As of the current moment, On-Call has its own Main Account, but it is not accounted for in the Ultipro/AX upload---
Case when Substring(LEDGERACCOUNT,1,5) in (Select [Main Account] from FM_OPERATIONS.dbo.PnLMap where PnLGrouping = 'Salaries & Wages')  THEN 'Labor'
     when Substring(LEDGERACCOUNT,1,5) in (Select [Main Account] from FM_OPERATIONS.dbo.PnLMap where PnLGrouping = 'Benefits')  THEN 'Benefits'
     when Substring(LEDGERACCOUNT,1,5) in (Select [Main Account] from FM_OPERATIONS.dbo.PnLMap where PnLGrouping = 'Overtime')  THEN 'Overtime'
	 when Substring(LEDGERACCOUNT,1,5) in (Select [Main Account] from FM_OPERATIONS.dbo.PnLMap where PnLGrouping = 'On-Call')  THEN 'On-Call'
	 else NULL END as Labor_Type 

, GJE.AccountingDate,GJAE.LEDGERACCOUNT,GJAE.TEXT,GJAE.ISCREDIT,GJE.SUBLEDGERVOUCHER,Month(GJE.AccountingDate) Month,Year(GJE.AccountingDate) Year,SUBSTRING(GJAE.ledgeraccount,1,5) Main_Account,SUBSTRING(GJAE.ledgeraccount,7,6) Cost_Center,ROUND(Cast(GJAE.ReportingCurrencyAmount as decimal(15,2)),2) Amount,NK.Minstry,MG.[Ministry Grouping],MG.[Regional Director],MG.AVP,PV.PSANotes,
              ROW_NUMBER() OVER(PARTITION BY GJAE.RECID ORDER BY GJAE.RECID) duplicateCounter

FROM            AX_Target.dbo.GENERALJOURNALENTRY GJE 
                                         INNER JOIN
                                         AX_Target.dbo.GENERALJOURNALACCOUNTENTRY GJAE 
                                         on GJE.RECID = GJAE.GENERALJOURNALENTRY 
										 left join 
										 /* Rolls cost center information into a ministry */ FM_Operations.dbo.NamingKey NK on Cast(NK.[Cost Center] as nvarchar) =  SUBSTRING(GJAE.ledgeraccount,7,6)
										 left join
										 /* Regional Directors and AVPs are assigned by Ministry, information */ FM_Operations.dbo.[Ministry Grouping] MG on MG.Ministry = NK.Minstry
										 left join AX_Target.dbo.VENDINVOICEJOUR VIJ on GJE.SUBLEDGERVOUCHER = VIJ.LEDGERVOUCHER
										 left join ConsolidatedReports.dbo.Purchasing_View PV on PV.Purchase_Order= VIJ.PURCHID
										 left join FM_OPERATIONS.dbo.Item_Description_Sector_Trade IDST on PV.Item_description = IDST.Item_Description
										 left join AX_Target.dbo.USERINFO UI on UI.ID = GJE.CREATEDBY
										 left join AX_Target.dbo.VENDPACKINGSLIPTRANS VPT on VPT.COSTLEDGERVOUCHER = GJE.SUBLEDGERVOUCHER
										 /* Mapps main accounts to PnL Cost Centers */left join FM_Operations.dbo.PnLMap PNL on PNL.[Main Account] = SUBSTRING(GJAE.ledgeraccount,1,5)
										 
 where GJE.Accountingdate between @BeginDate and @EndDate  and SUBSTRING(GJAE.ledgeraccount,1,5) NOT like '4%' and SUBSTRING(GJAE.ledgeraccount,1,5) > '399999'  and SUBSTRING(GJAE.ledgeraccount,7,6) >= '810100' and SUBSTRING(GJAE.ledgeraccount,7,6) NOT IN ('820300','820400','901000') and SUBSTRING(GJAE.ledgeraccount,7,6) like '%[0-9]%'


 )
 a
 /* Operational trade based on item_description  */left join FM_OPERATIONS.dbo.Item_Description_Sector_Trade IDST2 on IDST2.item_description = a.Item_Description
 /* Operational analysis of POs that are Above Baseline Work */left join FM_OPERATIONS.dbo.ABRs on ABRs.PURCHID = a.PURCHID
 /* Key aligning the two trades into a common format */left join FM_OPERATIONS.dbo.AX_OPS_Key AOK on AOK.[AX Trade] = RIGHT(a.LEDGERACCOUNT , CHARINDEX ('-' ,REVERSE(a.LEDGERACCOUNT))-1) 
 left join AX_Target.dbo.MXLPURCHTABLE MPT on MPT.PURCHID = a.PURCHID
 left join ConsolidatedReports.dbo.Purchasing_View APV on APV.Purchase_Order= a.PURCHID
 

 where duplicateCounter = 1 

 ) b
 left join AX_Target.dbo.PURCHTABLE PT on b.PURCHID = PT.PURCHID
 left join FM_OPERATIONS.dbo.Item_Description_Sector_Trade IDST3 on IDST3.item_description = b.Item_Description_Final

 where b.aduplicateCounter = 1


