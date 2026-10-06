# =============================================================================
# helpers.R — NASA POWER Data Viewer
# =============================================================================

# Shared theme for all plots (DRY — define once, reuse everywhere)
nasa_theme <- function() {
  theme_bw() +
    theme(
      legend.position  = "top",
      strip.text       = element_text(family = "serif", size = 16, face = "bold", color = "black"),
      text             = element_text(family = "serif", size = 14, face = "bold", color = "black"),
      axis.title       = element_text(family = "serif", size = 16, face = "bold", color = "black"),
      axis.text        = element_text(family = "serif", size = 11, face = "bold", color = "black"),
      axis.text.x      = element_text(family = "serif", size = 10, face = "bold", color = "black",
                                      angle = 45, hjust = 1),   # ← angled for readability
      panel.grid.minor = element_blank()
    )
}

# Helper: clean y-axis label
y_label <- function(param) {
  case_when(
    param == "Relative_Humidity"   ~ "Relative Humidity (%)",
    param == "Radiation_All_Sky"   ~ "Solar Radiation — All Sky (MJ/m²/day)",
    param == "Radiation_Clear_Sky" ~ "Solar Radiation — Clear Sky (MJ/m²/day)",
    param == "Precipitation"       ~ "Precipitation (in)",
    param == "Tmin"                ~ "Min Temperature (°F)",
    param == "Tmax"                ~ "Max Temperature (°F)",
    param == "Tmean"               ~ "Mean Temperature (°F)",
    TRUE                           ~ param
  )
}

# =============================================================================
# get_climate_data(): fetch and clean NASA POWER data
# =============================================================================
get_climate_data <- function(lat, lon, start_date, end_date) {
  data <- get_power(
    community    = "AG",
    lonlat       = c(lon, lat),
    pars         = c("RH2M", "T2M", "T2M_MIN", "T2M_MAX",
                     "PRECTOTCORR", "ALLSKY_SFC_SW_DWN", "CLRSKY_SFC_SW_DWN"),
    dates        = c(start_date, end_date),
    temporal_api = "daily"
  )
  
  data <- data |>
    rename(
      Relative_Humidity  = RH2M,
      Tmin               = T2M_MIN,
      Tmax               = T2M_MAX,
      Tmean              = T2M,
      Precipitation      = PRECTOTCORR,
      Radiation_All_Sky  = ALLSKY_SFC_SW_DWN,
      Radiation_Clear_Sky = CLRSKY_SFC_SW_DWN
    ) |>
    mutate(
      Tmin                = round((Tmin  * 9/5) + 32, 2),   # °C → °F
      Tmax                = round((Tmax  * 9/5) + 32, 2),
      Tmean               = round((Tmean * 9/5) + 32, 2),
      Precipitation       = round(Precipitation / 25.4, 4), # mm → inches (fix: was /25)
      Radiation_All_Sky   = round(Radiation_All_Sky,  2),
      Radiation_Clear_Sky = round(Radiation_Clear_Sky, 2),
      # Pre-build month name — used in MONTHLY plots
      MM_name = month.abb[MM]   # cleaner than a long case_when
    )
  
  return(data)
}

# Quick test (comment out when deploying):
# df <- get_climate_data(38.0364, -84.5000, "2023-10-01", "2024-04-15")

