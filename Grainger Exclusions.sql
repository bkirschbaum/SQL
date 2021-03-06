/****** Script for SelectTopNRows command from SSMS  ******/
SELECT Distinct
       Case when Item_Description  like 'PART%'THEN LTRIM(RTRIM(right(Item_Description,CHARINDEX(',',reverse(Item_Description))-1)))
	        when Item_Description  not like '%,%' THEN Item_Description
	   else left(Item_Description,CHARINDEX(',',Item_Description)-1)
	   end as Test

  FROM [ConsolidatedReports].[dbo].[FM - Part Group Mapping]
  where [Include/Exclude] = 'Exclude'
  order by Test



 