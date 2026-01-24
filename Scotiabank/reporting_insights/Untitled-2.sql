
Q1 

Select c.Client_Num, c.Beacon_Score, sum(Sales_Amount) as total_sales_amount
from client as c inner join account as a on c.Client_num = a.client_Num
group by 1,2
order by 1 ASC


Q2

with upl as (
    a.Client_Num, sum(a.Sales_Amount) as total_sales_amount
    from account as a
    where Product = 'UPL'
),

ranked as (
    Select *,
    rank() over (partition by client_Num order by total_sales_amount)
    from upl
)

select *
from ranked



Q3)

with transaction_info as (
    
    from account as a
    where a.Type = 'Secured'
)