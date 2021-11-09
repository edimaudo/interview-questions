//*
- The top Revenue opportunities that are in ""Closed Won"" stage, per Ultimate Parent ID, 
broken down by Type of Opportunity (New Customer and Renewal opps)
- Show the Opportunity Type, Closed Date, and Revenue of each opportunity
*//				

select m.`Ultimate Parent ID`, m.`Opportunity ID`, m.`Opportunity Type`, m.`Opportunity Close Date` as 'Close Date', 
SUM(m.`Ultimate Company Annual Revenue`) as Revenue
From mongo as m
where m.`Opportunity Stage` = 'Closed Won' and m.`Opportunity Type`in ('New Customer','Renewal opps')
group by m.`Ultimate Parent ID`, m.`Opportunity ID`, m.`Opportunity Type`, m.`Opportunity Close Date` 