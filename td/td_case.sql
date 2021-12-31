#using mysql
#create transaction data table
create table transaction_data(
client_id int, 
transaction_date date, 
transaction_amount float, 
transaction_month int, 
transaction_day int
);

#add data to transaction data table
insert into transaction_data (client_id, transaction_date, transaction_amount, transaction_month, transaction_day)
values("1","3/1/2018","30","3","1"),
("1","3/2/2018","60","3","2"),
("1","3/3/2018","90","3","3"),
("1","3/5/2018","120","3","5"),
("1","3/10/2018","80","3","10"),
("2","3/5/2018","30","3","5"),
("2","3/6/2018","80","3","6"),
("2","3/30/2018","60","3","30");

#transaction results
Create table transaction_results(
client_id int, 
transaction_date date, 
transaction_amount float,
mvg3dayavg int
);


INSERT INTO transaction_results
##sql code to get three day average
SELECT td.`client_id`, td.`transaction_date`,td.`transaction_amount`, 
(select avg(transaction_amount) from transaction_data as t2 where t2.`client_id` = td.`client_id` and t2.`transaction_date`between td.`transaction_date`- 3 and td.`transaction_date` - 1
       ) as mvg3dayavg
From transaction_data as td
group by td.`client_id`, td.`transaction_date`
order by td.`client_id`, td.`transaction_date` ASC;

UPDATE transaction_results
SET mvg3dayavg = NULL
WHERE dayofmonth(transaction_results.`transaction_date`) between 1 and 3;

