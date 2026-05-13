## Exploratory Mapping

# create a borough variable
final <- final %>%
  mutate(
    borough_code = substr(GEOID, 1, 5),
    borough = case_when(
      borough_code == "36005" ~ "Bronx",
      borough_code == "36047" ~ "Brooklyn",
      borough_code == "36061" ~ "Manhattan",
      borough_code == "36081" ~ "Queens",
      borough_code == "36085" ~ "Staten Island"
    )
  )


# color palettes
RColorBrewer::display.brewer.all()


# map NYC census tracts
map_borough <- ggplot(final) +
  geom_sf(aes(fill = borough), color = "black", size = .1) +
  scale_fill_brewer(palette = "Greys") +
  labs(
    title = "NYC Census Tracts (Borough Boundaries)",
    fill = "Borough"
  ) +
  theme_minimal() +
  theme(text = element_text(family = "Times New Roman", size = 8),
        plot.title = element_text(hjust = 0.5))

map_borough


# map a variable of interest
map_choropleth <- ggplot(data = final) +
  geom_sf(aes(fill = luxury_pressure_index), color = NA) +
  scale_fill_distiller(palette = "Reds",       # define color fill
                       direction = 1,          # ramp from light to dark
                       name = "Years\n(sales / income)",     # label the legend
                       na.value = "gray90") +  # color for nulls
  labs(
    title = "Luxury Pressure Index (Census Tract Level)"
  ) +
  theme_minimal() +
  theme(text = element_text(family = "Times New Roman", size = 8),
        plot.title = element_text(hjust = 0.5))

map_choropleth


# assemble plots with patchwork
spatial_plots <- ((map_borough) | (map_choropleth)) +
  plot_annotation(
    title = "Luxury Pressure Across New York City",
    caption = "Source: U.S. Census Bureau, 2020 ACS 5-Year Estimates; City of New York (NYC Open Data), 2025 Citywide Annualized Calendar Sales Update",
    theme = theme(
      plot.title = element_text(
        family = "Times New Roman",
        size = 14,
        hjust = 0.5,
        face = "bold"
      ),
      plot.caption = element_text(
        margin = margin(t = 20),
        family = "Times New Roman",
        size = 8,
        hjust = 1
      )
    )
  )

spatial_plots


# export as png
ggsave("spatial_plots.png", spatial_plots)



## Spatial Autocorrelation

# create spatial data frame and drop nulls in variable of interest
spatial_df <- final %>%
  filter(!is.na(luxury_pressure_index)) %>%
  mutate(log_lpi = log(luxury_pressure_index))


# create spatial weights / spatial neighbors
neighborlist <- poly2nb(pl = spatial_df, # polygons
                        queen = TRUE)   # concept for matrix

listweights <- nb2listw(neighbours = neighborlist, # neighborhoods
                        style = "W",
                        zero.policy = TRUE)


# global moran's I
# do nearby census tracts have similar values?
global_moran <- moran.test(x = spatial_df$log_lpi, 
                           listw = listweights,    # spatial structure (who is near whom)
                           randomisation = TRUE,   # use a permutation-test (more robust)
                           alternative = "greater",
                           na.action = na.omit,
                           zero.policy = TRUE)

global_moran


# compute spatial lag
spatial_df$lag_lpi <- lag.listw(listweights, spatial_df$log_lpi)


# standardize for proper quadrants around 0
spatial_df$lpi_std <- as.numeric(scale(spatial_df$log_lpi))
spatial_df$lag_std_moran <- as.numeric(scale(spatial_df$lag_lpi))


