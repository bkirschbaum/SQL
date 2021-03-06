/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [FM Invoices Paid].*, dbo_Purchasing_View.Created_By, dbo_Purchasing_View.CREATEDDATETIME AS Created_Date, dbo_Purchasing_View.RECID, 
dbo_PURCHREQTABLE.PURCHREQID, dbo_Purchasing_View.Purchase_Order, dbo_Purchasing_View.Vendor_Account, dbo_Purchasing_View.Invoice_Account, 
dbo_Purchasing_View.Vendor_Name, dbo_Purchasing_View.Purchase_Type, dbo_Purchasing_View.Approval_Status, dbo_Purchasing_View.Header_Status, 
dbo_Purchasing_View.Line_Status, dbo_Purchasing_View.ITEMID, dbo_Purchasing_View.PurchLineExternalItem, dbo_Purchasing_View.Item_description, 
dbo_Purchasing_View.Qty_Ordered, dbo_Purchasing_View.Qty_Remaining, dbo_Purchasing_View.Unit_price, 
dbo_Purchasing_View.Amount AS Line_Amount, dbo_Purchasing_View.Num_lines, dbo_Purchasing_View.Total_PO_Amount, 
dbo_Purchasing_View.Vendor_invoice_amount, dbo_Purchasing_View.Service_ref, dbo_PURCHTABLE.INVENTSITEID, dbo_Purchasing_View.InventSite AS Site_Name, 
dbo_Purchasing_View.DELIVERYDATE, dbo_Purchasing_View.Date_received, dbo_Purchasing_View.PSANotes, 
dbo_Purchasing_View.Requester_name AS Requested_By, dbo_PURCHREQTABLE.SUBMITTEDDATETIME AS Requested_Date, dbo_MXLPurchLine.MXLLINEITEMNOTES, 
dbo_PURCHTABLE.VENDORREF, dbo_VENDTABLE.DBA, [FM Site Listing].[Regional Director], [FM Site Listing].AVP, [FM Site Listing].State, 
dbo_Purchasing_View.DELIVERY_NAME, dbo_Purchasing_View.DELIVERY_STATE, dbo_VENDTABLE.PAYMTERMID, dbo_Purchasing_View.DELIVERY_CITY, 
dbo_Purchasing_View.DELIVERY_ZIP, dbo_Purchasing_View.DELIVERY_STREET, [MFM Sector & Trade].Service_Supplies, [MFM Sector & Trade].Sector, 
[MFM Sector & Trade].Trade, [MFM Site Listing].Ministry_Name, [FM - Cost Centers].[Cost Center]

FROM ((([FM Invoices Paid] 
LEFT JOIN ((((((dbo_Purchasing_View 
LEFT JOIN dbo_PURCHLINE ON dbo_Purchasing_View.INVENTTRANSID = dbo_PURCHLINE.INVENTTRANSID) 
LEFT JOIN dbo_PURCHREQTABLE ON dbo_PURCHLINE.PURCHREQID = dbo_PURCHREQTABLE.PURCHREQID) 
LEFT JOIN dbo_MXLPurchLine ON dbo_Purchasing_View.INVENTTRANSID = dbo_MXLPurchLine.INVENTTRANSID) 
LEFT JOIN dbo_PURCHTABLE ON dbo_Purchasing_View.Purchase_Order = dbo_PURCHTABLE.PURCHID) 
LEFT JOIN dbo_VENDTABLE ON dbo_Purchasing_View.Vendor_Account = dbo_VENDTABLE.ACCOUNTNUM) 
LEFT JOIN [FM Site Listing] ON dbo_PURCHTABLE.INVENTSITEID = [FM Site Listing].SITEID) ON [FM Invoices Paid].PURCHID = dbo_Purchasing_View.Purchase_Order) 
LEFT JOIN [MFM Sector & Trade] ON dbo_Purchasing_View.Item_description = [MFM Sector & Trade].Item_Description) 
LEFT JOIN [FM - Cost Centers] ON dbo_PURCHTABLE.INVENTSITEID = [FM - Cost Centers].[Site ID]) 
LEFT JOIN [MFM Site Listing] ON dbo_PURCHTABLE.INVENTSITEID = [MFM Site Listing].SITEID
ORDER BY dbo_Purchasing_View.CREATEDDATETIME;
