Select a.Year,a.Cost_Center,a.PnLGrouping,sum(a.Amount)
FROM 
(
SELECT        GJE.ACCOUNTINGDATE,Month(GJE.AccountingDate) Month,Year(GJE.AccountingDate) Year,NK.Site_Name,SUBSTRING(GJAE.ledgeraccount,1,5) Main_Account,SUBSTRING(GJAE.ledgeraccount,7,6) Cost_Center,ROUND(Cast(GJAE.ReportingCurrencyAmount as decimal(15,0)),0) Amount,NK.Minstry,MG.[Ministry Grouping],MG.[Regional Director],MG.AVP,PnL.PnLGrouping
FROM            AX_Target.dbo.GENERALJOURNALENTRY GJE 
                                          INNER JOIN
                                         AX_Target.dbo.GENERALJOURNALACCOUNTENTRY GJAE 
                                          on GJE.RECID = GJAE.GENERALJOURNALENTRY 
										 left join 
										 FM_Operations.dbo.NamingKey NK on Cast(NK.[Cost Center] as nvarchar) =  SUBSTRING(GJAE.ledgeraccount,7,6)
										 left join
										 FM_Operations.dbo.[Ministry Grouping] MG on MG.Ministry = NK.Minstry
										 left join FM_Operations.dbo.PnLMap PnL on PnL.[Main Account] = SUBSTRING(GJAE.ledgeraccount,1,5)
 where Accountingdate between '7-1-2015' and '6-30-2016'and SUBSTRING(GJAE.ledgeraccount,1,5) between '62000' and '62455' or Accountingdate between '7-1-2015' and '6-30-2016' and SUBSTRING(GJAE.ledgeraccount,1,5) IN ('62500','62650','62460','62950','62550','68400') or Accountingdate between '7-1-2015' and '6-30-2016' and SUBSTRING(GJAE.ledgeraccount,1,5) between '62700' and '62810'
 )
 a
  where  a.Cost_Center in ('885000','85001')  and a.Cost_Center NOT IN ('820300','820400','901001') /* Account Range */ and a.Cost_Center Like '%[0-9]%' and a.Site_Name <> 'Borgess Woodbridge'



group by A.Year,a.Cost_Center,a.PnLGrouping
order by Year,Cost_Center, PnLGrouping DESC


Select a.* from

(

SELECT        GJAE.LEDGERACCOUNT,GJE.ACCOUNTINGDATE,Month(GJE.AccountingDate) Month,Year(GJE.AccountingDate) Year,NK.Site_Name,SUBSTRING(GJAE.ledgeraccount,1,5) Main_Account,SUBSTRING(GJAE.ledgeraccount,7,6) Cost_Center,ROUND(Cast(GJAE.ReportingCurrencyAmount as decimal(15,0)),0) Amount,NK.Minstry,MG.[Ministry Grouping],MG.[Regional Director],MG.AVP,PnL.PnLGrouping
FROM            AX_Target.dbo.GENERALJOURNALENTRY GJE 
                                          INNER JOIN
                                         AX_Target.dbo.GENERALJOURNALACCOUNTENTRY GJAE 
                                          on GJE.RECID = GJAE.GENERALJOURNALENTRY 
										 left join 
										 FM_Operations.dbo.NamingKey NK on Cast(NK.[Cost Center] as nvarchar) =  SUBSTRING(GJAE.ledgeraccount,7,6)
										 left join
										 FM_Operations.dbo.[Ministry Grouping] MG on MG.Ministry = NK.Minstry
										 left join FM_Operations.dbo.PnLMap PnL on PnL.[Main Account] = SUBSTRING(GJAE.ledgeraccount,1,5)
 where Accountingdate between '7-1-2015' and '6-30-2016'and SUBSTRING(GJAE.ledgeraccount,1,5) between '62000' and '62455' or Accountingdate between '7-1-2015' and '6-30-2016' and SUBSTRING(GJAE.ledgeraccount,1,5) IN ('62500','62650','62460','62950','62550','68400') or Accountingdate between '7-1-2015' and '6-30-2016' and SUBSTRING(GJAE.ledgeraccount,1,5) between '62700' and '62810'
 )
 a
  where  a.Cost_Center in ('885000','85001')  and a.Cost_Center NOT IN ('820300','820400','901001') /* Account Range */ and a.Cost_Center Like '%[0-9]%' and a.Site_Name <> 'Borgess Woodbridge'