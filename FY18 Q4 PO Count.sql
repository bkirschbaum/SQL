/****** Script for SelectTopNRows command from SSMS  ******/

SELECT DISTINCT PO.PURCHID
      ,CC.CostCenterID
	  ,CC.NAME
	  INTO #POMAP
  FROM [mart].[f_FinanceData]
  left join mart.d_PurchaseOrder PO on PO.pk_PurchaseOrder = f_FinanceData.pk_PurchaseOrder
  left join mart.d_CostCenter CC on CC.pk_CostCenter = f_FinanceData.pk_CostCenter

  where (PO.pk_PurchaseOrder <> '-999' or CC.CostCenterID <> '-999') and cc.costcenterid <> 'N/A'


  



SELECT count(xVendInvoiceJourStaging.PURCHID) Count
      ,PO.CostCenterID
	  ,PO.NAME
      ,Month([INVOICEDATE]) Month

  FROM [dbo].[xVendInvoiceJourStaging]
  left join #POMAP PO on PO.PURCHID = xVendInvoiceJourStaging.PURCHID
  where invoicedate between '4/1/2018' and '6/30/2018' and xVendInvoiceJourStaging.purchid like 'mfac%'
  Group by Month([INVOICEDATE]),PO.CostCenterId,PO.NAME
  order by  PO.CostCenterID,Month([INVOICEDATE])