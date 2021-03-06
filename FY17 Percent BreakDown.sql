
  WITH TOTAL_CTE ([Cost Center], Total)
  AS
  (
  Select [Cost Center], Sum(iSNULL(Service_Cost,0)+ISNULL(Supplies_Cost,0)+ISNULL(Labor_Cost,0)) Total

  FRom FM_OPERATIONS.dbo.FY17COSTMIX
  Group by [Cost Center]
  )
  Select FY17COSTMIX.[Cost Center]
      ,[Site_Name]
      ,[Trade]
      ,isnull(([Service_Cost] / TOT.Total),0) AS 'Service % of Total Spend'
      ,isnull(([Supplies_Cost] / TOT.Total),0) AS 'Supplies % of Total Spend'
      ,isnull(([Labor_Cost] / TOT.Total),0) AS 'Labor % of Total Spend'
	  from [FM_OPERATIONS].[dbo].[FY17COSTMIX]
	  left join TOTAL_CTE TOT on TOT.[Cost Center] = FY17COSTMIX.[Cost Center]
