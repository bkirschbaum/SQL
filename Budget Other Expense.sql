/****** Script for SelectTopNRows command from SSMS  ******/
Use AX_Target;


SELECT        Month(GJE.ACCOUNTINGDATE) Month,Year(GJE.ACCOUNTINGDATE) Year,SUBSTRING(DAVC.Displayvalue,7,6) as 'Cost Center',GJAE.[REPORTINGCURRENCYAMOUNT] Amount, PnL.PnLGrouping, NK.Minstry, MG.[Ministry Grouping], MG.[Regional Director],MG.AVP

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
										 left join 
										 FM_Operations.dbo.NamingKey NK on Cast(NK.[Cost Center] as nvarchar) =  SUBSTRING(DAVC.Displayvalue,7,6)
										 left join
										 FM_Operations.dbo.[Ministry Grouping] MG on MG.Ministry = NK.Minstry

WHERE        ACCOUNTINGDATE between '7-1-2016' and '5-31-2017' and JOURNALNUMBER Like 'MFAC%' and SUBSTRING(DAVC.Displayvalue,7,6) > '810100' and SUBSTRING(DAVC.Displayvalue,7,6) NOT IN ('820300','820400') and PnL.PnLGrouping <> 'NULL'
order by PnL.[Service Supplies]


