/****** Script for SelectTopNRows command from SSMS  ******/
SELECT DISTINCT [Vendor_Name],INVOICEAMOUNT,PSANotes,[Cost Center],LASTSETTLEDATE,ITEMID
  FROM [FM_OPERATIONS].[dbo].[AllInvoices]
  where itemid IN (SELECT  [Item_Number]

  FROM [FM_OPERATIONS].[dbo].[Item_Description_Sector_Trade] where
  sector like '%parking%' and service_supplies = 'Service') and lastsettledate > '7/1/2017'