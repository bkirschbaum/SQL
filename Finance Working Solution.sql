/****** Script for SelectTopNRows command from SSMS  ******/


Select a.PURCHID,a.Vendor_Name,a.[PSA Notes],a.TEXT,a.Quarter,a.Year,CONCAT(a.Year,a.Quarter) TimeIndex,a.Cost_Center,a.Minstry,a.[Ministry Grouping],a.PURCHID, Sum(Amount) Amount from

(

SELECT [PURCHID]
      ,[Vendor_Name]
      ,[Labor_Type]
      ,case when Datepart(m,[Accountingdate]) <= 3 then 'Q3'
	        when Datepart(m,[Accountingdate]) between 4 and 6 then 'Q4'
			when Datepart(m,[Accountingdate]) between 7 and 9 then 'Q1'
			else 'Q2' end as Quarter
      ,[TEXT]
      ,[Year]
      ,[Cost_Center]
      ,[Amount]
      ,[Minstry]
      ,[Ministry Grouping]
	  ,[PSA Notes]

  FROM [FM_OPERATIONS].[dbo].[FINANCECAPITALTRACKING]
  where purchid is not null and TEXT = 'Vendor product receipt'
) a
 Group by a.PURCHID,a.[PSA Notes],a.Vendor_Name,a.Quarter,a.TEXT,a.Year,CONCAT(a.Year,a.Quarter),a.Cost_Center,a.Minstry,a.[Ministry Grouping],a.PURCHID
 order by a.PURCHID