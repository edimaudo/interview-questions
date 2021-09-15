#=============
# Forecasting 
#=============
rm(list = ls()) #clear environment
#=============
# Packages
#=============
packages <- c('ggplot2', 'corrplot','tidyverse','readxl',
              'scales','dplyr','mlbench','caTools','grid','gridExtra',
              'forecast','TTR','xts','lubridate')
for (package in packages) {
  if (!require(package, character.only=T, quietly=T)) {
    install.packages(package)
    library(package, character.only=T)
  }
}
#===================
# Load Data
#===================

forecast_df <- read_excel("Forecast Test Data - Senior BI Analyst.xlsx",sheet="Data")

#===================
# Aggregated forecast data visualization
#===================
forecast_overall_df <- forecast_df %>%
  group_by(Year, WeekNo) %>%
  dplyr::summarise(Turnover_total = sum(Turnover), 
            Profit_total = sum(Profit), 
            CustomerCount_total = sum(CustomerCount)) %>%
  select(Year, WeekNo, Turnover_total, Profit_total, CustomerCount_total)

forecast_turnover <- ggplot(forecast_overall_df, aes(x=as.factor(WeekNo), 
                                                           y=Turnover_total, 
                                                           group = as.factor(Year))) +
  geom_line(aes(color=Year)) +
  geom_point(aes(color=Year)) +
  theme_minimal() + scale_y_continuous(labels = comma) +
  ggtitle("Turnover trend")+
  xlab("Week #") + 
  ylab("Turnover") + scale_colour_discrete(name="Year")

forecast_turnover

forecast_Profit <- ggplot(forecast_overall_df, aes(x=as.factor(WeekNo), 
                                                   y=Profit_total, 
                                                   group = as.factor(Year))) +
  geom_line(aes(color=Year)) +
  geom_point(aes(color=Year)) +
  theme_minimal() + scale_y_continuous(labels = comma) +
  ggtitle("Profit trend")+
  xlab("Week #") + 
  ylab("Profit") + scale_colour_discrete(name="Year")

forecast_Profit

forecast_CustomerCount <- ggplot(forecast_overall_df, aes(x=as.factor(WeekNo), 
                                                          y=CustomerCount_total, 
                                                          group = as.factor(Year))) +
  geom_line(aes(color=Year)) +
  geom_point(aes(color=Year)) +
  theme_minimal() + scale_y_continuous(labels = comma) +
  ggtitle("CustomerCount trend")+
  xlab("Week #") + 
  ylab("CustomerCount") + scale_colour_discrete(name="Year")

forecast_CustomerCount

#==============
# Forecast modeling
#==============
forecast_aggregate <- forecast_df %>%
  group_by(Year, WeekNo, Website) %>%
  dplyr::summarise(Turnover_total = sum(Turnover), 
                   Profit_total = sum(Profit), 
                   CustomerCount_total = sum(CustomerCount)) %>%
  select(Year, WeekNo, Website, Turnover_total, Profit_total, CustomerCount_total)

# week num to month

#convert year + month + add first day

# convert to time series

# Visualize the time series (aggregate the info) 

#==============
# Overall
#==============
patient.xts <- xts(x = df$Patients, order.by = df$Arrival_date) 

# Turnover

# Profit

# Customer Count

#==============
# By website
#==============

# website 0

# Turnover

# Profit

# Customer Count


# website 1

# Turnover

# Profit

# Customer Count








