/******

The Budget import brings in all the base data for the Monthly Report Template. Each section the data needs to be placed in is marked by the corresponding noted header. 

******/



/* Budget Numbers */


/* Finance Pull */
Begin
Select Month(Date) Month,Year(Date) Year,(Sum([Amount in reporting currency])*-1) as 'Values',FMK.Ministry, Ministry_Grouping.[Ministry Grouping],'Finance' Identifier,Ministry_Grouping.AVP,Ministry_Grouping.[Regional Director]
From FinanceRevenue
inner join FinanceMinistryKey FMK on FMK.[Cost Center]=FinanceRevenue.[Cost Center]
inner join Ministry_Grouping on FMK.Ministry = Ministry_Grouping.Ministry
Group by Date, [FinanceRevenue].[Cost Center],FMK.Ministry,FMK.[Cost Center], Ministry_Grouping.[Ministry Grouping],Ministry_Grouping.AVP,Ministry_Grouping.[Regional Director]
END

/* ProForma Pull */
/* Completed */
Begin
Select [Reference Number],Coalesce(([Salary Cost]+[Addtl Benefits Cost]),[Salary Cost],[Addtl Benefits Cost]) AddedCost,Site,PFT.System,MG.[Ministry Grouping],[Approval Date],Month([Approval Date]) Month,YEAR([Approval Date]) Year,'Proforma' Identifier,MG.AVP,MG.[Regional Director]
From ProFormaTracker  PFT
Left join Ministry_Grouping MG on MG.Ministry = PFT.Ministry
where Status = 'Approved'
End

/* Risk Pull */
/* Completed */
Begin
SELECT [Operationalized Capital] + [Operational Efficiencies (Labor)] Risk,CSARisk.Ministry,MG.[Ministry Grouping],'Risk' Identifier,MG.AVP,MG.[Regional Director]  
FROM  CSARisk
inner join Ministry_Grouping MG on MG.Ministry = CSARisk.Ministry
End

/*Vop Add_Reduc Pull */
Begin
Select [Ministry Grouping],Trade,Type,[Year 1],[Year 2],[Year 3],[Year 4],[Year 5],Comments
From VOP
left join Ministry_Grouping MG ON MG.Ministry = VOP.Ministry
where Type IN ('Salary','Benefits', 'Overtime')


End

 /* CSA Salaries and Benefits Pull */
 /* Completed */
