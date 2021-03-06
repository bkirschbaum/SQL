/****** Script for SelectTopNRows command from SSMS  ******/


Select *
From (

SELECT        TOP (100) PERCENT  DAVC.DISPLAYVALUE,dbo.VENDINVOICEJOUR.PURCHID, dbo.VENDINVOICEJOUR.ORDERACCOUNT, 
                         dbo.VENDINVOICEJOUR.INVOICEACCOUNT, dbo.VENDINVOICEJOUR.INVOICEID, dbo.VENDINVOICEJOUR.DOCUMENTDATE, dbo.VENDINVOICEJOUR.DUEDATE, 
                         dbo.VENDINVOICEJOUR.PAYMENT, dbo.VENDINVOICEJOUR.INVOICEAMOUNT, dbo.VENDTRANS.SETTLEAMOUNTCUR, dbo.VENDTRANS.LASTSETTLEDATE, 
                         dbo.VENDTRANS.CLOSED, dbo.VENDTRANS.LASTSETTLECOMPANY, dbo.VENDINVOICEJOUR.LEDGERVOUCHER, dbo.VENDINVOICEJOUR.DELIVERYNAME, 
						 ROW_NUMBER() OVER(PARTITION BY VENDINVOICEJOUR.RECID ORDER BY VENDINVOICEJOUR.RECID) duplicateCounter
FROM            dbo.VENDINVOICEJOUR INNER JOIN
                         dbo.VENDTRANS 
                                          ON dbo.VENDINVOICEJOUR.LEDGERVOUCHER = dbo.VENDTRANS.VOUCHER 
                                          INNER JOIN
                                         dbo.GENERALJOURNALENTRY GJE 
                                          on GJE.SUBLEDGERVOUCHER = dbo.VENDINVOICEJOUR.LEDGERVOUCHER 
                                          INNER JOIN
                                         dbo.GENERALJOURNALACCOUNTENTRY GJAE 
                                          on GJE.RECID = GJAE.GENERALJOURNALENTRY 
                                          INNER JOIN
                                         dbo.DIMENSIONATTRIBUTEVALUEGROUPCOMBINATION DAVGC 
                                          on GJAE.LEDGERDIMENSION = DAVGC.DIMENSIONATTRIBUTEVALUECOMBINATION
                                         INNER JOIN
                                         dbo.DIMENSIONATTRIBUTEVALUECOMBINATION DAVC
                                         on DAVC.RECID = DAVGC.DIMENSIONATTRIBUTEVALUECOMBINATION and DAVC.ACCOUNTSTRUCTURE IN (5637149827,5637144831,5637144830,5637147328)

WHERE        ACCOUNTINGDATE between '4-1-2017' and '4-30-2017' and JOURNALNUMBER Like 'MFAC%'

ORDER BY dbo.VENDINVOICEJOUR.LEDGERVOUCHER

)

a

where duplicateCounter = 1
