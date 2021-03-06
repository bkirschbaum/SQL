/****** Script for SelectTopNRows command from SSMS  ******/

USE FM_OPERATIONS
Select a.[Cost Center],Sum(a.INVOICEAMOUNT) Amount,a.Insourcing_Year,a.Service_Supplies

From

(

SELECT  INVOICEAMOUNT

	  ,     CASE WHEN  CAST(LASTSETTLEDATE - Gl.[Go Live] AS INT) < 365 THEN 'Year 1'
	             WHEN  CAST(LASTSETTLEDATE - Gl.[Go Live] AS INT) < 730 THEN 'Year 2'
				 WHEN  CAST(LASTSETTLEDATE - Gl.[Go Live] AS INT) < 1095 THEN 'Year 3'
				 WHEN  CAST(LASTSETTLEDATE - Gl.[Go Live] AS INT) < 1460 THEN 'Year 4'
				 WHEN  CAST(LASTSETTLEDATE - Gl.[Go Live] AS INT) < 1825 THEN 'Year 5'
				 WHEN  CAST(LASTSETTLEDATE - Gl.[Go Live] AS INT) < 2190 THEN 'Year 6'
				 WHEN  CAST(LASTSETTLEDATE - Gl.[Go Live] AS INT) < 0 THEN 'Prior To Go-Live'
            ELSE 'INVALID' END AS Insourcing_Year
			,Year(LastSettleDate) PaidDate
			,Gl.[Go Live]
      ,Y0I.service_supplies
	  ,[Cost Center]
      
  FROM [FM_OPERATIONS].[dbo].[ALLINVOICES]
  left join [Go Live] GL on GL.Ministry = ALLINVOICES.Minstry
  left join Year0Items Y0I on Y0I.item_description = ALLINVOICES.Item_description
  left join ABRs ABR on ABR.purchid = ALLINVOICES.PURCHID
  where LASTSETTLEDATE < '6-1-2016' and  ABR.PURCHID IS NULL
) a

where a.[Cost Center] >= 810100 and a.[Cost Center] not in (820300,820400) 

group by a.Insourcing_Year,a.Service_Supplies,a.[Cost Center],a.[Go Live]
order by a.[Cost Center],a.Insourcing_Year,a.Service_Supplies





