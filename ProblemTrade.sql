/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [IDWorkOrder]
      ,WorkOrder.[IDCustomer]
      ,WorkOrder.[IDCustomerSegment]
      ,[WONumber]
      ,[WODescription]
	  ,Trade.TradeDescription
	  ,PC.Problem
	  ,WorkOrder.[IDProblem]
      ,[IDWOTrade]
      ,[IDWOLocation]
      ,[LocationOther]
      ,[IDWOStatus]
      ,[WODateAvailable]
      ,[WODateNeededBy]
      ,[WODateCompleted]
  FROM [CMS].[dbo].[WorkOrder]
  inner join Trade on Trade.IDTrade = WorkOrder.IDWOTrade
  inner join ProblemChoice PC on PC.IDProblem = WorkOrder.IDProblem
  where (WODateCompleted between '7-1-2016' and '6-30-2017')
  order by NEWID()

SELECT Distinct Trade.TradeDescription
	  ,PC.Problem
	  ,WorkOrder.[IDProblem]
	  ,Count(PC.Problem) Count
  FROM [CMS].[dbo].[WorkOrder]
  inner join Trade on Trade.IDTrade = WorkOrder.IDWOTrade
  inner join ProblemChoice PC on PC.IDProblem = WorkOrder.IDProblem
  where WODateCompleted between '7-1-2016' and '6-30-2017'
  Group by Trade.TradeDescription
	  ,PC.Problem
	  ,WorkOrder.[IDProblem]
  order by Problem