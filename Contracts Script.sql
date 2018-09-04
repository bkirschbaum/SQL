


SELECT MCS.[Contract ID]
      ,left(MCS.[CC -CAMPUS DESCRIPTION],6) as 'Cost Center'
	  ,NK.Site_Name
	  ,MG.[Ministry Grouping]
	  ,MG.[Regional Director]
	  ,MG.[AVP]
	  ,NK.Minstry
	  ,V.[Vendor Name]
	  ,MCS.[START DATE]
	  ,MCS.[END DATE]
	  ,[Updated Sector] as 'Sector'
	  ,MCS.[Cancellation Terms]
	  ,MCS.[Contract Status]
	  ,MCS.[Total Contract Amount]
	  ,MCS.[PO Number]
	  ,MCS.NOTES
	  
	  FROM [FM_CONTRACTS].[dbo].[Master Contract Table]
	  left join Vendors V 
	  on V.[Vendor ID] = [Master Contract Table].[VENDOR ID]
	  left join [FM_CONTRACTS].[dbo].[Master Contract Summary] MCS 
	  on MCS.[Contract ID] = [Master Contract Table].[Contract ID]
	  left join [FM_OPERATIONS].[dbo].[NamingKey] NK 
	  on NK.[Cost Center] = left(MCS.[CC -CAMPUS DESCRIPTION],6)
	  left join  [FM_OPERATIONS].[dbo].[Ministry Grouping] MG on MG.[Ministry] = NK.Minstry   where MCS.[END DATE] > GETDATE() -- Date inserted here Getdate is just an example