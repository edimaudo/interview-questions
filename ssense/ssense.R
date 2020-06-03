rm(list=ls())

#packages 
packages <- c('ggplot2', 'corrplot','tidyverse','caret','mlbench','mice', 
              'caTools','dummies','countrycode','readxl')

#load packages
for (package in packages) {
  if (!require(package, character.only=T, quietly=T)) {
    install.packages(package)
    library(package, character.only=T)
  }
}


df <- read_excel("PS_BA-Pt.2-Dataset.xlsx",sheet="data")

summary(df)

# #model
# #Approach 1
# res <- model.matrix(~language, data = df)
# head(res[, -1])
# 
# res <- as.data.frame(res)
# 
# output <- cbind(res,df)
# 
# output <- output[,c(1,2,18)]
# 
# library(car)
# model2 <- lm(grossProfit ~.,data = output)
# Anova(model2)


#Approach 2
#categorical variables
df2 <- df[,c(5,6,7,9,13,15)]

df_cat <- df2[,c(1,5)]

#one hot encoding
df_cat_new <- dummy.data.frame(as.data.frame(df_cat), sep = "_")

Target <- df2$grossProfit

#normalize data
normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}

df_cts <- df2[,c(2,3,4)]
df_cts <- as.data.frame(lapply(df_cts, normalize))

#combine data frame
df_new <- cbind(df_cat_new, df_cts,Target)

#split data
set.seed(123)
model <- lm(Target ~., data=df_new)
summary(model)
#plot(Target~., data=df_new)

#check for linearity
plot(model, 1)

#check residuals
plot(model, 2)

#check for variance homogenity
plot(model, 3)