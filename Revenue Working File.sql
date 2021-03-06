/****** Script for SelectTopNRows command from SSMS  ******/
Use AX_Target;


SELECT        Month(GJE.AccountingDate) Month,Year(GJE.AccountingDate) Year,SUBSTRING(GJAE.ledgeraccount,1,5) Main_Account,SUBSTRING(GJAE.ledgeraccount,7,6) Cost_Center,ROUND(Cast(GJAE.ReportingCurrencyAmount as decimal(15,0)),0) Amount,NK.Minstry,MG.[Ministry Grouping],MG.[Regional Director],MG.AVP

FROM            dbo.GENERALJOURNALENTRY GJE 
                                          INNER JOIN
                                         dbo.GENERALJOURNALACCOUNTENTRY GJAE 
                                          on GJE.RECID = GJAE.GENERALJOURNALENTRY 
										 left join 
										 FM_Operations.dbo.NamingKey NK on Cast(NK.[Cost Center] as nvarchar) =  SUBSTRING(GJAE.ledgeraccount,7,6)
										 left join
										 FM_Operations.dbo.[Ministry Grouping] MG on MG.Ministry = NK.Minstry
 where Accountingdate between '7-1-2016' and '4-30-2017'  and SUBSTRING(GJAE.ledgeraccount,1,5) IN ('40200','43100')  and SUBSTRING(GJAE.ledgeraccount,7,6) >= '810100' and SUBSTRING(GJAE.ledgeraccount,7,6) NOT IN ('820300','820400')
 order by Cost_Center


 