Q1
customer table
id int primary key
email varchar

packages table
id int primary key
customer_id int
status enum (created, shipped,delivered,onhold, cancelled)
weight decimal(5,2)

goal is to return stats on packages groups by status, either active or inactive using postgressql
active means created, onhold, shipped status
inactive means cancelled delivered status

output 
status_group, status, total_packages, total_weight

SELECT
    CASE
        WHEN p.status IN ('created','onhold','shipped') THEN 'active'
        ELSE 'inactive'
    END AS status_group,
    STRING_AGG(DISTINCT p.status, ',') AS status,
    COUNT(*) AS total_packages,
    SUM(p.weight) AS total_weight
FROM packages p
WHERE EXISTS (
    SELECT 1
    FROM customer c
    WHERE c.id = p.customer_id
)
GROUP BY status_group
ORDER BY status_group;


Q2
getKCount(s) using python 3
an array generator service takes in a single integer k and a sum s it returns an array with a sum s with ite ith element is k + i - 1 this hte parameters k = 6 and s = 30 the service rturns 6,7,8,9
Not it is not always possible to generate a valid array for some pair of k and s
Given an integer s find the numbner of vlaid values of k for which is it possible to generate a valid array using the service

supose s = 10

def getKCount(s):
    if s <= 0:
        return 0
    
    # The number of ways to write S as a sum of consecutive integers 
    # (including the single-element case [s]) is equal to the 
    # number of odd divisors of S.
    
    # 1. Isolate the odd part of s
    odd_part = s
    while odd_part % 2 == 0:
        odd_part //= 2
        
    # 2. Count divisors of the odd part
    count = 0
    for i in range(1, int(odd_part**0.5) + 1):
        if odd_part % i == 0:
            if i * i == odd_part:
                count += 1
            else:
                count += 2
                
    return count

# Test Case
print(getKCount(200)) # Outputs: 3