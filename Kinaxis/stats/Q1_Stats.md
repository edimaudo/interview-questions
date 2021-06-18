## Objective
The goal is to determine if there a statistically significant difference in the spending habits of groups A and B.

### Approach
 The first thing to do is to set up a null hypothesis based on the mean values of both groups
For comparing two means, the basic null hypothesis is that the means of group A and B are equal - H0: 𝜇A = 𝜇B
The next step is to use statistical test to validate the hypothesis.  The usual candidate is the T-test but it has to meet certain critieria.  

These include
- The data are continuous (not discrete).
- The data follow the normal probability distribution.
- The variances of the two populations are equal.
- The two samples are independent. There is no relationship between the individuals in one sample as
compared to the other.
- Both samples are simple random samples from their respective populations. Each individual in the
population has an equal probability of being selected in the sample.
- Reasonably large sample size is used

If the criteria is violated here are some other options to look at
- Review the data collection method
- Validate the data (checking the different groups were split correctly)
- If the data size is small it might be worthwhile looking at bootstrapping the data
- Try using a different test such as Mann Whitney. 

### Next steps
I will assume the data meets the criteria for the T-test.
The validation and t-test can be done using any statistical tool such as R, Excel, Minitab and Python.
You will also have to set your level of confidence.  In this case it will be set to 95% confidence.
Based on the outcome check the p-value.  If the p-value is less than your significance level, the difference between means is statistically significant.