Begin
 SELECT Coalesce((labor + SA.AdjustedAmount),labor) as [CSA Labor],[Ops Ministry],MG.[Ministry Grouping],'CSA Salaries and Benefits' Identifier,MG.AVP,MG.[Regional Director],[CSA_ID]
  FROM [Upload Testing].[dbo].[PnLValues] PnL
  left join [Cost Equation Demo].dbo.Ministry_Grouping MG on MG.Ministry = PnL.[Ops Ministry]
  left join [Upload Testing].[dbo].SalaryAdjustments SA on  PnL.CSA_ID = SA.[CSA #]
 End



/* Labor Pull */
Begin
SELECT       [Current Amount], Month([Pay Date]) as 'Month',Year([Pay Date]) as 'Year', LaborCategory_OpsCategory.[Ops Category], Labor.Ministry,[Ministry Grouping].[Ministry Grouping],[Ministry Grouping].AVP, [Ministry Grouping].[Regional Director],[Job Title],[Cost Center],TAK.Sector,TAK.Trade
FROM		 [FM_OPERATIONS].[dbo].[Labor]
left join [FM_OPERATIONS].dbo.[Ministry Grouping] on [Ministry Grouping].Ministry = Labor.Ministry
left join LaborCategory_OpsCategory on labor.Category = LaborCategory_OpsCategory.[Labor Category]
left join NamingKey NK on NK.[Cost Center] = Labor.[Org Level 1 Code]
left join TitleAsheKey TAK on TAK.[Position Title] = labor.[Job Title]
WHERE        [Pay Date] between '7-1-2016' and '6-30-2017' and [Cost Center] NOT IN (845500,845501,845502,845503,845504,845505,845507,885000,846100,841100,836100)
order by Year([Pay Date]),Month([Pay Date]),[Org Level 1 Code]
End


/* Service and Supplies Pull */
/* Completed */

Begin

Select [GL Amount],MONTH([GL Date]) Month, Year([GL Date]) Year,NK.Site_Name,NK.Minstry,MG.[Ministry Grouping],MG.[Regional Director],MG.AVP,'Service Contract' as  'Supplies/Service/Contract', STR.Trade,[Updated Sector] Sector, [Vendor Name],NOTES,SCI.[PO Number]
FROM	     Contracts CONT
inner join ServiceContractInfo SCI on SCI.[Contract ID] = CONT.[Contract ID]
inner join SectorTradeRelationship STR on STR.Sector = SCI.[Updated Sector]
inner join NamingKey NK on NK.[Cost Center] = LEFT(SCI.[CC -CAMPUS DESCRIPTION],6)
inner join Ministry_Grouping MG on MG.Ministry = NK.Minstry
WHERE        [GL Date] between '7-1-2016' and '4-30-2017' and Source = 'Payments'


Union All

SELECT       [Ext Price Amt], Month([Bill Date]) Month, YEAR([Bill Date]) Year, MFM_Site_Name ,NK.Minstry, Ministry_Grouping.[Ministry Grouping],Ministry_Grouping.[Regional Director],Ministry_Grouping.AVP, 'Supplies', STRel.Trade,GMS.Sector, 'Grainger',Description,'',NK.[Cost Center]
FROM		 [Cost Equation Demo].[dbo].[Grainger]
left join Grainger_Material_Sector GMS on GMS.[Material Segment] =Grainger.[Material Segment]
left join SectorTradeRelationship STRel on STRel.Sector = GMS.Sector
left join NamingKey NK on NK.INVENTSITEID = Grainger.MFM_Site_Code
inner join Ministry_Grouping on Ministry_Grouping.Ministry = NK.Minstry
where [Bill Date] between '5-1-2017' and '5-30-2017'
UNION ALL
SELECT		 [INVOICEAMOUNT] as 'Invoice Amount', Month(LASTSETTLEDATE) as 'Month', YEAR(LASTSETTLEDATE) as 'Year', Site_Name,[FY17 Invoices Paid].Minstry, Ministry_Grouping.[Ministry Grouping], Ministry_Grouping.[Regional Director],Ministry_Grouping.AVP, [Service_Supplies], [Trade],[Sector],[Vendor_Name],PSANotes,PURCHID
FROM		 [Cost Equation Demo].[dbo].[FY17 Invoices Paid]
inner join Ministry_Grouping on Ministry_Grouping.Ministry = [FY17 Invoices Paid].Minstry
where		 ABR = 'No' and [Vendor_Name] <> 'Grainger' and LASTSETTLEDATE between '7-1-2016' and '3-31-2017'
END


/* OTHER EXPENSES PULL */

SELECT Month(Date) as 'Month',Year(Date) as 'Year',[PnLConcur].[Cost Center],[Amount in reporting currency] as 'Amount', RTRIM(PnLAccountMap.PnLGrouping) as FinanceGrouping, FinanceMinistryKey.Ministry,Ministry_Grouping.[Ministry Grouping],Ministry_Grouping.[Regional Director],Ministry_Grouping.AVP
FROM [Cost Equation Demo].[dbo].[PnLConcur]
inner join PnLAccountMap on PnLAccountMap.[Main Account]=PnLConcur.[Main Account]
inner join FinanceMinistryKey on PnLConcur.[Cost Center]=FinanceMinistryKey.[Cost Center]
inner join Ministry_Grouping on Ministry_Grouping.Ministry=FinanceMinistryKey.Ministry







/*   We decided to leave out PO Detail when using actuals, but keeping code here just in case we revert the change
UNION ALL
SELECT	     [Line_Amount],[Month],[Year],[Minstry],[Service_Supplies],[Trade],[Sector],[Vendor_Name], PSANotes
FROM	     [Cost Equation Demo].[dbo].[PO Detail]
where		 ABR = 'No' and [Vendor_Name] <> 'Grainger'

*/







                         