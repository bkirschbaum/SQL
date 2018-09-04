/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [RECID]
      ,[PURCHID]
      ,[ORDERACCOUNT]
      ,[INVOICEACCOUNT]
      ,[INVOICEID]
      ,[DOCUMENTDATE]
      ,[DUEDATE]
      ,[PAYMENT]
      ,[INVOICEAMOUNT]
      ,[SETTLEAMOUNTCUR]
      ,[LASTSETTLEDATE]
      ,[CLOSED]
      ,[LASTSETTLECOMPANY]
      ,[LEDGERVOUCHER]
      ,[DELIVERYNAME]
      ,[Created_By]
      ,[Created_Date]
      ,[PURCHREQID]
      ,[Purchase_Order]
      ,[Vendor_Account]
      ,[Invoice_Account]
      ,[Vendor_Name]
      ,[Purchase_Type]
      ,[Approval_Status]
      ,[Header_Status]
      ,[Line_Status]
      ,[ITEMID]
      ,[PurchLineExternalItem]
      ,[Item_description]
      ,[Qty_Ordered]
      ,[Qty_Remaining]
      ,[Unit_price]
      ,[Line_Amount]
      ,[Num_lines]
      ,[Total_PO_Amount]
      ,[Vendor_invoice_amount]
      ,[Service_ref]
      ,[INVENTSITEID]
      ,[Site_Name]
      ,[DELIVERYDATE]
      ,[Date_received]
      ,[PSANotes]
      ,[Requested_By]
      ,[Requested_Date]
      ,[MXLLINEITEMNOTES]
      ,[Service_Supplies]
      ,[Sector]
      ,[Trade]
      ,[Cost Center]
      ,[Minstry]
      ,[Regional Director]
      ,[AVP]
      ,[VENDORREF]
      ,[DBA]
      ,[duplicateCounter]
  FROM [FM_OPERATIONS].[dbo].[CY17Invoices]
  where PURCHID in (Select PURCHID from CY17Invoices where Line_Status = 'Invoiced') and Line_Status <> 'Invoiced' and Created_by = 'Marissa L Cosand'
  order by purchid