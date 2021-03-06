/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [BD DB].[Ministry]
      ,PNL.[Ops Ministry]
	  ,Case when Cast([BD DB].Supplies as varchar(10)) = '1' then 'Supplies'
	        when Cast([BD DB].Supplies as varchar(10)) = '0' then 'Service'
			else Cast([BD DB].Supplies as varchar(10)) end as Supplies
	  ,Sum(coalesce([BD DB].Monetary_Amount + adjustments,Monetary_Amount,adjustments)) Total

  FROM [FM_OPERATIONS].[dbo].[BD DB]
  left join PnLValues PNL on PNL.CSA_ID = [BD DB].Ministry


  Group by [BD DB].Ministry,PNL.[Ops Ministry],[BD DB].Supplies
  order by Ministry