# moran scatterplot of luxury pressure
moran_lpi <- ggplot(spatial_df, aes(x = lpi_std, y = lag_std_moran)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", color = "#8D021F", se = FALSE) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_vline(xintercept = 0, linetype = "dashed") +
  annotate("text", x = 1.5, y = -1, label = "Moran's I = 0.42", size = 3) +
  labs(
    title = "Moran of Luxury Pressure",
    x = "Standardized Luxury Pressure Index",
    y = "Spatially Lagged Luxury Pressure Index"
  ) +
  theme_minimal() +
  theme(
    text = element_text(family = "Times New Roman", size = 8),
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


# build a gof tibble for key metrics
extra_gof_spatial <- tibble(
  term = c("Num.Obs.", "Rho", "Log-Likelihood", "AIC", "BIC"),
  `Spatial Lag` = as.character(c(
    nobs(spatial_model),
    round(spatial_model$rho, 3),
    round(as.numeric(logLik(spatial_model)), 3),
    round(AIC(spatial_model), 3),
    round(BIC(spatial_model), 3)
  ))
)


# blank row for clean formatting
blank_row_spatial <- tibble(
  term = "Model Fit Statistics",
  `Spatial Lag` = ""
)


# output a table with modelsummary and gt
spatial_lag_table <- modelsummary(
  list("Spatial Lag" = spatial_model),
  statistic = "({std.error})",
  stars = TRUE,
  fmt = 8,  # N. of decimals
  coef_map = c(
    "poverty_pct" = "Poverty (%)",
    "foreign_born_pct" = "Foreign-born (%)",
    "bach_or_higher_pct" = "Bachelor's Degree + (%)",
    "population_density" = "Population Density",
    "rent_burdened_pct" = "Rent Burdened (%)"
  ),
  gof_omit = ".*",  #omit default gof block
  add_rows = bind_rows(blank_row_spatial, extra_gof_spatial),
  output = "gt"
) %>%
  tab_header(title = "Spatial Lag Regression Results"
  ) %>%
  tab_source_note(
    "Source: U.S. Census Bureau, 2020 ACS 5-Year Estimates; City of New York (NYC Open Data), 2025 Citywide Annualized Calendar Sales Update"
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
  tab_style(
    style = cell_text(color = "#C97C5D"),
    locations = cells_body(rows = 15)
  ) %>%
  tab_options(
    table.font.names = "Times New Roman",
    heading.align = "center",
    source_notes.font.size = 9
  )

spatial_lag_table


# export as png
gtsave(spatial_lag_table, "spatial_lag_table.png")



## Exponentiation

# double check variable scale before exponentiation to account for log transformation
summary(model_df)


# extract coefficients
spatial_betas <- coef(spatial_model)


# build a pct effects tibble
spatial_pct_effects_df <- tibble(
  Variable = c(
    "Poverty (%)",
    "Foreign-born (%)",
    "Bachelor's + (%)",
    "Rent Burdened (%)"
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
  tab_header(title = "Exponentiated Spatial Lag Coefficients") %>%
  cols_label(
    Variable = "Variable",
    Change = "Change in Predictor",
    Effects = "% Change in Luxury Pressure"
  ) %>%
  tab_source_note(
    "Note: Estimated percent effects from spatial lag model. Effects are calculated as (exp(β × ΔX) - 1) × 100."
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
    table.font.names = "Times New Roman",
    heading.align = "center",
    source_notes.font.size = 9
  )

spatial_effects_table


# export as png
gtsave(spatial_effects_table, "spatial_effects_table.png")



## Model Comparison

# compare AIC between spatial lag model and ols
model_comp <- tibble(
  Model = c("OLS", "Spatial Lag"),
  AIC = c(
    AIC(ols_model_2),
    AIC(spatial_model)
  )
)


# model comparison slope plot
AIC_Slope <- ggplot(model_comp, aes(x = Model, y = AIC, group = 1)) +
  geom_line(color = "grey50", linewidth = 0.8) +
  geom_point(aes(color = Model), size = 3) +
  geom_text(aes(label = round(AIC, 1)), vjust = -1, size = 3) + # round to one decimal place 
  annotate("text", x = 1.75, y = 716.5, label = "↓ 4.5 AIC", size = 2) +
  scale_color_manual(values = c(
    "OLS" = "#8D021F",
    "Spatial Lag" = "#E07A7A"
  )) +
  labs(
    title = "AIC",
    y = "AIC",
    x = NULL
  ) +
  theme_minimal() +
  theme(text = element_text(family = "Times New Roman", size = 8),
        plot.title = element_text(hjust = 0.5),
        legend.position = "none")

AIC_Slope


# compare residual variance between ols and spatial lag
var_df <- tibble(
  Model = c("OLS", "Spatial Lag"),
  Residual_Variance = c(
    var(residuals(ols_model)),
    var(residuals(spatial_model))
  )
)


# model comparison lollipop plot
resid_var_lollipop <- ggplot(var_df, aes(x = Model, y = Residual_Variance)) +
  geom_segment(aes(xend = Model, y = 0, yend = Residual_Variance),
               color = "grey50") +
  geom_point(aes(color = Model), size = 3) +
  annotate("text", x = 1.75, y = 0.12, label = "↓ 0.0045 RV", size = 2) +
  geom_text(aes(label = round(Residual_Variance, 4)),
            vjust = -1, size = 3) +
  scale_color_manual(values = c(
    "OLS" = "#8D021F",
    "Spatial Lag" = "#E07A7A"
  )) +
  labs(
    title = "Residual Variance",
    y = "Residual Variance",
    x = NULL
  ) +
  theme_minimal() +
  theme(text = element_text(family = "Times New Roman", size = 8),
        plot.title = element_text(hjust = 0.5),
        legend.position = "none")

resid_var_lollipop


# assemble plots with patchwork
comparison_plots_AIC_resid_var <- ((AIC_Slope) | (resid_var_lollipop)) +
  plot_annotation(
    title = "Improvement in Model Fit",
    caption = "Source: U.S. Census Bureau, 2020 ACS 5-Year Estimates; City of New York (NYC Open Data), 2025 Citywide Annualized Calendar Sales Update",
    theme = theme(
      plot.title = element_text(
        family = "Times New Roman",
        size = 14,
        hjust = 0.5,
        face = "bold"
      ),
      plot.caption = element_text(
        margin = margin(t = 20),
        family = "Times New Roman",
        size = 8,
        hjust = 1
      )
    )
  )

comparison_plots_AIC_resid_var


# export as png
ggsave("comparison_plots_AIC_resid_var.png", comparison_plots_AIC_resid_var)


# residuals moran's I
resid_moran <- moran.test(x = spatial_df$residuals, 
                          listw = listweights, 
                          randomisation = TRUE,
                          alternative = "greater",
                          na.action = na.omit,
                          zero.policy = TRUE)

resid_moran


# compute spatial lag
spatial_df$lag_resid <- lag.listw(listweights, spatial_df$residuals)


# standardize for proper quadrants around 0
spatial_df$resid_std <- as.numeric(scale(spatial_df$residuals))
spatial_df$lag_std_resid   <- as.numeric(scale(spatial_df$lag_resid))


# moran scatterplot of residuals
moran_resid <- ggplot(spatial_df, aes(x = resid_std, y = lag_std_resid)) +
  geom_point(alpha = 0.5, color = "grey50") +
  geom_smooth(method = "lm", color = "#E07A7A", se = FALSE) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_vline(xintercept = 0, linetype = "dashed") +
  annotate("text", x = 2.5, y = -1.4, label = "Moran's I = 0.18", size = 3) +
  labs(
    title = "Moran of Residuals",
    x = "Standardized Residuals",
    y = "Spatially Lagged Residuals"
  ) +
  theme_minimal() +
  theme(
    text = element_text(family = "Times New Roman", size = 8),
    plot.title = element_text(hjust = 0.5)
  )

moran_resid


# assemble plots with patchwork
moran_plots <- ((moran_lpi) | (moran_resid)) +
  plot_annotation(
    title = "Spatial Autocorrelation Before and After Modeling",
    caption = "Source: U.S. Census Bureau, 2020 ACS 5-Year Estimates; City of New York (NYC Open Data), 2025 Citywide Annualized Calendar Sales Update",
    theme = theme(
      plot.title = element_text(
        family = "Times New Roman",
        size = 14,
        hjust = 0.5,
        face = "bold"
      ),
      plot.caption = element_text(
        margin = margin(t = 20),
        family = "Times New Roman",
        size = 8,
        hjust = 1
      )
    )
  )

moran_plots


# export as png
ggsave("moran_plots.png", moran_plots)


# map residuals
resid_map <- ggplot(spatial_df) +
  geom_sf(aes(fill = residuals)) +
  scale_fill_gradient2(
    low = "#2166AC",
    mid = "white",
    high = "#B2182B",
    midpoint = 0,
  ) +
  labs(
    title = "Residuals from Spatial Lag Regression",
    fill = "Residual"
  ) +
  theme_minimal() +
  theme(text = element_text(family = "Times New Roman", size = 8),
        plot.title = element_text(hjust = 0.5))

resid_map


# assemble plots with patchwork
spatial_resid_plots <- ((map_borough) | (resid_map)) +
  plot_annotation(
    title = "Regression Residuals Across New York City",
    caption = "Source: U.S. Census Bureau, 2020 ACS 5-Year Estimates; City of New York (NYC Open Data), 2025 Citywide Annualized Calendar Sales Update",
    theme = theme(
      plot.title = element_text(
        family = "Times New Roman",
        size = 14,
        hjust = 0.5,
        face = "bold"
      ),
      plot.caption = element_text(
        margin = margin(t = 20),
        family = "Times New Roman",
        size = 8,
        hjust = 1
      )
    )
  )

spatial_resid_plots


# export as png
ggsave("resid_map.png", spatial_resid_plots)
