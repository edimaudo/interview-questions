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

