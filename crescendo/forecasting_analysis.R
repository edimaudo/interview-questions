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
# Aggregated forecast data visualization by WeekNo and Year
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
# Forecast data #USING MAPE
#==============
forecast_aggregate <- forecast_df %>%
  inner_join(week_info,by = "WeekNo") %>%
  inner_join(year_info,by = "Year") %>%
  group_by(YearNo, Month2, Website) %>%
  dplyr::summarise(Turnover_total = sum(Turnover), 
                   Profit_total = sum(Profit), 
                   CustomerCount_total = sum(CustomerCount)) %>%
  select(YearNo, Month2, Website, Turnover_total, Profit_total, CustomerCount_total)

forecast_aggregate$dateInfo <- paste(forecast_aggregate$YearNo,forecast_aggregate$Month2,sep="-") 
forecast_aggregate$dateInfo2 <- as.Date(paste(forecast_aggregate$dateInfo,"-01",sep=""))

models<- c("auto-exponential","auto-exponential",
           "auto-arima","auto-arima",
           "simple-exponential","simple-exponential",
           "double-exponential","double-exponential",
           "triple-exponential","triple-exponential",
           "tbat","tbat")

data<- c("Training set", 'Test set',
         "Training set", 'Test set',
         "Training set", 'Test set',
         "Training set", 'Test set',
         "Training set", 'Test set',
         "Training set", 'Test set')

frequencyInput <- 12
# set forecast horizon
forecast.horizon <- 10

#==============
# Overall Forecast modelling
#==============
forecast_aggregate_overall <- forecast_aggregate %>%
  group_by(dateInfo2) %>%
  dplyr::summarise(Turnover_total = sum(Turnover_total), 
                   Profit_total = sum(Profit_total), 
                   CustomerCount_total = sum(CustomerCount_total)) %>%
  select(dateInfo2, Turnover_total, Profit_total, CustomerCount_total)

#==============
# Turnover
#==============
# Visualization
turnover_plot <- ggplot(forecast_aggregate_overall, aes(x = dateInfo2, y = Turnover_total)) +
  geom_line() +
  scale_x_date(date_labels = "%Y", date_breaks = "1 year") +
  theme_minimal() + guides(scale = "none") + scale_y_continuous(labels = comma) +
  ggtitle("Yearly Turnover") + 
  xlab("Turnover") + 
  ylab("Year")
turnover_plot

turnover.xts <- xts(x = forecast_aggregate_overall$Turnover_total, 
                    order.by = forecast_aggregate_overall$dateInfo2) 
turnover.monthly <- apply.monthly(turnover.xts, mean) 
turnover.end <- floor(1*length(turnover.monthly)) 
turnover.data <- turnover.monthly[1:turnover.end,] 
turnover.start <- c(year (start(turnover.data)), month(start(turnover.data)))
turnover.end <- c(year(end(turnover.data)), month(end(turnover.data)))
turnover.data <- ts(as.numeric(turnover.data), start = turnover.start, 
                    end = turnover.end, frequency = frequencyInput) 

#Decompose the Time Series
turnover.data %>%
  decompose() %>%
  autoplot()

#Decompose the Time Series - multi season output
turnover.data %>%
  mstl() %>%
  autoplot()

# ACF
ggAcf(turnover.data)

# Forecast
turnover.data <- apply.weekly(turnover.xts, mean) 
turnover.end <- floor(0.8*length(turnover.data)) 
turnover.train <- turnover.data[1:turnover.end,] 
turnover.test <- turnover.data[(turnover.end+1):length(turnover.data),]
turnover.start <- c(year (start(turnover.train)), month(start(turnover.train)))
turnover.end <- c(year(end(turnover.train)), month(end(turnover.train)))
turnover.train <- ts(as.numeric(turnover.train), start = turnover.start, 
                     end = turnover.end, frequency = frequencyInput)
turnover.start <- c(year (start(turnover.test)), month(start(turnover.test)))
turnover.end <- c(year(end(turnover.test)), month(end(turnover.test)))
turnover.test <- ts(as.numeric(turnover.test), start = turnover.start, 
                    end = turnover.end, frequency = frequencyInput)

# models
auto_exp_model <- turnover.train %>% ets %>% forecast(h=forecast.horizon)
auto_arima_model <- turnover.train %>% auto.arima() %>% forecast(h=forecast.horizon)
simple_exp_model <- turnover.train %>% HoltWinters(beta=FALSE, gamma=FALSE) %>% 
  forecast(h=forecast.horizon)
