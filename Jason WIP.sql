/****** Script for SelectTopNRows command from SSMS  ******/
SELECT Distinct GregnSara.[PURCHID]
      ,[Vendor_Account]
      ,[Invoice_Account]
      ,[Vendor_Name]
	  ,PSANotes
      ,[Num_lines]
      ,[Total_PO_Amount]

	  from GregnSara
	  left join PURCHIDTracking pidt ON pidt.PURCHID = GregnSara.PAYMENT

  where GregnSara.PURCHID IN (Select Distinct PURCHID From PURCHIDTracking) and Total_PO_Amount < 85000

  Group by GregnSara.[PURCHID]

      ,[LEDGERVOUCHER]
      ,[Vendor_Account]
      ,[Invoice_Account]
      ,[Vendor_Name]
	  ,PSANotes
      ,[Num_lines]
      ,[Total_PO_Amount]
order by Total_PO_Amount DESC