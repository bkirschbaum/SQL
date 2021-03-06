/****** Script for SelectTopNRows command from SSMS  ******/
SELECT Distinct Count([Supervisor Employee Number]) as 'Direct Reports',[Supervisor Employee Number],t2.[First Name],t2.[Last Name],t2.[Department Code (OrgLvl1)],BM.[Site Name]

  FROM [FM_OPERATIONS].[dbo].[NEM]
  
  left join (Select distinct [First Name],[Last Name],[Employee Number],[Department Code (OrgLvl1)] from NEM where [Employee Number] in (Select Distinct [Supervisor Employee Number] from NEM)) t2
  on t2.[Employee Number] = NEM.[Supervisor Employee Number]
  
  left join Benchmarks BM 
  on BM.[Cost Center] = NEM.[Department Code (OrgLvl1)]
  
  where NEM.[Department Code (OrgLvl1)] like '8900%'
  
  Group by [Supervisor Employee Number],t2.[First Name],t2.[Last Name],t2.[Department Code (OrgLvl1)],BM.[Site Name]