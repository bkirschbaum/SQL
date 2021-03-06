/****** Script for SelectTopNRows command from SSMS  ******/
SELECT Sum(Amount) Amount, COSTCENTERID,CostCenterName,
	   CASE WHEN COSTCENTERID IN ('20139','20140','20141') then 'Outsourced'
	   else 'Insourced' end as Landscaping
	  ,CASE WHen COSTCENTERID IN ('20101','20102','20131','20132','20137') then 'Insourced'
	   else 'Outsourced' end as Snow


  FROM [Finance].[FinanceData]
  left join Account_MAP AM
  on AM.Main_Account =FinanceData.MainAccountID
  where trade = 'lndscp' and [FISCAL_YEAR] = 2018 
						 and [Profit_and_Loss_Grouping] IN ('Compensation','Parts and Supplies','Demand Labor and Services', 'Other Expenses')
						 and COSTCENTERID like '201%' 
						 and CALENDAR_MONTH < 7
						 and VENDORACCOUNTNUMBER = 'V002139'

  GROUP BY COSTCENTERID, CostCenterName
  order by CostCENTERID, Landscaping,Snow
