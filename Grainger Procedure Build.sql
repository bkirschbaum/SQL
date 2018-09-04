

/* Chris O'Neill's QFM Invoice Query */

SELECT        TOP (100) PERCENT


 VIJ.RECID, VIJ.PURCHID, VIJ.ORDERACCOUNT, 
                         VIJ.INVOICEACCOUNT, VIJ.INVOICEID, VIJ.DOCUMENTDATE, VIJ.DUEDATE, 
                         VIJ.PAYMENT, VIJ.INVOICEAMOUNT, VT.SETTLEAMOUNTCUR, VT.LASTSETTLEDATE, 
                         VT.CLOSED, VT.LASTSETTLECOMPANY, VIJ.LEDGERVOUCHER, VIJ.DELIVERYNAME

INTO FM_OPERATIONS.dbo.ChisInvoices
FROM            AX_Target.dbo.VENDINVOICEJOUR VIJ INNER JOIN
                         AX_Target.dbo.VENDTRANS VT ON VIJ.LEDGERVOUCHER = VT.VOUCHER
WHERE        (VT.LASTSETTLEDATE BETWEEN CONVERT(DATETIME, '2017-4-1 00:00:00', 102) AND CONVERT(DATETIME, '2017-6-30 00:00:00', 102)) AND 
                         (VIJ.PURCHID LIKE N'MFAC%')
ORDER BY VT.LASTSETTLEDATE









SELECT [FM Invoices Paid].*, [Grainger Compliance Report].*, [FM - Part Group Mapping].FM_Mapping_Segment, 
[FM - Part Group Mapping].Summary_Mapping, [FM - Part Group Mapping].[Include/Exclude], [FM - Excluded Vendors].[Vendor Name]
FROM [FM Invoices Paid] 
INNER JOIN (([Grainger Compliance Report] 
LEFT JOIN [FM - Part Group Mapping] ON [Grainger Compliance Report].Item_description = [FM - Part Group Mapping].Item_Description) 
LEFT JOIN [FM - Excluded Vendors] ON [Grainger Compliance Report].Vendor_Name = [FM - Excluded Vendors].[Vendor Name]) ON [FM Invoices Paid].PURCHID = [Grainger Compliance Report].Purchase_Order;
