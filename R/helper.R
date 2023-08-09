####### Extract information ##############

library(dplyr)
library(tidyr)
library(httr2)
library(yahoofinancer)
library(purrr)

# Retrieve various informations about a list of ticker from Yahoo API using yahoofinancer
retrieve_information_M2 <- function(xList) {
  
    names1 <- c("longName", "marketCap", "trailingPE", "dividendYield")

  retrieve_information_1 <- function(x) {
    
    infos <- rep(NA, length(names1)) |> matrix(nrow = 1)
    colnames(infos) <- names1
    sector <- NA
    
    tryCatch(
      {
        assign(x, yahoofinancer::Ticker$new(symbol = x))


        tryCatch(
          {
            res <- get(x)$quote[names1]
            for (i in seq_len(length(res))) infos[1, i] <- ifelse(is.null(res[[i]]), NA, res[[i]])
          },
          error = function(e) {
            message(paste0("fail infos for ", x))
          }
        )


        tryCatch(
          {
            sector <- get(x)$technical_insights$instrumentInfo$technicalEvents$sector
          },
          error = function(e) {
            message(paste0("fail sector  for ", x))
          }
        )
      },
      error = function(e) {
        message(paste0("failed request for ", x))
      }
    )

    tibble(ticker = x, sector = sector) |> bind_cols(infos |> as_tibble())
  }

  purrr::map(xList, retrieve_information_1, .progress = "Status") |>
    purrr::reduce(bind_rows)
}


# Retrieve various informations about a list of ticker from Yahoo API using generic entry point & httr2
# Deprecated

retrieve_information_M <- function(x, base_url = "https://query2.finance.yahoo.com/v1/finance/search?q=") {
  retrieve_information_1 <- function(x) {
    my_request <- paste0(base_url, x)
    my_request <- paste0(my_request, "&f=yj1")

    test <- httr2::request(my_request) |>
      req_perform()

    zz <- test$body |>
      rawToChar() |>
      jsonlite::fromJSON() |>
      _[["quotes"]]

    resu <- tibble(ticker = x)

    tryCatch(
      {
        resu <- resu |>
          bind_cols(zz |>
            select(shortname, sector, industry, exchange) |>
            slice(1))
      },
      error = function(e) {
        message(paste0("fail for ", x))
      }
    )

    resu
  }

  purrr::map(x, retrieve_information_1, .progress = "Status") |>
    purrr::reduce(bind_rows)
}


# Discretization of a continuous vector in n categories
# Function should be further robustified (thestthat etc.)
discretise <-function(x,n_bins=6,labels=seq_len(6)) {
  
    x<-as.numeric(x) 
    breaks <- stats::quantile(x, probs = seq(0, 1, length.out = n_bins +1),na.rm=TRUE)
    cut(x, breaks = breaks, labels = labels)
  
}


entropy <- function(x) exp(-sum(x*log(x)))




