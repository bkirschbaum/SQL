


SELECT ConsolidatedReports.dbo.Purchasing_View.Created_By, ConsolidatedReports.dbo.Purchasing_View.CREATEDDATETIME AS Created_Date, ConsolidatedReports.dbo.Purchasing_View.Purchase_Order, 
ConsolidatedReports.dbo.Purchasing_View.Vendor_Name, ConsolidatedReports.dbo.Purchasing_View.Item_description, ConsolidatedReports.dbo.Purchasing_View.PurchLineExternalItem,
ConsolidatedReports.dbo.Purchasing_View.Num_lines, ConsolidatedReports.dbo.Purchasing_View.Total_PO_Amount, ConsolidatedReports.dbo.Purchasing_View.Service_ref, AX_Target.dbo.PURCHTABLE.INVENTSITEID,
ConsolidatedReports.dbo.Purchasing_View.InventSite AS Site_Name, ConsolidatedReports.dbo.Purchasing_View.PSANotes, ConsolidatedReports.dbo.Purchasing_View.Requester_name AS Requested_By,
AX_Target.dbo.PURCHREQTABLE.SUBMITTEDDATETIME AS Requested_Date, AX_Target.dbo.MXLPurchLine.MXLLINEITEMNOTES, AX_Target.dbo.PURCHTABLE.VENDORREF,
AX_Target.dbo.VENDTABLE.DBA, ConsolidatedReports.dbo.[FM Site Listing].[Regional Director],
ConsolidatedReports.dbo.[FM Site Listing].AVP, ConsolidatedReports.dbo.[FM Site Listing].State

INTO FM_OPERATIONS.dbo.GraingerCompliance
FROM ConsolidatedReports.dbo.Purchasing_View 

LEFT JOIN AX_Target.dbo.PURCHLINE ON ConsolidatedReports.dbo.Purchasing_View.INVENTTRANSID = AX_Target.dbo.PURCHLINE.INVENTTRANSID 
LEFT JOIN AX_Target.dbo.PURCHREQTABLE ON AX_Target.dbo.PURCHLINE.PURCHREQID = AX_Target.dbo.PURCHREQTABLE.PURCHREQID 
LEFT JOIN AX_Target.dbo.MXLPurchLine ON ConsolidatedReports.dbo.Purchasing_View.INVENTTRANSID = AX_Target.dbo.MXLPurchLine.INVENTTRANSID 
LEFT JOIN AX_Target.dbo.PURCHTABLE ON ConsolidatedReports.dbo.Purchasing_View.Purchase_Order = AX_Target.dbo.PURCHTABLE.PURCHID 
LEFT JOIN AX_Target.dbo.VENDTABLE ON ConsolidatedReports.dbo.Purchasing_View.Vendor_Account = AX_Target.dbo.VENDTABLE.ACCOUNTNUM 
LEFT JOIN ConsolidatedReports.dbo.[FM Site Listing] ON AX_Target.dbo.PURCHTABLE.INVENTSITEID = ConsolidatedReports.dbo.[FM Site Listing].SITEID

WHERE ConsolidatedReports.dbo.Purchasing_View.Purchase_Order Like 'MFAC%' AND ConsolidatedReports.dbo.Purchasing_View.Vendor_Name Not Like '%GRAINGER%' AND ConsolidatedReports.dbo.Purchasing_View.Item_description Not Like 'SERVICE%'
AND ConsolidatedReports.dbo.Purchasing_View.CREATEDDATETIME between '4-1-2017' and '6-30-2017'

ORDER BY ConsolidatedReports.dbo.Purchasing_View.CREATEDDATETIME;
