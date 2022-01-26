## Hierarchy Test Case

### Overview
See Hierarchy Test Case word document

### Objective
Provide a proposal on how to identify and solve for these data gaps and non-standard reporting structures to capture all valid employee-to-manager relationships? 

### Assumptions
See Hierarchy Test Case word document

### Solution

#### Idea 1
Use a recursive query traverse through the data
WITH cte_employees AS (
    SELECT       
       e.EMP_NM, e.EMP_POSN_ID, e.ROLE, e.MGR_POSN_ID, e.CAPTR_DT
        
    FROM       
        ALL_EMPLOYEES as e
    WHERE e.ROLE IN ('AM','SAM','AMCSR')
    UNION ALL
    SELECT 
       e.EMP_NM, e.EMP_POSN_ID, e.ROLE, e.MGR_POSN_ID, e.CAPTR_DT
    FROM 
        ALL_EMPLOYEES as e
        INNER JOIN cte_employees o 
            ON o.EMP_POSN_ID = e.MGR_POSN_ID
)
SELECT * FROM cte_employees;


#### Idea 2
Break down the query into different sections using by using different levels
first level would be ('AM','SAM','AMCSR'), 
second level would be ('ABM','BM')
and the third level would be ('RVP','RP')
