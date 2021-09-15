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

# Visualize the time series (aggregate the info) 

# Overall
forecast_overall_df <- forecast_df %>%
  group_by(Year, WeekNo) %>%
  summarise(Turnover_total = sum(Turnover), 
            Profit_total = sum(Profit), 
            CustomerCount_total = sum(CustomerCount)) %>%
  select(Year, WeekNo, Turnover, Profit_Total, CustomerCount_total)
  


# By website

# Option 1 - no change in Data
#- overall forecast for next 12 months

# Forecast by website for next 12 months



# Option 2 convert to time series data 
# overall forecast for next 12 months

# Forecast by website for next 12 months






#Forecasting using different techniques
#Overall forecast
#- Forecast by year
#- Forecast by month

#Forecast by website
#- Forecast by year
#- Forecast by month