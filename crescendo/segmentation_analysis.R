#===================
# Segmentation analysis
#===================

rm(list = ls()) #clear environment

#===================
## Load Packages
#===================
packages <- c('ggplot2', 'corrplot','tidyverse',"caret","dummies","fastDummies",'dplyr',
              'plyr','mlbench','caTools','doParallel','stringr',
              'scales','dplyr','mlbench','caTools','lubridate',
              'grid','gridExtra','readxl','NbClust','psy','nFactors')
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
# Country
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
  inner_join(player_wager,"CustomerID") %>%
  group_by(Country) %>%
  dplyr::summarise(turnover_total = sum(Turnover)) %>%
  arrange(desc(turnover_total), Country) %>%
  select(Country, turnover_total) %>%
  top_n(20) %>%
  ggplot(aes(x = reorder(Country,turnover_total), y = turnover_total)) + 
  geom_bar(stat = "identity") + 
  coord_flip() + theme_minimal() +
  guides(scale = "none") + scale_y_continuous(labels = comma) +
  ggtitle("Top 20 Countries vs. Total Turnover") + 
  xlab("Country") + 
  ylab("Turnover")
Country_turnover


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
# Country 13, 1, 52, 15, 23 are the top 5 most profitable
  
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
  
#===================
# Sport
#===================
# Sport user count
Sport_user_count <- player_wager %>%
  group_by(Sport) %>%
  dplyr::summarise(user_total = n()) %>%
  select(Sport, user_total) %>%
  arrange(desc(user_total)) %>%
  top_n(20) %>%
  ggplot(aes(x = reorder(Sport,user_total), y = user_total)) + 
  geom_bar(stat = "identity") + 
  coord_flip() + theme_minimal() +
  guides(fill = FALSE) + scale_y_continuous(labels = comma)
ggtitle("Top 20 Countries vs. User Count") + 
  xlab("Sport") + 
  ylab("User Count")
Sport_user_count


# Sport turnover
Sport_turnover <- player_wager %>%
  group_by(Sport) %>%
  dplyr::summarise(turnover_total = sum(Turnover)) %>%
  arrange(desc(turnover_total), Sport) %>%
  select(Sport, turnover_total) %>%
  top_n(20) %>%
  ggplot(aes(x = reorder(Sport,turnover_total), y = turnover_total)) + 
  geom_bar(stat = "identity") + 
  coord_flip() + theme_minimal() +
  guides(scale = "none") + scale_y_continuous(labels = comma) +
  ggtitle("Top 20 Sports vs. Total Turnover") + 
  xlab("Sport") + 
  ylab("Turnover")
Sport_turnover


# Sport Profit
Sport_profit <- player_wager %>%
  group_by(Sport) %>%
  dplyr::summarise(profit_total = sum(Profit)) %>%
  arrange(desc(profit_total), Sport) %>%
  select(Sport, profit_total) %>%
  top_n(20) %>%
  ggplot(aes(x = reorder(Sport,profit_total), y = profit_total)) + 
  geom_bar(stat = "identity") + 
  coord_flip() + theme_minimal() +
  guides(scale = "none") + scale_y_continuous(labels = comma) +
  ggtitle("Top 20 Sports vs. Total Profit") + 
  xlab("Sport") + 
  ylab("Profit")
Sport_profit
#

# Sport WagerCount
Sport_wager <- player_wager %>%
  group_by(Sport) %>%
  dplyr::summarise(wager_total = sum(WagerCount)) %>%
  arrange(desc(wager_total), Sport) %>%
  select(Sport, wager_total) %>%
  top_n(20) %>%
  ggplot(aes(x = reorder(Sport,wager_total), y = wager_total)) + 
  geom_bar(stat = "identity") + 
  coord_flip() + theme_minimal() +
  guides(fill = FALSE) + scale_y_continuous(labels = comma) +
  ggtitle("Top 20 Sports vs. Wager Total") + 
  xlab("Sport") + 
  ylab("Wager")
Sport_wager

# Sport DaysPlayed
Sport_days_played <- player_wager %>%
  group_by(Sport) %>%
  dplyr::summarise(days_played_total = sum(DaysPlayed)) %>%
  arrange(desc(days_played_total), Sport) %>%
  select(Sport, days_played_total) %>%
  top_n(20) %>%
  ggplot(aes(x = reorder(Sport,days_played_total), y = days_played_total)) + 
  geom_bar(stat = "identity") + 
  coord_flip() + theme_minimal() +
  guides(fill = FALSE) + scale_y_continuous(labels = comma) + 
  ggtitle("Top 20 Sports vs. Days Played Total") + 
  xlab("Sport") + 
  ylab("Days Played")
Sport_days_played



#===================
# Customer
#===================
player_wager1 <- player_wager
# remove "sport" from name
player_wager1$Sport <- stringr::str_sub(player_wager1$Sport,start = -2, -1)
player_wager1$Sport <- as.integer(player_wager1$Sport)

corMat = cor(player_wager1)
print(correlationMatrix)
corrplot(corMat, method = 'number', order = "hclust", bg='#676767', tl.col='black', tl.cex=.75) 
#corrplot(correlationMatrix,method='number',bg='#676767')
# # summarize the correlation matrix



# Player wager using K means clustering


























