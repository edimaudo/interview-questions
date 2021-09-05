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
parent$onboarded_mth_year <- lubridate::year(parent$onboarded_mth)
parent$onboarded_mth_month <- lubridate::month(parent$onboarded_mth)
parent$onboarded_mth_month_year <- format(as.Date(parent$onboarded_mth), "%Y-%m")

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

parent_df_deposit_amount  <- ggplot(parent_df_deposit_amount , aes(x=as.factor(onboarded_mth_month), 
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

parent_df_transfer_amount  <- ggplot(parent_df_transfer_amount , aes(x=as.factor(onboarded_mth_month), 
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
             parent_df_deposit_count,parent_df_deposit_count, parent_df_deposit_amount,
             parent_df_login_count, ncol=3, nrow=4)



# Child 
# - Monthly trends using 6 different measures with group by year


#g#rid.arrange(plot1, plot2, ncol=2)

#=================
#RFM Model
#=================
df_ind <- df %>%
  filter(Org_Flag != "Organization") %>%
  select(Constituent_ID,Gift_Date,Gift_Amount)

#update date
df_ind$Gift_Date <- as.Date(df_ind$Gift_Date)

#rfm model
#rfm model
analysis_date <- lubridate::as_date("2020-07-07", tz = "UTC")
report <- rfm_table_order(df_ind, Constituent_ID,Gift_Date,Gift_Amount, analysis_date)
#segment
segment_titles <- c("First Grade", "Loyal", "Likely to be Loyal",
                    "New Ones", "Could be Promising", "Require Assistance", "Getting Less Frequent",
                    "Almost Out", "Can't Lose Them", "Don’t Show Up at All")
#numerical thresholds
r_low <- c(4, 2, 3, 4, 3, 2, 2, 1, 1, 1)
r_high <- c(5, 5, 5, 5, 4, 3, 3, 2, 1, 2)
f_low <- c(4, 3, 1, 1, 1, 2, 1, 2, 4, 1)
f_high <- c(5, 5, 3, 1, 1, 3, 2, 5, 5, 2)
m_low <- c(4, 3, 1, 1, 1, 2, 1, 2, 4, 1)
m_high  <- c(5, 5, 3, 1, 1, 3, 2, 5, 5, 2)

divisions<-rfm_segment(report, segment_titles, r_low, r_high, f_low, f_high, m_low, m_high)

division_count <- divisions %>% count(segment) %>% arrange(desc(n)) %>% rename(Segment = segment, Count = n

# Parent


# Child