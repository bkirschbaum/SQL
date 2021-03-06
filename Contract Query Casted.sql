/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [Cost Center]
      ,[Vendor Name]
      ,[Contract ID]
      ,[Record ID]
      ,[Contract Notes]
      ,[Sector]
      ,CAST([Contract Start Date] as SmallDateTime) as 'Contract Start Date'
	  ,CAST([Contract End Date] as SmallDateTime) as 'Contract End Date'
	  ,CAST([Responsible Date] as SmallDateTime) as 'Responsible Date'
	  ,[Contract Monthly Amount]
	  ,CAST([Entered Date] as SmallDateTime) as 'Responsible Date'
	  ,CAST([GL Date] as SmallDateTime) as 'GL Date'
      ,[Invoice ID]
      ,[Invoice Number]
      ,[Invoice Amount]
      ,[GL Amount]
	  ,CAST([Billing Period Start Date] as SmallDateTime) as 'Billing Period Start Date'
      ,[Invoice Months Covered]
      ,[Prepaid]
      ,[Prior Period]
      ,[Invoice Notes]
      ,[Source]
	  ,CAST([Month End Period] as SmallDateTime) as 'Month End Period'
      ,[Month End Period]
      ,[PO Number]
  FROM [Cost Equation Demo].[dbo].[ServiceContract]