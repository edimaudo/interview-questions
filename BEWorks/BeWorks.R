#clear enviroment
rm(list=ls())

#packages
packages <- c('ggplot2', 'corrplot','tidyverse','caret','mlbench','mice', 'caTools', 
              'MASS','Metrics','randomForest','lars','xgboost','Matrix','methods','readxl',
              'factorextra','nFactors','scales','NbClust','psy','lattice')

#load packages
for (package in packages) {
  if (!require(package, character.only=T, quietly=T)) {
    install.packages(package)
    library(package, character.only=T)
  }
}

#load data
df <- read.csv(file.choose())

#columninfo
colinfo <- df[1,]

#remove row 1 and 2
df<- df[-c(1, 2), ]

glimpse(df)

#backup data
df.backup <- df

#get summary
summary(df)

#remove unnecessary columns status, ip address, progress, duration, finished, 
#recipient, latitude, longitude, 
#distrubution channle, user language
df <- df[,-c(3,4,5,6,7,8,10,11,12,13,14,15,16,17)]

#filter out data in q11 for 4 digit values
df$charlength <- nchar(df$Q11)
df <- df %>%
  filter(charlength == 4)

#summary statistics
summary(df)

#visualize data by q17_1,q19_1, q21_1,q5, q36,q38, q55,q57,q39,q39_1

ggplot(df, aes(x = Q17_1)) +
  geom_bar() +
  labs(
       x = "Customer satistifaction", 
       y = "Count") +
  theme_classic()

ggplot(df, aes(x = Q19_1)) +
  geom_bar() +
  labs(
    x = "Produces high quality socks", 
    y = "Count") +
  theme_classic()

ggplot(df, aes(x = Q5)) +
  geom_bar() +
  labs(
    x = "Only Company that sells patented socks", 
    y = "Count") +
  theme_classic()

ggplot(df, aes(x = Q36)) +
  geom_bar() +
  labs(
    x = "Age", 
    y = "Count") +
  theme_classic()


ggplot(df, aes(x = Q21_1)) +
  geom_bar() +
  labs(
    x = "Favourable opinion", 
    y = "Count") +
  theme_classic()



ggplot(df, aes(x = Q21_1)) +
  geom_bar(aes(fill = Q35)) +
  labs(
    x = "Favourable opinion", 
    y = "Count") +
  theme_classic()

#questions
#Which approach (or combination) had the most positive impact on a 
#customer’s perception of Dhushan’s Dazzling Sock Company?
#thoughts - which questions show this + demographic + visualization
glimpse(df)


#Which approach (or combination) had the most positive impact on a customer’s 
#comprehension of Dhushan’s Dazzling Sock Company’s products and services?

#thoughts - which questions showcase this + which demographic

#Which method (or combination) had the highest likelihood of customers recommending DDS 
#to their friends? find ehich questions correspond to this
