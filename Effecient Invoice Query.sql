Use ConsolidatedReports;

SELECT     TOP (100) PERCENT dbo.Purchasing_View.Vendor_Name,dbo.Purchasing_View.Purchase_Order,dbo.Purchasing_View.Item_description, AX_Target.dbo.MXLPurchLine.MXLLINEITEMNOTES, dbo.Purchasing_View.PSANotes, dbo.Purchasing_View.Num_lines, dbo.Purchasing_View.Total_PO_Amount, dbo.Purchasing_View.Vendor_invoice_amount, 
                  dbo.Purchasing_View.Created_by, dbo.Purchasing_View.CREATEDDATETIME AS Created_Date, dbo.Purchasing_View.Requester_name AS Requested_By, 
                  AX_Target.dbo.PURCHREQTABLE.SUBMITTEDDATETIME AS Requested_date, dbo.Purchasing_View.DELIVERYDATE, dbo.Purchasing_View.Date_received, AX_Target.dbo.PURCHTABLE.INVENTSITEID, dbo.Purchasing_View.Line_Status, dbo.Purchasing_View.DATAAREAID

FROM        AX_Target.dbo.PURCHREQTABLE RIGHT OUTER JOIN
                  AX_Target.dbo.PURCHLINE ON AX_Target.dbo.PURCHREQTABLE.PURCHREQID = AX_Target.dbo.PURCHLINE.PURCHREQID RIGHT OUTER JOIN
                  dbo.Purchasing_View LEFT OUTER JOIN
                  AX_Target.dbo.PURCHTABLE ON dbo.Purchasing_View.Purchase_Order = AX_Target.dbo.PURCHTABLE.PURCHID LEFT OUTER JOIN
                  AX_Target.dbo.MXLPurchLine ON dbo.Purchasing_View.INVENTTRANSID = AX_Target.dbo.MXLPurchLine.INVENTTRANSID ON 
                  AX_Target.dbo.PURCHLINE.INVENTTRANSID = dbo.Purchasing_View.INVENTTRANSID LEFT OUTER JOIN
                  AX_Target.dbo.VENDTABLE ON dbo.Purchasing_View.Vendor_Account = AX_Target.dbo.VENDTABLE.ACCOUNTNUM
WHERE     (dbo.Purchasing_View.CREATEDDATETIME BETWEEN CONVERT(DATETIME, '2016-7-01 00:00:00', 102) AND CONVERT(DATETIME, '2017-04-30 00:00:00', 102)) AND 
                  (NOT (dbo.Purchasing_View.Purchase_Type LIKE 'returned order')) AND (NOT (dbo.Purchasing_View.Line_Status LIKE 'canceled')) AND (dbo.Purchasing_View.DATAAREAID = N'mfac')
ORDER BY Created_Date

