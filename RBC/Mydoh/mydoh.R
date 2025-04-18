#===================
## Load Libraries
#===================
rm(list = ls()) #clear environment

# libraries
packages <- c('ggplot2', 'corrplot','tidyverse',"caret","dummies","fastDummies"
              ,'FactoMineR','factoextra','scales','dplyr','mlbench','caTools',
              'grid','gridExtra','doParallel','readxl','lubridate',
              'scales','rfm')
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

# Parent 
parent$onboarded_mth_year <- lubridate::year(parent$onboarded_mth)
parent$onboarded_mth_month <- lubridate::month(parent$onboarded_mth)
parent$onboarded_mth_month_year <- format(as.Date(parent$onboarded_mth), "%Y-%m")

child$onboarded_mth_year <- lubridate::year(child$onboarded_mth)
child$onboarded_mth_month <- lubridate::month(child$onboarded_mth)
child$onboarded_mth_month_year <- format(as.Date(child$onboarded_mth), "%Y-%m")

#=================
# Parent Trends
#=================
parent_df <- parent %>%
  filter(!is.na(onboarded_mth_year)) %>%
  select(member_id, cnt_user_login, trxn_amt, deposit_cnt, transfer_cnt, deposit_amt, transfer_amt,
         onboarded_mth_year,onboarded_mth_month, onboarded_mth_month_year)
# convert NA to 0s
parent_df[is.na(parent_df)] <- 0
parent_df$onboarded_mth_year <- as.factor(parent_df$onboarded_mth_year)
parent_df$onboarded_mth_month <- as.factor(parent_df$onboarded_mth_month)

# Parent Visualization
# parent login count visualization
parent_df_login_count <- parent_df %>%
  group_by(onboarded_mth_year,onboarded_mth_month) %>%
  summarise(total_login_count = sum(cnt_user_login)) %>%
  select(onboarded_mth_year,onboarded_mth_month,total_login_count)

parent_df_login_count <- ggplot(parent_df_login_count, aes(x=as.factor(onboarded_mth_month), 
                                                           y=total_login_count, 
                                                           group = as.factor(onboarded_mth_year))) +
  geom_line(aes(color=onboarded_mth_year)) +
  geom_point(aes(color=onboarded_mth_year)) +
  theme_minimal() +
  ggtitle("Parent Total Login Count")+
  xlab("Month #") + 
  ylab("Login Count") + scale_colour_discrete(name="Year")
#parent_df_login_count 

# Parent transaction amount
parent_df_trxn_amt  <- parent_df %>%
  group_by(onboarded_mth_year,onboarded_mth_month) %>%
  summarise(total_trxn_amt = sum(trxn_amt)) %>%
  select(onboarded_mth_year,onboarded_mth_month,total_trxn_amt)

parent_df_trxn_amt  <- ggplot(parent_df_trxn_amt, aes(x=as.factor(onboarded_mth_month), 
                                                           y=total_trxn_amt, 
                                                           group = as.factor(onboarded_mth_year))) +
  geom_line(aes(color=onboarded_mth_year)) +
  geom_point(aes(color=onboarded_mth_year)) +
  theme_minimal() +
  ggtitle("Parent Total Transaction Amount")+
  xlab("Month #") + 
  ylab("Ttansaction Amount") + scale_colour_discrete(name="Year")
#parent_df_trxn_amt 

# Parent deposit count
parent_df_deposit_count  <- parent_df %>%
  group_by(onboarded_mth_year,onboarded_mth_month) %>%
  summarise(total_deposit_count = sum(deposit_cnt)) %>%
  select(onboarded_mth_year,onboarded_mth_month,total_deposit_count )

parent_df_deposit_count   <- ggplot(parent_df_deposit_count , aes(x=as.factor(onboarded_mth_month), 
                                                      y=total_deposit_count , 
                                                      group = as.factor(onboarded_mth_year))) +
  geom_line(aes(color=onboarded_mth_year)) +
  geom_point(aes(color=onboarded_mth_year)) +
  theme_minimal() +
  ggtitle("Parent Total Deposit Count")+
  xlab("Month #") + 
  ylab("Deposit Count") + scale_colour_discrete(name="Year")
#parent_df_deposit_count 

# Parent transfer count
parent_df_transfer_count  <- parent_df %>%
  group_by(onboarded_mth_year,onboarded_mth_month) %>%
  summarise(total_transfer_count = sum(transfer_cnt)) %>%
  select(onboarded_mth_year,onboarded_mth_month,total_transfer_count)

parent_df_transfer_count  <- ggplot(parent_df_transfer_count, aes(x=as.factor(onboarded_mth_month), 
                                                                  y=total_transfer_count , 
                                                                  group = as.factor(onboarded_mth_year))) +
  geom_line(aes(color=onboarded_mth_year)) +
  geom_point(aes(color=onboarded_mth_year)) +
  theme_minimal() +
  ggtitle("Parent Total Transfer Count")+
  xlab("Month #") + 
  ylab("Transfer Count") + scale_colour_discrete(name="Year")
#parent_df_transfer_count

