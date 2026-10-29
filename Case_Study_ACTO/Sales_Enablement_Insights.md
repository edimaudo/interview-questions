# Sales Enablement Effectiveness — Findings & Recommendation

## Executive conclusion

Enablement activity is **associated** with performance, but the dataset does not establish causal lift. Coaching frequency and coach/manager patterns are more informative than training scores alone. 
The strongest leadership opportunity is to test a structured, behavior-focused coaching model and evaluate it with a controlled rollout rather than increase generic course volume.

## Data-quality notes

- Grain: one row per rep-quarter; no duplicate UserID-Year-Quarter records. There are 1,675 records and 150 distinct reps.
- Coach and rep rating fields are missing on 136 records (all have zero coaching sessions). The dashboard divides rating sums by rated sessions and leaves unrated records null rather than treating them as zero.
- `ManagerName` is used as the closest available proxy for “coach”; the dataset has no separate coach identifier.
- `total_self_learning_searches` is constant at zero, `courses_completed` is constant at four, and `total_time_on_search_results_seconds` is entirely null. Those fields cannot explain performance differences in this release.
- The training score is stored as a sum across four courses. The Tableau calculated field `Average Training Score per Course` divides by `courses_completed` to put it on a per-course scale.
- SalesQuotaAttainment is treated as a percentage/percentage-point measure based on the field name and observed scale; validate that business definition with the data owner before publishing.

## Core question 1 — Is training and coaching driving sales performance?

1) Training score and quota attainment have a positive raw correlation of **r = 0.18**. 
Coaching sessions have a stronger raw correlation with quota attainment (**r = 0.29**). 
Both correlations are statistically detectable in this large dataset, but correlation is not causation.
2) quota attainment rose from **51.37% in 2023** to **54.63% in 2025** (+3.26 points). 
3) Across the 138 reps with records in all three years, average 2025 minus 2023 change was **+3.71 points**, median **+3.15 points**, and **61%** improved. This suggests improvement is not only a changing sample, but it is not universal.
- When year, quarter, experience, territory, team, and product are controlled, the training-score coefficient is near zero and not statistically meaningful; coaching-session frequency remains associated with roughly **+1.8 quota-attainment points per additional session** in that specification. Once manager differences and coaching duration are added, the independent session coefficient is no longer distinguishable from zero. The manager/coaching environment may explain much of the raw association.
- In short: performance improved over the period, but the current data do **not** prove that training or coaching caused the improvement.

## Core question 2 — Patterns leadership should act on



### Territory, team, product, experience

- Territory: **Northeast** has the highest mean attainment (**57.5%**), while **West** is lowest (**50.8%**), a 6.8-point spread.
- Team: **Beta** leads (**54.7%**), while **Gamma** trails (**49.6%**). Team results should be read with manager and territory filters because mix may explain part of the gap.
- Product: **Folders** averages **56.6%** attainment versus **Staplers** at **50.7%**. Check product/territory mix before changing enablement by product.
- Experience: mean attainment ranges from **46.1%** among reps with zero years at the start of the period to **64.2%** in the 10-year experience group. New reps warrant distinct onboarding and coaching, not just the same course sequence.
- Coaching sessions: average attainment is **45.4%** for records with no sessions, **54.8%** with 3–4 sessions, and **59.7%** with 5+ sessions. The pattern is directional, not a causal dose response: higher-performing managers tend to coach more, and some high-session groups are small.
- Training score: the third training-score quartile has the highest mean attainment (**57.4%**); the highest training-score quartile averages only **53.7%**. Maximize applied skill and measured sales outcomes, not test score alone.

