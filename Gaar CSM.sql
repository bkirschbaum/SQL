/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [Record ID]
      ,[Contract ID]
      ,[CC -CAMPUS DESCRIPTION]
      ,[QUARTERLY AMOUNT]
      ,[ANNUAL AMOUNT]
      ,[Responsible Date]
      ,[Deactivated Y/N]
      ,[Deactivation Date]
      ,[Deactivation Reason]
      ,[FM Director E-mail]
      ,[NOTES]
      ,[Expiration Notes]
      ,[Date of Contact]
      ,[Payment Frequency]
      ,[Svc Descr]
	  ,[MONTHLY AMOUNT]
	  ,[CC -CAMPUS DESCRIPTION]
      ,[SSMA_TimeStamp]
  FROM [FM_CONTRACTS].[dbo].[Master Contract PO Lines]
  where [Deactivated Y/N] = 0
  order by [MONTHLY AMOUNT] desc


  SELECT sum([MONTHLY AMOUNT])

  FROM [FM_CONTRACTS].[dbo].[Master Contract PO Lines]
  where [Deactivated Y/N] = 0