double_exp_model <- turnover.train %>% HoltWinters(beta = TRUE, gamma=FALSE) %>% 
  forecast(h=forecast.horizon)
triple_exp_model <- turnover.train %>% HoltWinters(beta = TRUE, gamma = TRUE) %>% 
  forecast(h=forecast.horizon)
tbat_model <- turnover.train %>% tbats %>% forecast(h=forecast.horizon)

# forecast output
auto_exp_forecast <- as.data.frame(auto_exp_model$mean)
auto_arima_forecast <- as.data.frame(auto_arima_model$mean)
simple_exp_forecast <- as.data.frame(simple_exp_model$mean)
double_exp_forecast <- as.data.frame(double_exp_model$mean)
triple_exp_forecast <- as.data.frame(triple_exp_model$mean)
tbat_forecast <- as.data.frame(tbat_model$mean)

#model accuracy
auto_exp_accuracy <- as.data.frame(accuracy(auto_exp_model,turnover.test))
auto_arima_accuracy <- as.data.frame(accuracy(auto_arima_model ,turnover.test))
simple_exp_accuracy <- as.data.frame(accuracy(simple_exp_model ,turnover.test))
double_exp_accuracy <- as.data.frame(accuracy(double_exp_model ,turnover.test))
triple_exp_accuracy <- as.data.frame(accuracy(triple_exp_model ,turnover.test))
tbat_accuracy <- as.data.frame(accuracy(tbat_model ,turnover.test))

outputInfo <- rbind(auto_exp_accuracy,auto_arima_accuracy,
                    simple_exp_accuracy,double_exp_accuracy,
                    triple_exp_accuracy,tbat_accuracy) 

outputInfo <- cbind(models, data, outputInfo)

#next 12 month prediction
auto_exp_model %>% autoplot()
turnover_prediction <- auto_exp_forecast

#==============
# Profit
#==============
# Visualization
profit_plot <- ggplot(forecast_aggregate_overall, aes(x = dateInfo2, y = Profit_total)) +
  geom_line() +
  scale_x_date(date_labels = "%Y", date_breaks = "1 year") +
  theme_minimal() + guides(scale = "none") + scale_y_continuous(labels = comma) +
  ggtitle("Yearly Profit") + 
  xlab("Profit") + 
  ylab("Year")
profit_plot

profit.xts <- xts(x = forecast_aggregate_overall$Profit_total, 
                  order.by = forecast_aggregate_overall$dateInfo2) 
profit.monthly <- apply.monthly(profit.xts, mean) 
profit.end <- floor(1*length(profit.monthly)) 
profit.data <- profit.monthly[1:profit.end,] 
profit.start <- c(year (start(profit.data)), month(start(profit.data)))
profit.end <- c(year(end(profit.data)), month(end(profit.data)))
profit.data <- ts(as.numeric(profit.data), start = profit.start, 
                  end = profit.end, frequency = frequencyInput) 

#Decompose the Time Series
profit.data %>%
  decompose() %>%
  autoplot()

#Decompose the Time Series - multi season output
profit.data %>%
  mstl() %>%
  autoplot()

# ACF
ggAcf(profit.data)

# Forecast
profit.data <- apply.weekly(profit.xts, mean) 
profit.end <- floor(0.8*length(profit.data)) 
profit.train <- profit.data[1:profit.end,] 
profit.test <- profit.data[(profit.end+1):length(profit.data),]
profit.start <- c(year (start(profit.train)), month(start(profit.train)))
profit.end <- c(year(end(profit.train)), month(end(profit.train)))
profit.train <- ts(as.numeric(profit.train), start = profit.start, 
                   end = profit.end, frequency = frequencyInput)
profit.start <- c(year (start(profit.test)), month(start(profit.test)))
profit.end <- c(year(end(profit.test)), month(end(profit.test)))
profit.test <- ts(as.numeric(profit.test), start = profit.start, 
                  end = profit.end, frequency = frequencyInput)

# models
auto_exp_model <- profit.train %>% ets %>% forecast(h=forecast.horizon)
auto_arima_model <- profit.train %>% auto.arima() %>% forecast(h=forecast.horizon)
simple_exp_model <- profit.train %>% HoltWinters(beta=FALSE, gamma=FALSE) %>% 
  forecast(h=forecast.horizon)
