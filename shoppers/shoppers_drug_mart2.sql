Case Study #2



List of agents that give us a count of how many totalScores they have above 95%

Select S.UserId, Count(*)
From Scores as S
where s.UserId = (Select s.UserId From Scores as S where S.totalScore > 95)
group by S.userId

List all active agents with their avg qualityScore
Select S.UserId, Avg(S.QualityScore)
From Scores as S, Agents as A
where S.UserId = A.UserId
and A.Active = "Yes"
group by S.UserId

What were the highest totalScores for each Lead in 2020
Select A.Lead, max(A.totalScore)
From Scores as S, Agents as A
where S.UserId = A.UserId
and A.FiscalYear = 2020
group by A.Lead


From a trending perspective, Anthony would like to see the net changes for totalScore, productivityScore and qualityScore for each Lead/team between the first fiscal year/fiscal period to the most recent fiscal year/fiscal period.  Only show active agents.
With q1 as (
	A.Lead, sum(S.totalScore) as TotalScore, sum(S.productivityScore) as ProductivityScore, sum(S.qualityScore) as QualityScore
	From Scores as S, Agents as A
	where S.UserId = A.UserId
	and S.FiscalYear = '2019' and S.FiscalPeriod = "3"
),
With q2 as (
	A.Lead, sum(S.totalScore) as otalScore, sum(S.productivityScore) as ProductivityScore, sum(S.qualityScore) as QualityScore
	From Scores as S, Agents as A
	where S.UserId = A.UserId
	and S.FiscalYear = '2020' and S.FiscalPeriod = "3"
)

Select q1.TotalScore - q2.TotalScore as TotalScoreDelta,q1.ProductivityScore - q2.ProductivityScore as ProductivityScoreDelta, q1.QualityScore - q2.QualityScore as QualityScoreDelta
From q1,q2
where q1.Lead = q2.Lead




