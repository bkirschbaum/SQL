/****** Script for SelectTopNRows command from SSMS  ******/
Use AX_Target;


SELECT        DAVC.DISPLAYVALUE,GJE.ACCOUNTINGDATE, GJE.JournalNumber, GJE.Subledgervoucher,GJE.JournalCategory,GJAE.[TRANSACTIONCURRENCYCODE],GJAE.[TRANSACTIONCURRENCYAMOUNT]
      ,GJAE.[ACCOUNTINGCURRENCYAMOUNT],GJAE.[REPORTINGCURRENCYAMOUNT],GJAE.[POSTINGTYPE], PnL.[Service Supplies],PnL.PnLGrouping

FROM            dbo.GENERALJOURNALENTRY GJE 
                                          INNER JOIN
                                         dbo.GENERALJOURNALACCOUNTENTRY GJAE 
                                          on GJE.RECID = GJAE.GENERALJOURNALENTRY 
                                          INNER JOIN
                                         dbo.DIMENSIONATTRIBUTEVALUEGROUPCOMBINATION DAVGC 
                                          on GJAE.LEDGERDIMENSION = DAVGC.DIMENSIONATTRIBUTEVALUECOMBINATION
                                         INNER JOIN
                                         dbo.DIMENSIONATTRIBUTEVALUECOMBINATION DAVC
                                         on DAVC.RECID = DAVGC.DIMENSIONATTRIBUTEVALUECOMBINATION and DAVC.ACCOUNTSTRUCTURE = 5637149827
										 inner join FM_Operations.dbo.PnLMap PnL on PnL.[Main Account] = SUBSTRING(DAVC.Displayvalue,1,5)

WHERE        ACCOUNTINGDATE between '2-1-2017' and '2-28-2017' and JOURNALNUMBER Like 'MFAC%' and SUBSTRING(DAVC.Displayvalue,7,6) = '846100' and SUBSTRING(DAVC.Displayvalue,7,6) NOT IN ('820300','820400')
order by PnL.[Service Supplies]


