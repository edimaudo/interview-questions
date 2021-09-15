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

# Convert Year-XX to Numerical data
#  Generate Year-month and pick first day to convert to date
# Generate view 

# Visualize the time series (aggregate the info) 
#- overall
#- sports
#- website

#Forecasting using different techniques
#Overall forecast
#- Forecast by year
#- Forecast by month

#Forecast by website
#- Forecast by year
#- Forecast by month