

Begin

USE FM_Operations;
SELECT  *
--- INTO (insert table name)---  
From ( 

Select 

VIJ.RECID, VIJ.PURCHID, VIJ.ORDERACCOUNT, 
VIJ.INVOICEACCOUNT, VIJ.INVOICEID, VIJ.DOCUMENTDATE, VIJ.DUEDATE, 
VIJ.PAYMENT, VIJ.INVOICEAMOUNT, VTRANS.SETTLEAMOUNTCUR, VTRANS.LASTSETTLEDATE, 
VTRANS.CLOSED, VTRANS.LASTSETTLECOMPANY, VIJ.LEDGERVOUCHER,VIJ.DELIVERYNAME, 
PV.Created_By, PV.CREATEDDATETIME AS Created_Date,PRT.PURCHREQID, PV.Purchase_Order, PV.Vendor_Account, PV.Invoice_Account, 
PV.Vendor_Name, PV.Purchase_Type, PV.Approval_Status, PV.Header_Status, 
PV.Line_Status, PV.ITEMID, PV.PurchLineExternalItem, PV.Item_description, 
PV.Qty_Ordered, PV.Qty_Remaining, PV.Unit_price, 
PV.Amount AS Line_Amount, PV.Num_lines, PV.Total_PO_Amount, 
PV.Vendor_invoice_amount, PV.Service_ref, PT.INVENTSITEID, PV.InventSite AS Site_Name, 
PV.DELIVERYDATE, PV.Date_received, PV.PSANotes, 
PV.Requester_name AS Requested_By, PRT.SUBMITTEDDATETIME AS Requested_Date, MXLPL.MXLLINEITEMNOTES,
IDST.Service_Supplies,IDST.Sector,IDST.Trade,
NK.[Cost Center],NK.Minstry,MG.[Regional Director],MG.AVP,

PT.VENDORREF, VTable.DBA, ROW_NUMBER() OVER(PARTITION BY VIJ.RECID ORDER BY VIJ.RECID) duplicateCounter

FROM AX_Target.dbo.VENDINVOICEJOUR VIJ
INNER JOIN AX_Target.dbo.VENDTRANS  VTRANS on VIJ.LEDGERVOUCHER = VTRANS.VOUCHER
LEFT JOIN ConsolidatedReports.dbo.Purchasing_View PV on PV.Purchase_Order = VIJ.PURCHID
LEFT JOIN AX_Target.dbo.PURCHLINE PL on PV.INVENTTRANSID = PL.INVENTTRANSID
LEFT JOIN AX_Target.dbo.PURCHREQTABLE PRT ON PL.PURCHREQID = PRT.PURCHREQID
LEFT JOIN AX_Target.dbo.MXLPurchLine MXLPL ON MXLPL.INVENTTRANSID = PL.INVENTTRANSID 
LEFT JOIN AX_Target.dbo.PURCHTABLE PT ON PV.Purchase_Order = PT.PURCHID 
LEFT JOIN AX_Target.dbo.VENDTABLE VTable ON PV.Vendor_Account = VTable.ACCOUNTNUM 
LEFT JOIN FM_OPERATIONS.dbo.Item_Description_Sector_Trade IDST on PV.Item_description = IDST.Item_Description
LEFT JOIN FM_OPERATIONS.dbo.[NamingKey] NK on NK.INVENTSITEID = PT.INVENTSITEID
LEFT JOIN FM_OPERATIONS.dbo.[Ministry Grouping] MG on MG.Ministry = NK.Minstry

WHERE        (VTRANS.LASTSETTLEDATE BETWEEN CONVERT(DATETIME, '2015-12-16 00:00:00', 102) AND CONVERT(DATETIME, '2017-11-30 00:00:00', 102)) AND 
                         (VIJ.PURCHID LIKE N'MFAC%')
)

a


where duplicateCounter = 1
END