double_exp_model <- profit.train %>% HoltWinters(beta = TRUE, gamma=FALSE) %>% 
  forecast(h=forecast.horizon)
triple_exp_model <- profit.train %>% HoltWinters(beta = TRUE, gamma = TRUE) %>% 
  forecast(h=forecast.horizon)
tbat_model <- profit.train %>% tbats %>% forecast(h=forecast.horizon)

# forecast output
auto_exp_forecast <- as.data.frame(auto_exp_model$mean)
auto_arima_forecast <- as.data.frame(auto_arima_model$mean)
simple_exp_forecast <- as.data.frame(simple_exp_model$mean)
double_exp_forecast <- as.data.frame(double_exp_model$mean)
triple_exp_forecast <- as.data.frame(triple_exp_model$mean)
tbat_forecast <- as.data.frame(tbat_model$mean)

#model accuracy
auto_exp_accuracy <- as.data.frame(accuracy(auto_exp_model,profit.test))
auto_arima_accuracy <- as.data.frame(accuracy(auto_arima_model ,profit.test))
simple_exp_accuracy <- as.data.frame(accuracy(simple_exp_model ,profit.test))
double_exp_accuracy <- as.data.frame(accuracy(double_exp_model ,profit.test))
triple_exp_accuracy <- as.data.frame(accuracy(triple_exp_model ,profit.test))
tbat_accuracy <- as.data.frame(accuracy(tbat_model ,profit.test))

outputInfo <- rbind(auto_exp_accuracy,auto_arima_accuracy,
                    simple_exp_accuracy,double_exp_accuracy,
                    triple_exp_accuracy,tbat_accuracy) 

outputInfo <- cbind(models, data, outputInfo)

#next 12 month prediction
simple_exp_model %>% autoplot()
profit_prediction <- simple_exp_forecast

#==============
# Customer Count
#==============

# Visualization
customercount_plot <- ggplot(forecast_aggregate_overall, aes(x = dateInfo2, y = CustomerCount_total)) +
  geom_line() +
  scale_x_date(date_labels = "%Y", date_breaks = "1 year") +
  theme_minimal() + guides(scale = "none") + scale_y_continuous(labels = comma) +
  ggtitle("Yearly Customers") + 
  xlab("Customers") + 
  ylab("Year")
customercount_plot

customercount.xts <- xts(x = forecast_aggregate_overall$CustomerCount_total, 
                         order.by = forecast_aggregate_overall$dateInfo2) 
customercount.monthly <- apply.monthly(customercount.xts, mean) 
customercount.end <- floor(1*length(customercount.monthly)) 
customercount.data <- customercount.monthly[1:customercount.end,] 
customercount.start <- c(year (start(customercount.data)), month(start(customercount.data)))
customercount.end <- c(year(end(customercount.data)), month(end(customercount.data)))
customercount.data <- ts(as.numeric(customercount.data), start = customercount.start, 
                         end = customercount.end, frequency = frequencyInput) 

#Decompose the Time Series
customercount.data %>%
  decompose() %>%
  autoplot()

#Decompose the Time Series - multi season output
customercount.data %>%
  mstl() %>%
  autoplot()

# ACF
ggAcf(customercount.data)

# Forecast
customercount.data <- apply.weekly(customercount.xts, mean) 
customercount.end <- floor(0.8*length(customercount.data)) 
customercount.train <- customercount.data[1:customercount.end,] 
customercount.test <- customercount.data[(customercount.end+1):length(customercount.data),]
customercount.start <- c(year (start(customercount.train)), month(start(customercount.train)))
customercount.end <- c(year(end(customercount.train)), month(end(customercount.train)))
customercount.train <- ts(as.numeric(customercount.train), start = customercount.start, 
                          end = customercount.end, frequency = frequencyInput)
customercount.start <- c(year (start(customercount.test)), month(start(customercount.test)))
customercount.end <- c(year(end(customercount.test)), month(end(customercount.test)))
customercount.test <- ts(as.numeric(customercount.test), start = customercount.start, 
                         end = customercount.end, frequency = frequencyInput)

# models
auto_exp_model <- customercount.train %>% ets %>% forecast(h=forecast.horizon)
auto_arima_model <- customercount.train %>% auto.arima() %>% forecast(h=forecast.horizon)
simple_exp_model <- customercount.train %>% HoltWinters(beta=FALSE, gamma=FALSE) %>% 
  forecast(h=forecast.horizon)
