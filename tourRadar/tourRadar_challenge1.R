#clear old data
rm(list=ls())

#load libraries
for (package in c('ggplot2', 'corrplot','tidyverse',
                  "cowplot",'lubridate','data.table','MASS','car' )) {
  if (!require(package, character.only=T, quietly=T)) {
    install.packages(package)
    library(package, character.only=T)
  }
}

#load data
df <- read.table(file.choose(), sep = '\t', header = TRUE)

#backup data
df.backup <- df

#descriptive statistics
basic_stats <- summary(df)
print(basic_stats)

#missing data
missing_data <- apply(df, 2, function(x) any(is.na(x)))

#exploratory analysis

#correlations between #visits, bounce rate, time on page, conversions
corrinfo <- df[,6:9]
corrplot(cor(corrinfo), method="number")

#date, version , conversions
ggplot(data=df, aes(x=as.factor(date), y=conversions, fill=factor(version))) +
  geom_bar(stat="identity", position=position_dodge()) + theme_classic() +
  theme(axis.text.x = element_text(angle=60, hjust=1)) + xlab("date")  
  
#visit vs bounce rate, time on page, conversions
scatterplotMatrix(df[6:9])

#ab test modelling
abInfo <- df %>% 
  dplyr::group_by(version) %>%
  summarise(versiontotalconversions = sum(conversions))
abInfo$total <- sum(abInfo$versiontotalconversions)
abInfo$proportions = abInfo$versiontotalconversions / abInfo$total 

v1mean = abInfo[1,4]$proportions
v2mean = abInfo[2,4]$proportions
v3mean = abInfo[3,4]$proportions
vtotal = abInfo[1,3]$total

v1amount <- abInfo[1,2]$versiontotalconversions
v2amount <- abInfo[2,2]$versiontotalconversions
v3amount <- abInfo[3,2]$versiontotalconversions

comparemean <- function(mean1, mean2, total){
  x_a = seq(from=0.05, to=1, by=0.00001)
  y_a = dnorm(x_a, mean = mean1, sd = sqrt((mean1 * 0.99)/total))
  
  x_b = seq(from=0.05, to=1, by=0.00001)
  y_b = dnorm(x_b, mean = mean2, sd = sqrt((mean2 * 0.988)/total))
  
  data = data.frame(x_a=x_a, y_a=y_a, x_b=x_b, y_b=y_b)
  options(repr.plot.width=15)
  cols = c("A"="green","B"="orange")
  ggplot(data = data)+
    labs(x="Proportions value", y="PDF") +
    geom_point(aes(x=x_a, y=y_a, colour="A")) +
    geom_point(aes(x=x_b, y=y_b, colour="B")) +
    scale_colour_manual(name="Variants", values=cols) +
    theme(axis.text.x = element_text(angle=60, hjust=1))
  
}

#compare v1 & 2
c12 <- comparemean(v1mean, v2mean, vtotal)

#compare v1 & 3
c13 <- comparemean(v1mean, v3mean, vtotal)

##compare v2 & 3
c23 <- comparemean(v2mean, v3mean, vtotal)

plot_grid(c12, c13, c23, labels = "AUTO")

#compare v1 & 2
b_v12 <- binom.test(v2amount, vtotal, p =v1mean, alternative = "greater")

#compare v1 & 3
b_v13 <- binom.test(v3amount, vtotal, p =v1mean, alternative = "greater")

#compare v2 & 3
b_v23 <- binom.test(v3amount, vtotal, p =v2mean, alternative = "greater")

#Type 1 and 2 errors
alpha = 0.05
#Type 1 error
type1_v1 <- qbinom(1 - alpha, vtotal, v1mean)
type1_v2 <- qbinom(1 - alpha, vtotal, v2mean)
type1_v3 <- qbinom(1 - alpha, vtotal, v3mean)

#type 2 error
type2_v1 <- pbinom(type1_v1, vtotal, b_v12$estimate)
type2_v2 <- pbinom(type1_v2, vtotal, b_v13$estimate)
type2_v3 <- pbinom(type1_v3, vtotal, b_v23$estimate)