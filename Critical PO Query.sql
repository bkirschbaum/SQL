/****** Script for SelectTopNRows command from SSMS  ******/
SELECT Sum(INVOICEAMOUNT) as 'Amount', Count(RECID) as 'Total Critical PO Line Items',Minstry,Month(Created_Date) as 'Month', Year(Created_Date) as 'Year', Trade 
  FROM [Cost Equation Demo].[dbo].[FY17 Invoices Paid]
  where PSANotes like '%%Critical%%'
  group by Minstry, Trade, Month(Created_Date),Year(Created_Date)
  order by Sum(INVOICEAMOUNT)DESC