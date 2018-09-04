/****** Script for SelectTopNRows command from SSMS  ******/
SELECT Top (100) GS.*, GMST.Trade,GMST.Sector, NK.Minstry, NK.[Cost Center]
FROM [FM_OPERATIONS].[dbo].[GraingerSpend] GS
left join Grainger_Material_Sector_Trade GMST on GS.[Material Segment] = GMST.[Material Segment]
left join NamingKey NK on GS.MFM_Site_Code = NK.INVENTSITEID

