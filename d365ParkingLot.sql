/****** Script for SelectTopNRows command from SSMS  ******/

WITH PIDName AS
(
SELECT DISTINCT [PURCHID]
       ,ITEMID
	   ,NAME
  FROM [dbo].[xPurchOrdersLinesStaging]
)

Select * from (
SELECT PT.PURCHNAME as 'Vendor_Name'
	  ,VIJ.[INVOICEAMOUNT]
	  ,PIDName.Name as PSANotes
	  ,SUBSTRING(GJE.ledgeraccount,8,5) as 'Cost Center'
      ,VIJ.[INVOICEDATE] as 'LASTSETTLEDATE'
	  ,PIDName.ITEMID
      ,VIJ.[PURCHID]

	  
	  ,row_number() OVER(Partition by VIJ.RECID Order by VIJ.RECID) DUPCOUNT
  FROM [dbo].[xVendInvoiceJourStaging] VIJ
  left join xPurchOrdersTableStaging PT on PT.PURCHID = VIJ.PURCHID
  left join PIDName on PIDName.PURCHID = VIJ.PURCHID 
  left join GeneralJournalAccountEntryStaging GJE on GJE.VOUCHER = VIJ.ledgervoucher
  where vij.purchid like 'mfac%' and GJE.LEDGERACCOUNT like '6%')

  a where DUPCOUNT = 1

