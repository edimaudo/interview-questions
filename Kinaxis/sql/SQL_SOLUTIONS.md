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
Select S.seg_name , P.category,  CAST(SUM(T.item_price* T.item_qty) as INTEGER) as revenue
From segments as S inner join transactions as T on S.cust_id = T.cust_id
 inner join products P on P.prod_id = T.prod_id
where S.active_flag = 'Y'
group by S.seg_name , P.category
Order by 3 DESC


### Question 5 Answer
UPDATE segments
SET seg_name = 'NEW2'
where cust_id in (Select S1.cust_id  From segments as S1 group by S1.cust_id having min(S1.update_at) >= '2016-03-01 00:00:00')

UPDATE segments
SET seg_name = 'NEW2'
where active_flag = 'Y' and cust_id in (Select S1.cust_id
From segments S1
where S1.active_flag = 'Y'
group by S1.cust_id
having max(S1.update_at) < '2016-03-01 00:00:00')

Select S1.seg_name, count(S1.cust_id) as count_cust
From segments as S1
group by S1.seg_name

### Question 6 Answer
- See data_insight.pptx