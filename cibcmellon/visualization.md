Given this table structure
index,tag_number_masked,date_of_infraction,infraction_code,infraction_description,set_fine_amount,time_of_infraction,location1,location2,location3,location4,province
0,***39755,20170101,29.0,PARK PROHIBITED TIME NO PERMIT,30,0.0,NR,45 LEWIS ST,NaN,NaN,ON
1,***10593,20170101,9.0,STOP-SIGNED HWY-PROHIBIT TM/DY,60,1.0,OPP,5 MERCER ST,NaN,NaN,ON
2,***39756,20170101,29.0,PARK PROHIBITED TIME NO PERMIT,30,1.0,NR,55 LEWIS ST,NaN,NaN,ON
3,***92318,20170101,5.0,PARK-SIGNED HWY-PROHIBIT DY/TM,50,1.0,N/S,MAPLEWOOD AVE,W/O,VAUGHAN RD,ON
4,***39757,20170101,29.0,PARK PROHIBITED TIME NO PERMIT,30,2.0,NR,61 LEWIS ST,NaN,NaN,ON

I would like to get the

- new dataframe


Visualization
- 




#,Visualization Name,Plotly Type,Analysis Insight
- Annual Ticket Volume (2017-2020),Bar,date_of_infraction count by year.
- Revenue Contribution by Code,Treemap,Sum of set_fine_amount grouped by infraction_code.
- "The COVID ""Cliff""",px.area,Time series showing the 2020 drop vs. 2017-2019 baseline. + 16,2020 Lockdown Recovery,px.line,Tracking the speed of enforcement return post-May 2020.
- Hourly Heatmap,px.density_heatmap,"Identifies 10 AM and 2 PM as ""Prime Enforcement Hours.""" + Rush Hour Enforcement Trend,Line,Filter 7-9 AM / 4-6 PM over the years.
- Heatmap: Day vs. Hour,Heatmap,date (Day of Week) vs time.
- Monthly Seasonality,px.line,Seasonal trends showing summer peaks and winter dips.
- Day of Week Density,px.box,Comparison of weekend vs. weekday enforcement volume.
- Revenue vs. Volume,px.scatter,Compares number of tickets to total fine amount per infraction.
Top 20 Infraction Descriptions,Bar,infraction_description value counts.
- "Top 10 ""Ticket-Trap"" Locations",px.bar,"Ranking location2 (e.g., 2075 Bayview Ave)." + Top 10 High-Revenue Streets,Bar,location2 sum of set_fine_amount.
- Out-of-Province Leakage,px.pie,Perce	ntage of non-Ontario plates (revenue recovery risk).
- Fine Distribution,px.histogram,"Frequency of $30, $60, and $150 tickets." + 13,Fine Amount Frequency,Box Plot,"Distribution of fine values to see ""typical"" penalties."
- Rush Hour Compliance,px.bar,Volume of tickets issued between 7-9 AM and 4-6 PM.
- Location 3/4 Corner Analysis,px.histogram,"How often ""Near Corners"" is used vs. mid-block."
- Infraction Word Cloud,px.treemap,Hierarchical view of infraction_description.
- Average Fine by Province,px.bar,Do US/Quebec plates get higher-value tickets? + US-Plate Growth Trend,Line,Count of non-Canadian provinces in province.




time & seasonality
#,Visualization Name,Plotly Type,Data Logic & Analysis Insight
1,"The COVID ""Cliff"" (Annual)",px.area,Logic: date_of_infraction count by year. Insight: Shows the 36.7% drop in 2020 volume compared to the 2017-2019 baseline.
2,The COVID-19 Decline (Monthly),px.line,"Logic: Monthly count of date_of_infraction. Insight: Pinpoints the exact ""valley"" in April 2020 where issuance plummeted by 90%."
3,Monthly Seasonality (Summer Peak),px.line,"Logic: Aggregated by month across all years. Insight: Identifies the ""Summer Peak"" (May–Aug) where enforcement typically increases by 60%."
4,Heatmap: Day vs. Hour,px.density_heatmap,"Logic: day_of_week vs time_of_infraction. Insight: Identifies the 10 AM and 2 PM ""Prime Enforcement Hours"" across a 7-day week."
5,Hourly Issuance Spikes,px.histogram,Logic: Binned time_of_infraction distribution. Insight: Highlights specific spikes during shift changeovers and peak congestion.
6,Weekend vs. Weekday Volume,px.box,Logic: Comparing ticket counts for Sat/Sun vs. Mon-Fri. Insight: Observes significantly different enforcement patterns on weekends.
7,2020 Lockdown Recovery,px.line,Logic: Post-July 2020 daily ticket volume. Insight: Tracks the velocity of enforcement return once government restrictions were rescinded.

finance and infraction
#,Visualization Name,Plotly Type,Data Logic & Analysis Insight
8,Revenue vs. Volume Matrix,px.scatter,"Logic: Ticket count vs. sum of set_fine_amount by infraction. Insight: Identifies high-ROI infractions (low volume/high fine) vs ""nuisance"" infractions."
9,Revenue Contribution by Code,px.treemap,Logic: Sum of set_fine_amount grouped by infraction_code. Insight: Hierarchical view of which specific bylaws generate the most municipal revenue.
10,Top 20 Infraction Descriptions,px.bar,Logic: infraction_description value counts. Insight: Highlights that 10 infractions typically make up 80% of total ticket volume.
11,Fine Distribution,px.histogram,"Logic: Frequency of set_fine_amount values. Insight: Visualizes the ""Big Three"" clusters: $30 (expired), $60 (No Parking), and $150 (Rush Hour)."
12,Average Fine by Province,px.bar,"Logic: Mean set_fine_amount grouped by province. Insight: Determines if out-of-province plates are receiving higher-tier fines (e.g., $450 Accessible Parking)."


geospatial
#,Visualization Name,Plotly Type,Data Logic & Analysis Insight
13,Top 10 High-Revenue Streets,px.bar,"Logic: location2 sum of set_fine_amount. Insight: Ranks major arteries (Yonge, Queen, Bloor) by their financial contribution."
14,"Top 10 ""Ticket-Trap"" Locations",px.bar,"Logic: Ranking location2 by volume only. Insight: Locates specific addresses (e.g., 60 Bloor St W) that are chronic non-compliance zones."
15,Rush Hour Compliance Trend,px.line,Logic: Filtered for 7-9 AM / 4-6 PM windows. Insight: Tracks compliance on major routes; notably decreased during 2020 discretion policies.
16,Private Property vs. Public,px.pie,"Logic: Filtering description for ""Private Property"". Insight: In 2020, Private Property tickets represented ~24% of all tickets (up from 20%)."
17,Corner Infraction Frequency,px.histogram,"Logic: Count where location3 or location4 is not null. Insight: Measures how often ""Intersection/Corner"" safety violations are targeted vs mid-block."


