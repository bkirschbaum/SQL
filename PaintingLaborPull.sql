/****** Script for SelectTopNRows command from SSMS  ******/
SELECT Distinct [Employee Number],Round(AVG([Hourly Pay Rate]),4) AverageRate,MAX([Hourly Pay Rate]) MaxRate,Min([Hourly Pay Rate]) MinRate

  FROM [Cost Equation Demo].[dbo].[Labor]
  where [Employee Number] IS NOT NULL
  group by [Employee Number]


Select Distinct [Employee Number],[Hourly Pay Rate],Max([Pay Date]) 
From Labor
where [Employee Number] IS NOT NULL
group by [Employee Number], [Hourly Pay Rate]
order by [Employee Number]

select * from (
    select
        [Employee Number],[Hourly Pay Rate],[Pay Date],
        row_number() over(partition by [Employee Number] order by [Pay Date] desc) as rn
    from
        Labor
) t
where t.rn = 1 and [Employee Number] IS NOT NULL