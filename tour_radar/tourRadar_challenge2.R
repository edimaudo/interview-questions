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
missing_data <- apply(df, 2, function(x) any(is.na(x)))



#-------------------
#exploratory analysis
#-------------------

#sessions          bounces          time_on_page     transactions

# sessions vs bounce rate
ggplot(data=df, aes(y=sessions, x=bounces)) +
  geom_line()+ geom_point() + theme_classic()
# sessions vs time on page
ggplot(data=df, aes(y=sessions, x=time_on_page)) +
  geom_line()+ geom_point() + theme_classic()
# sessions vs transactions
ggplot(data=df, aes(y=sessions, x=transactions)) +
  geom_line()+ geom_point() + theme_classic()

# bounce rate vs time on page
# bounce rate vs transactions
# 
# time on page vs transactions
# 

# correlations
corrinfo <- df[,3:6]
corrplot(cor(corrinfo), method="number")



# trends over time
# date vs path
# date vs sessions
# date vs transactions
# date vs bounce rate
# date vs time on page
ggplot(data=df, aes(y=sessions, x=transactions)) +
  geom_line(color="blue")+ geom_point() + theme_classic()

#rfm modelling

#time series
