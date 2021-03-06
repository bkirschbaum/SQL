/****** Script for SelectTopNRows command from SSMS  ******/
Use AX_Target;



Create Table #OtherExpenses (Cost_Center nvarchar(6),Month int, Year int,Ops_Category varchar(100),Sector varchar (100), Trade varchar (100),Amount Float)

SELECT        Substring(DAVC.DISPLAYVALUE,7,6) Cost_Center,Month(GJE.ACCOUNTINGDATE) Month,Year(GJE.ACCOUNTINGDATE) Year, Sum(GJAE.ReportingCurrencyAmount) Amount

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

WHERE        ACCOUNTINGDATE between '7-1-2016' and '7-10-2016' and JOURNALNUMBER Like 'MFAC%' and SUBSTRING(DAVC.Displayvalue,7,6) >='810100' and SUBSTRING(DAVC.Displayvalue,7,6)  like '%[0-9]%' and SUBSTRING(DAVC.Displayvalue,7,6) NOT IN ('820300','820400') and PnL.Benchmarking = 'Other Expenses'

group by Substring(DAVC.DISPLAYVALUE,7,6),Year(GJE.ACCOUNTINGDATE),Month(GJE.ACCOUNTINGDATE)


