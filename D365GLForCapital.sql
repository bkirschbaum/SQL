

Select
                Coalesce(PT.PURCHNAME,PT2.PURCHNAME) PURCHNAME,Coalesce(PT.AVA_PURCHREQID,PT2.AVA_PURCHREQID) PURCHREQID ,Coalesce(PT.AVA_WORKORDERNUMBER,PT2.AVA_WORKORDERNUMBER) WORKORDERNUMBER,
                Coalesce(PT.AVA_ISSENTFROMCMS,PT2.AVA_ISSENTFROMCMS) ISSENTFROMCMS,GJAE.TEXT,VIJ.INVOICEAMOUNT,COALESCE(VIJ.PURCHID,VPT.ORIGPURCHID) PURCHID,
                Coalesce(VIJ.INVOICEACCOUNT,PT2.ORDERACCOUNT) INVOICEACCOUNT,GJAE.REPORTINGCURRENCYAMOUNT,GJE.SUBLEDGERVOUCHER,GJE.JOURNALCATEGORY,GJE.LEDGER,GJAE.LEDGERACCOUNT,
				DAVC.TradeValue,DAVC.MAINACCOUNTVALUE,MA.NAME as 'Main Account Name',
				DAVC.COSTCENTER,DPT.Name,DAVC.COSTCENTERVALUE,GJAE.LEDGERDIMENSION,GJE.RECID,GJE.accountingdate

				
				INTO #T1
FROM            AxDB.dbo.GENERALJOURNALENTRY GJE 

                INNER JOIN AxDB.dbo.GENERALJOURNALACCOUNTENTRY GJAE 
                ON GJE.RECID = GJAE.GENERALJOURNALENTRY 
				INNER JOIN AxDB.dbo.DIMENSIONATTRIBUTEVALUECOMBINATION DAVC 
 				ON DAVC.RECID = GJAE.LEDGERDIMENSION
				INNER JOIN AxDB.dbo.MAINACCOUNT MA
				ON MA.RECID = DAVC.MAINACCOUNT
				INNER JOIN AxDB.dbo.DIMATTRIBUTEOMCOSTCENTER DACC 
				ON DACC.RECID = DAVC.COSTCENTER
				INNER JOIN AxDB.dbo.DIRPARTYTABLE DPT 
				ON DPT.RECID = DAVC.COSTCENTER
				LEFT JOIN AxDB.dbo.VENDINVOICEJOUR VIJ 
				ON VIJ.LEDGERVOUCHER = GJE.SUBLEDGERVOUCHER
				LEFT JOIN AxDB.dbo.VENDPACKINGSLIPTRANS VPT
				ON VPT.COSTLEDGERVOUCHER = GJE.SUBLEDGERVOUCHER
				LEFT JOIN AxDb.dbo.PURCHTABLE PT 
				ON PT.PURCHID = VIJ.PURCHID
				LEFT JOIN AxDb.dbo.PURCHTABLE PT2
				ON PT2.PURCHID = VPT.ORIGPURCHID
				where GJE.accountingdate between '1/1/2018' and '2/28/2018'


order by GJE.AccountingDate DESC


Select PRT.AVA_HEADERNOTES,PRT.AVA_LOCATIONID,PRT.AVA_CRITICALPO,#T1.*  INTO #T2 from #T1
left join PURCHREQTABLE PRT on PRT.PURCHREQID = #T1.PURCHREQID
left join AxDb.dbo.VENDTABLE VT on VT.ACCOUNTNUM = #T1.INVOICEACCOUNT


Select AVA_HEADERNOTES,PURCHNAME as 'Vendor Name',PURCHID,SUM(REPORTINGCURRENCYAMOUNT) AMOUNT, NAME,COSTCENTERVALUE INTO FMOPS_BRIAN FROm #T2 where PURCHID IS NOT NULL and PURCHID <> ''
Group by AVA_HEADERNOTES,PURCHNAME,PURCHID,NAME,COSTCENTERVALUE
order by AMOUNT DESC






