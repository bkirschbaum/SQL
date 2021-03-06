/****** Script for SelectTopNRows command from SSMS  ******/
USE FM_OPERATIONS;


--- Internal Benchmarks ---

Create Table #CrossJoin (Cost_Center nvarchar(6),[ASHE Category] nvarchar (50))

Insert Into #CrossJoin

Select Distinct NamingKey.[Cost Center],[ASHE Category]

From [HR Master]
Cross Join NamingKey where [ASHE Category] IS NOT NULL and [ASHE Category] <> '0'

Create Table #FootageCount (Site_Count float(1),[Footage Grouping] nvarchar(20))

Insert Into #FootageCount 

Select Count([ASHE Footage Grouping]) AS 'Sites in Group', [ASHE Footage Grouping] From Benchmarks Group by [ASHE Footage Grouping]


Create Table #Internal_BM ([Footage Grouping] nvarchar(20),[ASHE Category] nvarchar(25),Amount Float, ASHEAmount Float)

Insert Into #Internal_BM

/* Benchmark Table in Excel */

SELECT BM.[ASHE Footage Grouping]
	  ,[HR Master].[ASHE Category]
	  ,(Count([Count])/ FC.Site_Count) Internal_BM
	  ,ABM.[ASHE BM]  

  FROM [FM_OPERATIONS].[dbo].[HR Master]
  left join FM_OPERATIONS.dbo.NamingKey NK on NK.[Cost Center] = [HR Master].[Department Code (OrgLvl1)]
  left join FM_OPERATIONS.dbo.Benchmarks BM on BM.[Cost Center] = [HR Master].[Department Code (OrgLvl1)]
  left join #FootageCount FC on FC.[Footage Grouping] = BM.[ASHE Footage Grouping]
  left join [ASHE BM] ABM on ABM.[SF Category] = BM.[ASHE Footage Grouping] and ABM.[ASHE Category]=[HR Master].[ASHE Category]
  where [Sq Footage] IS NOT NULL and [HR Master].[ASHE Category] <> '0'

  Group by  BM.[ASHE Footage Grouping],[HR Master].[ASHE Category],ABM.[ASHE BM],FC.Site_Count
  order by BM.[ASHE Footage Grouping],[HR Master].[ASHE Category],ABM.[ASHE BM]






  /* Site Level Data in Excel */

 
Select BM.[Cost Center],NK.Minstry,NK.Site_Name,BM.[Sq Footage],BM.[Footage Grouping],BM.[ASHE Footage Grouping],BM.Region,Cj.[ASHE Category],
       ABM.[ASHE BM]
	  ,IBM.Amount AS 'Internal Amount'
	  ,Count(HR.[Count]) AS 'Current Employee Count'

From #CrossJoin CJ
left join FM_OPERATIONS.dbo.NamingKey NK on NK.[Cost Center] = CJ.Cost_Center
left join FM_OPERATIONS.dbo.Benchmarks BM on BM.[Cost Center] = Cj.Cost_Center
left join #Internal_BM IBM on IBM.[Footage Grouping]= BM.[ASHE Footage Grouping] and IBM.[ASHE Category] = CJ.[ASHE Category]
left join [ASHE BM] ABM on ABM.[SF Category] = BM.[ASHE Footage Grouping] and ABM.[ASHE Category] = CJ.[ASHE Category]
left join [HR Master] HR on HR.[ASHE Category] = CJ.[ASHE Category] and HR.[Department Code (OrgLvl1)] = CJ.Cost_Center
where CJ.[ASHE Category] <> '0' and CJ.[ASHE Category] NOT IN ('EOC/Emergency Management','Landscaping','Life Safety') and BM.[Cost Center] IS NOT NULL

Group By 
BM.[Cost Center],NK.Minstry,NK.Site_Name,BM.[Sq Footage],BM.[Footage Grouping],BM.[ASHE Footage Grouping],BM.Region,Cj.[ASHE Category],
       ABM.[ASHE BM]
	  ,IBM.Amount

PRINT 'Site Level Data Pull'









/* Site Total - Overall */

Select BM.[Cost Center],NK.Minstry,NK.Site_Name,BM.[Sq Footage],BM.[Footage Grouping],BM.[ASHE Footage Grouping],BM.Region,Cj.[ASHE Category],
       ABM.[ASHE BM]
	  ,IBM.Amount AS 'Internal Amount'
	  ,Count(HR.[Count]) AS 'Current Employee Count'

INTO #Site_Level


