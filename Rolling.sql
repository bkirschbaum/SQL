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
      ,Case when Minstry = 'Amsterdam' THEN [Amount]*12/7 else [Amount] end as Amount
      ,[Minstry]
      ,[Ministry Grouping]
      ,[Regional Director]
      ,[AVP]
      ,[aduplicatecounter]
      ,[CREATEDBY]
      ,[IS_MVP]
  FROM [FM_OPERATIONS].[dbo].[RollingAXLinesDec16Nov17]
 