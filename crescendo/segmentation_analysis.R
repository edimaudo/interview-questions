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
segmentation_df <- read_excel(file.choose())