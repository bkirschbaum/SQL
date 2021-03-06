/****** Script for SelectTopNRows command from SSMS  ******/
SELECT Case when NEM.[Employee Number] not in (Select Distinct [Supervisor Employee Number] from FM_OPERATIONS.dbo.NEM where [Supervisor Employee Number] is not null)  then OEM.[Position ID #]
       end as 'POS ID'
      ,NEM.[CO]
      ,NEM.[FT PT]
      ,NEM.[Job Code]
      ,NEM.[Job]
      ,NEM.[Last Name]
      ,NEM.[First Name]
      ,NEM.[Preferred First Name]
      ,NEM.[Employee Number]
      ,NEM.[Department Code (OrgLvl1)]
      ,NEM.[Department]
      ,NEM.[Site Code (OrgLvl2)]
      ,NEM.[Site Code]
      ,NEM.[DIV Code (OrgLvl3)]
      ,NEM.[Division]
      ,NEM.[Region Code (OrgLvl4)]
      ,NEM.[Region]
      ,NEM.[Original Hire]
      ,NEM.[Supervisor Employee Number]
      ,NEM.[Pay Group Code]
      ,NEM.[Supervisor]
      ,NEM.[Supervisor Email]
      ,NEM.[Location Code]
      ,NEM.[Location]
      ,NEM.[EEID]
      ,NEM.[Last Hire]
	  ,CONCAT(OEM.Job,OEM.[Employee Number]) as 'Old Title'
	  ,CONCAT(NEM.Job,right(NEM.[Employee Number],4)) as 'New Title'
	  
	  
  
  FROM [FM_OPERATIONS].[dbo].[NEM]
  left join FM_OPERATIONS.dbo.OEM 
  on OEM.[Employee Number] = NEM.[Employee Number]



  --- Dropped Employees ---
Select * from FM_OPERATIONS.dbo.OEM
where [Employee Number] not in (Select [Employee Number] from FM_OPERATIONS.dbo.NEM where [Employee Number] is not null)

  --- Added Employees ---
Select * from FM_OPERATIONS.dbo.NEM
where [Employee Number] not in (Select [Employee Number] from FM_OPERATIONS.dbo.OEM where [Employee Number] is not null)

 


