/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
      [ACCOUNTINGDATE]
      ,Substring([LEDGERACCOUNT],1,6) Main_Account
	  ,Substring([LEDGERACCOUNT],8,5) Cost_Center
	  ,Replace(RIGHT(LEDGERACCOUNT,CHARINDEX ('-' ,REVERSE(LEDGERACCOUNT))),'-','') Trade
	  ,'Expense' as 'Budget/Expense'
      ,[REPORTINGCURRENCYAMOUNT]
FROM [D365BYOD].[dbo].[GeneralJournalAccountEntryStaging]

where  ACCOUNTINGDATE between '7/1/2017' and '2/28/2018'

UNION ALL

SELECT [DATE] as 'ACCOUNTINGDATE'
      ,Substring([DIMENSIONDISPLAYVALUE],1,6) Main_Account
	  ,Substring([DIMENSIONDISPLAYVALUE],8,5) Cost_Center
	  ,Case when ISNUMERIC(Replace(RIGHT([DIMENSIONDISPLAYVALUE],CHARINDEX ('-' ,REVERSE([DIMENSIONDISPLAYVALUE]))),'-','')) = 1 then 'None' 
			else Replace(RIGHT([DIMENSIONDISPLAYVALUE],CHARINDEX ('-' ,REVERSE([DIMENSIONDISPLAYVALUE]))),'-','')
			END AS  Trade
	  ,'Budget' as 'Budget/Expense'
      ,[ACCOUNTINGCURRENCYAMOUNT] as 'REPORTINGCURRENCYAMOUNT'
  FROM [D365BYOD].[dbo].[BudgetRegisterEntryStaging]

  where  date between '7/1/2017' and '2/28/2018'