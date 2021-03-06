/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [Org Level 1 Code]
      ,[Current Amount]*1.3 Current_Amount_With_Benefits
      ,[Pay Date]
      ,[Company]
	  ,titles.Sector
	  ,titles.Trade
      ,Labor.[Job Title]
      ,NK.Minstry
	  ,CAT.[Ops Category]
	  ,LEFT(INVENTSITEID,2) State
	  ,MG.[Regional Director]
	  ,MG.AVP
	  ,NK.Site_Name
	  ,TAK.ASHE
	  ,[Employee Number]
  FROM [Cost Equation Demo].[dbo].[Labor]
  left join LaborCategory_OpsCategory CAT on CAT.[Labor Category] = Labor.Category
  left join NamingKey NK on NK.[Cost Center] = Labor.[Org Level 1 Code]
  left join Ministry_Grouping MG on MG.Ministry = NK.Minstry
  left join titles on titles.[Job Title] = Labor.[Job Title]
  left join TitleAsheKey TAK on TAK.[Position Title] = labor.[Job Title]
  where [Pay Date] between '5-1-2016' and '4-30-2017'