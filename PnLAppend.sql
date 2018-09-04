/****** Script for SelectTopNRows command from SSMS  ******/


begin tran
    UPDATE PnLValues
    SET PnLValues.OpCapital = b.[Operationalized Capital], PnLValues.AutomaticSavings =b.[Automatic Savings]
	FROM PnLValues AS a INNER JOIN CSARisk b ON a.CSA_ID = b.CSA_ID
    WHERE a.CSA_ID = b.CSA_ID
commit tran



Select * from PnLValues