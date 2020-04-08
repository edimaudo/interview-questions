#clear enviroment
rm(list=ls())

#packages
packages <- c('ggplot2', 'corrplot','tidyverse','readxl',
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

#backup data
df.backup <- df

glimpse(df)

#get column headers
colinfo <-   as.data.frame (df[1,])

#summary statistics
summary(df)

#notes
#columns that may be important Finished,distribution channel,q35,q17_1,q19_1,Q21_1,Q12
#Q10,Q5
#Q36 to end could be used for correlation


#clean up rows
#remove row 1 and 2
df<- df[-c(1, 2), ]

#visualize data by q17_1,q19_1, q21_1,q5, q36,q38, q55,q57,q39,q39_1 for better understanding

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

# ggplot(data=genderinfo, aes(x=reorder(Q2,-freq), y=freq)) +
#   geom_bar(stat="identity",fill="steelblue") + theme_classic() + labs(x = "Gender", y = "Count") +
#   theme(axis.text.x = element_text(angle = 0, hjust = 1),
#         legend.position="none",axis.title = element_text(size = 25),
#         axis.text = element_text(size = 15)) + coord_flip()
# }

ggplot(df, aes(x = Q5)) +
  geom_bar() + theme_classic()
  labs(x = "Only Company that sells patented socks", 
    y = "Count") + theme(axis.text.x = element_text(angle = 0, hjust = 1))+ coord_flip()
  

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



#data cleaning

#remove unnecessary columns status, ip address, progress, duration, finished, 
#recipient, latitude, longitude, 
#distrubution channle, user language
df <- df[,-c(3,4,5,6,7,8,10,11,12,13,14,15,16,17)]

#filter out data in q11 for 4 digit values
df$charlength <- nchar(df$Q11)
df <- df %>%
  filter(charlength == 4)


#questions
#Which approach (or combination) had the most positive impact on a 
#customer’s perception of Dhushan’s Dazzling Sock Company?

glimpse(df)


#Which approach (or combination) had the most positive impact on a customer’s 
#comprehension of Dhushan’s Dazzling Sock Company’s products and services?



#Which method (or combination) had the highest likelihood of customers recommending DDS 
#to their friends? find ehich questions correspond to this
