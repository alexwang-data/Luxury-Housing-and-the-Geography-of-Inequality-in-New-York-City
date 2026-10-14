<p align="center">
  <img src="https://raw.githubusercontent.com/alexwang-data/Luxury-Housing-and-the-Geography-of-Inequality-in-New-York-City/main/HEADER.jpg" width="500">
</p>

# Luxury-Housing-and-the-Geography-of-Inequality-in-New-York-City

## 🕵️ Overview

New York City is a tale of two cities, where immense wealth and extreme poverty exist in stark proximity within a single metropolis. While the US National Gini Index hovered around 0.40, New York City’s reached 0.55 (reported in Black & Richards, 2020), placing it among the most unequal large cities in the country. Nowhere is this divide more visible than in the housing market. On one block, ultra-luxury condominiums sell for tens of millions of dollars; a few blocks away, half of renter households are rent-burdened, spending more than 30% of their income on rent (ANHD, 2025). Between 2010 and 2019, the city’s luxury housing market grew by 102%, intensifying in already-affluent neighborhoods on the west side of Manhattan while expanding into recently gentrified parts of northern and central Brooklyn (Lauermann, 2021). 

In April 2026, New York City and State announced the state’s first pied-à-terre tax, targeting luxury second homes valued above $5 million whose owners maintain primary residences elsewhere (NYC Mayor’s Office, 2026). Mayor Mamdani and Governor Hochul framed high-end real estate as “a vehicle for wealth storage rather than as homes” (NYC Mayor’s Office, 2026). This characterization echoes literature describing luxury housing as both a vehicle for capital preservation and a form of “social dead space” (Lauermann, 2021; Fernandez et al., 2016; Atkinson, 2019). Shortly after the announcement, the NYC Comptroller’s Office released “The Pied-à-Terre Tax and Its Potential Revenues.” The analysis estimates the tax could raise roughly $340 - $500 million annually, depending on implementation details. It also highlights substantial uncertainty surrounding which luxury properties and ownership arrangements would ultimately be subject to the tax, including questions related to occupancy status, rental use, condominium and cooperative valuation methods, and ownership through opaque legal structures such as LLCs and trusts (NYC Comptroller’s Office, 2026). However, while the Comptroller’s focus remains primarily fiscal and jurisdictional, it stops short of assessing the spatial pressure these investments may exert on adjacent low-income communities.

This lack of empirical clarity is mirrored in the academic literature. Despite growing policy attention, evidence on the spatial relationship between luxury housing and resident vulnerability remains limited. Spatial methods have been used to identify neighborhoods at risk of gentrification at the fine geographic scale (Bogin et al., 2023), but few studies directly measure the mismatch between luxury prices and the incomes of nearby residents. This study addresses that gap by asking whether luxury housing is landing in New York City’s most socioeconomically vulnerable neighborhoods. The study makes four contributions: (1) it applies spatial methods to identify the concentrations of luxury sales and neighborhoods at risk of gentrification and displacement; (2) it introduces the Luxury Pressure Index (LPI), a tract-level measure of this mismatch and the spatial tension produced when high-value real estate capital enters neighborhoods with limited resident purchasing power, designed to be reproducible and extensible for future research; (3) it documents a “Manhattan paradox” in which the neighborhoods with the most luxury sales are not those with the most luxury pressure; and (4) it situates spatial findings within established frameworks of gentrification eligibility (Freeman, 2005), displacement pressure (Marcuse, 1985) and global-city (Sassen, 1991).




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

The replication code are available in four folders, covering Data Development, Exploratory Data Analysis, Ordinary Least Squares, and Spatial Analysis.<br>

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

Follow the Geoprocessing Model workflow. <br>


## ⚙️ Methodology

Following Lauermann (2021), luxury housing is defined as residential properties sold for at least $2 million per unit, which is the threshold New York City adopted in 2019 for a “mansion tax” on real estate sales.

Transaction records were obtained from NYC Open Data’s Citywide Annualized Calendar Sales via the Socrata API and filtered to residential properties. Neighborhood characteristics were drawn from the 2020 American Community Survey 5-year estimates at the census tract level via the Census API. Both datasets were spatially joined in a common projected coordinate system, restricting the study to tracts with 500 or more residents to focus strictly on established residential areas. This threshold is informed by applied gentrification and displacement mapping practices (Urban Displacement Project, 2019).

For each tract, a Luxury Pressure Index (LPI) was calculated as the ratio of median luxury price-per-unit to median household income. Tracts with fewer than five luxury sales were excluded to ensure reliability, yielding a final sample of 457 tracts.

To support visual interpretation, LPI values were also aggregated to Neighborhood Tabulation Areas (NTAs). An Optimized Hot Spot Analysis (Getis-Ord Gi*) was run on luxury price-per-unit at the individual transaction level to identify statistically significant clusters of high- and low value sales.

