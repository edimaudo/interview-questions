#===================
## Load Libraries
#===================
rm(list = ls()) #clear environment

# libraries
packages <- c('ggplot2', 'corrplot','tidyverse',"caret","dummies","fastDummies"
              ,'FactoMineR','factoextra','scales','dplyr','mlbench','caTools',
              'grid','gridExtra','doParallel','readxl')
# load packages
for (package in packages) {
  if (!require(package, character.only=T, quietly=T)) {
    install.packages(package)
    library(package, character.only=T)
  }
}


parent <- read_excel("Home Assignment.xlsx","Parent Data")
child <- read_excel("Home Assignment.xlsx","Child Data")

# Preview parent
glimpse(parent)

# Summary of parent
summary(parent)

# Preview child
glimpse(child)

# Summary of child
summary(child)

# overall information

# Parents
# Number of parents/users
parent_count <- length(unique(parent$member_id))

#registration status
parent_registration <- length(unique(parent$registration_status))

#amount 

parent_df <- parent %>%
  select(member_id, cnt_user_login, trxn_amt, deposit_cnt, transfer_cnt, deposit_amt, transfer_amt)

#convert NA to 0s
parent_df[is.na(parent_df)] <- 0


# - toal transaction amount
parent_transaction_total <- sum(parent_df$trxn_amt)
# - total depoist count
parent_deposit_count_total <- sum(parent_df$deposit_cnt)
# - total transfer count
parent_transfer_count_total <- sum(parent_df$transfer_cnt)
# - deposit amount
parent_deposit_amount_total <- sum(parent_df$deposit_amt)
# - transfer amount
parent_transfer_amountt_total <- sum(parent_df$transfer_amt)

#correlations

#Child
# Number of child/ussers
# - total login amount count
# - transaction amount
# - total purchase count
# - total receive count
# - total purchase amount
# - total receive amount

# Avg parent to child ratio if needed


#Assumption
#- Data provided is a snapshot so state like analysis like conversion will not be looked at


# trends

#Child 
# - Monthly trends using 6 different measures with group by year
#g#rid.arrange(plot1, plot2, ncol=2)

#RFM Model

#Parent
#- Monthly trends using 6 different measures with group by year
#RFM Model
# Parents