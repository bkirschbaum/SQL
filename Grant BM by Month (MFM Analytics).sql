/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [Month]
      ,FY18GL.[Cost_Center]
      ,Sum([Amount]/BM.[Sq Footage])*12 Benchmark
      ,[Minstry]
      ,[Ministry Grouping]
      ,[Regional Director]
      ,[AVP]

  FROM [FM_OPERATIONS].[dbo].[FY18GL]
  left join Benchmarks BM on BM.[Cost Center] = FY18GL.Cost_Center

  Group by Month,FY18GL.Cost_Center,[Minstry],[Ministry Grouping],[Regional Director],[AVP]