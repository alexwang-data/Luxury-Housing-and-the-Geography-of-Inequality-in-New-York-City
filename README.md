# Luxury-Housing-and-the-Geography-of-Inequality-in-New-York-City

## 🕵️ Overview

New York City is a tale of two cities, where immense wealth and extreme poverty exist in stark proximity within a single metropolis. While the US National Gini Index hovered around 0.40, New York City’s reached 0.55 (reported in Black & Richards, 2020), placing it among the most unequal large cities in the country. Nowhere is this divide more visible than in the housing market. On one block, ultra-luxury condominiums sell for tens of millions of dollars; a few blocks away, rent-burdened households spend more than half their income to stay housed. Between 2010 and 2019, the city’s luxury housing market grew by 102%, intensifying in already-affluent neighborhoods on the west side of Manhattan while expanding into recently gentrified parts of northern and central Brooklyn (Lauermann, 2021).

Spatial methods have been used to identify neighborhoods at risk of gentrification at the fine geographic scales (Bogin et al., 2023), but few studies build a tract-level index that directly measures the mismatch between luxury prices and local incomes. This study addresses that gap by asking whether luxury housing is landing in New York City’s most socioeconomically vulnerable neighborhoods.

## 🧩 Research Design

**Reseach Question:**
Is the luxury housing market concentrated in socioeconomically vulnerable neighborhoods in New York City?

**Null Hypothesis (H0):**
The luxury housing market is not associated with neighborhood socioeconomic vulnerability.

**Alternative Hypothesis (Ha):**
The luxury housing market is concentrated in socioeconomically vulnerable neighborhoods.

## 📁 Data

U.S. Census; 2020 American Community Survey 5-Years Estimate<br>
https://data.census.gov/

NYC Open Data; 2025 Citywide Annualized Calendar Sales Update<br>
https://data.cityofnewyork.us/City-Government/NYC-Citywide-Annualized-Calendar-Sales-Update/w2pb-icbu/about_data

NYC Department of City Planning; 2020 Neighborhood Tabulation Areas<br>
https://www.nyc.gov/content/planning/pages/resources/datasets/neighborhood-tabulation

ArcGIS Pro; Esri Basemap<br>
https://pro.arcgis.com/en/pro-app/latest/help/mapping/map-authoring/author-a-basemap.htm

## 📚 Libraries
```r
library(socratadata)    # for Socrata API
library(tidyverse)      # for data manipulation and visualization
library(tidycensus)     # for Census API
library(sf)             # for spatial analysis
library(spdep)          # for autocorrelation tests
library(spatialreg)     # for spatial lag regression
library(psych)          # for descriptive statistics
library(car)            # for evaluating model assumptions
library(sandwich)       # for heteroskedasticity consistent covariance matrix
library(lmtest)         # for heteroskedasticity consistent covariance matrix
library(olsrr)          # for stepwise modeling
library(GGally)         # for correlation matrix
library(modelsummary)   # for model summary
library(patchwork)      # for plot composition
library(gt)             # for table composition
```
## 🎨 Visual Identity

Typography:<br>

Times New Roman         (presentation & writing)<br>
Tahoma                  (poster)<br>
Carbria Math            (poster)<br>

Color Palette:<br>

Neutral Tones:<br>
White: #FFFFFF<br>
Grey 50: #7A7A7A <br>
Charcoal: #2F2F2F <br>

Earth & Brown Tones:<br>
Warm Clay: #C97C5D <br>
Burnt Sienna: #8C3B2A <br>

Red Tones:<br>
Crimson Red: #8D021F <br>
Deep Red: #B2182B <br>
Soft Coral: #E07A7A <br>

Blue & Cool Tones:<br>
Slate Blue Grey: #6F7F8C <br>
Royal Blue: #2166AC <br>

## 💻 How To Replicate
Sign up for a U.S. Census API Key:<br>
https://api.census.gov/data/key_signup.html

Sign up for a NYC Open Data API Key:<br>
https://opendata.cityofnewyork.us/ <br>
Click on name. Choose developer setting. Create a new API Key. Note both Key ID and Key Secret. <br>

Install R and RStudio:<br>
https://posit.co/download/rstudio-desktop <br>

In RStudio, install and load all of the **15 libraries**:<br>
```r
install.packages("tidyverse")
library(tidyverse)
```
Tidyverse is a collection of packages. It contains tools like `dplyr`, `tibble`, `tidyr`, and `ggplot2` for data manipulation and visualization.<br>

The replication code are available in four folders, covering data development, exploratory data analysis, ordinary least squares, and spatial analysis.<br>

Create a folder on your desktop.<br>

In RStudio, set a working directory (Mac):<br>
https://www.learn-r.org/r-tutorial/setwd-r.php
```r
getwd()
setwd("/Users/USER/Desktop/FOLDER")
```

