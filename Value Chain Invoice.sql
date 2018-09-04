

Begin

USE FM_Operations;
SELECT  *
/* INTO FY17 */
From ( 

Select 

VIJ.RECID, VIJ.PURCHID, VIJ.ORDERACCOUNT, 
VIJ.INVOICEACCOUNT, VIJ.INVOICEID, VIJ.DOCUMENTDATE, VIJ.DUEDATE, 
VIJ.PAYMENT, VIJ.INVOICEAMOUNT, VTRANS.SETTLEAMOUNTCUR, VTRANS.LASTSETTLEDATE, 
VTRANS.CLOSED,Month(VTRANS.closed) Month, VTRANS.LASTSETTLECOMPANY, VIJ.LEDGERVOUCHER,VIJ.DELIVERYNAME, 
PV.Purchase_Order,PV.Vendor_Name,VTable.DBA,PV.Item_description,PV.Num_lines,PV.Total_PO_Amount,PV.Service_ref,
PV.Created_By, PV.CREATEDDATETIME AS Created_Date,PV.Requester_name AS Requested_By,PRT.SUBMITTEDDATETIME AS Requested_Date,
PV.PurchLineExternalItem,PV.PSANotes,MXLPL.MXLLINEITEMNOTES,PT.VENDORREF,PT.INVENTSITEID,
PV.InventSite AS Site_Name,GSM.[State],MG.[Regional Director],MG.AVP,PGM.Summary_Mapping,

ROW_NUMBER() OVER(PARTITION BY VIJ.RECID ORDER BY VIJ.RECID) duplicateCounter

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
LEFT JOIN FM_OPERATIONS.dbo.MinistryWalk MW on PT.INVENTSITEID = MW.INVENTSITEID
LEFT JOIN FM_OPERATIONS.dbo.[Ministry Grouping] MG on MG.Ministry = NK.Minstry
LEFT JOIN [ConsolidatedReports].[dbo].[FM - Part Group Mapping] PGM on PGM.Item_Description = PV.Item_description
LEFT JOIN [ConsolidatedReports].[dbo].[Grainger - Site Mapping] GSM on GSM.[MFM_Site_Code] = PT.INVENTSITEID
LEFT JOIN [ConsolidatedReports].[dbo].[FM - Excluded Vendors] FEV on FEV.[Vendor Account] = PV.Vendor_Account
WHERE        (VTRANS.LASTSETTLEDATE BETWEEN CONVERT(DATETIME, '2017-04-01 00:00:00', 102) AND CONVERT(DATETIME, '2017-04-30 00:00:00', 102)) AND 
                         (VIJ.PURCHID LIKE N'MFAC%') AND PV.Vendor_Name NOT LIKE '%grainger%' and FEV.Status IS NULL
)

a


where duplicateCounter = 1 and a.Summary_Mapping IS NOT NULL and a.Summary_Mapping <> 'Exclude'
order by a.closed
END