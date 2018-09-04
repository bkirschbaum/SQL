



Select Month(Date) as Month, Year(Date) as Year, [FinanceRevenue].[Cost Center],(Sum([Amount in reporting currency])*-1) as 'Revenue',NamingKey.Site_Name,NamingKey.Minstry, Ministry_Grouping.[Ministry Grouping] ,Namingkey.INVENTSITEID, 'Finance' as 'Marker' from FinanceRevenue
inner join NamingKey on NamingKey.[Cost Center]=FinanceRevenue.[Cost Center]
inner join Ministry_Grouping on NamingKey.Minstry = Ministry_Grouping.Ministry
Group by Year(Date),Month(Date), [FinanceRevenue].[Cost Center],NamingKey.Site_Name,NamingKey.Minstry,Namingkey.INVENTSITEID, Ministry_Grouping.[Ministry Grouping]



 