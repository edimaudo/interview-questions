#clear old data
rm(list=ls())

#load libraries
for (package in c('ggplot2', 'corrplot','tidyverse',
                  "cowplot",'lubridate','data.table', 'tseries','forecast')) {
  if (!require(package, character.only=T, quietly=T)) {
    install.packages(package)
    library(package, character.only=T)
  }
}

#load data
df <- read.csv(file.choose())

#backup data
df.backup <- df

#descriptive statistics
basic_stats <- summary(df)
print(basic_stats)

#missing data
missing_data <- apply(df, 2, function(x) any(is.na(x)))

#-------------------
#exploratory analysis
#-------------------

# correlations
corrinfo <- df[,3:6]
corrplot(cor(corrinfo), method="number")

#observation between variables
# sessions vs bounce rate
sb <- ggplot(data=df, aes(y=sessions, x=bounces)) +
  geom_line()+ geom_point() + theme_classic()
# sessions vs time on page
sti <- ggplot(data=df, aes(y=sessions, x=time_on_page)) +
  geom_line()+ geom_point() + theme_classic()
# sessions vs transactions
str <- ggplot(data=df, aes(y=sessions, x=transactions)) +
  geom_line()+ geom_point() + theme_classic()

sout <- plot_grid(sb, sti, str, labels = "AUTO")
print(sout)

sti <- NULL
str <- NULL
sb <- NULL
sout <- NULL

# bounce rate vs time on page
bti <- ggplot(data=df, aes(y=time_on_page, x=bounces)) +
  geom_line()+ geom_point() + theme_classic()
# bounce rate vs transactions
btr <- ggplot(data=df, aes(y=transactions, x=bounces)) +
  geom_line()+ geom_point() + theme_classic()

bout <- plot_grid(bti, btr, labels = "AUTO")
print(bout)

btr <- NULL
bti <- NULL

# time on page vs transactions
tp <- ggplot(data=df, aes(y=transactions, x=time_on_page)) +
  geom_line()+ geom_point() + theme_classic()

tout <- plot_grid(tp, labels = "AUTO")

tp <- NULL

#rfm modelling
rfm_info <- df %>%
  select(date,path,transactions)

#convert date
rfm_info <- transform(rfm_info, date = as.Date(as.character(date), "%Y%m%d"))

rfm_temp <- rfm_info %>%
  group_by(path) %>%
  summarise(recency=-(as.numeric(as.Date(today())-max(date))),
            frequency=n_distinct(path), monetary= sum(transactions))


#rfm rank scoring
# sort data set for Recency with Recency (ascending) - Frequency (descending) - Monetary (descending)
rfm_temp <- rfm_temp %>%
  arrange(recency, desc(frequency), desc(monetary))
rfm_temp$rankR <- cut(rfm_temp$recency,5,labels=F)
rfm_temp <- rfm_temp %>%
  mutate(recency = 0-recency)
# sort data set for Frequency with Recency (descending) - Frequency (ascending) - Monetary (descending)
rfm_temp <- rfm_temp %>%
  arrange(desc(recency), frequency, desc(monetary))
rfm_temp$rankF <- cut(rfm_temp$frequency,5,labels=F) 
# sort data set for Monetary with Recency (descending) - Frequency (descending) - Monetary (ascending)
rfm_temp <- rfm_temp %>%
  arrange(desc(recency), desc(frequency), monetary)
rfm_temp$rankM <- cut(rfm_temp$monetary,5,labels=F)
rfm_temp$Score <- with(rfm_temp, paste0(rankR, rankF, rankM))
rfm_temp <- rfm_temp %>%
  mutate(Score = as.integer(Score)) %>%
  arrange(desc(Score))

#use score range
rfm_main <- rfm_temp %>%
  arrange(desc(rankR), desc(rankF), desc(rankM)) %>%
  filter(between(Score, 455, 555))

convertdate <- function(dframe){
  dframe <- transform(dframe, date = as.Date(as.character(date), "%Y%m%d"))
  return (dframe)
}

#time series - trends over time

generate_time_series <- function(dfinfo){

  count_ts = ts(dfinfo[, c('info')])
  df_ds$sessions = tsclean(count_ts)
  q <- ggplot() +
    geom_line(data = df_ds, aes(x = date, y = info)) + 
    scale_x_date('month') + ylab('Info')
  print(q)
  
  #decompose data
  count_ma = ts(na.omit(df_ds$sessions), frequency=30)
  decomp = stl(count_ma, s.window="periodic")
  deseasonal_cnt <- seasadj(decomp)
  plot(decomp)
  
  return ("")
  
}

# date vs sessions
df_ds <- df %>%
  rename (info = sessions) %>%
  select(date,info)
df_ds <- convertdate(df_ds)
generate_time_series(df_ds)

# date vs bounce rate
df_ds <- df %>%
  rename (info = bounces) %>%
  select(date,info)
df_ds <- convertdate(df_ds)
generate_time_series(df_ds)

# date vs time on page
df_ds <- df %>%
  rename (info = time_on_page) %>%
  select(date,info)
df_ds <- convertdate(df_ds)
generate_time_series(df_ds)

# date vs transactions
df_ds <- df %>%
  rename (info = transactions) %>%
  select(date,info)
df_ds <- convertdate(df_ds)
generate_time_series(df_ds)