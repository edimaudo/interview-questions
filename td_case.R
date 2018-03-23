#transaction analysis
#goal is to calculate 3day average transaction for each client-transaction

#remove old data
rm(list=ls())

#libraries
library(dplyr)

#create data
client_id <- as.integer(c(1,1,1,1,1,2,2,2))
transaction_date <- c('03/01/2018','03/02/2018','03/03/2018','03/05/2018','03/10/2018',
                      '03/05/2018','03/06/2018','03/30/2018')
transaction_amount <- as.numeric(c(30,60,90,120,80,30,80,60))
transaction_month <- as.integer(month(as.POSIXlt(transaction_date, format="%m/%d/%Y")))
transaction_day <- as.integer(day(as.POSIXlt(transaction_date, format="%m/%d/%Y")))

#combine columns
transactions <- cbind(client_id, transaction_date, transaction_amount, transaction_day,
                      transaction_month)

#convert to dataframe
transactions <- as.data.frame(transactions)

#update columns
transactions$transaction_day <- as.integer(as.character((transactions$transaction_day)))
transactions$transaction_amount <- as.integer(as.character((transactions$transaction_amount)))


#get unique client numbers
client_info_id <- c(unique(transactions$client_id))

#function to get average 3 day
update_avg <- function(df){
  
  day_avg = list() #store averages
  
  for (row in 1:nrow(df)){
    
    rowdata <- as.data.frame(df[row,])
    rowdata_clientid <- as.integer(rowdata$client_id)
    rowdata_day <- as.integer(as.numeric(as.character(rowdata$transaction_day)))
    
    if (rowdata_day > 3){
      
      day1back = rowdata_day - 1
      day2back = rowdata_day - 2
      day3back = rowdata_day - 3
      
      count = 0
      amount = 0
      average_amount = 0
      
      amount1 <- tempinfo %>%
        filter(day1back %in% tempinfo$transaction_day)%>%
        select(transaction_amount)
      amount2 <- tempinfo %>%
        filter(day2back %in% tempinfo$transaction_day)%>%
        select(transaction_amount)
      amount3 <- tempinfo %>%
        filter(day3back %in% tempinfo$transaction_day)%>%
        select(transaction_amount)
      
      day1back_amount <- as.integer(as.character(amount1$transaction_amount))
      day2back_amount <- as.integer(as.character(amount2$transaction_amount))
      day3back_amount <- as.integer(as.character(amount3$transaction_amount))
      
      if (length(day1back_amount) > 0 ){
        amount = amount + day1back_amount
        count = count + 1
      }
      
      if (length(day2back_amount) > 0 ){
        amount = amount + day2back_amount
        count = count + 1
      }
      
      if (length(day3back_amount) > 0 ){
        amount = amount + day3back_amount
        count = count + 1
      }
      
      if (length(amount/count) <= 0){
        day_avg[row] <- 0
      } else {
        day_avg[row] <- amount/count
      }
      
    } else {
      day_avg[row] <- "N/A"
    }
  }
  
  return (day_avg)
}


#list to hold output
three_day_avg <- list()

for (id in 1:length(client_info_id)){
  clientid <- as.numeric(as.character(client_info_id[id]))
  temp <- transactions
  tempinfo <- temp %>%
    filter(as.integer(temp$client_id) == as.integer(clientid))
  three_day_avg <- append(three_day_avg,update_avg(tempinfo),length(three_day_avg))
}

three_day_avg <- unlist(three_day_avg)

transactions <- cbind(transactions,three_day_avg)





