Use AX_Target;



/* Compile and Insert all Labor Expenses into Temp Table ##Labor */

Create Table ##Labor (Cost_Center nvarchar(6),Month int, Year int,Labor_Cost Float)


Insert into ##Labor

SELECT        SUBSTRING(GJAE.ledgeraccount,7,6) Cost_Center,Month(AccountingDate) Month, Year(AccountingDate) Year,Sum(GJAE.ReportingCurrencyAmount)

FROM            dbo.GENERALJOURNALENTRY GJE 
                                          INNER JOIN
                                         dbo.GENERALJOURNALACCOUNTENTRY GJAE 
                                          on GJE.RECID = GJAE.GENERALJOURNALENTRY 
										 left join 
										 FM_Operations.dbo.NamingKey NK on Cast(NK.[Cost Center] as nvarchar) =  SUBSTRING(GJAE.ledgeraccount,7,6)
										 left join
										 FM_Operations.dbo.[Ministry Grouping] MG on MG.Ministry = NK.Minstry

 where 

 SUBSTRING(GJAE.ledgeraccount,7,6) >= '810100'  and SUBSTRING(GJAE.ledgeraccount,7,6) NOT IN ('820300','820400') and SUBSTRING(GJAE.ledgeraccount,7,6) Not Like '%Asc%'

 and
 Accountingdate between '7-1-2016' and '4-30-2017' 
 /* Main Account Range */

 and 
 SUBSTRING(GJAE.ledgeraccount,1,5) IN ('62000','62010','62050','62100','62115','62150','62200','62250','62300','62350','62400','62450','62455','62500','62650','62460','62950','62550','68400','62700','62750','62800','62810')
 /* Cost Center Range */

 Group by SUBSTRING(GJAE.ledgeraccount,7,6),Month(AccountingDate), Year(AccountingDate)
 order by Cost_Center




 /* Compile and Insert all Service Contracts into Temp Table ##ServiceContracts */


Create Table ##ServiceContracts (Cost_Center nvarchar(6),Month int, Year int,Service_Contract_Cost Float)

Insert into ##ServiceContracts

SELECT        SUBSTRING(GJAE.ledgeraccount,7,6) Cost_Center,Month(AccountingDate) Month, Year(AccountingDate) Year,Sum(GJAE.ReportingCurrencyAmount)

FROM            dbo.GENERALJOURNALENTRY GJE 
                                          INNER JOIN
                                         dbo.GENERALJOURNALACCOUNTENTRY GJAE 
                                          on GJE.RECID = GJAE.GENERALJOURNALENTRY 
										 left join 
										 FM_Operations.dbo.NamingKey NK on Cast(NK.[Cost Center] as nvarchar) =  SUBSTRING(GJAE.ledgeraccount,7,6)
										 left join
										 FM_Operations.dbo.[Ministry Grouping] MG on MG.Ministry = NK.Minstry
 where 

 SUBSTRING(GJAE.ledgeraccount,7,6) >= '810100'  and SUBSTRING(GJAE.ledgeraccount,7,6) NOT IN ('820300','820400')

 and
 Accountingdate between '7-1-2016' and '4-30-2017' 
 /* Main Account Range */

 and 
 SUBSTRING(GJAE.ledgeraccount,1,5) = '55000'
 /* Cost Center Range */

 Group by SUBSTRING(GJAE.ledgeraccount,7,6),Month(AccountingDate), Year(AccountingDate)
 order by Cost_Center


 /* Compile and Insert all Service Contracts into Temp Table ##Supplies */

Create Table ##Supplies (Cost_Center nvarchar(6),Month int, Year int,Supplies_Cost Float)

Insert into ##Supplies

SELECT        SUBSTRING(GJAE.ledgeraccount,7,6) Cost_Center,Month(AccountingDate) Month, Year(AccountingDate) Year,Sum(GJAE.ReportingCurrencyAmount)

FROM            dbo.GENERALJOURNALENTRY GJE 
                                          INNER JOIN
                                         dbo.GENERALJOURNALACCOUNTENTRY GJAE 
                                          on GJE.RECID = GJAE.GENERALJOURNALENTRY 
										 left join 
										 FM_Operations.dbo.NamingKey NK on Cast(NK.[Cost Center] as nvarchar) =  SUBSTRING(GJAE.ledgeraccount,7,6)
										 left join
										 FM_Operations.dbo.[Ministry Grouping] MG on MG.Ministry = NK.Minstry
 where 

 SUBSTRING(GJAE.ledgeraccount,7,6) >= '810100'  and SUBSTRING(GJAE.ledgeraccount,7,6) NOT IN ('820300','820400')

 and
 Accountingdate between '7-1-2016' and '4-30-2017' 
 /* Main Account Range */

 and 
 SUBSTRING(GJAE.ledgeraccount,1,5) IN ('50000','51000','52000','52005','52050','52100','52125','58000','53000','53100','53200','57500','57500')
 /* Cost Center Range */

 Group by SUBSTRING(GJAE.ledgeraccount,7,6),Month(AccountingDate), Year(AccountingDate)
 order by Cost_Center

 /* Compile and Insert all Service Contracts into Temp Table ##Services */

