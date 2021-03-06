/****** Script for SelectTopNRows command from SSMS  ******/
SELECT Gl.[Life Safety],[RECID]
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
      ,[LASTSETTLECOMPANY],
	  CAST(LASTSETTLEDATE - Gl.[Life Safety] AS INT),
	   CASE      WHEN  CAST(LASTSETTLEDATE - Gl.[Life Safety] AS INT) between -365 and 0 THEN 'Year 0'
	             WHEN  CAST(LASTSETTLEDATE - Gl.[Life Safety] AS INT) between 1 and 365 THEN 'Year 1'
				 WHEN  CAST(LASTSETTLEDATE - Gl.[Life Safety] AS INT) between 366 and 730 THEN 'Year 2'
				 WHEN  CAST(LASTSETTLEDATE - Gl.[Life Safety] AS INT) between 731 and 1095 THEN 'Year 3'
				 WHEN  CAST(LASTSETTLEDATE - Gl.[Life Safety] AS INT) between 1096 and 1460  THEN 'Year 4'
				 WHEN  CAST(LASTSETTLEDATE - Gl.[Life Safety] AS INT) between 1461 and 1825 THEN 'Year 5'
				 WHEN  CAST(LASTSETTLEDATE - Gl.[Life Safety] AS INT) < 0 THEN 'Prior To Go-Live'
            ELSE 'INVALID' END AS Insourcing_Year
      ,[Minstry]
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

      ,[Regional Director]
      ,[AVP]
      ,[VENDORREF]
      ,[DBA]
      ,[duplicateCounter]
  FROM [FM_OPERATIONS].[dbo].[ALLINVOICES]
  left join FM_OPERATIONS.dbo.[Go Live] GL on GL.Ministry = ALLINVOICES.Minstry

  where Gl.[Life Safety] IS NOT NULL and Trade = 'Life Safety'