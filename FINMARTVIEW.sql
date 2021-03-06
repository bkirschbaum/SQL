/****** Script for SelectTopNRows command from SSMS  ******/
SELECT DT.DATE
	  ,FD.[LEDGERACCOUNT]
      ,FD.[TEXT]
      ,FD.[MainAccountID]
      ,FD.[CostCenterID]
	  ,CC.NAME as 'Cost Center Name'
	  ,CC.BusinessUnit
	  ,CC.NominalBusinessUnit
      ,FD.[Trade]
      ,FD.[Amount]
      ,FD.[PURCHID] 
	  ,PO.NAME as 'Notes'
	  ,PO.PURCHREQID
	  ,PO.WORKORDERNUMBER
	  ,PO.ISSENTFROMCMS
	  ,PO.REQATTENTION
	  ,PO.ITEMID 
	  ,FD.[LEDGERDIMENSION]
      ,FD.[SUBLEDGERVOUCHER]
      ,FD.[INVOICEID]
	  ,FD.[INVOICEACCOUNT]
      ,FD.[RECID]
      ,FD.[duplicateCounter]
	  ,ACC.NAME as 'Main Account Name'
	  ,ACC.MAINACCOUNTCATEGORY
	  ,ACC.ACCOUNTCATEGORYDESCRIPTION
	  ,DT.*
  FROM [mart].[f_FinanceData] FD
  
  
  left join [mart].[d_Account] ACC on ACC.MAINACCOUNTID = FD.MainAccountID
  left join [mart].[d_PurchaseOrder] PO on PO.PURCHID = FD.PURCHID
  left join [mart].[d_Date] DT on DT.DateKey = FD.DateKey
  left join [mart].[d_CostCenter] CC on CC.CostCenterID = FD.CostCenterID
  
  
  where DT.date between '7/1/2017' and '5/31/2018' and duplicateCounter = 2