double_exp_model <- customercount.train %>% HoltWinters(beta = TRUE, gamma=FALSE) %>% 
  forecast(h=forecast.horizon)
triple_exp_model <- customercount.train %>% HoltWinters(beta = TRUE, gamma = TRUE) %>% 
  forecast(h=forecast.horizon)
tbat_model <- customercount.train %>% tbats %>% forecast(h=forecast.horizon)

# forecast output
auto_exp_forecast <- as.data.frame(auto_exp_model$mean)
auto_arima_forecast <- as.data.frame(auto_arima_model$mean)
simple_exp_forecast <- as.data.frame(simple_exp_model$mean)
double_exp_forecast <- as.data.frame(double_exp_model$mean)
triple_exp_forecast <- as.data.frame(triple_exp_model$mean)
tbat_forecast <- as.data.frame(tbat_model$mean)

#model accuracy
auto_exp_accuracy <- as.data.frame(accuracy(auto_exp_model,customercount.test))
auto_arima_accuracy <- as.data.frame(accuracy(auto_arima_model ,customercount.test))
simple_exp_accuracy <- as.data.frame(accuracy(simple_exp_model ,customercount.test))
double_exp_accuracy <- as.data.frame(accuracy(double_exp_model ,customercount.test))
triple_exp_accuracy <- as.data.frame(accuracy(triple_exp_model ,customercount.test))
tbat_accuracy <- as.data.frame(accuracy(tbat_model ,customercount.test))

outputInfo <- rbind(auto_exp_accuracy,auto_arima_accuracy,
                    simple_exp_accuracy,double_exp_accuracy,
                    triple_exp_accuracy,tbat_accuracy) 

outputInfo <- cbind(models, data, outputInfo)

#next 12 month prediction
auto_arima_model %>% autoplot()
customercount_prediction <- auto_arima_forecast





#==============
# By website
#==============

#================
# website 0
#================
forecast_aggregate_website0 <- forecast_aggregate %>%
  filter(Website == 0) %>%
  group_by(dateInfo2) %>%
  dplyr::summarise(Turnover_total = sum(Turnover_total), 
                   Profit_total = sum(Profit_total), 
                   CustomerCount_total = sum(CustomerCount_total)) %>%
  select(dateInfo2, Turnover_total, Profit_total, CustomerCount_total)

turnover.xts <- xts(x = forecast_aggregate_website0$Turnover_total, 
                    order.by = forecast_aggregate_website0$dateInfo2) 
# Forecast
turnover.data <- apply.weekly(turnover.xts, mean) 
turnover.end <- floor(0.8*length(turnover.data)) 
turnover.train <- turnover.data[1:turnover.end,] 
turnover.test <- turnover.data[(turnover.end+1):length(turnover.data),]
turnover.start <- c(year (start(turnover.train)), month(start(turnover.train)))
turnover.end <- c(year(end(turnover.train)), month(end(turnover.train)))
turnover.train <- ts(as.numeric(turnover.train), start = turnover.start, 
                     end = turnover.end, frequency = frequencyInput)
turnover.start <- c(year (start(turnover.test)), month(start(turnover.test)))
turnover.end <- c(year(end(turnover.test)), month(end(turnover.test)))
turnover.test <- ts(as.numeric(turnover.test), start = turnover.start, 
                    end = turnover.end, frequency = frequencyInput)

# models
auto_exp_model <- turnover.train %>% ets %>% forecast(h=forecast.horizon)
auto_arima_model <- turnover.train %>% auto.arima() %>% forecast(h=forecast.horizon)
simple_exp_model <- turnover.train %>% HoltWinters(beta=FALSE, gamma=FALSE) %>% 
  forecast(h=forecast.horizon)
double_exp_model <- turnover.train %>% HoltWinters(beta = TRUE, gamma=FALSE) %>% 
  forecast(h=forecast.horizon)
triple_exp_model <- turnover.train %>% HoltWinters(beta = TRUE, gamma = TRUE) %>% 
  forecast(h=forecast.horizon)
tbat_model <- turnover.train %>% tbats %>% forecast(h=forecast.horizon)

# forecast output
auto_exp_forecast <- as.data.frame(auto_exp_model$mean)
auto_arima_forecast <- as.data.frame(auto_arima_model$mean)
simple_exp_forecast <- as.data.frame(simple_exp_model$mean)
double_exp_forecast <- as.data.frame(double_exp_model$mean)
triple_exp_forecast <- as.data.frame(triple_exp_model$mean)
tbat_forecast <- as.data.frame(tbat_model$mean)

