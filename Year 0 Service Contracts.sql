


Use FM_OPERATIONS;

Select a.[cost center],a.Insourcing_Year, Sum(a.[GL Amount]) Amount

from

(

Select [GL Amount],




[GL Date],CASE WHEN  CAST([GL Date] - Gl.[Go Live] AS INT) < 365 THEN 'Year 1'
	             WHEN  CAST([GL Date] - Gl.[Go Live] AS INT) < 730 THEN 'Year 2'
				 WHEN  CAST([GL Date] - Gl.[Go Live] AS INT) < 1095 THEN 'Year 3'
				 WHEN  CAST([GL Date] - Gl.[Go Live] AS INT) < 1460 THEN 'Year 4'
				 WHEN  CAST([GL Date] - Gl.[Go Live] AS INT) < 1825 THEN 'Year 5'
				 WHEN  CAST([GL Date] - Gl.[Go Live] AS INT) < 2190 THEN 'Year 6'
				 WHEN  CAST([GL Date] - Gl.[Go Live] AS INT) < 0 THEN 'Prior To Go-Live'
            ELSE 'INVALID' END AS Insourcing_Year

			, NK.Minstry,

NK.[Cost Center],'Service' Service
FROM	     Contracts CONT
left join ServiceContractInfo SCI on SCI.[Contract ID] = CONT.[Contract ID] and SCI.[Record ID] = CONT.[Record ID]
inner join Sector_Trade STR on STR.Sector = SCI.[Updated Sector]
inner join NamingKey NK on NK.[Cost Center] = LEFT(SCI.[CC -CAMPUS DESCRIPTION],6)
inner join [Ministry Grouping] MG on MG.Ministry = NK.Minstry
left join [Go Live] GL on GL.Ministry = NK.Minstry
WHERE        [GL Date] between '1-1-2014' and '6-30-2017' and Source = 'Payments'

) a

Group by a.[cost center],a.Insourcing_Year
order by a.[cost center]



