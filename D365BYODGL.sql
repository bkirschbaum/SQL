/****** Script for SelectTopNRows command from SSMS  ******/


--- BOTH CTEs could be combined into 1 PO dimension table ---
WITH PO_CTE
 AS
(
	  SELECT [PURCHID]
      ,AVA_PURCHREQID
	  ,AVA_WORKORDERNUMBER
	  ,AVA_ISSENTFROMCMS
	  ,REQATTENTION
      FROM [dbo].[xPurchOrdersTableStaging]
 )
, POINFO_CTE AS 
(
Select a.PURCHID,a.ITEMID,a.Name from
(

SELECT [PURCHID]
      ,[ITEMID]
	  ,NAME
	  ,ROW_NUMBER() OVER(PARTITION BY PURCHID ORDER BY PURCHID) duplicateCounter
  FROM [dbo].[xPurchOrdersLinesStaging]
) a where a.duplicateCounter = 1
)

------- END CTE -------



Select * from
(
SELECT  GJE.[ACCOUNTINGDATE]
	  ,GJAE.LEDGERACCOUNT
	  ,GJAE.TEXT

	  -- Main Account --
	  ,SUBSTRING(GJAE.ledgeraccount,1,6) Main_Account
	  ,MA.NAME as  'Main Account Name'
	  ,MA.ACCOUNTCATEGORYDESCRIPTION
	  
	  -- Cost Center --

	  ,SUBSTRING(GJAE.ledgeraccount,8,5) Cost_Center 
	  ,OU.NAME as 'Cost Center Name'
	  
	  -- Business Unit & Nominal Business Unit --
	  ,OU.AVA_BUSINESSUNIT
	  ,OU.AVA_NOMINALBUSINESSUNIT

	  -- Trade --
	  ,CASE WHEN GJAE.LEDGERACCOUNT like '%-%' 
	        then RIGHT(GJAE.LEDGERACCOUNT , CHARINDEX ('-' ,REVERSE(GJAE.LEDGERACCOUNT))-1) 
			else '' 
			end as Trade
	  ,GJAE.[REPORTINGCURRENCYAMOUNT] as 'Amount'

	  --- PO Information ---
	  ,Coalesce(VPT.ORIGPURCHID,VIJ.PURCHID) PURCHID

	  --- All could be in PO Dimension table ---
      ,Coalesce(PO1.AVA_PURCHREQID,PO2.AVA_PURCHREQID) PURCHREQID
	  ,Coalesce(PO1.AVA_WORKORDERNUMBER,PO2.AVA_WORKORDERNUMBER) WORKORDERNUMBER
	  ,Coalesce(PO1.AVA_ISSENTFROMCMS,PO2.AVA_ISSENTFROMCMS) SENTFROMCMS -- Potentially wrap this in a case statement 1- Yes   0- No  else NULL --
	  ,Coalesce(PO1.REQATTENTION,PO2.REQATTENTION) REQATTENTION
	  ,Coalesce(POI1.ITEMID,POI2.ITEMID) ITEMID
	  ,Coalesce(POI1.Name,POI2.Name) Notes
	  
	  ,GJAE.LEDGERDIMENSION 
	  ,GJE.SUBLEDGERVOUCHER
	  
	  ,VIJ.INVOICEID
	  
	  -- Vendor Information --
	  ,VIJ.INVOICEACCOUNT
	  ,VS.TAX1099DOINGBUSINESSASNAME as 'Vendor Name'
	  ,VS.FORMATTEDPRIMARYADDRESS as 'Address'
	  ,VS.TAX1099FEDERALTAXID
	  ,GJAE.RECID
	  ,ROW_NUMBER() OVER(PARTITION BY GJAE.RECID ORDER BY GJAE.RECID) duplicateCounter
  FROM [dbo].[xGeneralJournalAccountentryStaging] GJAE
  
  inner join dbo.xGeneralJournalEntryStaging GJE on GJE.RECID = GJAE.[GENERALJOURNALENTRY]
  left join dbo.OMOperatingUnitStaging OU on OU.OPERATINGUNITNUMBER = SUBSTRING(GJAE.ledgeraccount,8,5)
  left join dbo.xVendInvoiceJourStaging VIJ on VIJ.LEDGERVOUCHER = GJE.SUBLEDGERVOUCHER
  left join dbo.xVendPackingSlipTransStaging VPT on VPT.COSTLEDGERVOUCHER = GJE.SUBLEDGERVOUCHER
  left join dbo.MainAccountStaging MA on MA.MAINACCOUNTID = SUBSTRING(GJAE.ledgeraccount,1,6)
  left join dbo.VendVendorV2Staging VS on VS.VENDORACCOUNTNUMBER = VIJ.INVOICEACCOUNT
  
  -- Might be a better way to handle this join to the PO table (Issue is PO# in VPT and VIJ) ---
  left join PO_CTE PO1 on PO1.PURCHID = VPT.ORIGPURCHID
  left join PO_CTE PO2 on PO2.PURCHID = VIJ.PURCHID
  left join POINFO_CTE POI1 on POI1.PURCHID = VPT.ORIGPURCHID
  left join POINFO_CTE POI2 on POI2.PURCHID = VIJ.PURCHID





  
  where GJE.accountingdate between '1/1/2018' and '1/31/2018'

  )a where duplicateCounter = 1