# Parent deposit amount
parent_df_deposit_amount <- parent_df %>%
  group_by(onboarded_mth_year,onboarded_mth_month) %>%
  summarise(total_deposit_amount = sum(deposit_amt)) %>%
  select(onboarded_mth_year,onboarded_mth_month,total_deposit_amount)

parent_df_deposit_amount  <- ggplot(parent_df_deposit_amount , 
                                    aes(x=as.factor(onboarded_mth_month), 
                                                y=total_deposit_amount, 
                                                group = as.factor(onboarded_mth_year))) +
  geom_line(aes(color=onboarded_mth_year)) +
  geom_point(aes(color=onboarded_mth_year)) +
  theme_minimal() +
  ggtitle("Parent Total Deposit Amount")+
  xlab("Month #") + 
  ylab("Deposit Amount") + scale_colour_discrete(name="Year")
#parent_df_deposit_amount 

# Parent transfer amount
parent_df_transfer_amount <- parent_df %>%
  group_by(onboarded_mth_year,onboarded_mth_month) %>%
  summarise(total_transfer_amount = sum(transfer_amt)) %>%
  select(onboarded_mth_year,onboarded_mth_month,total_transfer_amount)

parent_df_transfer_amount  <- ggplot(parent_df_transfer_amount , 
                                     aes(x=as.factor(onboarded_mth_month), 
                                      y=total_transfer_amount, 
                                      group = as.factor(onboarded_mth_year))) +
  geom_line(aes(color=onboarded_mth_year)) +
  geom_point(aes(color=onboarded_mth_year)) +
  theme_minimal() +
  ggtitle("Parent Total Transfer Amount")+
  xlab("Month #") + 
  ylab("Trasnfer Amount") + scale_colour_discrete(name="Year")
#parent_df_transfer_amount 

# combine parent visualization
grid.arrange(parent_df_trxn_amt, parent_df_transfer_count,parent_df_transfer_amount,
            parent_df_deposit_count, parent_df_deposit_amount,
             parent_df_login_count, ncol=3, nrow=2)


#=================
# Child Trends
#=================
child_df <- child  %>%
  filter(!is.na(onboarded_mth_year)) %>%
  select(member_id, cnt_user_login, trxn_amt, purchase_cnt, receive_cnt, purchase_amt, receive_amt,
         onboarded_mth_year,onboarded_mth_month, onboarded_mth_month_year)
# convert NA to 0s
child_df[is.na(child_df)] <- 0
child_df$onboarded_mth_year <- as.factor(child_df$onboarded_mth_year)
child_df$onboarded_mth_month <- as.factor(child_df$onboarded_mth_month)

# Child user logn count
child_df_login <- child_df %>%
  group_by(onboarded_mth_year,onboarded_mth_month) %>%
  summarise(total_login_amount = sum(cnt_user_login)) %>%
  select(onboarded_mth_year,onboarded_mth_month,total_login_amount)

child_df_login<- ggplot(child_df_login  , 
                                     aes(x=as.factor(onboarded_mth_month), 
                                         y=total_login_amount, 
                                         group = as.factor(onboarded_mth_year))) +
  geom_line(aes(color=onboarded_mth_year)) +
  geom_point(aes(color=onboarded_mth_year)) +
  theme_minimal() +
  ggtitle("Child Total Login Count")+
  xlab("Month #") + 
  ylab("Login Amount") + scale_colour_discrete(name="Year")

# Child Transaction amount
child_df_transaction_amount <- child_df %>%
  group_by(onboarded_mth_year,onboarded_mth_month) %>%
  summarise(total_transaction_amount = sum(trxn_amt)) %>%
  select(onboarded_mth_year,onboarded_mth_month,total_transaction_amount)

child_df_transaction_amount <- ggplot(child_df_transaction_amount  , 
                        aes(x=as.factor(onboarded_mth_month), 
                            y=total_transaction_amount, 
                            group = as.factor(onboarded_mth_year))) +
  geom_line(aes(color=onboarded_mth_year)) +
  geom_point(aes(color=onboarded_mth_year)) +
  theme_minimal() +
  ggtitle("Child Total Transaction Amount")+
  xlab("Month #") + 
  ylab("Transaction Amount") + scale_colour_discrete(name="Year")


# Child Purchase Count
child_df_Purchase_count <- child_df %>%
  group_by(onboarded_mth_year,onboarded_mth_month) %>%
  summarise(total_purchase_count = sum(purchase_cnt)) %>%
  select(onboarded_mth_year,onboarded_mth_month,total_purchase_count)

child_df_Purchase_count<- ggplot(child_df_Purchase_count  , 
                                aes(x=as.factor(onboarded_mth_month), 
                                    y=total_purchase_count, 
                                    group = as.factor(onboarded_mth_year))) +
  geom_line(aes(color=onboarded_mth_year)) +
  geom_point(aes(color=onboarded_mth_year)) +
  theme_minimal() +
  ggtitle("Child Total Purchase Count")+
  xlab("Month #") + 
  ylab("Purchase Count") + scale_colour_discrete(name="Year")

