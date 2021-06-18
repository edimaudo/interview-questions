## SQL Solutions


### Question 1 Answer 

Assumption 1 - Current active segment is when the `active_flag = 'Y'`

Select S.cust_id, S.seg_name, S.update_at
From segments as S
where active_flag = 'Y'
order by S.update_at

Assumption 2 - Current active segment is when the `active_flag = 'Y'` and using the most recent update_dt

Select S.cust_id, S.seg_name, Max(S.update_at) as update_at
From segments as S
where active_flag = 'Y'
group by S.cust_id, S.seg_name
order by S.update_at


### Question 2 Answer

#Note: transaction date was not included in the readme synposis about transaction

Select T.prod_id, P.prod_name, Count( Distinct T.trans_id) as count
From transactions T inner join products P on T.prod_id = P.prod_id 

where T.trans_dt BETWEEN '2016-01-01 00:00:00' and '2016-05-31 23:59:59'
group by T.prod_id, P.prod_name


### Question 3 Answer
Select S.cust_id, S.seg_name,  Max(S.update_at) as update_at
From segments as S 
where S.update_at < '2016-03-01 00:00:00' 
GROUP by S.cust_id
order by S.cust_id, S.update_at

### Question 4 Answer


### Question 5 Answer