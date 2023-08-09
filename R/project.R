library(yfR)
library(tidyverse)
library(lubridate)
library(moments)
library(zoo)


#tickersOld <- c("SPXN","SPXS","SPY","SPXL")
tickers <- c("SPXS","SPY","SPXL")

dataRaw <- yf_get(tickers= tickers,first_date = "2016-12-26" |> as.Date()) 
#save(dataRaw,file="bup.rdata")

# load("bup.rdata")
# dataRaw <- dataRaw |> 
#   filter(ticker != "SPXN")

datasetDailyW<- dataRaw |> 
  select(ticker,ref_date,price_close) |>
  rename(date=ref_date,
         price=price_close) |> 
  pivot_wider(names_from = ticker,values_from = price) |>
  mutate(across(-date,~(log(.x)-lag(log(.x))),.names ="ret_{.col}")) |> 
  drop_na() |> 
  filter(date>as.Date("2017-01-01")) |> 
  mutate(across(-c(date,starts_with("ret")),~(.x/.x[1]))) 



plotTime <- datasetDailyW |>
  select(!starts_with("ret")) |>
  pivot_longer(cols = -date,names_to = "product",values_to = "price") |>
  ggplot() +
  aes(x=date,y=price,color=product) +
  geom_line()
  
plotTime




statDesDaily <- datasetDailyW |> 
  reframe(across(starts_with("ret"),list(mean=function(x) round(252*100*mean(x),2),
                                         vol= function(x) round(16*100*sd(x),2),
                                         skew=function(x) round(skewness(x),2),
                                         kur=function(x) round(kurtosis(x),2)
                                         ),
                 .names = "{fn}_{col}")
              ) |> 
  pivot_longer(cols =everything(),names_to = c("moment",".value"),names_pattern = "(.+)_(.+)")
  

datasetMonthlyW <- datasetDailyW |>
  select(!starts_with("ret")) |> 
  mutate(sample_date=floor_date(date,"month"),.after = date) |> 
  group_by(sample_date) |> 
  filter(row_number()==1) |>
  select(-date) |> 
  ungroup() |> 
  mutate(across(-sample_date,~(log(.x)-lag(log(.x))),.names ="ret_{.col}")) |> 
  drop_na() 

statdesMonthly <-datasetMonthlyW|> 
  reframe(across(starts_with("ret"),list(mean=function(x) round(252*100*mean(x),2),
                                         vol= function(x) round(16*100*sd(x),2),
                                         skew=function(x) round(skewness(x),2),
                                         kur=function(x) round(kurtosis(x),2)
  ),
  .names = "{fn}_{col}")
  ) |> 
  pivot_longer(cols =everything(),names_to = c("moment",".value"),names_pattern = "(.+)_(.+)")


correlDaily <- datasetDailyW |>
  select(starts_with("ret")) |> 
  as.matrix() |> 
  cor()
  
correlMonthly <- datasetMonthlyW |>
  select(starts_with("ret")) |> 
  as.matrix() |> 
  cor()

  

# rollingYearly
myLag=256

datasetRolling <- datasetDailyW |> 
  mutate(across(!c(date,starts_with("ret")),~(.x/lag(.x,myLag)),.names = "{myLag}_{.col}")) |> 
  mutate(accVar=rollapplyr(ret_SPY,width=myLag+1,FUN=function(x) sum(x*x),by.column=TRUE,fill=NA)) 

gamma <- function(m) +0.5*(m*m-m)



gamma(-3)

data_pow <- datasetRolling |> 
  select(c(date,accVar,starts_with(myLag |> as.character()))) |> 
  drop_na() |> 
  rename(SPY=`256_SPY`) |> 
  mutate(`corrected_SPXL` = `256_SPXL` * exp(gamma(3)*accVar)) |> 
  mutate(`corrected_SPXS` = `256_SPXS` * exp(gamma(-3)*accVar)) |>
  mutate(`linear_SPXL`=SPY*3-2,
         `linear_SPXS`=-SPY*3+4) |> 
  mutate(`fit_SPXL` = SPY^3) |> 
  mutate(`fit_SPXS` = SPY^(-3)) |> 
  pivot_longer(cols =-c(date,accVar,SPY),names_to = c(".value","product"),names_pattern = "(.+)_(.+)") |> 
  rename(notCorrected=`256`) |> 
  pivot_longer(cols=c(corrected,notCorrected,linear),names_to = "type",values_to = "value")
  

## if linear VT/V0-1 = +/-3*(ST/S0-1)

data_pow |>
  filter(type %in% c("corrected")) |> 
  ggplot() +
  aes(x=SPY,y=value,color=product) +
  geom_point()

plot(datasetRolling$accVar)
  
