



select SegmentName, sum(TimeChargeHours) AS TimeChargeHours,  FirstName + ' ' + LastName as Tech, Username,
SUBSTRING(t3.hierarchy ,charindex('.',t3.hierarchy)+1, 6) as IDLocation
from TimeCharge t1 with (NOLOCK)
join WorkOrder t2 with (NOLOCK) on t1.IDWorkOrder = t2.IDWorkOrder
join Location t3 with (NOLOCK) on t3.IDLocation = t2.IDWOLocation
join CustomerSegment t4 with (NOLOCK) on t4.IDCustomerSegment=t2.IDCustomerSegment 
join [User] t5 with (NOLOCK) on t5.IDUser = t1.IDUser
join dbo.Aspnet_Users t10 with (NOLOCK) on t10.UserID = t5.IDUser 
where 
TimeChargeHours > 0
and (t2.IDCustomerSegment IN (@Customer)
and (TimeChargeStartDateTime >=@TimeChargeStartTime and TimeChargeStartDateTime <= @TimeChargeEndTime)
and t2.IDCustomerSegment not in (1, 11, 28, 30, 1056, 1087, 1100, 1109, 1110, 1114, 1115, 1117)
GROUP BY SegmentName, Username, FirstName, LastName, SUBSTRING(t3.Hierarchy ,charindex('.',t3.Hierarchy)+1, 6)
order by SegmentName, Tech;




--- Original ---
select SegmentName, sum(TimeChargeHours) AS TimeChargeHours,  FirstName + ' ' + LastName as Tech, Username,
SUBSTRING(t3.hierarchy ,charindex('.',t3.hierarchy)+1, 6) as IDLocation
from TimeCharge t1 with (NOLOCK)
join WorkOrder t2 with (NOLOCK) on t1.IDWorkOrder = t2.IDWorkOrder
join Location t3 with (NOLOCK) on t3.IDLocation = t2.IDWOLocation
join CustomerSegment t4 with (NOLOCK) on t4.IDCustomerSegment=t2.IDCustomerSegment 
join [User] t5 with (NOLOCK) on t5.IDUser = t1.IDUser
join dbo.Aspnet_Users t10 with (NOLOCK) on t10.UserID = t5.IDUser 
where 
TimeChargeHours > 0
and (t2.IDCustomerSegment =@Customer or @Customer = '999')
and (TimeChargeStartDateTime >='07-01-17' and TimeChargeStartDateTime <='07-31-17')
and t2.IDCustomerSegment not in (1, 11, 28, 30, 1056, 1087, 1100, 1109, 1110, 1114, 1115, 1117)
GROUP BY SegmentName, Username, FirstName, LastName, SUBSTRING(t3.Hierarchy ,charindex('.',t3.Hierarchy)+1, 6)
order by SegmentName, Tech;

