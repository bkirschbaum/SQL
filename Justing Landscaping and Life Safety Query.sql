/****** Script for SelectTopNRows command from SSMS  ******/
SELECT NK.[Cost Center]
      ,NK.Site_Name

      ,TAK.[Trade]
	  ,Sum([Count]) Total
	  

  FROM [FM_OPERATIONS].[dbo].[HR Master]
  left join TitleAsheKey TAK on TAK.[Position Title] = [HR Master].job
  left join NamingKey NK on NK.[Cost Center] = [HR Master].[Department Code (OrgLvl1)]
  where [Department Code (OrgLvl1)] not like ('800%')and TAK.Trade IN ('Life Safety','Landscaping')

  Group by NK.[Cost Center]
      ,NK.Site_Name
      ,TAK.[Trade]

  Order by NK.[Cost Center]



  Begin Tran

  Update NamingKey 
  Set Site_Name = 'Seton Service Plant Operations'

  where [Cost Center] = 830112

  Commit Tran