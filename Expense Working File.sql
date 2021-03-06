/****** Script for SelectTopNRows command from SSMS  ******/
Use AX_Target;


Select *

From

(

SELECT        Month(GJE.AccountingDate) Month,Year(GJE.AccountingDate) Year,SUBSTRING(GJAE.ledgeraccount,1,5) Main_Account,SUBSTRING(GJAE.ledgeraccount,7,6) Cost_Center,ROUND(Cast(GJAE.ReportingCurrencyAmount as decimal(15,0)),0) Amount,NK.Minstry,MG.[Ministry Grouping],MG.[Regional Director],MG.AVP,
              ROW_NUMBER() OVER(PARTITION BY GJAE.RECID ORDER BY GJAE.RECID) duplicateCounter, GJAE.recid

FROM            dbo.GENERALJOURNALENTRY GJE 
                                          INNER JOIN
                                         dbo.GENERALJOURNALACCOUNTENTRY GJAE 
                                          on GJE.RECID = GJAE.GENERALJOURNALENTRY 
										 left join 
										 FM_Operations.dbo.NamingKey NK on Cast(NK.[Cost Center] as nvarchar) =  SUBSTRING(GJAE.ledgeraccount,7,6)
										 left join
										 FM_Operations.dbo.[Ministry Grouping] MG on MG.Ministry = NK.Minstry
 where Accountingdate between '5-1-2017' and '5-31-2017'  and SUBSTRING(GJAE.ledgeraccount,1,5) NOT like '4%' and SUBSTRING(GJAE.ledgeraccount,1,5) > '399999'  and SUBSTRING(GJAE.ledgeraccount,7,6) >= '810100' and SUBSTRING(GJAE.ledgeraccount,7,6) NOT IN ('820300','820400')


 )
 a

 where duplicateCounter = 1

 