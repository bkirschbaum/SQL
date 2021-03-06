/****** Script for SelectTopNRows command from SSMS  ******/
Use AX_Target;




Select a.Cost_Center,a.Insourcing_Year,a.Other,Sum(


From

(


SELECT     


CASE WHEN  CAST(GJE.ACCOUNTINGDATE - Gl.[Go Live] AS INT) < 365 THEN 'Year 1'
	             WHEN  CAST(GJE.ACCOUNTINGDATE - Gl.[Go Live] AS INT) < 730 THEN 'Year 2'
				 WHEN  CAST(GJE.ACCOUNTINGDATE - Gl.[Go Live] AS INT) < 1095 THEN 'Year 3'
				 WHEN  CAST(GJE.ACCOUNTINGDATE - Gl.[Go Live] AS INT) < 1460 THEN 'Year 4'
				 WHEN  CAST(GJE.ACCOUNTINGDATE - Gl.[Go Live] AS INT) < 1825 THEN 'Year 5'
				 WHEN  CAST(GJE.ACCOUNTINGDATE - Gl.[Go Live] AS INT) < 2190 THEN 'Year 6'
				 WHEN  CAST(GJE.ACCOUNTINGDATE - Gl.[Go Live] AS INT) < 0 THEN 'Prior To Go-Live'
            ELSE 'INVALID' END AS Insourcing_Year


			,


Substring(DAVC.DISPLAYVALUE,7,6) Cost_Center, 'Other Expenses' AS Other

FROM            dbo.GENERALJOURNALENTRY GJE 
                                          INNER JOIN
                                         dbo.GENERALJOURNALACCOUNTENTRY GJAE 
                                          on GJE.RECID = GJAE.GENERALJOURNALENTRY 
                                          INNER JOIN
                                         dbo.DIMENSIONATTRIBUTEVALUEGROUPCOMBINATION DAVGC 
                                          on GJAE.LEDGERDIMENSION = DAVGC.DIMENSIONATTRIBUTEVALUECOMBINATION
                                         INNER JOIN
                                         dbo.DIMENSIONATTRIBUTEVALUECOMBINATION DAVC
                                         on DAVC.RECID = DAVGC.DIMENSIONATTRIBUTEVALUECOMBINATION and DAVC.ACCOUNTSTRUCTURE = 5637149827
										 inner join FM_Operations.dbo.PnLMap PnL on PnL.[Main Account] = SUBSTRING(DAVC.Displayvalue,1,5)
										 left join FM_OPERATIONS.dbo.NamingKey NK on NK.[Cost Center] = SUBSTRING(DAVC.Displayvalue,7,6)
										 left join FM_OPERATIONS.dbo.[Ministry Grouping] MG on MG.Ministry = NK.Minstry
										 left join FM_OPERATIONS.dbo.[Go Live] Gl on Gl.Ministry = NK.Minstry

WHERE        ACCOUNTINGDATE between '1-1-2014' and '6-30-2017' and JOURNALNUMBER Like 'MFAC%' and SUBSTRING(DAVC.Displayvalue,7,6) >='810100' and SUBSTRING(DAVC.Displayvalue,7,6)  like '%[0-9]%' and SUBSTRING(DAVC.Displayvalue,7,6) NOT IN ('820300','820400') and PnL.Benchmarking = 'Other Expenses'


) a
