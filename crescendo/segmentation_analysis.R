# Segmentation analysis

rm(list = ls()) #clear environment

#===================
## Load Packages
#===================
packages <- c('ggplot2', 'corrplot','tidyverse',"caret","dummies","fastDummies",'dplyr',
              'plyr','mlbench','caTools','doParallel',
              'scales','dplyr','mlbench','caTools','lubridate',
              'grid','gridExtra','doParallel','readxl')

# Load packages
for (package in packages) {
  if (!require(package, character.only=T, quietly=T)) {
    install.packages(package)
    library(package, character.only=T)
  }
}


# Load Data
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
  mutate(Age = lubridate::year(now()) - YearOfBirth)

Country_age <- Country_age %>%
  group_by(Country) %>%
  dplyr::summarise(age_total = sum(Age)) %>%
  select(Country, age_total) %>%
  arrange(desc(age_total)) %>%
  top_n(20) %>%
  ggplot(aes(x = Country, y = age_total)) + 
  geom_bar(stat = "identity") + 
  coord_flip() + 
  guides(fill = FALSE) + 
  ggtitle("Country vs. Age") + 
  xlab("Country") + 
  ylab("Age")






user_count = n()
  










user_count = dplyr::tally(CustomerID)

(Country	Cumulative age)
(Country	turnover	
  Profit	
  WagerCount	
  DaysPlayed)
Country vs transaction type


#===================
# Country segmentation
#===================



#===================
# Sport segmentation
#===================