#model accuracy
auto_exp_accuracy <- as.data.frame(accuracy(auto_exp_model,turnover.test))
auto_arima_accuracy <- as.data.frame(accuracy(auto_arima_model ,turnover.test))
simple_exp_accuracy <- as.data.frame(accuracy(simple_exp_model ,turnover.test))
double_exp_accuracy <- as.data.frame(accuracy(double_exp_model ,turnover.test))
triple_exp_accuracy <- as.data.frame(accuracy(triple_exp_model ,turnover.test))
tbat_accuracy <- as.data.frame(accuracy(tbat_model ,turnover.test))

outputInfo <- rbind(auto_exp_accuracy,auto_arima_accuracy,
                    simple_exp_accuracy,double_exp_accuracy,
                    triple_exp_accuracy,tbat_accuracy) 

outputInfo <- cbind(models, data, outputInfo)

#next 12 month prediction
auto_exp_model %>% autoplot()
turnover_website0_prediction <- auto_exp_forecast

#==============
# Profit
#==============
profit.xts <- xts(x = forecast_aggregate_website0$Profit_total, 
                  order.by = forecast_aggregate_website0$dateInfo2) 

# Forecast
profit.data <- apply.weekly(profit.xts, mean) 
profit.end <- floor(0.8*length(profit.data)) 
profit.train <- profit.data[1:profit.end,] 
profit.test <- profit.data[(profit.end+1):length(profit.data),]
profit.start <- c(year (start(profit.train)), month(start(profit.train)))
profit.end <- c(year(end(profit.train)), month(end(profit.train)))
profit.train <- ts(as.numeric(profit.train), start = profit.start, 
                   end = profit.end, frequency = frequencyInput)
profit.start <- c(year (start(profit.test)), month(start(profit.test)))
profit.end <- c(year(end(profit.test)), month(end(profit.test)))
profit.test <- ts(as.numeric(profit.test), start = profit.start, 
                  end = profit.end, frequency = frequencyInput)

# models
auto_exp_model <- profit.train %>% ets %>% forecast(h=forecast.horizon)
auto_arima_model <- profit.train %>% auto.arima() %>% forecast(h=forecast.horizon)
simple_exp_model <- profit.train %>% HoltWinters(beta=FALSE, gamma=FALSE) %>% 
  forecast(h=forecast.horizon)
double_exp_model <- profit.train %>% HoltWinters(beta = TRUE, gamma=FALSE) %>% 
  forecast(h=forecast.horizon)
triple_exp_model <- profit.train %>% HoltWinters(beta = TRUE, gamma = TRUE) %>% 
  forecast(h=forecast.horizon)
tbat_model <- profit.train %>% tbats %>% forecast(h=forecast.horizon)

# forecast output
auto_exp_forecast <- as.data.frame(auto_exp_model$mean)
auto_arima_forecast <- as.data.frame(auto_arima_model$mean)
simple_exp_forecast <- as.data.frame(simple_exp_model$mean)
double_exp_forecast <- as.data.frame(double_exp_model$mean)
triple_exp_forecast <- as.data.frame(triple_exp_model$mean)
tbat_forecast <- as.data.frame(tbat_model$mean)

#model accuracy
auto_exp_accuracy <- as.data.frame(accuracy(auto_exp_model,profit.test))
auto_arima_accuracy <- as.data.frame(accuracy(auto_arima_model ,profit.test))
simple_exp_accuracy <- as.data.frame(accuracy(simple_exp_model ,profit.test))
double_exp_accuracy <- as.data.frame(accuracy(double_exp_model ,profit.test))
triple_exp_accuracy <- as.data.frame(accuracy(triple_exp_model ,profit.test))
tbat_accuracy <- as.data.frame(accuracy(tbat_model ,profit.test))

outputInfo <- rbind(auto_exp_accuracy,auto_arima_accuracy,
                    simple_exp_accuracy,double_exp_accuracy,
                    triple_exp_accuracy,tbat_accuracy) 

outputInfo <- cbind(models, data, outputInfo)

#next 12 month prediction
simple_exp_model %>% autoplot()
profit_website0_prediction <- simple_exp_forecast

#==============
# Customer Count
#==============
customercount.xts <- xts(x = forecast_aggregate_website0$CustomerCount_total, 
                         order.by = forecast_aggregate_website0$dateInfo2) 

