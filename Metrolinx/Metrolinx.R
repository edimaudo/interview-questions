## Objective
## Analyze food access and mortality

# Clear Environment
rm(list = ls()) 
#===================
## Load Libraries
#===================
packages <- c('ggplot2','corrplot','tidyr','validate','glmnet',
              'tidyverse','dplyr','scales','caret',
              'dummies','mlbench','caTools')
for (package in packages) {
  if (!require(package, character.only=T, quietly=T)) {
    install.packages(package)
    library(package, character.only=T)
  }
}

# =======================================================
# Data Munging
# =======================================================
# --------------------------------------------------------
# Load Data
# --------------------------------------------------------
df <- read_csv("food_health_politics.csv")

# --------------------------------------------------------
# Check Summary
# --------------------------------------------------------
summary(df)
# --------------------------------------------------------
# Check for missing data
# --------------------------------------------------------
missing_data <- apply(df, 2, function(x) any(is.na(x))) 
print(missing_data)

# --------------------------------------------------------
# Correlation of mortality_rate, low_access_pop, fastfood, snap_stores_per_1000,per_dem_2016
# --------------------------------------------------------
cor_df <- df %>%
  select(mortality_rate, low_access_pop, fastfood, snap_stores_per_1000,per_dem_2016) %>%
  na.omit()
corrplot(cor(cor_df), method="number")
#{plot.new(); dev.off()}

#  i.	How related are mortality rate and access to food?
ggplot(data = cor_df,aes(x =mortality_rate ,y = low_access_pop)) +
  geom_point() + theme_classic() +
  labs(x = "Mortality Rate",
       y = "Access to Food") +
  scale_y_continuous(labels = comma) +
  theme(
    legend.text = element_text(size = 10),
    legend.title = element_text(size = 10),
    axis.title = element_text(size = 15),
    axis.text = element_text(size = 10))

#  ii.	How related are mortality rate and the prevalence of fast food restaurants?
ggplot(data = cor_df,aes(x =mortality_rate ,y = fastfood)) +
  geom_point() + theme_classic() +
  labs(x = "Mortality Rate",
       y = "Prevelance of Fast Food") +
  scale_y_continuous(labels = comma) +
  theme(
    legend.text = element_text(size = 10),
    legend.title = element_text(size = 10),
    axis.title = element_text(size = 10),
    axis.text = element_text(size = 10))

#  iii.	How related are mortality rate and the prevalence of SNAP stores per 1,000 residents?
ggplot(data = cor_df,aes(x =mortality_rate ,y = snap_stores_per_1000)) +
  geom_point() + theme_classic() +
  labs(x = "Mortality Rate",
       y = "Snap stores per 1000 residents") +
  scale_y_continuous(labels = comma) +
  theme(
    legend.text = element_text(size = 10),
    legend.title = element_text(size = 10),
    axis.title = element_text(size = 15),
    axis.text = element_text(size = 10))

#  iv.	How related are mortality rate and the percent of the county that voted for Democrats in 2016?
ggplot(data = cor_df,aes(x =mortality_rate ,y = per_dem_2016)) +
  geom_point() + theme_classic() +
  labs(x = "Mortality Rate",
       y = "Percent of county that voted democrate in 2016") +
  scale_y_continuous(labels = comma) +
  theme(
    legend.text = element_text(size = 10),
    legend.title = element_text(size = 10),
    axis.title = element_text(size = 15),
    axis.text = element_text(size = 10))

#  v.	Top 5 states that have the widest variance in "Percent of the county's 
# population with low access to food" for county's that fall within that state?
top_df <- df %>%
  na.omit()

top_df2 <- top_df %>%
  filter(pct_low_access_pop != 0) %>%
  group_by(state,county) %>%
  mutate(Variance = var(pct_low_access_pop)) %>%
  arrange(desc(Variance)) %>%
  select(state,county,Variance)

#vi.	Top 3 states that have in absolute terms, reduced most the population with
#     low access to food across the election years 2012 and 2016? 
#     Columns  "low_access_pop" and "low_access_change" have relevant data.

top_red_df <- df %>%
  na.omit() %>%
  group_by(state) %>%
  summarize(Total_pop=sum(low_access_pop),Total_change= sum(low_access_change)) %>%
  arrange(desc(Total_change)) %>%
  top_n(3) %>%
  select(state,Total_pop, Total_change)
         
#b.	Any other interesting insights that you can discover from the data?
# State insights
top_df <- df %>%
  select(state,low_access_pop,deaths,snap_stores, population, fastfood) %>%
  na.omit()

#top 10 states with highest death
top_df %>% 
  group_by(state) %>%
  summarize(Deaths = sum(deaths)) %>%
  arrange(desc(Deaths)) %>%
  top_n(10) %>%
  ggplot(aes(x = reorder(state, Deaths) , y = Deaths)) + 
  geom_bar(stat = "identity", position = "dodge") + 
  coord_flip() + 
  guides(fill = FALSE) + 
  ggtitle("Top 10 states with highest death") + 
  xlab("States") + 
  ylab("Death")

#top 10 states population
top_df %>% 
  group_by(state) %>%
  summarize(Population = sum(population)) %>%
  arrange(desc(Population)) %>%
  top_n(10) %>%
  ggplot(aes(x = reorder(state, Population) , y = Population)) + 
  geom_bar(stat = "identity", position = "dodge") + 
  coord_flip() + 
  guides(fill = FALSE) + 
  ggtitle("Top 10 States with the highest population") + 
  xlab("States") + 
  ylab("Population")


# --------------------------------------------------------
# Regression
# --------------------------------------------------------

reg_df <- df %>%
  select(low_access_pop,snap_stores_per_1000,mortality_rate) %>%
  na.omit()


#create train and test data
# set.seed(2020)
# sample <- sample.split(reg_df,SplitRatio = 0.75)
# train <- subset(reg_df,sample ==TRUE)
# test <- subset(reg_df, sample==FALSE)
# # normalized data
# normalize <- function(x) {
#   return ((x - min(x)) / (max(x) - min(x)))
# }
# # train information normalizing
# train_df<- as.data.frame(lapply(train[,c(1,2)], normalize))
# df_train<- train[,c(1:8)]
# 
# # test information normalized
# test <- as.data.frame(lapply(test, normalize))
# df_test<- test[,c(1:8)]
# 
# Target_train_pm <- train$mortality_rate
#  a.	Does access to food predict mortality?
# linear regression

scatter.smooth(reg_df$low_access_pop,reg_df$mortality_rate, main='Food Access vs. Mortality Rate')
model <- lm(reg_df$mortality_rate~reg_df$low_access_pop)
summary(model)

#  b.	Do more SNAP stores per person predict mortality?

scatter.smooth(reg_df$snap_stores_per_1000,reg_df$mortality_rate, main='Snap stores vs. Mortality Rate')
model <- lm(reg_df$mortality_rate~reg_df$snap_stores_per_1000)
summary(model)

#  c.	Do election results and access to food and SNAP stores predict mortality?

model <- lm(reg_df$mortality_rate~.,data=reg_df)
summary(model)


