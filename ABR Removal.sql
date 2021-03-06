/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [PSA Notes]
      ,[LTSG]
      ,[IS_ABR]
      ,[Sector]
      ,[Trade]
      ,[Item_Description]
      ,[ledgeraccount]
      ,[benchmarking]
      ,[pnlgrouping]
      ,[Service_Supplies_Labor_Depreciation]
      ,[SUBLEDGERVOUCHER]
      ,[PURCHID]
      ,[Service_ref]
      ,[Vendor_Name]
      ,[Labor_Type]
      ,[Accountingdate]
      ,[TEXT]
      ,[Month]
      ,[Year]
      ,[Main_Account]
      ,[Cost_Center]
      ,[Amount]
      ,[Minstry]
      ,[Ministry Grouping]
      ,[Regional Director]
      ,[AVP]
      ,[aduplicatecounter]
      ,[idlocation]
      ,[location]
      ,[Is Main Hospital?]
  FROM [FM_OPERATIONS].[dbo].[FY17GL]
  where amount > 50000 and [IS_ABR] <> 'Yes' and [Service_Supplies_Labor_Depreciation] not in ('Labor','Depreciation')
  and LTSG = 'Invoice' and TEXT like '%vendor invoice%' 
  order by Amount DESC


  --- Append As ABRS ---
  /* Leave anything with Landscaping in as NON - ABR 
  
  Define the steps? Potential Pitfalls? Reviewing what the path forward is?
  
  */


