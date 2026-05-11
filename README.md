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

## 🧹 Part 1: Data Development

## 📊 Part 2: Exploratory Data Analysis (EDA)

## 🧮 Part 3: Ordinary Least Squares

## 🗺️ Part 4: Spatial Analysis

## 🎬 Conclusion
The results support the alternative hypothesis that the luxury housing market is concentrated in socioeconomically vulnerable neighborhoods. Higher poverty and rent burden are associated with greater luxury pressure, while higher educational attainment is associated with lower pressure. This profile is broadly consistent with characteristics used to identify neighborhoods vulnerable to gentrification or “gentrification eligible” in prior research (Freeman, 2005) and aligns with socioeconomic indicators commonly employed in recent quantitative studies of gentrification and super-gentrification (Lauermann et al., 2025).

Two limitations qualify these findings. First, the LPI is cross-sectional and cannot capture how luxury pressure changes over time; future research could introduce a temporal dimension to track neighborhood change as luxury capital arrives, intensifies, or recedes. Second, residual spatial autocorrelation remained after modeling (Moran’I = 0.18), indicating that some spatial structure is not fully explained by the included predictors. Alternative model specifications could further reduce residual clustering and refine the estimates.

## 💡 References
