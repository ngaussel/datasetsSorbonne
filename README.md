# Presentation

This repo has been created for students at MMMEF & IRFA Masters at Paris I, La Sorbonne. It is aimed at providing some equity, the code allowing to update/generate those datasets as well as some basic cross-sectional analysis on this dataset.

Those data are related to the Equity / CAPM chapter of the course "Financial Products" given by Nicolas Gaussel, year 2023.

Important warning: those datasets have been programmatically generated from free data sources. Those data have not been curated nor cross-checked in any manner. They might contain important flaws that do not make them appropriate for industrial or academic use.

Any information contained in this site is purely indicative and subject to modification at any time. The author does not undertake to update such information at any specific frequency. The author will be liable or responsible for any loss or damage resulting, directly or indirectly,from the use of this information.

# Datasets

Datasets can be found either as rdata format, that can be directly loaded in R or as .csv, in the data folder

The R folder contains :

-   a dataMangement page which describes the data management,

-   a helper page which contains some specific functions

-   a project page which relates to a specific project

-   a shinyViewer page which contains the analysis presented as a plain Shiny Application

## Technicalities

Regarding what long and wide datasets are see e.g. <a href ="https://en.wikipedia.org/wiki/Wide_and_narrow_data">Wikipedia Wide_and_narrow_data</a>, where long is referred to as "narrow".

Regarding what csv files are see also <a href ="https://en.wikipedia.org/wiki/Comma-separated_values">Wikipedia Comma-separated_values</a>.

## S&P500

We provide two datasets obtained from Yahoo, using the <a href ="https://github.com/ropensci/yfR">yfR</a> package.

1.  <a href = "data/SP500_simplified_with_volume.csv">SP500_simplified_with_volume.csv</a>: long data containing a 5 year history of daily adjusted prices and volumes.
2.  <a href = "data/SP500_simplified_price_only_wide.csv">SP500_simplified_price_only_wide.csv</a>: wide data containing a 5 year history of daily adjusted prices only.

## Multi-Asset

The file <a href = "data/prices_Multi_Asset_long.csv">prices_Multi_Asset_long.csv</a> contains 12 years of daily generic future values rolled regularly.
