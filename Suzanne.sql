/****** Script for SelectTopNRows command from SSMS  ******/

Select a.* 

from

(

SELECT  VENDINVOICEJOUR.[VENDGROUP]
      ,VENDINVOICEJOUR.[PURCHID]
      ,VENDINVOICEJOUR.[INVOICEAMOUNT]
	  ,Right(PL.[EXTERNALITEMID], 10) Reference_Number
	  ,PL.[EXTERNALITEMID]
	  ,PT.PURCHNAME
	  ,VT.CLOSED
	  ,ROW_NUMBER() OVER(PARTITION BY VENDINVOICEJOUR.[PURCHID] ORDER BY VENDINVOICEJOUR.[PURCHID]) duplicateCounter


  FROM [AX_Target].[dbo].[VENDINVOICEJOUR]
  inner join 
  [AX_Target].[dbo].PURCHLINE PL on PL.PURCHID = [AX_Target].[dbo].[VENDINVOICEJOUR].PURCHID
    left join AX_Target.dbo.PURCHTABLE PT on PT.PURCHID = VENDINVOICEJOUR.[PURCHID]
	left join AX_Target.dbo.VENDTRANS VT on VT.VOUCHER= [VENDINVOICEJOUR].LedgerVoucher
  where PL.[EXTERNALITEMID] like '%service%' and VENDINVOICEJOUR.[PURCHID] like '%mfac%' and PT.PURCHNAME like '%kone%'

  ) a
  where duplicateCounter = 1 and a.closed between '7-1-2016' and '8-28-2017'
  order by a.closed