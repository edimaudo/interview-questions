#clear old data
rm(list=ls())

#load libraries
for (package in c('ggplot2', 'corrplot','tidyverse','lubridate','data.table')) {
  if (!require(package, character.only=T, quietly=T)) {
    install.packages(package)
    library(package, character.only=T)
  }
}

#load data
df <- read.csv(file.choose())

#backup data
df.backup <- df

#descriptive statistics
basic_stats <- summary(df)
print(basic_stats)

#missing data

#outliers

#exploratory analysis

# each variable
# 
# most popular path
# least popular path
# 
# highest number of sessions
# lowest number of sessions
# average # of sessions
# 
# highest, lowest, average bounce rate
# 
# highest, lowest, average time of page
# 
# highest, lowest, average transactions
# 
# 
# graphs
# sessions vs bounce rate
# sessions vs time on page
# sessions vs transactions
# 
# bounce rate vs time on page
# bounce rate vs transactions
# 
# time on page vs transactions
# 
# correlations
# sessions, bounce rate
# sessions, time on page
# sessions, transactions
# 
# bounce rate, time on page
# bounce rate, transactions
# 
# time on page, transactions
# 
# 
# trends over time
# date vs path
# date vs sessions
# date vs transactions
# date vs bounce rate
# date vs time on page

#analytics
#rfm model

#basic forecasting using prophet with other infor
