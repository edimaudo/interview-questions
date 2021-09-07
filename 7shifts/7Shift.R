#===================
## Load Libraries
#===================
rm(list = ls()) #clear environment

# Packages
packages <- c('ggplot2', 'corrplot','tidyverse','scales','dplyr', 'lubridate','gridExtra','grid')

# Load packages
for (package in packages) {
  if (!require(package, character.only=T, quietly=T)) {
    install.packages(package)
    library(package, character.only=T)
  }
}

#===================
# Load data
#===================
trials <- read_csv("trials.csv")
companies <- read_csv("companies.csv")

#remove the first column
trials[1] <- NULL
companies[1] <- NULL

# preview company data
summary(companies)

# preview data types
glimpse(companies)

# preview the data
summary(trials)

# remove data types
glimpse(trials)


#key definitions
#Conversion rate is defined as the proportion of prospective customers (trials) that made
#a purchase and became actual customers (companies) within a given time period.

#Trials can be joined to companies via company_id. A trial with no company ID did not
#convert.

# combine trials and companies
trials_company <- trials %>%
  inner_join(companies,by = "company_id")

# preview information
glimpse(trials_company)

trials_company$trial_year <- lubridate::year(trials_company$trial_date)

unique(trials_company$trial_year)

#remove years after 2017
trials_company <- trials_company %>%
  filter(trial_year >= 2017)

#trends
#trial year vs avg display price
trial_avg_display_price <- trials_company %>%
  dplyr::group_by(trial_year) %>%
  dplyr::summarise(avg_display_price = mean(display_price)) %>%
  dplyr::select(trial_year, avg_display_price)
  

ggplot(data=trial_avg_display_price, aes(x=(trial_year), y=avg_display_price)) +
  #geom_line(color = "#6d031c") +
  #geom_point(color = "#a79086")+
  geom_bar(stat="identity", fill="steelblue")+ 
  theme_minimal()+
  xlab("Trial Year") + 
  ylab("Avg. Display Price")

#trial year vs utm vs avg display price
trial_utm_avg_display_price <- trials_company %>%
  dplyr::group_by(trial_year, utm) %>%
  dplyr::summarise(avg_display_price = mean(display_price)) %>%
  dplyr::select(trial_year, utm, avg_display_price)

ggplot(trial_utm_avg_display_price, aes(x=(trial_year), y=avg_display_price, group = utm)) +
  geom_line(aes(color=utm)) +
  geom_point(aes(color=utm)) +
  #geom_bar(stat="identity",position = "dodge")+ 
  theme_minimal()+
  xlab("Trial Year") + 
  ylab("Avg. Display Price")


trials_company$cancellation_start_date_diff <- trials_company$cancellation_date - trials_company$signup_date

#differences between companies that have cancelled vs not cancelled
trial_utm_avg_display_price_other <- trials_company %>%
  dplyr::filter(is.na(cancellation_date)) %>%
  dplyr::group_by(trial_year, utm) %>%
  dplyr::summarise(avg_display_price = mean(display_price)) %>%
  dplyr::select(trial_year, utm, avg_display_price)

plot1 <- ggplot(trial_utm_avg_display_price_other, aes(x=(trial_year), y=avg_display_price, group = utm)) +
  geom_line(aes(color=utm)) +
  geom_point(aes(color=utm)) +
  #geom_bar(stat="identity",position = "dodge")+ 
  theme_minimal()+
  ggtitle("cancelled ")+
  xlab("Trial Year") + 
  ylab("Avg. Display Price")


trial_utm_avg_display_price_other1 <- trials_company %>%
  dplyr::filter(!is.na(cancellation_date)) %>%
  dplyr::group_by(trial_year, utm) %>%
  dplyr::summarise(avg_display_price = mean(display_price)) %>%
  dplyr::select(trial_year, utm, avg_display_price)

plot2 <- ggplot(trial_utm_avg_display_price_other1, aes(x=(trial_year), y=avg_display_price, group = utm)) +
  geom_line(aes(color=utm)) +
  geom_point(aes(color=utm)) +
  #geom_bar(stat="identity",position = "dodge")+ 
  theme_minimal()+
  ggtitle("current ")+
  xlab("Trial Year") + 
  ylab("Avg. Display Price")


grid.arrange(plot1, plot2, ncol=2)
