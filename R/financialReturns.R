library(yfR)
library(lubridate)
library(tidyr)

available_collections <- yf_get_available_collections()


SP500_history <- available_collections[1] |> 
  yf_collection_get(first_date = Sys.Date()-years(5)                           )

# Data converted to wide data if needed

# SP500_history_wide <- SP500_history |> 
#   yf_convert_to_wide()

SP500_simplified_with_volume <- SP500_history[c(1,2,7,8)] 

SP500_simplified_price_only_wide <- SP500_simplified_with_volume[-3] |> 
  pivot_wider(names_from = ticker,
            values_from = price_adjusted
            )



write.table(SP500_simplified_with_volume, file = "SP500_simplified_with_volume.csv", sep=",", row.names=FALSE)
write.table(SP500_simplified_price_only_wide, file = "SP500_simplified_price_only_wide.csv", sep=",", row.names=FALSE)

  