Because the LPI was right-skewed, it was log-transformed for regression. An ordinary least squares model was fit using forward stepwise selection, retaining poverty rate, foreign-born share, educational attainment, rent burden, and population density as predictors. Standard OLS diagnostics (residual normality, homoscedasticity, leverage, and multicollinearity) were checked and reasonably satisfied. Moran’s I (Anselin, 1995) revealed significant spatial autocorrelation in the LPI (I = 0.34, p < 0.001), violating OLS independence assumptions, so a spatial lag regression (Anselin, 1988) was used. To account for spatial isolates across slightly disconnected tracts, a snap distance was applied to the Queen contiguity spatial weight matrix (Pebesma & Bivand, 2023)



## 🗺️ Analysis

In the neighborhoods experiencing the greatest luxury pressure, a single luxury unit costs more than 200 years of the local median household income, reaching as high as 1,109 years in the most extreme case.

Manhattan’s Billionaires Row dominates the hot spot map, with significant clusters of high-value sales, yet the LPI values are not the highest in the city. In Midtown, Lenox Hill, and Carnegie Hill, median incomes are high enough to absorb high luxury prices, narrowing the price-to-income ratio. The most extreme LPI values instead appear in East Harlem, East New York, Canarsie, Marine Park, Long Island City, Woodside, Elmhurst, Flushing, and Far Rockaway. A map of luxury sales alone would point to Manhattan as the epicenter of the market; a map of luxury pressure points elsewhere, to where the gap between prices and earnings is widest and where what Marcuse (1985) called “displacement pressure” is acute.

The spatial lag regression quantifies these patterns and identifies which neighborhood characteristics drive luxury pressure. Poverty, rent burden, population density, and foreign-born share each predict higher LPI, while educational attainment moves in the opposite direction (see Fig. 1 and Fig. 5 on the poster). The positive coefficient on foreign-born share is consistent with Sassen’s (1991) global-city framework, in which capital investment and immigrant labor concentrate in the same metropolis and often the same neighborhoods.


## 🎬 Conclusion
The results support the alternative hypothesis that the luxury housing market is concentrated in socioeconomically vulnerable neighborhoods. Higher poverty and rent burden are associated with greater luxury pressure, while higher educational attainment is associated with lower pressure. This profile is broadly consistent with characteristics used to identify neighborhoods vulnerable to gentrification or “gentrification eligible” in prior research (Freeman, 2005) and aligns with socioeconomic indicators commonly employed in recent quantitative studies of gentrification and super-gentrification (Lauermann et al., 2025).

Two limitations qualify these findings. First, the LPI is cross-sectional and cannot capture how luxury pressure changes over time; future research could introduce a temporal dimension to track neighborhood change. Second, while a minor trace of residual spatial autocorrelation remained (Moran’I = 0.08, p < 0.001), its magnitude is negligible and indicates that the spatial lag model successfully resolved the primary spatial dependencies in the data.



## 💡 References

Aalbers, M. B. (2016). The financialization of housing: A political economy approach. Routledge. <br><br>

Anselin, L. (1988). Spatial econometrics: Methods and models. Kluwer Academic Publishers. <br>
 https://web.pdx.edu/~crkl/WISE/SEAUG/papers/anselin01_CTE14.pdf <br><br>
 
Anselin, L. (1995). Local indicators of spatial association—LISA. Geographical Analysis, 27(2), 93–115. <br>
 https://doi.org/10.1111/j.1538-4632.1995.tb00338.x <br><br>
 
Association for Neighborhood & Housing Development. (2025). 2025 AMI cheat sheet: New housing is not affordable to the majority of New Yorkers. <br>
https://anhd.org/report/2025-ami-cheat-sheet-new-housing-is-not-affordable-to-the-majority-of-new-yorkers/ <br><br>

Atkinson, R. (2019). Necrotecture: Lifeless dwellings and London’s super-rich. International Journal of Urban and Regional Research, 43(1), 2–13. <br>
 https://doi.org/10.1111/1468-2427.12707 <br><br>
 
Black, B. D., & Richards, M. (2020). Eco-gentrification and who benefits from urban green amenities: NYC’s High Line. Landscape and Urban Planning, 204, 103900. <br>
 https://doi.org/10.1016/j.landurbplan.2020.103900 <br><br>
 
Bogin, A., Doerner, W., & Larson, W. (2023). Estimating census tract house price indexes: A new spatial dynamic factor approach. Journal of Real Estate Finance and Economics. <br>
 https://link.springer.com/article/10.1007/s11146-023-09957-w <br><br>
 
Fernandez, R., Hofman, A., & Aalbers, M. B. (2016). London and New York as a safe deposit box for the transnational wealth elite. Environment and Planning A: Economy and Space, 48(12), 2443–2461. <br>
 https://doi.org/10.1177/0308518X16659479 <br><br>
 