Create Table ##Services (Cost_Center nvarchar(6),Month int, Year int,Services_Cost Float)

Insert into ##Services

SELECT        SUBSTRING(GJAE.ledgeraccount,7,6) Cost_Center,Month(AccountingDate) Month, Year(AccountingDate) Year,Sum(GJAE.ReportingCurrencyAmount)

FROM            dbo.GENERALJOURNALENTRY GJE 
                                          INNER JOIN
                                         dbo.GENERALJOURNALACCOUNTENTRY GJAE 
                                          on GJE.RECID = GJAE.GENERALJOURNALENTRY 
										 left join 
										 FM_Operations.dbo.NamingKey NK on Cast(NK.[Cost Center] as nvarchar) =  SUBSTRING(GJAE.ledgeraccount,7,6)
										 left join
										 FM_Operations.dbo.[Ministry Grouping] MG on MG.Ministry = NK.Minstry
 where 

 SUBSTRING(GJAE.ledgeraccount,7,6) >= '810100'  and SUBSTRING(GJAE.ledgeraccount,7,6) NOT IN ('820300','820400')

 and
 Accountingdate between '7-1-2016' and '4-30-2017' 
 /* Main Account Range */

 and 
 SUBSTRING(GJAE.ledgeraccount,1,5) IN ('54000','54500')
 /* Cost Center Range */

 Group by SUBSTRING(GJAE.ledgeraccount,7,6),Month(AccountingDate), Year(AccountingDate)
 order by Cost_Center

/* Compile and Insert all Expenses into Temp Table ##TotalExpenses */

Create Table ##TotalExpenses (Cost_Center nvarchar(6),Month int, Year int,Total_Cost Float)

Insert into ##TotalExpenses

Select Cost_Center,Month,Year,Sum(Amount)

From

(

SELECT        Month(GJE.AccountingDate) Month,Year(GJE.AccountingDate) Year,SUBSTRING(GJAE.ledgeraccount,1,5) Main_Account,SUBSTRING(GJAE.ledgeraccount,7,6) Cost_Center,GJAE.ReportingCurrencyAmount Amount,NK.Minstry,MG.[Ministry Grouping],MG.[Regional Director],MG.AVP,
              ROW_NUMBER() OVER(PARTITION BY GJAE.RECID ORDER BY GJAE.RECID) duplicateCounter, GJAE.recid

FROM            dbo.GENERALJOURNALENTRY GJE 
                                          INNER JOIN
                                         dbo.GENERALJOURNALACCOUNTENTRY GJAE 
                                          on GJE.RECID = GJAE.GENERALJOURNALENTRY 
										 left join 
										 FM_Operations.dbo.NamingKey NK on Cast(NK.[Cost Center] as nvarchar) =  SUBSTRING(GJAE.ledgeraccount,7,6)
										 left join
										 FM_Operations.dbo.[Ministry Grouping] MG on MG.Ministry = NK.Minstry
 where Accountingdate between '7-1-2016' and '4-30-2017'  and SUBSTRING(GJAE.ledgeraccount,1,5) NOT like '4%' and SUBSTRING(GJAE.ledgeraccount,1,5) > '399999'  and SUBSTRING(GJAE.ledgeraccount,7,6) >= '810100' and SUBSTRING(GJAE.ledgeraccount,7,6) NOT IN ('820300','820400')


 )
 a

 where duplicateCounter = 1 and Cost_Center Not Like '-%'

 Group by Cost_Center,Month, Year
 order by Cost_Center

 Select * from ##TotalExpenses


 



 Select SC.Cost_Center,SC.Month,SC.Year,SC.Service_Contract_Cost,Lab.Labor_Cost,Sup.Supplies_Cost,SERV.Services_Cost,TEX.Total_Cost-SERV.Services_Cost-Sup.Supplies_Cost-Lab.Labor_Cost-SC.Service_Contract_Cost Other_Expenses,TEX.Total_Cost Total_Cost,NK.Site_Name,NK.Minstry,MG.[Ministry Grouping],MG.[Regional Director],MG.AVP
 from ##ServiceContracts SC
 inner join ##labor Lab on Lab.Cost_Center = SC.Cost_Center and Lab.Month = SC.Month and Lab.year = SC.year
 inner join ##supplies SUP on SUP.Cost_Center = SC.Cost_Center and SUP.Month = SC.Month and SUP.year = SC.year
 inner join ##services SERV on SERV.Cost_Center = SC.Cost_Center and SERV.Month = SC.Month and SERV.year = SC.year
 inner join ##Totalexpenses TEX on TEX.Cost_Center = SC.Cost_Center and TEX.Month = SC.Month and TEX.year = SC.year
 left join FM_Operations.dbo.NamingKey NK on NK.[Cost Center] = SC.Cost_Center
 left join FM_Operations.dbo.[Ministry Grouping] MG on MG.Ministry = NK.Minstry 



 





