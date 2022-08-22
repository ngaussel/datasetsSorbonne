# Presentation 
This repo has been created for students at MMMEF, La Sorbonne. It is aimed at providing some datasets as well as the code allowing to update/generate those datasets. Those data are related to some lectures given by Nicolas Gaussel, year 2022.

Important warning: those datasets have been programmatically generated from free data sources. Those data have not been curated nor cross-checked in any manner. They might contain important flaws that do not make them appropriate for industrial or academic use. 

Any  information contained in this site is purely indicative and subject to modification at any time. The author does not undertake to update such information at any specific frequency. The author will be liable or responsible for any loss or damage resulting, directly or indirectly,from the use of this information.


# Datasets


Datasets can be found in the data folder while R code can be found in the R. folder.

## Technicalities

Regarding what long and wide datasets are see e.g. <a href ="https://en.wikipedia.org/wiki/Wide_and_narrow_data">Wikipedia Wide_and_narrow_data</a>, where long is referred to as "narrow".

Regarding what csv files are see also <a href ="https://en.wikipedia.org/wiki/Comma-separated_values">Wikipedia Comma-separated_values</a>.  

## S&P500

We provide two datasets obtained from Yahoo, using the <a href ="https://github.com/ropensci/yfR">yfR</a> package.

1. <a href = "data/SP500_simplified_with_volume.csv">SP500_simplified_with_volume.csv</a>: long data containing a 5 year history of daily adjusted prices and volumes.
2. <a href = "data/SP500_simplified_price_only_wide.csv">SP500_simplified_price_only_wide.csv</a>: wide data containing a 5 year history of daily adjusted prices only.
 
The code is provided in financialReturns.R. It allows to update those data and to generate a more complete (but significantly heavier) historical dataset with Open/High/low and close information.

