## Part 4: Spatial Autocorrelation

# create spatial data frame and drop nulls in variable of interest
spatial_df <- final %>%
  filter(!is.na(luxury_pressure_index)) %>%
  mutate(log_lpi = log(luxury_pressure_index))
  

# create spatial weights / spatial neighbors
neighborlist <- poly2nb(pl = spatial_df, # polygons
                        queen = TRUE,    # concept for matrix
                        snap = 1500)
   



neighborlist <- poly2nb(spatial_df, queen = TRUE, snap = 1500)
listweights <- nb2listw(neighbours = neighborlist, # neighborhoods
style = "W",
zero.policy = TRUE)




# global moran's I
# do nearby census tracts have similar values?
global_moran <- moran.test(x = spatial_df$log_lpi, 
                           listw = listweights,    # spatial structure (who is near whom)
                           randomisation = TRUE,   
                           alternative = "greater",
                           na.action = na.omit,
                           zero.policy = TRUE)

global_moran


# LM test for model selection
lm.RStests(ols_model_2, listweights, test = "all", zero.policy = TRUE) # error and then lag


# compute spatial lag
spatial_df$lag_lpi <- lag.listw(listweights, spatial_df$log_lpi)


# standardize for proper quadrants around 0
spatial_df$lpi_std <- as.numeric(scale(spatial_df$log_lpi))
spatial_df$lag_std_moran <- lag.listw(listweights, spatial_df$lpi_std, zero.policy = TRUE)


