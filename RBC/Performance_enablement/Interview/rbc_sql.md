
Select T.DEPARTMENT AS Department, 
T.WORK_TITLE as Title, 
CASE WHEN YEAR(TODAY()) - YEAR(W.JOINING_DATE) >= 3, ">=3 YEARS", THEN '< 3 years' END AS Seniority,
AVERAGE(C.BONUS + C.ANNUAL_SALARY) AS Avg_Compensation
Count(T.Department) as Num_of_Employees

From title as T INNER JOIN WORKER AS W ON T.WORKER_REF_ID = W.WORKER_REF_ID
inner join Compensation as C on C.WORKER_REF_ID = T.WORKER_REF_ID
WHERE T.WORKER_TITLE = 'Manager'
group by T.DEPARTMENT, T.WORK_TITLE

#Feedback notes
- Number of employees should be count of workers
- Use partition for affected by 