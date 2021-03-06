/****** Script for SelectTopNRows command from SSMS  ******/
Use AX_Target;


--- Gets Non Contract Revenue PUTS into #T1 ---

SELECT       SUBSTRING(GJAE.ledgeraccount,7,6) Cost_Center,Sum((ROUND(Cast(GJAE.ReportingCurrencyAmount as decimal(15,0)),0))*-1) Non_Contract_Revenue_Amount

INTO #T1
FROM            dbo.GENERALJOURNALENTRY GJE 
                INNER JOIN
                dbo.GENERALJOURNALACCOUNTENTRY GJAE 
                on GJE.RECID = GJAE.GENERALJOURNALENTRY 
				left join 
				FM_Operations.dbo.NamingKey NK on Cast(NK.[Cost Center] as nvarchar) =  SUBSTRING(GJAE.ledgeraccount,7,6)
				left join
				FM_Operations.dbo.[Ministry Grouping] MG on MG.Ministry = NK.Minstry
where Accountingdate between '7-1-2016' and '6-30-2017'  
				and SUBSTRING(GJAE.ledgeraccount,1,5) IN ('40100')  and SUBSTRING(GJAE.ledgeraccount,7,6) >= '810100' 
				and SUBSTRING(GJAE.ledgeraccount,7,6) NOT IN ('820300','820400')
Group by SUBSTRING(GJAE.ledgeraccount,7,6)

--- Gets Contract Revenue PUTS into #T2 ---

SELECT        SUBSTRING(GJAE.ledgeraccount,7,6) Cost_Center,Sum((ROUND(Cast(GJAE.ReportingCurrencyAmount as decimal(15,0)),0))*-1) Contract_Revenue_Amount
INTO #T2
FROM            dbo.GENERALJOURNALENTRY GJE 
                INNER JOIN
                dbo.GENERALJOURNALACCOUNTENTRY GJAE 
                on GJE.RECID = GJAE.GENERALJOURNALENTRY 
				left join 
				FM_Operations.dbo.NamingKey NK on Cast(NK.[Cost Center] as nvarchar) =  SUBSTRING(GJAE.ledgeraccount,7,6)
				left join
				FM_Operations.dbo.[Ministry Grouping] MG on MG.Ministry = NK.Minstry
where Accountingdate between '7-1-2016' and '6-30-2017'  
                and SUBSTRING(GJAE.ledgeraccount,1,5) IN ('40200','43100')  
				and SUBSTRING(GJAE.ledgeraccount,7,6) >= '810100' 
				and SUBSTRING(GJAE.ledgeraccount,7,6) NOT IN ('820300','820400')
Group by SUBSTRING(GJAE.ledgeraccount,7,6)

--- Gets Total Expenses PUTS into #T3 ---

SELECT        SUBSTRING(GJAE.ledgeraccount,7,6) Cost_Center,Sum((ROUND(Cast(GJAE.ReportingCurrencyAmount as decimal(15,0)),0))*-1) Total_Expense

INTO #T3
FROM   dbo.GENERALJOURNALENTRY GJE 
	   INNER JOIN
	   dbo.GENERALJOURNALACCOUNTENTRY GJAE 
	   on GJE.RECID = GJAE.GENERALJOURNALENTRY 

where Accountingdate between '7-1-2016' and '6-30-2017'  
       and SUBSTRING(GJAE.ledgeraccount,1,5) NOT like '4%' 
	   and SUBSTRING(GJAE.ledgeraccount,1,5) > '399999'  
       and SUBSTRING(GJAE.ledgeraccount,7,6) >= '810100' 
	   and SUBSTRING(GJAE.ledgeraccount,7,6) NOT IN ('820300','820400')
 Group by SUBSTRING(GJAE.ledgeraccount,7,6)

--- Gets Ops Numbers PUTS into #T5 ---

SELECT [Cost_Center]
      ,Sum([Amount]/BM.[Sq Footage]) Total

  INTO #T5
  FROM [FM_OPERATIONS].[dbo].[FY17GL]
  left join FM_Operations.dbo.Benchmarks BM on BM.[Cost Center] = FY17GL.Cost_Center
  where Service_Supplies_Labor_Depreciation <> 'Depreciation' 
        and FY17GL.IS_ABR = 'No'
  
  Group by [Cost_Center]
  order by [Cost_Center]


--- Finds distribution of Contact/Non-Contract Revenue Puts into #T4---