Freeman, L. (2005). Displacement or succession? Residential mobility in gentrifying neighborhoods. Urban Affairs Review, 40(4), 463–491. <br>
 https://ds4ps.org/cpp-528-spr-2020/articles/gentrification/displacement-or-succession.pdf <br><br>
 
Furman Center. (2010). The effects of rezonings on neighborhoods and schools. NYU Furman Center. <br>
https://www.furmancenter.org/wp-content/uploads/ee-legacy/publications/Rezonings_Furman_Center_Policy_Brief_March_2010.pdf <br><br>

Hackworth, J., & Smith, N. (2000). The changing state of gentrification. Tijdschrift voor Economische en Sociale Geografie, 91(4), 464–477. <br>
 https://doi.org/10.1111/1467-9663.00172 <br><br>
 
Lauermann, J. (2021). Luxury housing and gentrification in New York City, 2010–2019. Urban Geography, 43(10), 1683–1701. <br>
 https://doi.org/10.1080/02723638.2021.1956112 <br><br>
 
Lauermann, J., Alexander, Z., & Wang, Z. (2025). Mapping super-gentrification in large US cities, 1990–2020. Urban Geography. <br>
 https://doi.org/10.1080/02723638.2025.2528418 <br><br>
 
Madden, D., & Marcuse, P. (2016). In defense of housing: The politics of crisis. Verso. <br><br>

Marcuse, P. (1985). Gentrification, abandonment, and displacement: Connections, causes, and policy responses in New York City. Washington University Journal of Urban and Contemporary Law, 28, 195–240. <br>
 https://openscholarship.wustl.edu/law_urbanlaw/vol28/iss1/4 <br><br>
 
Martucci, E. (2024). There was nothing there: Williamsburg, the gentrification of a Brooklyn neighborhood. Fordham University Press. <br><br>

Midtown South Community Council. (n.d.). The hidden horror of Hudson Yards is how it was financed. <br>
 https://midtownsouthcc.org/blogs/the-hidden-horror-of-hudson-yards-is-how-it-was-financed/ <br><br>
 
New York City Comptroller. (n.d.). The pied-à-terre tax and its potential revenues. <br>
 https://comptroller.nyc.gov/reports/the-pied-a-terre-tax-and-its-potential-revenues/ <br><br>

New York City Council. (2025, May 14). City Council announces new housing affordability initiatives. <br>
 https://council.nyc.gov/press/2025/05/14/2869/ <br><br>
 
New York City Department of City Planning. (n.d.). Mandatory inclusionary housing. <br>
https://www.nyc.gov/content/planning/pages/our-work/plans/citywide/mandatory-inclusionary-housing <br><br>

New York City Mayor’s Office. (2026, April). Mayor Mamdani and Governor Hochul announce the state's first pied-à-terre tax proposal. <br>
https://www.nyc.gov/mayors-office/news/2026/04/mayor-mamdani–governor-hochul-announce-state-s-first-pied-a-ter <br><br>

Pebesma, E., & Bivand, R. (2023). Spatial Data Science: With Applications in R (1st ed.). Chapman and Hall/CRC. <br>
https://doi.org/10.1201/9780429459016 <br><br>

Sassen, S. (1991). The global city: New York, London, Tokyo. Princeton University Press. <br><br>

Stabrowski, F. (2015). Inclusionary zoning and exclusionary development: The politics of “affordable housing” in North Brooklyn. International Journal of Urban and Regional Research, 39(6), 1120–1136. <br>
 https://doi.org/10.1111/1468-2427.12297 <br><br>
 
Stein, S. (2019). Capital city: Gentrification and the real estate state. Verso. <br><br>

The Wall Street Journal. (2016, October 20). Immigrant investor program for poor neighborhoods benefits rich ones more, study shows. <br>
https://www.wsj.com/articles/immigrant-investor-program-for-poor-neighborhoods-benefits-rich-ones-more-study-shows-1476917304 <br><br>

Urban Displacement Project. (2019, January). Gentrification and displacement census tract typologies: Methodology for New York [Methodology document]. <br>
University of California, Berkeley. https://www.urbandisplacement.org/wp-content/uploads/2021/07/udp_methodology_for_ny_-_jan_2019.pdf <br><br>


## ⚖️ License

![License: CC BY-NC 4.0](https://img.shields.io/badge/License-CC_BY--NC_4.0-lightgrey.svg)

This work is licensed under a
[Creative Commons Attribution-NonCommercial 4.0 International License](https://creativecommons.org/licenses/by-nc/4.0/).

[![CC BY-NC 4.0](https://licensebuttons.net/l/by-nc/4.0/88x31.png)](https://creativecommons.org/licenses/by-nc/4.0/)
