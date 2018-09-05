


Begin Tran


DECLARE @date  date;
DECLARE @InnerCounter int;
DECLARE @Counter int;
DECLARE @OuterCounter int;
DECLARE @date1 date;
DECLARE @SiteName nvarchar(100);
DECLARE @X int;
DECLARE @I nvarchar(250);
DECLARE @S nvarchar(250);
DECLARE @E nvarchar(250);
DECLARE @R nvarchar(250);
DECLARE @V nvarchar(250);
DECLARE @MedxcelAttendees nvarchar(250);
DECLARE @CustomerAttendees nvarchar(250)
DECLARE @Score int;


SET @date = '8/1/2018'
SET @Counter = 0;
SET @OuterCounter = 0;
SET @date1 = @date;
SET @X = 151;
SET @InnerCounter = 0;
Set @SiteName = (Select Site_Name  from FM_OPERATIONS.dbo.NamingKey where ID = @InnerCounter + 1);
Set @I = '"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'
Set @S = '"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'
Set @E = '"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'
Set @R = '"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'
Set @V = '"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'
Set @MedxcelAttendees = 'AVP;RD;Site Leader';
Set @CustomerAttendees = 'CEO,COO,VP';
Set @Score = ROUND(RAND()*(10-5)+5,0);


while (@OuterCounter < @X) BEGIN

	while (@Counter < 20) BEGIN
		Set @Score = ROUND(RAND()*(10-1)+1,0);
		INSERT INTO Test VALUES 
		(@SiteName,@date,@Counter + 1,DATEADD(m,3,@date1),@I,@S,@E,@R,@V,@Score,@MedxcelAttendees,@CustomerAttendees);
		Set @Counter = @Counter + 1;
		Set @date1 = DATEADD(m,3,@date1)
		END
	Set @Counter = 0;
	Set @OuterCounter = @OuterCounter + 1;
	Set @date1 = @date;
	Set @SiteName = (Select Site_Name  from FM_OPERATIONS.dbo.NamingKey where ID = @OuterCounter + 1);
END



/* Testing Code 

--- Clear Table ---

TRUNCATE TABLE Test

--- Check Table Contents ---

Select * from Test


*/

