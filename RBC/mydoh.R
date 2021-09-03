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


# Summary of parent

# Preview parent

# Summary of child

# Preview child

# check for missing information

# check for data anomalies


# data aggregation


# trends