Select #T1.Cost_Center,(#T1.Non_Contract_Revenue_Amount/(#T2.Contract_Revenue_Amount+#T1.Non_Contract_Revenue_Amount)) AS '% of Revenue is Non-Contract',
       (#T2.Contract_Revenue_Amount/(#T2.Contract_Revenue_Amount+#T1.Non_Contract_Revenue_Amount)) AS '% of Revenue is Contract'
INTO #T4
From #T1
left join #T2 on #T2.Cost_Center = #T1.Cost_Center


--- Comparison Table ---

Select BM.Region,BM.[Footage Grouping],RANK() OVER   
    (PARTITION BY BM.[Footage Grouping] ORDER BY ((TOTEXP.Total_Expense*-1)*#T4.[% of Revenue is Contract])/BM.[Sq Footage]  ) AS Rank  ,#T4.Cost_Center,(TOTEXP.Total_Expense*-1)/BM.[Sq Footage] as 'PNL Expense (Sq/Ft)',
((TOTEXP.Total_Expense*-1)*#T4.[% of Revenue is Contract])/BM.[Sq Footage] as 'PNL Expense (Sq/Ft) Contract Adj',
OPS.Total as 'Operations Less ABR (Sq/Ft)'

From #T4
left join #T3 TOTEXP on TOTEXP.Cost_Center = #T4.Cost_Center
left join FM_OPERATIONS.dbo.Benchmarks BM on BM.[Cost Center] = #T4.Cost_Center
left join #T5 OPS on OPS.Cost_Center = #T4.Cost_Center
where OPS.Total IS NOT NULL


--- Development Tables ---



Select BM.Region,BM.[Footage Grouping],
RANK() OVER(PARTITION BY BM.[Footage Grouping] ORDER BY ((TOTEXP.Total_Expense*-1)*#T4.[% of Revenue is Contract])/BM.[Sq Footage] ASC) AS Rank ,
#T4.Cost_Center,(TOTEXP.Total_Expense*-1)/BM.[Sq Footage] as 'PNL Expense (Sq/Ft)',
((TOTEXP.Total_Expense*-1)*#T4.[% of Revenue is Contract])/BM.[Sq Footage] as 'PNL Expense (Sq/Ft) Contract Adj',
OPS.Total as 'Operations Less ABR (Sq/Ft)'

From #T4
left join #T3 TOTEXP on TOTEXP.Cost_Center = #T4.Cost_Center
left join FM_OPERATIONS.dbo.Benchmarks BM on BM.[Cost Center] = #T4.Cost_Center
left join #T5 OPS on OPS.Cost_Center = #T4.Cost_Center
where OPS.Total IS NOT NULL and (TOTEXP.Total_Expense*-1)/BM.[Sq Footage] IS NOT NULL and ((TOTEXP.Total_Expense*-1)*#T4.[% of Revenue is Contract])/BM.[Sq Footage] IS NOT NULL

 

 --- Ops Footage Grouping ---

Select BM.[Footage Grouping],
AVG(OPS.Total) as 'Operations Less ABR (Sq/Ft)'

From #T4
left join #T3 TOTEXP on TOTEXP.Cost_Center = #T4.Cost_Center
left join FM_OPERATIONS.dbo.Benchmarks BM on BM.[Cost Center] = #T4.Cost_Center
left join #T5 OPS on OPS.Cost_Center = #T4.Cost_Center
where OPS.Total IS NOT NULL
Group by BM.[Footage Grouping]

 --- Ops Region Grouping ---

Select BM.[Region],
AVG(OPS.Total) as 'Operations Less ABR (Sq/Ft)'

From #T4
left join #T3 TOTEXP on TOTEXP.Cost_Center = #T4.Cost_Center
left join FM_OPERATIONS.dbo.Benchmarks BM on BM.[Cost Center] = #T4.Cost_Center
left join #T5 OPS on OPS.Cost_Center = #T4.Cost_Center
where OPS.Total IS NOT NULL
Group by BM.[Region]

--- ASHE Footage Grouping ---

Select BM.[ASHE Footage Grouping],
AVG(OPS.Total) as 'Operations Less ABR (Sq/Ft)'

From #T4
left join #T3 TOTEXP on TOTEXP.Cost_Center = #T4.Cost_Center
left join FM_OPERATIONS.dbo.Benchmarks BM on BM.[Cost Center] = #T4.Cost_Center
left join #T5 OPS on OPS.Cost_Center = #T4.Cost_Center
where OPS.Total IS NOT NULL
Group by BM.[ASHE Footage Grouping]
order by BM.[ASHE Footage Grouping] 


--- Hospital Type ---

Select BM.[Accred_Type_Tier1],
AVG(OPS.Total) as 'Operations Less ABR (Sq/Ft)'

From #T4
left join #T3 TOTEXP on TOTEXP.Cost_Center = #T4.Cost_Center
left join FM_OPERATIONS.dbo.Benchmarks BM on BM.[Cost Center] = #T4.Cost_Center
left join #T5 OPS on OPS.Cost_Center = #T4.Cost_Center
where OPS.Total IS NOT NULL 
Group by BM.[Accred_Type_Tier1]
order by BM.[Accred_Type_Tier1] 