### Managers / coaching environment
- The three highest-attainment manager cohorts (Elena Rodriguez, Sarah O'Brien, Thomas Park) average **62.1%** quota attainment, **4.7** coaching sessions per rep-quarter, and a mean coach rating per rated session of **4.40**.
- The two lowest-attainment manager cohorts (Michael Nguyen, David Kim) average **42.8%** attainment, **1.2** coaching sessions, and **3.17** average coach rating. The gap is large, but manager, territory, and rep composition are entangled, so treat this as a diagnostic lead rather than a coach ranking.


## Core question 3 — One investment change

**Shift the next increment of enablement investment from more standardized course volume to a structured, manager-led coaching pilot, prioritizing low-coaching teams and new reps.** Use a working target of 4–5 short, behavior-specific coaching sessions per rep per quarter for the pilot (a testable hypothesis, not an established optimum), focused on call review, objection handling, product positioning, and one tracked commitment per session. Keep the core training curriculum in place, but tie it to coaching practice and observed field behavior.

Evaluate the pilot using a phased or randomized rollout with a comparable holdout. Pre-specify quota-attainment lift, percentage of reps above the selected threshold, manager fidelity, and cost per incremental attainment point; compare like-for-like reps across territory, product, experience, and seasonality. The file contains no enablement cost data, so ROI or a dollar-reallocation amount cannot yet be estimated.


## recommendations
1. Standardize coaching for under-supported sales teams
Priority 1
Recommendation: Introduce a structured coaching pilot for representatives in manager groups with low coaching frequency and weak sales attainment.

The differences between manager cohorts are substantial:
Manager cohort	Avg. attainment	Sessions per rep/quarter	Coaching minutes per quarter
Michael Nguyen (12 reps)	42.3%	1.17	62
David Kim (10 reps)	43.2%	1.31	72
Sarah O'Brien (15 reps)	61.5%	4.75	267
Elena Rodriguez (13 reps)	63.0%	4.71	269

These are averages across each representative's available quarters. The results show a substantial performance gap alongside differences in coaching activity and ratings.

What leadership should do: Pilot three structured coaching sessions per representative per quarter in the lower-frequency cohorts. Each session should cover a specific performance gap, review a real sales interaction, and establish a follow-up action.

Measure changes in attainment, coaching quality ratings and follow-through against a comparable group before expanding the program.

The data do not establish that coaching frequency caused the performance difference, so the pilot should test that hypothesis rather than assume it.
2. Build a dedicated ramp-up program for inexperienced representatives
Priority 2
Recommendation: Invest in practical sales readiness for representatives entering the organization with little or no prior experience.
Experience at start	Representatives	Avg. attainment	Avg. training-score sum
0 years	26	46.5%	156.7
1 year	38	52.0%	211.6
2 years	25	51.0%	246.6
3 years	21	53.9%	320.3

Representatives with zero years of experience at the start average approximately 5.5 percentage points less attainment than those starting with one year of experience.

The pattern suggests a development need, but it does not prove that training scores explain the attainment gap.

What leadership should do: Develop a first-year sales ramp that combines product knowledge with practical application: call shadowing, objection-handling exercises, manager-observed practice and structured feedback.

Use 30-, 60- and 90-day reviews to evaluate whether new representatives are improving their sales behaviors and attainment. Do not simply add more courses; the dataset records four courses completed per rep-quarter throughout, so course count alone does not distinguish performance.
3. Target product-specific enablement where performance gaps persist
Recommendation: Run a focused product-selling pilot for Staplers in the Midwest and Northeast, rather than investing equally across every product and territory.

The product-level results vary considerably:
Product and territory	Representatives	Avg. attainment
Folders, Northeast	12	62.7%
Staplers, Northeast	11	51.4%
Folders, Midwest	8	58.4%
Staplers, Midwest	6	47.1%
Folders, South	8	51.4%
Staplers, South	9	51.9%

The gap between Folders and Staplers is approximately 11 percentage points in both the Midwest and Northeast, but not in the South. In the Midwest, Staplers representatives actually have a higher average training-score sum than Folders representatives despite lower attainment.

This is a reason to investigate product-specific sales execution, not to assume that Staplers representatives need more classroom training.

What leadership should do: Review sales calls, customer objections, product positioning and lost opportunities for Staplers representatives in those two territories. Test focused product-selling support against a comparable group and measure the subsequent attainment change.

The samples are relatively small, particularly in the Midwest, so validate the pattern across comparable representatives and managers before scaling.

How I would prioritize the three

First: Coaching consistency

Address the sizeable differences in coaching activity and attainment. This is the most direct operational intervention to test.

Second: New-rep ramp-up

Reduce the early-experience performance gap through structured practice and feedback.

Third: Product-specific pilot

Investigate whether targeted sales support can improve Staplers attainment in the Midwest and Northeast before committing to a broader rollout.


Conclusion
The overall recommendation: Invest in targeted, measurable interventions instead of increasing standardized training volume. The dataset identifies specific coaching, experience and product-territory gaps, but a controlled pilot is needed to determine which changes generate incremental sales performance.


## testing
To establish whether training or coaching causes an improvement in sales quota attainment, you need to observe what happens when a defined enablement intervention is introduced, compared with what would have happened without it.

Your current dataset can identify associations, but it cannot establish that coaching or training caused higher attainment. For that, I recommend the following design.
1. Best option: a controlled coaching experiment
The research question would be:

Does a structured coaching intervention improve quarterly sales quota attainment compared with business-as-usual coaching?

Treatment group

Sales reps receive a clearly defined, structured coaching program. Specify the coaching content, delivery process and cadence before the experiment begins.




Control group

Comparable sales reps continue receiving business-as-usual coaching and existing required training. They should not be denied essential support.




Compare sales outcomes

Measure quota attainment before and after the intervention, over the same quarters for both groups.



How to assign the groups
Randomly assign eligible reps to treatment or control, balancing the assignment on baseline quota attainment, team, territory and experience. Where feasible, also balance by manager.

If managers cannot realistically deliver different approaches to different reps without contaminating the control group, randomize by manager instead. That requires enough independent managers to support a credible comparison. Your dataset's four teams alone would be too few clusters for a reliable team-randomized experiment.
2. Define the outcome before starting
Use sales quota attainment as the primary outcome.
Metric	Purpose
Average quota attainment (%)	Measures the overall change in sales performance
Percentage of reps reaching 100% of quota	Measures whether the intervention helps reps meet their targets
Change from baseline	Accounts for differences in starting performance
Cost per incremental improvement	Helps leadership decide whether the intervention is worth scaling

For example, suppose the treatment group improves by 5 percentage points and the control group improves by 1 percentage point.

The estimated treatment effect is:
\[
(5)-(1)=\boxed{4\text{ percentage points}}
\]

That is the difference in improvement between the groups, not a 4% relative increase. It would be evidence of an intervention effect if the study is properly randomized and the estimate is sufficiently precise.

The actual sample size and experiment duration should be determined using historical variability, the smallest improvement leadership considers commercially meaningful, and a statistical power calculation. With 150 reps, it is particularly important to assess whether the study can detect a meaningful effect.
3. If randomization is not possible
Use a stronger quasi-experimental design, preferably a difference-in-differences analysis.

For example, suppose a new coaching program is rolled out to selected managers, while comparable managers continue with existing practices.

Compare the change in quota attainment for the treated reps with the change for the comparison reps, before and after rollout:
\[
\text{Effect} =
(\text{Treated After}-\text{Treated Before})
-
(\text{Control After}-\text{Control Before})
\]

This design is more credible when the groups had similar performance trends before the intervention, the rollout timing is documented, and no other changes disproportionately affect the treated group at the same time. An event-study analysis can help assess pre-existing trends.

Rep-level and quarter-level controls can account for some differences, but regression alone does not remove all confounding.
4. What is missing from your current dataset?
Your existing records already contain useful information about sales attainment, training scores, coaching activity, experience, managers, teams and territories. To evaluate causal impact, you would additionally need:
- The date each rep was assigned to the intervention, and whether they were assigned to treatment or control.
- A precise definition of what the intervention changed.
- Reliable pre-intervention and post-intervention sales outcomes.
- Consistent quota definitions and actual sales results for each period.
- Records of intervention participation and other significant changes, such as manager changes or territory reassignment.
There is also an important source of bias in the current data: managers may increase coaching when reps are struggling. Consequently, more coaching could coincide with lower attainment even if coaching helps, or could coincide with higher attainment because stronger managers both coach more and manage better.
My recommendation
Start with a randomized, controlled pilot of a specific coaching intervention, with rep-level assignment where contamination can be managed. Use quota attainment as the primary outcome, and compare the change in the treatment group with the change in the control group.

Do not select an arbitrary number of coaching sessions from the existing correlations. First define what constitutes effective coaching, calculate the sample size needed to detect a meaningful sales improvement, and then test whether the intervention produces that improvement.

That will let leadership move from “coaching is associated with attainment” to a much stronger conclusion: “This coaching intervention generated a measurable, statistically supported improvement in sales quota attainment.”