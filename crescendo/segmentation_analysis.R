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
              'grid','gridExtra','doParallel','readxl')
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
  guides(fill = FALSE) + 
  ggtitle("Top 20 Countries vs. User Count") + 
  xlab("Country") + 
  ylab("User Count")
Country_user_count

## Country 1 has the most users and some of the oldest users  

# Country turnover

# Country Profit
  
# Country WagerCount

# Country DaysPlayed)

# Country transaction type


#===================
# Sport segmentation
#===================



#===================
# Customer segmentation
#===================































