/****** Script for SelectTopNRows command from SSMS  ******/
SELECT Distinct DT.DateKey,[PURCHID] ,text, 
           ROW_NUMBER() OVER(PARTITION BY DT.DateKey
                                 ORDER BY DT.DateKey ASC) AS order123
  into #T2
  FROM [mart].[f_FinanceData]
  left join mart.d_Date DT on DT.DateKey = [f_FinanceData].datekey 
  where text like 'Vendor invoice' and purchid like 'mfac-[0-9]%'


SELECT Distinct DT.DateKey,[PURCHID] ,text
  into #T1
  FROM [mart].[f_FinanceData]
  left join mart.d_Date DT on DT.DateKey = [f_FinanceData].datekey 

  where text like '%receipt%' and purchid like 'mfac-[0-9]%'

    

  Select 
  
  --#T1.DateKey as 'Receipt Date',#T2.PURCHID,#T2.DateKey as 'First Invoice Date'
  AVG(#T2.DateKey - #T1.DateKey)
  from #T2 
  inner join #T1 on #T1.PURCHID = #T2.PURCHID
  where order123 = 1

  Drop Table #T1,#T2