# Forecast
customercount.data <- apply.weekly(customercount.xts, mean) 
customercount.end <- floor(0.8*length(customercount.data)) 
customercount.train <- customercount.data[1:customercount.end,] 
customercount.test <- customercount.data[(customercount.end+1):length(customercount.data),]
customercount.start <- c(year (start(customercount.train)), month(start(customercount.train)))
customercount.end <- c(year(end(customercount.train)), month(end(customercount.train)))
customercount.train <- ts(as.numeric(customercount.train), start = customercount.start, 
                          end = customercount.end, frequency = frequencyInput)
customercount.start <- c(year (start(customercount.test)), month(start(customercount.test)))
customercount.end <- c(year(end(customercount.test)), month(end(customercount.test)))
customercount.test <- ts(as.numeric(customercount.test), start = customercount.start, 
                         end = customercount.end, frequency = frequencyInput)

# models
auto_exp_model <- customercount.train %>% ets %>% forecast(h=forecast.horizon)
auto_arima_model <- customercount.train %>% auto.arima() %>% forecast(h=forecast.horizon)
simple_exp_model <- customercount.train %>% HoltWinters(beta=FALSE, gamma=FALSE) %>% 
  forecast(h=forecast.horizon)
double_exp_model <- customercount.train %>% HoltWinters(beta = TRUE, gamma=FALSE) %>% 
  forecast(h=forecast.horizon)
triple_exp_model <- customercount.train %>% HoltWinters(beta = TRUE, gamma = TRUE) %>% 
  forecast(h=forecast.horizon)
tbat_model <- customercount.train %>% tbats %>% forecast(h=forecast.horizon)

# forecast output
auto_exp_forecast <- as.data.frame(auto_exp_model$mean)
auto_arima_forecast <- as.data.frame(auto_arima_model$mean)
simple_exp_forecast <- as.data.frame(simple_exp_model$mean)
double_exp_forecast <- as.data.frame(double_exp_model$mean)
triple_exp_forecast <- as.data.frame(triple_exp_model$mean)
tbat_forecast <- as.data.frame(tbat_model$mean)

#model accuracy
auto_exp_accuracy <- as.data.frame(accuracy(auto_exp_model,customercount.test))
auto_arima_accuracy <- as.data.frame(accuracy(auto_arima_model ,customercount.test))
simple_exp_accuracy <- as.data.frame(accuracy(simple_exp_model ,customercount.test))
double_exp_accuracy <- as.data.frame(accuracy(double_exp_model ,customercount.test))
triple_exp_accuracy <- as.data.frame(accuracy(triple_exp_model ,customercount.test))
tbat_accuracy <- as.data.frame(accuracy(tbat_model ,customercount.test))

outputInfo <- rbind(auto_exp_accuracy,auto_arima_accuracy,
                    simple_exp_accuracy,double_exp_accuracy,
                    triple_exp_accuracy,tbat_accuracy) 

outputInfo <- cbind(models, data, outputInfo)

#next 12 month prediction
simple_exp_model %>% autoplot()
customercount_website0_prediction <- simple_exp_forecast

#================
# website 1
#================
forecast_aggregate_website1 <- forecast_aggregate %>%
  filter(Website == 1) %>%
  group_by(dateInfo2) %>%
  dplyr::summarise(Turnover_total = sum(Turnover_total), 
                   Profit_total = sum(Profit_total), 
                   CustomerCount_total = sum(CustomerCount_total)) %>%
  select(dateInfo2, Turnover_total, Profit_total, CustomerCount_total)

#============
#Turnover
#============
turnover.xts <- xts(x = forecast_aggregate_website1$Turnover_total, 
                    order.by = forecast_aggregate_website1$dateInfo2) 

# Forecast
turnover.data <- apply.weekly(turnover.xts, mean) 
turnover.end <- floor(0.8*length(turnover.data)) 
turnover.train <- turnover.data[1:turnover.end,] 
turnover.test <- turnover.data[(turnover.end+1):length(turnover.data),]
turnover.start <- c(year (start(turnover.train)), month(start(turnover.train)))
turnover.end <- c(year(end(turnover.train)), month(end(turnover.train)))
turnover.train <- ts(as.numeric(turnover.train), start = turnover.start, 
                     end = turnover.end, frequency = frequencyInput)