# Child Purchase Amount
child_df_Purchase_amount <- child_df %>%
  group_by(onboarded_mth_year,onboarded_mth_month) %>%
  summarise(total_purchase_amount = sum(purchase_amt)) %>%
  select(onboarded_mth_year,onboarded_mth_month,total_purchase_amount)

child_df_Purchase_amount<- ggplot(child_df_Purchase_amount  , 
                                  aes(x=as.factor(onboarded_mth_month), 
                                      y=total_purchase_amount, 
                                      group = as.factor(onboarded_mth_year))) +
  geom_line(aes(color=onboarded_mth_year)) +
  geom_point(aes(color=onboarded_mth_year)) +
  theme_minimal() +
  ggtitle("Child Total Purchase Amount")+
  xlab("Month #") + 
  ylab("Purchase Amount") + scale_colour_discrete(name="Year")

# Child Receive Count
child_df_Receive_count <- child_df %>%
  group_by(onboarded_mth_year,onboarded_mth_month) %>%
  summarise(total_receive_count = sum(receive_cnt)) %>%
  select(onboarded_mth_year,onboarded_mth_month,total_receive_count)

child_df_Receive_count<- ggplot(child_df_Receive_count  , 
                                 aes(x=as.factor(onboarded_mth_month), 
                                     y=total_receive_count, 
                                     group = as.factor(onboarded_mth_year))) +
  geom_line(aes(color=onboarded_mth_year)) +
  geom_point(aes(color=onboarded_mth_year)) +
  theme_minimal() +
  ggtitle("Child Total Receive Count")+
  xlab("Month #") + 
  ylab("Receive Count") + scale_colour_discrete(name="Year")

# Child Receive Amount
child_df_Receive_amount <- child_df %>%
  group_by(onboarded_mth_year,onboarded_mth_month) %>%
  summarise(total_receive_amount = sum(receive_amt)) %>%
  select(onboarded_mth_year,onboarded_mth_month,total_receive_amount)

child_df_Receive_amount<- ggplot(child_df_Receive_amount  , 
                                      aes(x=as.factor(onboarded_mth_month), 
                                          y=total_receive_amount, 
                                          group = as.factor(onboarded_mth_year))) +
  geom_line(aes(color=onboarded_mth_year)) +
  geom_point(aes(color=onboarded_mth_year)) +
  theme_minimal() +
  ggtitle("Child Total Receive Amount")+
  xlab("Month #") + 
  ylab("Receive Amount") + scale_colour_discrete(name="Year")


# Child 
grid.arrange(child_df_login,
             child_df_transaction_amount, 
             child_df_Purchase_count,child_df_Purchase_amount,
             child_df_Receive_count,child_df_Receive_amount,
             ncol=3, nrow=2)

#=================
#RFM Model
#=================
# Parent
parent_df2 <- parent %>%
  filter(!is.na(onboarded_mth_year)) %>%
  select(member_id, trxn_amt, onboarded_mth)
# convert NA to 0s
parent_df2[is.na(parent_df2)] <- 0

#update date
parent_df2$onboarded_mth <- as.Date(parent_df2$onboarded_mth)

analysis_date <- lubridate::as_date("2021-09-01")
report <- rfm::rfm_table_order(parent_df2, member_id,onboarded_mth,trxn_amt, analysis_date)

#segment
segment_names <- c("Champions", "Loyal Customers", "Potential Loyalist",
                   "New Customers", "Promising", "Need Attention", "About To Sleep",
                   "At Risk", "Can't Lose Them", "Lost")
#numerical thresholds
r_low <- c(4, 2, 3, 4, 3, 2, 2, 1, 1, 1)
r_high <- c(5, 5, 5, 5, 4, 3, 3, 2, 1, 2)
f_low <- c(4, 3, 1, 1, 1, 2, 1, 2, 4, 1)
f_high <- c(5, 5, 3, 1, 1, 3, 2, 5, 5, 2)
m_low <- c(4, 3, 1, 1, 1, 2, 1, 2, 4, 1)
m_high  <- c(5, 5, 3, 1, 1, 3, 2, 5, 5, 2)

divisions<-rfm_segment(report, segment_names, r_low, r_high, f_low, f_high, m_low, m_high)


divisions_df <- divisions %>%
  dplyr::group_by(segment) %>%
  dplyr::summarize( transaction_total = sum(transaction_count), 
             amount_total = sum(amount)) %>%
  dplyr::select(segment, transaction_total, amount_total)


transactionplot <- ggplot(data = divisions_df,aes(x = reorder(segment, transaction_total), y = transaction_total)) + 
geom_bar(stat = "identity") + 
coord_flip() + theme_minimal() + 
ggtitle("Segment and Total Transaction") + 
xlab("Segment") + 
ylab("Transactions")

amountplot <- ggplot(data = divisions_df,aes(x = reorder(segment, amount_total), y = amount_total)) + 
  geom_bar(stat = "identity") + 
  coord_flip() + theme_minimal() +
  ggtitle("Segment and Total Amount") + 
  xlab("Segment") + 
  ylab("Amount")


grid.arrange(transactionplot,
             amountplot,
             ncol=2, nrow=1)



