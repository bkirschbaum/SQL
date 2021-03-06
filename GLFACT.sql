/****** Script for SelectTopNRows command from SSMS  ******/


Select * from (
SELECT GJE.[ACCOUNTINGDATE]
	  ,GJAE.LEDGERACCOUNT
	  ,GJAE.TEXT

	  -- Main Account --
	  ,SUBSTRING(GJAE.ledgeraccount,1,6) Main_Account
	  
	  -- Cost Center --
	  ,SUBSTRING(GJAE.ledgeraccount,8,5) Cost_Center 
	  
	  -- Trade --
	  ,CASE WHEN GJAE.LEDGERACCOUNT like '%-%' 
	        then RIGHT(GJAE.LEDGERACCOUNT , CHARINDEX ('-' ,REVERSE(GJAE.LEDGERACCOUNT))-1) 
			else '' 
			end as Trade
	  ,GJAE.[REPORTINGCURRENCYAMOUNT] as 'Amount'

	  --- PO Information ---
	  ,Coalesce(VPT.ORIGPURCHID,VIJ.PURCHID) PURCHID

	  ,GJAE.LEDGERDIMENSION 
	  ,GJE.SUBLEDGERVOUCHER
	  ,VIJ.INVOICEID
	  
	  ,VIJ.INVOICEACCOUNT
	  ,GJAE.RECID
	  ,ROW_NUMBER() OVER(PARTITION BY GJAE.RECID ORDER BY GJAE.RECID) duplicateCounter
  
  FROM [dbo].[xGeneralJournalAccountentryStaging] GJAE
  
  inner join dbo.xGeneralJournalEntryStaging GJE on GJE.RECID = GJAE.[GENERALJOURNALENTRY]
  left join dbo.xVendInvoiceJourStaging VIJ on VIJ.LEDGERVOUCHER = GJE.SUBLEDGERVOUCHER
  left join dbo.xVendPackingSlipTransStaging VPT on VPT.COSTLEDGERVOUCHER = GJE.SUBLEDGERVOUCHER  

  ) a where a.duplicateCounter = 1
  