From #CrossJoin CJ
left join FM_OPERATIONS.dbo.NamingKey NK on NK.[Cost Center] = CJ.Cost_Center
left join FM_OPERATIONS.dbo.Benchmarks BM on BM.[Cost Center] = Cj.Cost_Center
left join #Internal_BM IBM on IBM.[Footage Grouping]= BM.[ASHE Footage Grouping] and IBM.[ASHE Category] = CJ.[ASHE Category]
left join [ASHE BM] ABM on ABM.[SF Category] = BM.[ASHE Footage Grouping] and ABM.[ASHE Category] = CJ.[ASHE Category]
left join [HR Master] HR on HR.[ASHE Category] = CJ.[ASHE Category] and HR.[Department Code (OrgLvl1)] = CJ.Cost_Center
where CJ.[ASHE Category] <> '0' and CJ.[ASHE Category] NOT IN ('EOC/Emergency Management','Landscaping','Life Safety') and BM.[Cost Center] IS NOT NULL

Group By 
BM.[Cost Center],NK.Minstry,NK.Site_Name,BM.[Sq Footage],BM.[Footage Grouping],BM.[ASHE Footage Grouping],BM.Region,Cj.[ASHE Category],
       ABM.[ASHE BM]
	  ,IBM.Amount




/* This section produces the table 'Site Total - Overall' */



--- Collects Employee Count Per Cost Center ---
Select [Cost Center] ,Sum([Current Employee Count]) [Employee Count]

Into #Site_Holder

from #Site_Level

Group by [Cost Center]
order by [Cost Center]


--- Seperates the Total Employees in Each ASHE Grouping ---
Select  Distinct [Cost Center], Sum([Current Employee Count]) [Employee Count]
Into #EmployeesPerCostCenter
From #Site_Level
Group by [Cost Center]
order by [Cost Center]


--- Gets the Ashe Count From Master Data ---
Select Distinct Benchmarks.[Cost Center], Benchmarks.[ASHE Footage Grouping],Benchmarks.[Site Name], AVG([Sq Footage]/nullif(EPCC.[Employee Count],0)) AverageFootage
Into #AVGFootagePerCostCenter


From Benchmarks
left join #EmployeesPerCostCenter EPCC on EPCC.[Cost Center] = Benchmarks.[Cost Center]

Group by [ASHE Footage Grouping],EPCC.[Employee Count],Benchmarks.[Cost Center],Benchmarks.[Site Name],Benchmarks.[ASHE Footage Grouping]
order by Benchmarks.[Cost Center]

Select [ASHE Footage Grouping],AVG(AverageFootage) [Footage Average]

into #FootageGroupAverage


From #AVGFootagePerCostCenter

Group by [ASHE Footage Grouping]
order by [ASHE Footage Grouping]

--- Actual Selection of Data ---
Select  #Site_Level.[Cost Center],Minstry,Site_Name,[Sq Footage],[Footage Grouping],Region,#Site_Level.[ASHE Footage Grouping], [Sq Footage]/36000 [ASHE BM],[Sq Footage]/FGA.[Footage Average] [Internal Benchmark],Sum([Current Employee Count]) [Current Employees], round(([Sq Footage]/nullif(SH.[Employee Count],0)),0) AS FTESQFT 



from #Site_Level
left join #Site_Holder SH on SH.[Cost Center] = #Site_Level.[Cost Center]
left join #FootageGroupAverage FGA on FGA.[ASHE Footage Grouping] = #Site_Level.[ASHE Footage Grouping]



Group by #Site_Level.[Cost Center],Minstry,Site_Name,[Sq Footage],[Footage Grouping],Region,#Site_Level.[ASHE Footage Grouping], [Sq Footage]/36000,SH.[Employee Count],[Sq Footage]/FGA.[Footage Average]
order by #Site_Level.[Cost Center]

Print 'Site Total - Overall'


Select  #Site_Level.[Cost Center],Minstry,Site_Name,[Sq Footage],[Footage Grouping],Region,#Site_Level.[ASHE Footage Grouping]

from #Site_Level
left join #Site_Holder SH on SH.[Cost Center] = #Site_Level.[Cost Center]
left join #FootageGroupAverage FGA on FGA.[ASHE Footage Grouping] = #Site_Level.[ASHE Footage Grouping]



Group by #Site_Level.[Cost Center],Minstry,Site_Name,[Sq Footage],[Footage Grouping],Region,#Site_Level.[ASHE Footage Grouping]
order by #Site_Level.[Cost Center]

PRINT 'Site Total - Aggregate'












