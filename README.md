# Presentation 
This repo has been created for students at MMMEF, La Sorbonne. It is aimed at providing some datasets as well as the code allowing to update/generate those datasets. Those data are related to some lectures given by Nicolas Gaussel, year 2022.

# Datasets

Important warning: those datasets have been programmatically generated from free data sources. Those data have not been curated nor cross-checked in any manner. They might contain important flaws that do not make them appropriate for industrial or academic use. 

Any  information contained in this site is purely indicative and subject to modification at any time. The author does not undertake to update such information at any specific frequency. The author will be liable or responsible for any loss or damage resulting, directly or indirectly,from the use of this information.


## Technicalities {-}

Regarding Long and wide datasets see e.g. <a href ="https://en.wikipedia.org/wiki/Wide_and_narrow_data">Wikipedia</a>, where long is referred to as "narrow".

Regarding csv files see also <a href ="https://en.wikipedia.org/wiki/Comma-separated_values">Wikipedia</a>.  

## S&P500

We provide two datasets obtained from Yahoo, using the <a href ="https://github.com/ropensci/yfR">yfR</a> package.

1. **SP500_simplified_with_volume .csv**: long data containing a 5 year history of daily adjusted prices and volumes.
2. **SP500_simplified_price_only_wide.csv**: wide data containing a 5 year history of daily adjusted prices only.
 
The code is provided in financialReturns.R. It allows to update those data and to generate a more complete (but significantly heavier) historical dataset with Open/High/low and close information.

