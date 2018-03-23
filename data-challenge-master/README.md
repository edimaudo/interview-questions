# Chattermill Data Challenge

### Goal
We would like you to demonstrate your skills in simple data manipulation and analysis. We are looking to understand how you approach the problem and knowledge of programming / data analysis skills, attention to detail and ability to learn new things on the fly.

### Data
We have provided you with a dataset of app reviews for the popular reddit app. The CSV file has multiple flaws and falls short of what we would like to work with, as is often the case and therefore we want you to fix it.

### Expected Output
We expect you to parse the file and make sure that things are consistent and as orderly as possible. For example the app_bought and money_spent variables should be available in buckets (feel free to choose the buckets yourself). We will leave it to you to define what is desirable. 

You should produce these outputs in a ZIP archive or as Pull Request to this repo:
1. A new CSV file with clean data (see above)
2. We would want you to populate the  `reviews` table in exercise_database.db (a SQLlite database). It holds the following columns:

review | title | iso | score | date | apps_bought | money_spent | apps_bought_bucket | money_spent_bucket
--- | --- | --- | --- |--- |--- |--- |--- |--- 
TEXT | TEXG | TEXT | INTEGER | TEXT | INTEGER | NUMERIC | TEXT | TEXT 

Add the updated `exercise_database.db` and the code used to populate the database to the archive.

3. Once you have the table ready, please write SQL queries to fetch the following metrics from the `reviews` table. 
	1. Average score by `iso`
	2. Maximum score by `app_bought_bucket`
	3. Average score over time (day)

Add the code used to generate the queries and a CSV with results into the archive.

### Notes 
- You should be able to complete the project within a couple of hours, not days.
- If you don't have time to complete the full challenge, please focus on the quality of the solution to the parts you do complete.
- Feel free to work in whatever language / framework you are most comfortable in, we usually prefer Python for data tasks.
- Please focus on making the code clear and modular, rather than on the complexity of the solution. Treat your code as if it will be deployed to production. Which would mean taking into account things changing in the incoming data format, such as columns moving.
- You can use a Jupyter Notebook if you prefer, but make sure your code is modular and could be deployed, i.e. it should probably be composed of functions.
- You can use [this handy library](https://docs.python.org/2/library/sqlite3.html) to interact with the database from Python. [Here's](http://pythoncentral.io/introduction-to-sqlite-in-python/) a tutorial on it. There are similar libraries for other languages (R, Matlab). You can also use [this tool](http://sqlitebrowser.org/) if you want a GUI but we prefer programatic solutions.