turnover.start <- c(year (start(turnover.test)), month(start(turnover.test)))
turnover.end <- c(year(end(turnover.test)), month(end(turnover.test)))
turnover.test <- ts(as.numeric(turnover.test), start = turnover.start, 
                    end = turnover.end, frequency = frequencyInput)

# models
auto_exp_model <- turnover.train %>% ets %>% forecast(h=forecast.horizon)
auto_arima_model <- turnover.train %>% auto.arima() %>% forecast(h=forecast.horizon)
simple_exp_model <- turnover.train %>% HoltWinters(beta=FALSE, gamma=FALSE) %>% 
  forecast(h=forecast.horizon)
double_exp_model <- turnover.train %>% HoltWinters(beta = TRUE, gamma=FALSE) %>% 
  forecast(h=forecast.horizon)
triple_exp_model <- turnover.train %>% HoltWinters(beta = TRUE, gamma = TRUE) %>% 
  forecast(h=forecast.horizon)
tbat_model <- turnover.train %>% tbats %>% forecast(h=forecast.horizon)

# forecast output
auto_exp_forecast <- as.data.frame(auto_exp_model$mean)
auto_arima_forecast <- as.data.frame(auto_arima_model$mean)
simple_exp_forecast <- as.data.frame(simple_exp_model$mean)
double_exp_forecast <- as.data.frame(double_exp_model$mean)
triple_exp_forecast <- as.data.frame(triple_exp_model$mean)
tbat_forecast <- as.data.frame(tbat_model$mean)

#model accuracy
auto_exp_accuracy <- as.data.frame(accuracy(auto_exp_model,turnover.test))
auto_arima_accuracy <- as.data.frame(accuracy(auto_arima_model ,turnover.test))
simple_exp_accuracy <- as.data.frame(accuracy(simple_exp_model ,turnover.test))
double_exp_accuracy <- as.data.frame(accuracy(double_exp_model ,turnover.test))
triple_exp_accuracy <- as.data.frame(accuracy(triple_exp_model ,turnover.test))
tbat_accuracy <- as.data.frame(accuracy(tbat_model ,turnover.test))

outputInfo <- rbind(auto_exp_accuracy,auto_arima_accuracy,
                    simple_exp_accuracy,double_exp_accuracy,
                    triple_exp_accuracy,tbat_accuracy) 

outputInfo <- cbind(models, data, outputInfo)

#next 12 month prediction
double_exp_model %>% autoplot()
turnover_website1_prediction <-double_exp_forecast

#==============
# Profit
#==============
profit.xts <- xts(x = forecast_aggregate_website1$Profit_total, 
                  order.by = forecast_aggregate_website1$dateInfo2) 

# Forecast
profit.data <- apply.weekly(profit.xts, mean) 
profit.end <- floor(0.8*length(profit.data)) 
profit.train <- profit.data[1:profit.end,] 
profit.test <- profit.data[(profit.end+1):length(profit.data),]
profit.start <- c(year (start(profit.train)), month(start(profit.train)))
profit.end <- c(year(end(profit.train)), month(end(profit.train)))
profit.train <- ts(as.numeric(profit.train), start = profit.start, 
                   end = profit.end, frequency = frequencyInput)
profit.start <- c(year (start(profit.test)), month(start(profit.test)))
profit.end <- c(year(end(profit.test)), month(end(profit.test)))
profit.test <- ts(as.numeric(profit.test), start = profit.start, 
                  end = profit.end, frequency = frequencyInput)

# models
auto_exp_model <- profit.train %>% ets %>% forecast(h=forecast.horizon)
auto_arima_model <- profit.train %>% auto.arima() %>% forecast(h=forecast.horizon)
simple_exp_model <- profit.train %>% HoltWinters(beta=FALSE, gamma=FALSE) %>% 
  forecast(h=forecast.horizon)
double_exp_model <- profit.train %>% HoltWinters(beta = TRUE, gamma=FALSE) %>% 
  forecast(h=forecast.horizon)
triple_exp_model <- profit.train %>% HoltWinters(beta = TRUE, gamma = TRUE) %>% 
  forecast(h=forecast.horizon)
tbat_model <- profit.train %>% tbats %>% forecast(h=forecast.horizon)

# forecast output
auto_exp_forecast <- as.data.frame(auto_exp_model$mean)
auto_arima_forecast <- as.data.frame(auto_arima_model$mean)
simple_exp_forecast <- as.data.frame(simple_exp_model$mean)
double_exp_forecast <- as.data.frame(double_exp_model$mean)
triple_exp_forecast <- as.data.frame(triple_exp_model$mean)
tbat_forecast <- as.data.frame(tbat_model$mean)

