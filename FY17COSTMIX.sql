/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [Cost Center]
      ,[Trade]
      ,[Total Cost by Trade] Labor_Cost

INTO #Labor
FROM [FM_OPERATIONS].[dbo].[FY17_Labor]


SELECT [Trade]
      ,[Cost Center]
      ,[Sum of Grouping]
	  INTO #Service
  FROM [FM_OPERATIONS].[dbo].[FY17_Serv_Supp]
  where Service_Supplies = 'Service'

  SELECT [Trade]
      ,[Cost Center]
      ,[Sum of Grouping]
	  INTO #Supplies
  FROM [FM_OPERATIONS].[dbo].[FY17_Serv_Supp]
  where Service_Supplies = 'Supplies'



Select SERV.[Cost Center],NK.Site_Name,Serv.Trade,serv.[Sum of Grouping] Service_Cost,SUP.[Sum of Grouping] Supplies_Cost,LAB.Labor_Cost INTO FY17COSTMIX
from #Service SERV

left join #Supplies SUP on SUP.[Cost Center]=SERV.[Cost Center] and SUP.Trade=SERV.Trade
left join #Labor LAB on LAB.[Cost Center]=SERV.[Cost Center] and Lab.Trade=SERV.Trade
left join NamingKey NK on NK.[Cost Center] = Serv.[Cost Center]