# Statistics Problem

This question will test some basic knowledge of statistics.  These
questions should not take more than 30 minutes to complete.

## Problems

Please provide a description of how you would solve the problems below and the
reasoning for your methodology.  Be sure to include a link to any tools,
libraries, websites that you would use in your solution.  If there is not
enough information given, please make a reasonable assumption and we can
discuss it in the in-person interview.

1. Suppose we have two groups (A and B) of customers.  For each customer, we
   have the total amount of money they have spent in the last three months.
   For example, the data might be contained in a CSV file like so:

        cust_id,group,spend
        1,A,150.66
        2,A,130.00
        3,A,104.99
        4,B,130.00
        5,B,123.67
        6,B,133.53
        ...
   How can we determine if there a statistically significant difference in the
   spending habits of groups A and B?

2. Suppose we are looking to target 10,000 customers for a given marketing
   campaign treatment (e.g. 10% off purchases over $50 for a one week period).
   To measure the effect of this marketing treatment, we are looking to design
   a treatment vs. control experiment
   (https://en.wikipedia.org/wiki/Treatment_and_control_groups), where the
   control group receives no offer.  We allocate 5,000 customers to the
   treatment group and 5,000 customers to the control group.

   We will measure the effectiveness of the campaign by the proportion of each
   group that came into the store and shopped.  For example, suppose X customers
   in the treatment group and Y in the control group came into the store and
   shopped at least once during the one week period (a `X/5000` and `Y/5000`
   *shop rate* respectively).  The difference between the shop rate should give
   us an estimate of the effect size of the marketing treatment.

   Suppose we have finished this hypothetical marketing campaign and measured
   the difference between the treatment and control shop rate.  After some
   analysis, we have concluded that this difference is not a good estimate
   of the *actual* effect size of the marketing campaign.  What are some possible
   ways in which we could reach this conclusion?  *Hint: Think about
   experimental design and statistical significance.*
