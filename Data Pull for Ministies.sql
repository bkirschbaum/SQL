/* Replace the Alexian Symbol with the desired Ministry you are pulling data for */


SELECT       [GL Amount],[GL Date],CAST('No' AS VARCHAR(30)) as ABR,CAST(0 AS NVARCHAR(30)) as Purch_ID ,Ministry, Contract as 'Contract/Supply/Service', Trade,Sector,[Vendor Name], [Contract Notes],NamingKey.Site_Name,
	        CASE WHEN [GL Date] between '7-1-2014' and '6-30-2015' THEN 'FY15'
				 WHEN [GL Date] between '7-1-2015' and '6-30-2016' THEN 'FY16'
				 WHEN [GL Date] between '7-1-2016' and '6-30-2017' THEN 'FY17'
			END AS FiscalYear,
				 CASE WHEN DATEDIFF(dd,[Upload Testing].dbo.CSADates.[GO Live Dates],[GL Date]) < 365 THEN 'SY1'
				 WHEN DATEDIFF(dd,[Upload Testing].dbo.CSADates.[GO Live Dates],[GL Date]) < 730 THEN 'SY2'
				 WHEN DATEDIFF(dd,[Upload Testing].dbo.CSADates.[GO Live Dates],[GL Date]) < 1095 THEN 'SY3'
				 WHEN DATEDIFF(dd,[Upload Testing].dbo.CSADates.[GO Live Dates],[GL Date]) < 1460 THEN 'SY4'
				 WHEN DATEDIFF(dd,[Upload Testing].dbo.CSADates.[GO Live Dates],[GL Date]) < 2190 THEN 'SY5'
				 Else 'Error'
			END AS SavingsYear

FROM	     [Cost Equation Demo].[dbo].[Contracts]
left join NamingKey on NamingKey.Minstry = Contracts.Ministry
left join [Upload Testing].dbo.CSADates on [Upload Testing].dbo.CSADates.[Ministry Name]=contracts.Ministry
WHERE      Source = 'Payments' and [Ministry Name] = 'Alexian'

Union All

SELECT       [Ext Price Amt],[Bill Date],CAST('No' AS VARCHAR(30)) as ABR,CAST(0 AS NVARCHAR(30)) as Purch_ID, Ministry, Supplies, Trade,Sector, Vendor,Description,MFM_Site_Name,
	        CASE WHEN [Bill Date] between '7-1-2014' and '6-30-2015' THEN 'FY15'
				 WHEN [Bill Date] between '7-1-2015' and '6-30-2016' THEN 'FY16'
				 WHEN [Bill Date] between '7-1-2016' and '6-30-2017' THEN 'FY17'
			END AS FiscalYear,
				 CASE WHEN DATEDIFF(dd,[Upload Testing].dbo.CSADates.[GO Live Dates],[Bill Date]) < 365 THEN 'SY1'
				 WHEN DATEDIFF(dd,[Upload Testing].dbo.CSADates.[GO Live Dates],[Bill Date]) < 730 THEN 'SY2'
				 WHEN DATEDIFF(dd,[Upload Testing].dbo.CSADates.[GO Live Dates],[Bill Date]) < 1095 THEN 'SY3'
				 WHEN DATEDIFF(dd,[Upload Testing].dbo.CSADates.[GO Live Dates],[Bill Date]) < 1460 THEN 'SY4'
				 WHEN DATEDIFF(dd,[Upload Testing].dbo.CSADates.[GO Live Dates],[Bill Date]) < 2190 THEN 'SY5'
				 Else 'Error'
			END AS SavingsYear
FROM		 [Cost Equation Demo].[dbo].[GraingerSpend]
left join [Upload Testing].dbo.CSADates on [Upload Testing].dbo.CSADates.[Ministry Name]=GraingerSpend.Ministry
where Ministry = 'Alexian'



UNION ALL


SELECT		 [INVOICEAMOUNT] as 'Invoice Amount',(LASTSETTLEDATE),ABR,PURCHID, Minstry, [Service_Supplies], [Trade],[Sector],[Vendor_Name],PSANotes,Site_Name,
	        CASE WHEN [LASTSETTLEDATE] between '7-1-2014' and '6-30-2015' THEN 'FY15'
				 WHEN [LASTSETTLEDATE] between '7-1-2015' and '6-30-2016' THEN 'FY16'
				 WHEN [LASTSETTLEDATE] between '7-1-2016' and '6-30-2017' THEN 'FY17'
			END AS FiscalYear,
				 CASE WHEN DATEDIFF(dd,[Upload Testing].dbo.CSADates.[GO Live Dates],[LASTSETTLEDATE]) < 365 THEN 'SY1'
				 WHEN DATEDIFF(dd,[Upload Testing].dbo.CSADates.[GO Live Dates],[LASTSETTLEDATE]) < 730 THEN 'SY2'
				 WHEN DATEDIFF(dd,[Upload Testing].dbo.CSADates.[GO Live Dates],[LASTSETTLEDATE]) < 1095 THEN 'SY3'
				 WHEN DATEDIFF(dd,[Upload Testing].dbo.CSADates.[GO Live Dates],[LASTSETTLEDATE]) < 1460 THEN 'SY4'
				 WHEN DATEDIFF(dd,[Upload Testing].dbo.CSADates.[GO Live Dates],[LASTSETTLEDATE]) < 2190 THEN 'SY5'
				 Else 'Error'
			END AS SavingsYear
FROM		 [Cost Equation Demo].[dbo].[FY17 Invoices Paid]
left join [Upload Testing].dbo.CSADates on [Upload Testing].dbo.CSADates.[Ministry Name]=[FY17 Invoices Paid].Minstry
where		 ABR = 'No' and [Vendor_Name] <> 'Grainger' and [Ministry Name] = 'Alexian'





