# Luxury-Housing-and-the-Geography-of-Inequality-in-New-York-City

## 🕵️ Overview

HI! Thanks for stopping by. I'm still building this repository - please check back soon.

**Reseach Question:**
Is the luxury housing market concentrated in socioeconomically vulnerable neighborhoods in New York City?

**Null Hypothesis (H0):**
The luxury housing market is not associated with neighborhood socioeconomic vulnerability.

**Alternative Hypothesis (Ha):**
The luxury housing market is more concentrated in socioeconomically vulnerable neighborhoods.

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
## 💻 How To Replicate
Sign up for a U.S. Census API Key:<br>
https://api.census.gov/data/key_signup.html

Sign up for a NYC Open Data API Key:<br>
https://opendata.cityofnewyork.us/ <br>
Click on name. Choose developer setting. Create a new API Key. Note both Key ID and Key Secret. <br>

Install R and RStudio:<br>
https://posit.co/download/rstudio-desktop <br>

In RStudio, install and load all of the 15 libraries:<br>
```r
install.packages("tidyverse")
library(tidyverse)
```
Tidyverse is a collection of packages. It contains tools like `dplyr`, `tibble`, `tidyr`, and `ggplot2` for data manipulation and visualization.<br>

Optional:<br>
Install ArcGIS Pro

## 🧹 Part 1: Data Development

## 📊 Part 2: Exploratory Data Analysis (EDA)

## 🧮 Part 3: Ordinary Least Squares

## 🗺️ Part 4: Spatial Data

## 💡 Sources
