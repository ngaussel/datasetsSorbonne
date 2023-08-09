###################  Update historical data ############


library(yfR)
source("R/helper.R")

available_collections <- yf_get_available_collections()


SP500_history <- available_collections[1] |> 
  yf_collection_get(first_date = Sys.Date()-years(5))


# Data simplification and conversion to wide format 

SP500_simplified_with_volume <- SP500_history[c(1,2,7,8)] 

SP500_simplified_price_only_wide <- SP500_simplified_with_volume[-3] |> 
  pivot_wider(names_from = ticker,
              values_from = price_adjusted
  )

write.table(SP500_simplified_with_volume, file = "SP500_simplified_with_volume.csv", sep=",", row.names=FALSE)
write.table(SP500_simplified_price_only_wide, file = "SP500_simplified_price_only_wide.csv", sep=",", row.names=FALSE)


USStocks <- SP500_simplified_price_only_wide |> 
  rename(date=ref_date)


save(USStocks,file = "USstocks.rdata")

############## Data enrichment #########


my_stocks <- names(USStocks)[-1]
stocks_info_raw <- retrieve_information_M2(my_stocks)

# Discretization of continuous characteristics for future grouping

stocks_info <- stocks_info_raw |>
  rename_at(4:6,~c("marketCap","PE","Div")) |> 
  mutate(across(.cols=4:6,.fns=~discretise(x=.x,) ,.names="{.col}_C"))


save(stocks_info,file = "stock_info.rdata")






