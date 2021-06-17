## SQL Solutions

### Questions 1

Answer 1
Assumption - Current active segment is when Segment active_flag is "Y" and it is the last occuring  update date

Select S.cust_id, S.seg_name, Max(S.update_at) as update_at
From segments as S
where S.active_flag = 'Y'
group by S.cust_id, S.seg_name
order by S.update_at

Answer 2 - based on question 5 hint

Select S.cust_id, S.seg_name, S.update_at
From segments as S
where S.active_flag = 'Y'
order by S.update_at

### Question 2

#Note: transaction date was not included in the readme synposis about transaction

Select T.prod_id, P.prod_name, Count( Distinct T.trans_id) as count
From transactions T inner join products P on T.prod_id = P.prod_id 

where T.trans_dt BETWEEN '2016-01-01 00:00:00' and '2016-05-31 23:59:59'
group by T.prod_id, P.prod_name

### Question 3


### Question 4


###