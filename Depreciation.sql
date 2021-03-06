/****** Script for SelectTopNRows command from SSMS  ******/
Use AX_Target;


SELECT        Month(GJE.AccountingDate) Month,Year(GJE.AccountingDate) Year,SUBSTRING(GJAE.ledgeraccount,1,5) Main_Account,SUBSTRING(GJAE.ledgeraccount,7,6) Cost_Center,Sum(Cast(GJAE.ReportingCurrencyAmount as decimal(6,0))) Amount,NK.Minstry,MG.[Ministry Grouping],MG.[Regional Director],MG.AVP

FROM            dbo.GENERALJOURNALENTRY GJE 
                                          INNER JOIN
                                         dbo.GENERALJOURNALACCOUNTENTRY GJAE 
                                          on GJE.RECID = GJAE.GENERALJOURNALENTRY 
										 left join 
										 FM_Operations.dbo.NamingKey NK on Cast(NK.[Cost Center] as nvarchar) =  SUBSTRING(GJAE.ledgeraccount,7,6)
										 left join
										 FM_Operations.dbo.[Ministry Grouping] MG on MG.Ministry = NK.Minstry
 where Accountingdate between '7-1-2016' and '6-30-2017'  and SUBSTRING(GJAE.ledgeraccount,1,5) IN ('67100','67200')  and SUBSTRING(GJAE.ledgeraccount,7,6) >= '810100' and SUBSTRING(GJAE.ledgeraccount,7,6) NOT IN ('820300','820400')
 
 Group by SUBSTRING(GJAE.ledgeraccount,1,5),SUBSTRING(GJAE.ledgeraccount,7,6),Year(GJE.AccountingDate),Month(GJE.AccountingDate),NK.Minstry,MG.[Ministry Grouping],MG.[Regional Director],MG.AVP
 order by Cost_Center,Year,Month

 


 