# moran scatterplot of luxury pressure
moran_lpi <- ggplot(spatial_df, aes(x = lpi_std, y = lag_std_moran)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", color = "#8D021F", se = FALSE) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_vline(xintercept = 0, linetype = "dashed") +
  annotate("text", x = 4, y = -1, label = "Moran's I = 0.34", size = 3) +
  labs(
    title = "Global Moran of Luxury Pressure",
    x = "Standardized Luxury Pressure Index",
    y = "Spatially Lagged Luxury Pressure Index"
  ) +
  theme_minimal() +
  theme(
    text = element_text(family = "Tahoma", size = 8),
    plot.title = element_text(hjust = 0.5)
  )

moran_lpi


## Spatial Lag Regression
spatial_model <- lagsarlm(formula = formula,
                          data = model_df,
                          listw = listweights,
                          zero.policy = TRUE,
                          na.action = na.omit)

# intepret model results
names(spatial_model)
summary(spatial_model)


## Spatial Error Regression
spatial_error <- errorsarlm(formula = formula,
                            data = model_df,
                            listw = listweights,
                            zero.policy = TRUE,
                            na.action = na.omit)

# intepret model results
names(spatial_error)
summary(spatial_error)


# build a gof tibble for key metrics
extra_gof_spatial <- tibble(
  term = c("Num.Obs.", "Lambda", "Log-Likelihood", "AIC", "BIC"),
  `Spatial Error` = as.character(c(
    nobs(spatial_error),
    round(spatial_error$lambda, 3),
    round(as.numeric(logLik(spatial_error)), 3),
    round(AIC(spatial_error), 3),
    round(BIC(spatial_error), 3)
  ))
)


# blank row for clean formatting
blank_row_spatial <- tibble(
  term = "Model Fit Statistics",
  `Spatial Error` = ""
)


# output a table with modelsummary and gt
spatial_error_table <- modelsummary(
  list("Spatial Error" = spatial_error),
  statistic = "({std.error})",
  stars = TRUE,
  fmt = 8,  # N. of decimals
  coef_map = c(
    "poverty_pct" = "Poverty",
    "foreign_born_pct" = "Foreign-born",
    "bach_or_higher_pct" = "Bachelor's Degree +",
    "rent_burdened_pct" = "Rent Burdened",
    "population_density" = "Population Density"
  ),
  gof_omit = ".*",  #omit default gof block
  add_rows = bind_rows(blank_row_spatial, extra_gof_spatial),
  output = "gt"
) %>%
  tab_header(title = "Spatial Error Regression Results"
  ) %>%
  tab_style(
    style = cell_text(size = 16, weight = "bold"),
    locations = cells_title()
  ) %>%
  tab_style(
    style = cell_text(size = 11),
    locations = cells_body()
  ) %>%
  tab_style(
    style = cell_text(color = "grey50", align = "right"),
    locations = cells_source_notes()
  ) %>%
  tab_options(
    table.font.names = "Tahoma",
    heading.align = "center",
    source_notes.font.size = 9
  )

spatial_error_table


# export as png
gtsave(spatial_error_table, "spatial_error_table.png",
       vwidth = 1000,    # wide
       vheight = 900,   # tall 
       zoom = 2,
       expand = 10)


## Exponentiation

# double check variable scale before exponentiation to account for log transformation
summary(model_df)


# extract coefficients
spatial_betas <- coef(spatial_error)


# build a pct effects tibble
spatial_pct_effects_df <- tibble(
  Variable = c(
    "Poverty",
    "Foreign-born",
    "Bachelor's +",
    "Rent Burdened"
  ),
  Change = "10 percentage points",
  Effects = c(
    (exp(spatial_betas["poverty_pct"] * 0.10) -1 ) * 100,
    (exp(spatial_betas["foreign_born_pct"] * 0.10) -1 ) * 100,
    (exp(spatial_betas["bach_or_higher_pct"] * 0.10) -1 ) * 100,
    (exp(spatial_betas["rent_burdened_pct"] * 0.10) -1 ) * 100
  )
)


# build a density effects tibble
spatial_density_effects_df <- tibble(
  Variable = "Population Density",
  Change = "10,000 People",
  Effects = (exp(spatial_betas["population_density"] * 10000) -1 ) * 100
)


# bind tibbles
spatial_effects_df <- bind_rows(spatial_pct_effects_df, spatial_density_effects_df)


# build a table with gt
spatial_effects_table <- spatial_effects_df %>%
  mutate(Effects = round(Effects, 3)) %>%
  gt() %>%
  tab_header(title = "Exponentiated Spatial Error Coefficients") %>%
  cols_label(
    Variable = "Variable",
    Change = "Change in Predictor",
    Effects = "% Change in Luxury Pressure"
  ) %>%
  tab_style(
    style = cell_text(size = 16, weight = "bold"),
    locations = cells_title()
  ) %>%
  tab_style(
    style = cell_text(color = "grey50", align = "right"),
    locations = cells_source_notes()
  ) %>%
  tab_options(
    table.font.names = "Tahoma",
    heading.align = "center",
    source_notes.font.size = 9
  )

spatial_effects_table


# export as png
gtsave(spatial_effects_table, "spatial_effects_table.png",
       vwidth = 700,
       vheight = 400,
       zoom = 3,
       expand = 10)


# residuals OLS
model_df$resid <- as.numeric(residuals(ols_model_2))

resid_moran_ols <- moran.test(x = model_df$resid, 
                          listw = listweights, 
                          randomisation = TRUE,
                          alternative = "greater",
                          na.action = na.omit,
                          zero.policy = TRUE)

resid_moran_ols




# residuals moran's I
spatial_df$resid <- as.numeric(residuals(spatial_error))


resid_moran <- moran.test(x = spatial_df$resid, 
                           listw = listweights, 
                           randomisation = TRUE,
                           alternative = "greater",
                           na.action = na.omit,
                           zero.policy = TRUE)

resid_moran


# compute spatial lag
spatial_df$lag_resid <- lag.listw(listweights, spatial_df$resid)


# standardize for proper quadrants around 0
spatial_df$resid_std <- as.numeric(scale(spatial_df$resid))
spatial_df$lag_std_resid   <- lag.listw(listweights, spatial_df$resid_std, zero.policy = TRUE)


# moran scatterplot of residuals
moran_resid <- ggplot(spatial_df, aes(x = resid_std, y = lag_std_resid)) +
  geom_point(alpha = 0.5, color = "grey50") +
  geom_smooth(method = "lm", color = "#E07A7A", se = FALSE) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_vline(xintercept = 0, linetype = "dashed") +
  annotate("text", x = 6, y = -1.4, label = "Moran's I = -0.03", size = 3) +
  labs(
    title = "Global Moran of Spatial Error Residuals",
    x = "Standardized Residuals",
    y = "Spatially Lagged Residuals"
  ) +
  theme_minimal() +
  theme(
    text = element_text(family = "Tahoma", size = 8),
    plot.title = element_text(hjust = 0.5)
  )

moran_resid


# assemble plots with patchwork
moran_plots <- ((moran_lpi) | (moran_resid)) +
  plot_annotation(
    title = "Spatial Autocorrelation Before and After Modeling",
    theme = theme(
      plot.title = element_text(
        family = "Tahoma",
        size = 14,
        hjust = 0.5,
        face = "bold"
      )
    )
  )
      
moran_plots


# export as png
ggsave("moran_plots.png", moran_plots, width = 9, height = 4, dpi = 300)



  
# map residuals
resid_map <- ggplot(spatial_df) +
 geom_sf(aes(fill = lag_resid)) +
 scale_fill_gradient2(
   low = "#2166AC",
   mid = "white",
   high = "#B2182B",
   midpoint = 0,
 ) +
 labs(
   fill = "Residual"
 ) +
 theme_minimal()

resid_map

# export as png
ggsave("resid_map.png", resid_map, width = 6, height = 6, dpi = 300, bg = "transparent")

