library(dplyr)
library(tidyr)
library(purrr)
library(yahoofinancer)
library(broom)





############### Compute Factor statistics ################

load(file = "stock_info.rdata")
load(file = "USstocks.rdata")

returns <- USStocks |> 
  mutate(across(-date,function(x) log(x/dplyr::lag(x)))) |> 
  drop_na() 

correlation <- returns |> 
  select(-date) |> 
  as.matrix() |> 
  cor() 

spectrum <- correlation |> eigen()

eigenF <- spectrum$vectors |> 
  as_tibble(.name_repair = NULL)

eigenV <- spectrum$values

stockFactors <- tibble(ticker=colnames(correlation)) |> 
  bind_cols(eigenF) |> 
  left_join(stocks_info)

save(stockFactors,eigenV,file = "shiny.rdata")


############# Test CAPM ###############


SP500 <-  yahoofinancer::Ticker$new(symbol = "^GSPC")


SPReturns_raw <- SP500$get_history(start = min(returns$date) ,end = max(returns$date)) 

SPReturns <- SPReturns_raw |> 
  select(date,close) |> 
  mutate(across(-date,function(x) log(x/dplyr::lag(x)))) |> 
  drop_na() |> 
  mutate(date = date |> as.Date()) |> 
  rename(SP500 = close)

dataset <- returns |> 
  left_join(SPReturns)

##### need to retrieve some short term rates history

######## Compute regressions ##################
onereg <- function(x){
  
  fit1 <- lm(dataset[,x] |> pull() ~ dataset[,"SP500"] |> pull()) 
  
  fit <- fit1 |>  
    broom::tidy() |> 
    rename(sigma=std.error)
  
  fit[1,1] <- "alpha"
  fit[2,1] <- "beta"

  r2<- fit1 |> 
    glance() |> 
    select(c(1,3,4,5)) |> 
    mutate(term="r2",.before=1) |> 
    rename(estimate=r.squared)
  
  fit <- bind_rows(fit,r2) |> 
    mutate(ticker=x)
  
    
  fit
}


bulkRegression <- map(.x = dataset |> 
                   select(-date,-SP500) |> 
                   colnames(), 
                 .f= onereg,
                 .progress = "status") |> 
  reduce(bind_rows) |> 
  left_join(stocks_info)

save(bulkRegression,file = "bulkRegression.rdata")


