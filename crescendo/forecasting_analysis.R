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
year_info <- read_excel("Forecast Test Data - Senior BI Analyst.xlsx",sheet="YearInfo")
week_info <- read_excel("Forecast Test Data - Senior BI Analyst.xlsx",sheet="WeekInfo")

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
# Forecast modelling
#==============
forecast_aggregate <- forecast_df %>%
  inner_join(week_info,by = "WeekNo") %>%
  inner_join(year_info,by = "Year") %>%
  group_by(YearNo, Month, Website) %>%
  dplyr::summarise(Turnover_total = sum(Turnover), 
                   Profit_total = sum(Profit), 
                   CustomerCount_total = sum(CustomerCount)) %>%
  select(YearNo, Month, Website, Turnover_total, Profit_total, CustomerCount_total)




# Visualize the time series (aggregate the info) 

#==============
# Overall
#==============
patient.xts <- xts(x = df$Patients, order.by = df$Arrival_date) 
patient.end <- floor(1*length(patient.monthly)) 
patient.data <- ppatient.monthly[1:patient.end,] 
patient.start <- c(year (start(patient.data)), month(start(patient.data)))
patient.end <- c(year(end(patient.data)), month(end(patient.data)))
patient.data <- ts(as.numeric(patient.data), start = patient.start, 
                   end = patient.end, frequency = as.numeric(input$frequencyInput)) 

#Decompose the Time Series
patient.data %>%
  decompose() %>%
  autoplot()


#Decompose the Time Series - multi season output
patient.data %>%
  mstl() %>%
  autoplot()

# ACF
ggAcf(patient.data)


patient.data <- apply.weekly(patient.xts, mean) 
patient.end <- floor(as.numeric(input$traintestInput)*length(patient.data)) 
patient.train <- patient.data[1:patient.end,] 
patient.test <- patient.data[(patient.end+1):length(patient.data),]
patient.start <- c(year (start(patient.train)), month(start(patient.train)))
patient.end <- c(year(end(patient.train)), month(end(patient.train)))
patient.train <- ts(as.numeric(patient.train), start = patient.start, 
                    end = patient.end, frequency = as.numeric(input$frequencyInput) )
patient.start <- c(year (start(patient.test)), month(start(patient.test)))
patient.end <- c(year(end(patient.test)), month(end(patient.test)))
patient.test <- ts(as.numeric(patient.test), start = patient.start, 
                   end = patient.end, frequency = as.numeric(input$frequencyInput))

# set forecast horizon
forecast.horizon <- 10 #as.numeric(input$horizonInput) #horizon_info <- c(1:50)

# models
auto_exp_model <- patient.train %>% ets %>% forecast(h=forecast.horizon)
#patient_train_auto_exp_forecast <- ets(patient.train) %>% 
#  forecast(h=forecast.horizon) 

auto_arima_model <- patient.train %>% auto.arima() %>% forecast(h=forecast.horizon)
simple_exp_model <- patient.train %>% HoltWinters(beta=FALSE, gamma=FALSE) %>% 
  forecast(h=forecast.horizon)
double_exp_model <- patient.train %>% HoltWinters(beta = TRUE, gamma=FALSE) %>% 
  forecast(h=forecast.horizon)
triple_exp_model <- patient.train %>% HoltWinters(beta = TRUE, gamma = TRUE) %>% 
  forecast(h=forecast.horizon)
tbat_model <- patient.train %>% tbats %>% forecast(h=forecast.horizon)

# forecast output
auto_exp_forecast <- as.data.frame(patient_train_auto_exp_forecast$mean)
auto_arima_forecast <- as.data.frame(patient_train_auto_arima_forecast$mean)
simple_exp_forecast <- as.data.frame(patient_train_simple_exp_forecast$mean)
double_exp_forecast <- as.data.frame(patient_train_double_exp_forecast$mean)
triple_exp_forecast <- as.data.frame(patient_train_triple_exp_forecast$mean)
tbat_forecast <- as.data.frame(patient_train_tbat_forecast$mean)
manual_arima_forecast <- as.data.frame(patient_train_manual_forecast$mean)

#model accuracy
auto_exp_accuracy <- as.data.frame(accuracy(patient_train_auto_exp_forecast ,patient.test))
auto_arima_accuracy <- as.data.frame(accuracy(patient_train_auto_arima_forecast ,patient.test))
simple_exp_accuracy <- as.data.frame(accuracy(patient_train_simple_exp_forecast ,patient.test))
double_exp_accuracy <- as.data.frame(accuracy(patient_train_double_exp_forecast ,patient.test))
triple_exp_accuracy <- as.data.frame(accuracy(patient_train_triple_exp_forecast ,patient.test))
tbat_accuracy <- as.data.frame(accuracy(patient_train_tbat_forecast ,patient.test))

models<- c("auto-exponential","auto-exponential",
           "auto-arima","auto-arima",
           "simple-exponential","simple-exponential",
           "double-exponential","double-exponential",
           "triple-exponential","triple-exponential",
           "tbat","tbat",
           "manual-arima","manual-arima")

data<- c("Training set", 'Test set',
         "Training set", 'Test set',
         "Training set", 'Test set',
         "Training set", 'Test set',
         "Training set", 'Test set',
         "Training set", 'Test set',
         "Training set", 'Test set')

outputInfo <- rbind(auto_exp_accuracy,auto_arima_accuracy,
                    simple_exp_accuracy,double_exp_accuracy,
                    triple_exp_accuracy,tbat_accuracy,manual_accuracy) 

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