#model accuracy
auto_exp_accuracy <- as.data.frame(accuracy(auto_exp_model,profit.test))
auto_arima_accuracy <- as.data.frame(accuracy(auto_arima_model ,profit.test))
simple_exp_accuracy <- as.data.frame(accuracy(simple_exp_model ,profit.test))
double_exp_accuracy <- as.data.frame(accuracy(double_exp_model ,profit.test))
triple_exp_accuracy <- as.data.frame(accuracy(triple_exp_model ,profit.test))
tbat_accuracy <- as.data.frame(accuracy(tbat_model ,profit.test))

outputInfo <- rbind(auto_exp_accuracy,auto_arima_accuracy,
                    simple_exp_accuracy,double_exp_accuracy,
                    triple_exp_accuracy,tbat_accuracy) 

outputInfo <- cbind(models, data, outputInfo)

#next 12 month prediction
triple_exp_model %>% autoplot()
profit_website1_prediction <- triple_exp_forecast

#==============
# Customer Count
#==============
customercount.xts <- xts(x = forecast_aggregate_website1$CustomerCount_total, 
                         order.by = forecast_aggregate_website1$dateInfo2) 

# Forecast
customercount.data <- apply.weekly(customercount.xts, mean) 
customercount.end <- floor(0.8*length(customercount.data)) 
customercount.train <- customercount.data[1:customercount.end,] 
customercount.test <- customercount.data[(customercount.end+1):length(customercount.data),]
customercount.start <- c(year (start(customercount.train)), month(start(customercount.train)))
customercount.end <- c(year(end(customercount.train)), month(end(customercount.train)))
customercount.train <- ts(as.numeric(customercount.train), start = customercount.start, 
                          end = customercount.end, frequency = frequencyInput)
customercount.start <- c(year (start(customercount.test)), month(start(customercount.test)))
customercount.end <- c(year(end(customercount.test)), month(end(customercount.test)))
customercount.test <- ts(as.numeric(customercount.test), start = customercount.start, 
                         end = customercount.end, frequency = frequencyInput)

# models
auto_exp_model <- customercount.train %>% ets %>% forecast(h=forecast.horizon)
auto_arima_model <- customercount.train %>% auto.arima() %>% forecast(h=forecast.horizon)
simple_exp_model <- customercount.train %>% HoltWinters(beta=FALSE, gamma=FALSE) %>% 
  forecast(h=forecast.horizon)
double_exp_model <- customercount.train %>% HoltWinters(beta = TRUE, gamma=FALSE) %>% 
  forecast(h=forecast.horizon)
triple_exp_model <- customercount.train %>% HoltWinters(beta = TRUE, gamma = TRUE) %>% 
  forecast(h=forecast.horizon)
tbat_model <- customercount.train %>% tbats %>% forecast(h=forecast.horizon)

# forecast output
auto_exp_forecast <- as.data.frame(auto_exp_model$mean)
auto_arima_forecast <- as.data.frame(auto_arima_model$mean)
simple_exp_forecast <- as.data.frame(simple_exp_model$mean)
double_exp_forecast <- as.data.frame(double_exp_model$mean)
triple_exp_forecast <- as.data.frame(triple_exp_model$mean)
tbat_forecast <- as.data.frame(tbat_model$mean)

#model accuracy
auto_exp_accuracy <- as.data.frame(accuracy(auto_exp_model,customercount.test))
auto_arima_accuracy <- as.data.frame(accuracy(auto_arima_model ,customercount.test))
simple_exp_accuracy <- as.data.frame(accuracy(simple_exp_model ,customercount.test))
double_exp_accuracy <- as.data.frame(accuracy(double_exp_model ,customercount.test))
triple_exp_accuracy <- as.data.frame(accuracy(triple_exp_model ,customercount.test))
tbat_accuracy <- as.data.frame(accuracy(tbat_model ,customercount.test))

outputInfo <- rbind(auto_exp_accuracy,auto_arima_accuracy,
                    simple_exp_accuracy,double_exp_accuracy,
                    triple_exp_accuracy,tbat_accuracy) 

outputInfo <- cbind(models, data, outputInfo)

#next 12 month prediction
triple_exp_model %>% autoplot()
customercount_website1_prediction <- triple_exp_forecast













