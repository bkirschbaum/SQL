/****** Script for SelectTopNRows command from SSMS  ******/

Select a.*

From

(

SELECT  CI.*,GC.*, PGM.[FM_Mapping_Segment],[Summary_Mapping],[Include/Exclude],ROW_NUMBER() OVER(PARTITION BY CI.RECID ORDER BY CI.RECID) duplicateCounter
  FROM [FM_OPERATIONS].[dbo].[ChisInvoices] CI
  left join [FM_OPERATIONS].[dbo].[GraingerCompliance] GC on GC.Purchase_Order = CI.PURCHID
  left join ConsolidatedReports.dbo.[FM - Excluded Vendors] FEM on FEM.[Vendor Name] = GC.Vendor_Name
  left join [ConsolidatedReports].[dbo].[FM - Part Group Mapping] PGM on PGM.Item_Description = GC.Item_Description
  where Summary_Mapping IS NOT NULL and Summary_Mapping <> 'Exclude' and FEM.[Vendor Name] is NULL




  ) a

  where duplicateCounter = 1

    order by a.RECID ASC