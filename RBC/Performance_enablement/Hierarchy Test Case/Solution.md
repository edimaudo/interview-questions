## Hierarchy Test Case

### Overview
See Hierarchy Test Case word document

### Objective
Provide a proposal on how to identify and solve for these data gaps and non-standard reporting structures to capture all valid employee-to-manager relationships? 

### Assumptions
See Hierarchy Test Case word document

### Potential Approaches

#### Idea 1 - Recursive query
Use a recursive query to traverse through the data that looks something like this.

WITH cte_employee AS (
   cte_query_definition
 
   UNION ALL
 
   cte_query_definition filter on employee position and manager position
   )
  
SELECT *
FROM cte_employee ;


#### Idea 2 - Multiple Queries
Design multiple queries to get the design for the hierarchy table using the With Clause
Query 1 should filter on ('ABM','BM') since they are the main connection between the different employee levels
Query 2 should filter on ('AM','SAM','AMCSR')
Query 3 should filter on ('RVP','RP',"VP")
Query 4 should connect Query 2 with Query 3
Query 5 should connect Query 2 with Query 1
Query 6 should connect Query 4 and 5 and then organize then pick the correct headers based on the hierarchy screen shot provided




