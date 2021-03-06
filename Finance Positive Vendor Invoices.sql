/****** Script for SelectTopNRows command from SSMS  ******/



SELECT [PURCHID]
      ,[Vendor_Name]
      ,[Labor_Type]
	  ,Accountingdate
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
  where purchid = 'MFAC-P-101932' and TEXT = 'Vendor invoice' and Amount > 0
