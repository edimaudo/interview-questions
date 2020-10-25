# clear old information
rm(list = ls())

# packages 
packages <- c('ggplot2', 'corrplot','tidyverse','dplyr','readxl','scales','rfm','lubridate')

# load packages
for (package in packages) {
  if (!require(package, character.only=T, quietly=T)) {
    install.packages(package)
    library(package, character.only=T)
  }
}

# load data
users <- read_excel("data_analysis.xlsx","User")
purchases <- read_excel("data_analysis.xlsx","Purchase")

colnames(users) <- c("id",'name','user_id')

users_purchases <- users %>%
  inner_join(purchases, by="user_id") %>%
  select(user_id, date, total, discount)

users_purchases$final_amount = users_purchases$total - users_purchases$discount

df <- users_purchases %>%
  select(user_id,date,final_amount)

#update date
df$date <- as.Date(df$date)

#rfm model
analysis_date <- lubridate::as_date("2020-04-01", tz = "UTC")
report <- rfm_table_order(df, user_id,date,final_amount, analysis_date)
#segment
segment_titles <- c("First Grade", "Loyal", "Likely to be Loyal",
                    "New Ones", "Could be Promising", "Require Assistance", "Getting Less Frequent",
                    "Almost Out", "Can't Lose Them", "Don’t Show Up at All")
#numerical thresholds
r_low <- c(4, 2, 3, 4, 3, 2, 2, 1, 1, 1)
r_high <- c(5, 5, 5, 5, 4, 3, 3, 2, 1, 2)
f_low <- c(4, 3, 1, 1, 1, 2, 1, 2, 4, 1)
f_high <- c(5, 5, 3, 1, 1, 3, 2, 5, 5, 2)
m_low <- c(4, 3, 1, 1, 1, 2, 1, 2, 4, 1)
m_high  <- c(5, 5, 3, 1, 1, 3, 2, 5, 5, 2)

divisions<-rfm_segment(report, segment_titles, r_low, r_high, f_low, f_high, m_low, m_high)

division_count <- divisions %>% count(segment) %>% arrange(desc(n)) %>% rename(Segment = segment, Count = n)

write.csv(divisions,"divisions.csv")