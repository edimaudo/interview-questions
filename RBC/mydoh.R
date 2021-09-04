#===================
## Load Libraries
#===================
rm(list = ls()) #clear environment

# libraries
packages <- c('ggplot2', 'corrplot','tidyverse',"caret","dummies","fastDummies"
              ,'FactoMineR','factoextra','scales','dplyr','mlbench','caTools',
              'grid','gridExtra','doParallel','readxl','lubridate')
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

#=================
# Overall
#=================

# Parents
# Number of parents/users
parent_count <- length(unique(parent$member_id))
# registration status
parent_registration <- length(unique(parent$registration_status))
# numerical information
parent_df <- parent %>%
  select(member_id, cnt_user_login, trxn_amt, deposit_cnt, transfer_cnt, deposit_amt, transfer_amt)
# convert NA to 0s
parent_df[is.na(parent_df)] <- 0
# login count
parent_login_count <- sum(parent_df$cnt_user_login)
# - transaction amount
parent_transaction_total <- sum(parent_df$trxn_amt)
# - deposit count
parent_deposit_count_total <- sum(parent_df$deposit_cnt)
# - total transfer count
parent_transfer_count_total <- sum(parent_df$transfer_cnt)
# - deposit amount
parent_deposit_amount_total <- sum(parent_df$deposit_amt)
# - transfer amount
parent_transfer_amountt_total <- sum(parent_df$transfer_amt)

# correlation of parent information
correlationMatrix <- cor(parent_df[,c(-1)])
corrplot(correlationMatrix,method='number', bg='#676767')
# # summarize the correlation matrix
print(correlationMatrix)

#Child
# Number of child/users
child_count <- length(unique(child$member_id))
# numerical information
child_df <- child %>%
  select(member_id, cnt_user_login, trxn_amt, purchase_cnt, receive_cnt, purchase_amt, receive_amt)
# convert NA to 0s
child_df[is.na(child_df)] <- 0
# total login
child_login_count <- sum(child_df$cnt_user_login)
# transaction amount
child_transaction_total <- sum(child_df$trxn_amt)
# purchase count
child_purchase_count_total <- sum(child_df$purchase_cnt)
# receive count
child_receive_count_total <- sum(child_df$receive_cnt)
# purchase amount
child_purchase_amount_total <- sum(child_df$purchase_amt)
# receive amount
child_receive_amount_total <- sum(child_df$receive_amt)

# child correlation 
correlationMatrix <- cor(child_df[,c(-1)])
corrplot(correlationMatrix,method='number',bg='#676767')
# # summarize the correlation matrix
print(correlationMatrix)

#=================
# Trends
#=================
# Parent 


# Child 
# - Monthly trends using 6 different measures with group by year


#g#rid.arrange(plot1, plot2, ncol=2)

#=================
#RFM Model
#=================

# Parent


# Child