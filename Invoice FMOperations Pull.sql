/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
       [InvoiceAmount]
	  ,[lastsettledate]
	  ,month(lastsettledate) month
	  ,year(lastsettledate) year
	  ,[Site_Name]
	  ,FY17Invoice.[Ministry]
	  ,MG.[Ministry Grouping]
      ,MG.[Regional Director]
      ,MG.[AVP]
      ,[Service_Supplies]
      ,[Service_Supplies]
      ,[Trade]
      ,[Sector]
	  ,[Vendor_Name]
	  ,psanotes
	  ,FY17Invoice.PurchID
	  ,[Cost Center]

FROM [FM_OPERATIONS].[dbo].[FY17Invoice]
left join [Ministry Grouping] MG on MG.Ministry = FY17Invoice.Ministry
left join ABRs ABR on ABR.PurchID = FY17Invoice.PurchID
where ABR IS NULL

Union All

Select [GL Amount],[GL Date],MONTH([GL Date]) Month, Year([GL Date]) Year,NK.Site_Name,NK.Minstry,MG.[Ministry Grouping],MG.[Regional Director],MG.AVP,'Service Contract','Service', STR.Trade,[Updated Sector] Sector, [Vendor Name],NOTES,SCI.[PO Number],NK.[Cost Center]
FROM	     Contracts CONT
inner join ServiceContractInfo SCI on SCI.[Contract ID] = CONT.[Contract ID]
inner join Sector_Trade STR on STR.Sector = SCI.[Updated Sector]
inner join NamingKey NK on NK.[Cost Center] = LEFT(SCI.[CC -CAMPUS DESCRIPTION],6)
inner join [Ministry Grouping] MG on MG.Ministry = NK.Minstry
WHERE        [GL Date] between '7-1-2016' and '5-31-2017' and Source = 'Payments'

Union All

SELECT       [Ext Price Amt], Month([Bill Date]) Month, YEAR([Bill Date]) Year, MFM_Site_Name ,NK.Minstry, MG.[Ministry Grouping],MG.[Regional Director],MG.AVP, 'Supplies','Supplies', STRel.Trade,GMS.Sector, 'Grainger',Description,'',NK.[Cost Center]
FROM		 GraingerSpend
left join Grainger_Material_Sector_Trade GMS on GMS.[Material Segment] =GraingerSpend.[Material Segment]
left join Sector_Trade STRel on STRel.Sector = GMS.Sector
left join NamingKey NK on NK.INVENTSITEID = GraingerSpend.MFM_Site_Code
inner join [Ministry Grouping] MG on MG.Ministry = NK.Minstry
where [Bill Date] between '5-1-2017' and '5-30-2017'

