/****** Script for SelectTopNRows command from SSMS  ******/
  
 SELECT Distinct [ORIGPURCHID], ITEMID
  INTO #T3
  FROM [AxDB].[dbo].[VENDPACKINGSLIPTRANS]
  order by ORIGPURCHID
 
SELECT Distinct [PURCHID]
      ,ITEMID
	  ,Name
  INTO #T1
  FROM [AxDB].[dbo].[PURCHLINE]
  order by PURCHID

SELECT   DISTINCT VIJ.purchid,GJAE.LEDGERACCOUNT,substring(GJAE.Ledgeraccount,8,5) as 'Cost Center',Replace(RIGHT(LEDGERACCOUNT,CHARINDEX ('-' ,REVERSE(LEDGERACCOUNT))),'-','') Trade
 INTO #T2
FROM            AxDB.dbo.GENERALJOURNALENTRY GJE 
                INNER JOIN
                AxDB.dbo.GENERALJOURNALACCOUNTENTRY GJAE on GJE.RECID = GJAE.GENERALJOURNALENTRY 
				INNer JOIN
				Axdb.dbo.VENDINVOICEJOUR VIJ on VIJ.Ledgervoucher = GJE.subledgervoucher
				where vij.purchid IS NOT NULL and vij.purchid != '' and VIJ.PURCHID IN (Select Purchid from #T1) and gjae.ledgeraccount > '400000' and gjae.LEDGERACCOUNT != '999996'

Select * 

from (
SELECT VIJ.[INVOICEACCOUNT]
      ,VT.DBA
      ,#T2.[Cost Center]
	  ,#T2.Trade as 'AX Trade Code'
	  ,AOK.[Actual AX Trade] as 'AX Trade'
	  ,#T1.Name
	  ,#T1.ITEMID
	  ,IDST.Sector
	  ,IDST.Trade as 'Ops Trade'
      ,VIJ.[INVOICEAMOUNT]
      --,VIJ.[INVOICEAMOUNTMST]
      ,VIJ.[INVOICEDATE]
      --,VIJ.[LEDGERVOUCHER]
      ,VIJ.[PURCHID]
      --,VIJ.[DATAAREAID]
      ,VIJ.[PARTITION]
      ,VIJ.[RECID]
	  ,row_number() OVER(Partition By VIJ.RECID order by VIJ.RECID) DuplicateCounter
  FROM [AxDB].[dbo].[VENDINVOICEJOUR] VIJ
  left JOIN #T2 on #T2.PURCHID = VIJ.PURCHID
  left join #T3 on VIJ.PURCHID = #T3.ORIGPURCHID
  left join #T1 on #T1.PURCHID = VIJ.PURCHID
  inner join AxDB.dbo.VENDTABLE VT on VT.ACCOUNTNUM = VIJ.INVOICEACCOUNT
  left join FM_OPERATIONS.dbo.Item_Description_Sector_Trade IDST on IDST.Item_Number = #T1.ITEMID
  left join [FM_OPERATIONS].[dbo].[AX_OPS_Key] AOK on AOK.[AX Trade] = #T2.Trade
  where ledgervoucher not like 'APIN%'
  )
  a where duplicatecounter = 1
  order by invoicedate desc

  Drop table #T1
  Drop table #T2
  Drop table #T3
  