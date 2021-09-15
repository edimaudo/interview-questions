#===================
# Segmentation analysis
#===================

rm(list = ls()) #clear environment

#===================
## Load Packages
#===================
packages <- c('ggplot2', 'corrplot','tidyverse',"caret","dummies","fastDummies",'dplyr',
              'plyr','mlbench','caTools','doParallel',
              'scales','dplyr','mlbench','caTools','lubridate',
              'grid','gridExtra','readxl')
for (package in packages) {
  if (!require(package, character.only=T, quietly=T)) {
    install.packages(package)
    library(package, character.only=T)
  }
}
#===================
# Load Data
#===================
player_wager <- read_excel("Player segmentation dummy data trimmed.xlsx",sheet="Player Wagering data")
player_signup <- read_excel("Player segmentation dummy data trimmed.xlsx",sheet="Player sign up stats") 
player_transaction <- read_excel("Player segmentation dummy data trimmed.xlsx",sheet="Player Transaction Stats")

# Summary
summary(player_wager)
summary(player_signup)
summary(player_transaction)

#===================
# Country segmentation
#===================
# Country cumulative Age
Country_age <- player_signup %>%
  filter(!is.na(YearOfBirth)) %>%
  mutate(Age = lubridate::year(now()) - YearOfBirth) %>%
  group_by(Country) %>%
  dplyr::summarise(age_total = sum(Age)) %>%
  select(Country, age_total) %>%
  arrange(desc(age_total)) %>%
  top_n(20) %>%
  ggplot(aes(x = reorder(Country,age_total), y = age_total)) + 
  geom_bar(stat = "identity") + 
  coord_flip() + theme_minimal() +
  guides(fill = FALSE) + 
  ggtitle("Top 20 Countries vs. Cumulative Age") + 
  xlab("Country") + 
  ylab("Cumulative Age")
Country_age

# Country user count
Country_user_count <- player_signup %>%
  filter(!is.na(YearOfBirth)) %>%
  group_by(Country) %>%
  dplyr::summarise(user_total = n()) %>%
  select(Country, user_total) %>%
  arrange(desc(user_total)) %>%
  top_n(20) %>%
  ggplot(aes(x = reorder(Country,user_total), y = user_total)) + 
  geom_bar(stat = "identity") + 
  coord_flip() + theme_minimal() +
  guides(fill = FALSE) + scale_y_continuous(labels = comma)
  ggtitle("Top 20 Countries vs. User Count") + 
  xlab("Country") + 
  ylab("User Count")
Country_user_count

## Country 1 has the most users and some of the oldest users  

# Country turnover
Country_turnover <- player_signup %>%
  


# Country Profit
Country_profit <- player_signup %>%
  inner_join(player_wager,"CustomerID") %>%
  group_by(Country) %>%
  dplyr::summarise(profit_total = sum(Profit)) %>%
  arrange(desc(profit_total), Country) %>%
  select(Country, profit_total) %>%
  top_n(20) %>%
  ggplot(aes(x = reorder(Country,profit_total), y = profit_total)) + 
  geom_bar(stat = "identity") + 
  coord_flip() + theme_minimal() +
  guides(scale = "none") + scale_y_continuous(labels = comma) +
  ggtitle("Top 20 Countries vs. Total Profit") + 
  xlab("Country") + 
  ylab("Profit")
Country_profit
  
# Country WagerCount
Country_wager <- player_signup %>%
  inner_join(player_wager,"CustomerID") %>%
  group_by(Country) %>%
  dplyr::summarise(wager_total = sum(WagerCount)) %>%
  arrange(desc(wager_total), Country) %>%
  select(Country, wager_total) %>%
  top_n(20) %>%
  ggplot(aes(x = reorder(Country,wager_total), y = wager_total)) + 
  geom_bar(stat = "identity") + 
  coord_flip() + theme_minimal() +
  guides(fill = FALSE) + scale_y_continuous(labels = comma) +
  ggtitle("Top 20 Countries vs. Wager Total") + 
  xlab("Country") + 
  ylab("Wager")
Country_wager

# Country DaysPlayed
Country_days_played <- player_signup %>%
  inner_join(player_wager,"CustomerID") %>%
  group_by(Country) %>%
  dplyr::summarise(days_played_total = sum(DaysPlayed)) %>%
  arrange(desc(days_played_total), Country) %>%
  select(Country, days_played_total) %>%
  top_n(20) %>%
  ggplot(aes(x = reorder(Country,days_played_total), y = days_played_total)) + 
  geom_bar(stat = "identity") + 
  coord_flip() + theme_minimal() +
  guides(fill = FALSE) + scale_y_continuous(labels = comma) + 
  ggtitle("Top 20 Countries vs. Days Played Total") + 
  xlab("Country") + 
  ylab("Days Played")
Country_days_played
  

# Country transaction type <-- issue
Country_transaction_type <- player_signup %>%
  inner_join(player_transaction,"CustomerID") %>%
  group_by(Country, TranType) %>%
  dplyr::summarise(amount_total = sum(AmountUSD)) %>%
  arrange(desc(amount_total), Country) %>%
  select(Country, TranType, amount_total) %>%
  
Country_transaction_type %>% 
  top_frac(.1)
  
  slice_max(order_by = Country, n = 5) %>%
  ggplot(aes(x = reorder(Country,amount_total), y = amount_total,fill = TranType)) + 
  geom_bar(stat = "identity") + 
  coord_flip() + theme_minimal() +
  #guides(fill = FALSE) + 
  ggtitle("Top 20 Countries vs. Total USD Amount") + 
  xlab("Country") + 
  ylab("USD Amount")
Country_transaction_type
  
  
  




#===================
# Sport segmentation
#===================



#===================
# Customer segmentation
#===================