When running the code, the associated visualizations and tables will be automatically saved to the folder linked to the working directory.<br>

You can disregard this by skipping:<br>
```r
ggsave() # visuals
# and
gtsave() # tables
```

Optional:<br>
Install ArcGIS Pro:<br>
https://pro.arcgis.com/en/pro-app/latest/get-started/install-and-sign-in-to-arcgis-pro.htm <br>


## ⚙️ Methodology

Following Lauermann (2021), luxury housing is defined as residential properties sold for at least $2 million per unit, which is the threshold New York City adopted in 2019 for a “mansion tax” on real estate sales.

Transaction records were obtained from NYC Open Data’s Citywide Annualized Calendar Sales via the Socrata API and filtered to residential properties. Neighborhood characteristics were drawn from the 2020 American Community Survey 5-year estimates at the census tract level via the Census API. Both datasets were spatially joined in a common projected coordinate system.

For each tract, a Luxury Pressure Index (LPI) was calculated as the ratio of median luxury price-per-unit to median household income. Tracts with fewer than five luxury sales were excluded to ensure reliability, yielding a final sample of 455 tracts.

To support visual interpretation, LPI values were also aggregated to Neighborhood Tabulation Areas (NTAs). An Optimized Hot Spot Analysis (Getis-Ord Gi*) was run on luxury price-per-unit at the individual transaction level to identify statistically significant clusters of high- and low value sales.

Because the LPI was right-skewed, it was log-transformed for regression. An ordinary least squares model was fit using forward stepwise selection, retaining poverty rate, foreign-born share, educational attainment, rent burden, and population density as predictors. Standard OLS diagnostics (residual normality, homoscedasticity, leverage, and multicollinearity) were checked and reasonably satisfied. Moran’s I (Anselin, 1995) revealed significant spatial autocorrelation in the LPI (I = 0.42, p < 0.05), violating OLS independence assumptions, so a spatial lag regression (Anselin, 1988) was used. 


## 🗺️ Analysis

In the neighborhoods experiencing the greatest luxury pressure, a single luxury unit costs more than 200 years of the local median household income, reaching as high as 1,109 years in the most extreme case.

Manhattan’s Billionaires Row dominates the hot spot map, with significant clusters of high-value sales, yet the LPI values are not the highest in the city. In Midtown, Lenox Hill, and Carnegie Hill, median incomes are high enough to absorb high luxury prices, narrowing the price-to-income ratio. The most extreme LPI values instead appear in East Harlem, East New York, Canarsie, Marine Park, Long Island City, Woodside, Elmhurst, Flushing, and Far Rockaway. A map of luxury sales alone would point to Manhattan as the epicenter of the market; a map of luxury pressure points elsewhere, to where the gap between prices and earnings is widest and where what Marcuse (1985) called “displacement pressure” is acute.

The spatial lag regression quantifies these patterns and identifies which neighborhood characteristics drive luxury pressure. Poverty, rent burden, population density, and foreign-born share each predict higher LPI, while educational attainment moves in the opposite direction (see Fig. 1 and Fig. 5). The positive coefficient on foreign-born share is consistent with Sassen’s (1991) global-city framework, in which capital investment and immigrant labor concentrate in the same metropolis and often the same neighborhoods.


## 🎬 Conclusion
The results support the alternative hypothesis that the luxury housing market is concentrated in socioeconomically vulnerable neighborhoods. Higher poverty and rent burden are associated with greater luxury pressure, while higher educational attainment is associated with lower pressure. This profile is broadly consistent with characteristics used to identify neighborhoods vulnerable to gentrification or “gentrification eligible” in prior research (Freeman, 2005) and aligns with socioeconomic indicators commonly employed in recent quantitative studies of gentrification and super-gentrification (Lauermann et al., 2025).

Two limitations qualify these findings. First, the LPI is cross-sectional and cannot capture how luxury pressure changes over time; future research could introduce a temporal dimension to track neighborhood change as luxury capital arrives, intensifies, or recedes. Second, residual spatial autocorrelation remained after modeling (Moran’I = 0.18), indicating that some spatial structure is not fully explained by the included predictors. Alternative model specifications could further reduce residual clustering and refine the estimates.


## 💡 References

## ⚖️ License

![License: CC BY-NC 4.0](https://img.shields.io/badge/License-CC_BY--NC_4.0-lightgrey.svg)

This work is licensed under a
[Creative Commons Attribution-NonCommercial 4.0 International License](https://creativecommons.org/licenses/by-nc/4.0/).

[![CC BY-NC 4.0](https://licensebuttons.net/l/by-nc/4.0/88x31.png)](https://creativecommons.org/licenses/by-nc/4.0/)