# =============================================================================
# plot_weather(): main plotting function
# =============================================================================
plot_weather <- function(df, freq, param, col, plot_type = "Individual Parameter") {
  
  # ── INDIVIDUAL PARAMETER ────────────────────────────────────────────────────
  if (plot_type == "Individual Parameter") {
    
    # ── DAILY ──
    if (freq == "DAILY") {
      df |>
        ggplot(aes(x = YYYYMMDD, y = !!sym(param))) +   # real dates, not DOY
        geom_line(color  = col, linewidth = 0.7) +
        geom_point(color = col, size = 0.6) +
        facet_wrap(. ~ YEAR, ncol = 2, scales = "free_x") + # free_x: each year own range
        scale_x_date(
          date_labels = "%b %d",     # "Oct 01", "Jan 15" — readable by anyone
          date_breaks = "1 month"
        ) +
        labs(
          x       = "",
          y       = y_label(param),
          caption = "Data source: NASA POWER"
        ) +
        nasa_theme()
      
      # ── MONTHLY ──
    } else if (freq == "MONTHLY") {
      df |>
        group_by(YEAR, MM, MM_name) |>
        reframe(
          Tmin                = mean(Tmin,                na.rm = TRUE),
          Tmax                = mean(Tmax,                na.rm = TRUE),
          Tmean               = mean(Tmean,               na.rm = TRUE),
          Precipitation       = sum(Precipitation,        na.rm = TRUE),
          Relative_Humidity   = mean(Relative_Humidity,   na.rm = TRUE),
          Radiation_All_Sky   = mean(Radiation_All_Sky,   na.rm = TRUE),
          Radiation_Clear_Sky = mean(Radiation_Clear_Sky, na.rm = TRUE)
        ) |>
        ggplot(aes(x = reorder(MM_name, MM), y = !!sym(param))) +
        geom_line(group = 1, color = col, linewidth = 0.8) +
        geom_point(color = col, size = 2) +
        facet_wrap(. ~ YEAR, ncol = 2) +
        labs(
          x       = "Month",
          y       = y_label(param),
          caption = "Data source: NASA POWER"
        ) +
        nasa_theme()
      
      # ── ANNUAL ──
    } else if (freq == "ANNUAL") {
      df |>
        group_by(YEAR) |>
        reframe(
          Tmin                = mean(Tmin,                na.rm = TRUE),
          Tmax                = mean(Tmax,                na.rm = TRUE),
          Tmean               = mean(Tmean,               na.rm = TRUE),
          Precipitation       = sum(Precipitation,        na.rm = TRUE),
          Relative_Humidity   = mean(Relative_Humidity,   na.rm = TRUE),
          Radiation_All_Sky   = mean(Radiation_All_Sky,   na.rm = TRUE),
          Radiation_Clear_Sky = mean(Radiation_Clear_Sky, na.rm = TRUE)
        ) |>
        mutate(YEAR = as.factor(YEAR)) |>
        ggplot(aes(x = YEAR, y = !!sym(param))) +
        geom_line(group = 1, color = col, linewidth = 0.9) +
        geom_point(color = col, size = 3) +
        labs(
          x       = "Year",
          y       = y_label(param),
          caption = "Data source: NASA POWER"
        ) +
        nasa_theme()
    }
    
    # ── OVERVIEW (Temperature + Precipitation together) ─────────────────────────
  } else {
    
    # ── DAILY OVERVIEW ──
    if (freq == "DAILY") {
      scale_factor <- 10   # multiply precip to map onto temp axis
      
      df |>
        ggplot(aes(x = YYYYMMDD)) +                  # ← real dates
        geom_col(aes(y = Precipitation * scale_factor, fill = "Precipitation"),
                 width = 1, alpha = 0.7) +
        geom_line(aes(y = Tmin,  color = "Tmin",  group = 1), linewidth = 0.7) +
        geom_point(aes(y = Tmin, color = "Tmin"),  size = 0.5) +
        geom_line(aes(y = Tmax,  color = "Tmax",  group = 1), linewidth = 0.7) +
        geom_point(aes(y = Tmax, color = "Tmax"),  size = 0.5) +
        geom_line(aes(y = Tmean, color = "Tmean", group = 1), linewidth = 0.7) +
        geom_point(aes(y = Tmean,color = "Tmean"), size = 0.5) +
        scale_y_continuous(
          name      = "Temperature (°F)",
          sec.axis  = sec_axis(~ . / scale_factor, name = "Precipitation (in)")
        ) +
        scale_x_date(
          date_labels = "%b %d",
          date_breaks = "1 month"
        ) +
        scale_color_manual(values = c(
          "Tmin"  = "cornflowerblue",
          "Tmax"  = "blue",
          "Tmean" = "darkblue"
        )) +
        scale_fill_manual(values = c("Precipitation" = "purple")) +
        facet_wrap(. ~ YEAR, ncol = 2, scales = "free_x") +
        labs(
          color   = "",
          fill    = "",
          x       = "",
          caption = "Data source: NASA POWER"
        ) +
        nasa_theme()
      
      # ── MONTHLY OVERVIEW ──
    } else if (freq == "MONTHLY") {
      scale_factor <- 10
      
      df |>
        group_by(YEAR, MM, MM_name) |>
        reframe(
          Tmin          = mean(Tmin,          na.rm = TRUE),
          Tmax          = mean(Tmax,          na.rm = TRUE),
          Tmean         = mean(Tmean,         na.rm = TRUE),
          Precipitation = sum(Precipitation,  na.rm = TRUE)
        ) |>
        ggplot(aes(x = reorder(MM_name, MM))) +
        geom_col(aes(y = Precipitation * scale_factor, fill = "Precipitation"),
                 width = 0.5, alpha = 0.7) +
        geom_line(aes(y = Tmin,  color = "Tmin",  group = 1), linewidth = 0.8) +
        geom_point(aes(y = Tmin, color = "Tmin"),  size = 2) +
        geom_line(aes(y = Tmax,  color = "Tmax",  group = 1), linewidth = 0.8) +
        geom_point(aes(y = Tmax, color = "Tmax"),  size = 2) +
        geom_line(aes(y = Tmean, color = "Tmean", group = 1), linewidth = 0.8) +
        geom_point(aes(y = Tmean,color = "Tmean"), size = 2) +
        scale_y_continuous(
          name     = "Temperature (°F)",
          sec.axis = sec_axis(~ . / scale_factor, name = "Precipitation (in)")
        ) +
        scale_color_manual(values = c(
          "Tmin"  = "cornflowerblue",
          "Tmax"  = "blue",
          "Tmean" = "darkblue"
        )) +
        scale_fill_manual(values = c("Precipitation" = "purple")) +
        facet_wrap(. ~ YEAR, ncol = 2) +
        labs(
          color   = "",
          fill    = "",
          x       = "",
          caption = "Data source: NASA POWER"
        ) +
        nasa_theme()
      
      # ── ANNUAL OVERVIEW ──
    } else if (freq == "ANNUAL") {
      # Annual precip is already in total inches — scale factor maps to temp axis
      scale_factor <- 5
      
      df |>
        group_by(YEAR) |>
        reframe(
          Tmin          = mean(Tmin,          na.rm = TRUE),
          Tmax          = mean(Tmax,          na.rm = TRUE),
          Tmean         = mean(Tmean,         na.rm = TRUE),
          Precipitation = sum(Precipitation,  na.rm = TRUE)
        ) |>
        mutate(YEAR = as.factor(YEAR)) |>
        ggplot(aes(x = YEAR)) +
        geom_col(aes(y = Precipitation * scale_factor, fill = "Precipitation"),
                 width = 0.5, alpha = 0.7) +
        geom_line(aes(y = Tmin,  color = "Tmin",  group = 1), linewidth = 0.9) +
        geom_point(aes(y = Tmin, color = "Tmin"),  size = 3) +
        geom_line(aes(y = Tmax,  color = "Tmax",  group = 1), linewidth = 0.9) +
        geom_point(aes(y = Tmax, color = "Tmax"),  size = 3) +
        geom_line(aes(y = Tmean, color = "Tmean", group = 1), linewidth = 0.9) +
        geom_point(aes(y = Tmean,color = "Tmean"), size = 3) +
        scale_y_continuous(
          name     = "Temperature (°F)",
          sec.axis = sec_axis(~ . / scale_factor, name = "Total Precipitation (in)")
        ) +
        scale_color_manual(values = c(
          "Tmin"  = "cornflowerblue",
          "Tmax"  = "blue",
          "Tmean" = "darkblue"
        )) +
        scale_fill_manual(values = c("Precipitation" = "purple")) +
        labs(
          color   = "",
          fill    = "",
          x       = "Year",
          caption = "Data source: NASA POWER"
        ) +
        nasa_theme()
    }
  }
}
