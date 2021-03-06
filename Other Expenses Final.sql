/****** Script for SelectTopNRows command from SSMS  ******/
Use AX_Target;




SELECT        Month(GJE.ACCOUNTINGDATE) Month,Year(GJE.ACCOUNTINGDATE) Year,Substring(DAVC.DISPLAYVALUE,7,6) Cost_Center, GJAE.ReportingCurrencyAmount, PnL.PnLGrouping, NK.Minstry,MG.[Ministry Grouping],mg.[Regional Director],mg.AVP

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
										 left join FM_OPERATIONS.dbo.NamingKey NK on NK.[Cost Center] = SUBSTRING(DAVC.Displayvalue,7,6)
										 left join FM_OPERATIONS.dbo.[Ministry Grouping] MG on MG.Ministry = NK.Minstry

WHERE        ACCOUNTINGDATE between '7-1-2016' and '6-30-2017' and JOURNALNUMBER Like 'MFAC%' and SUBSTRING(DAVC.Displayvalue,7,6) >='810100' and SUBSTRING(DAVC.Displayvalue,7,6)  like '%[0-9]%' and SUBSTRING(DAVC.Displayvalue,7,6) NOT IN ('820300','820400') and PnL.Benchmarking = 'Other Expenses'

order by [Cost Center],year,month


