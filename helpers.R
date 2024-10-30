
get_climate_data <- function(lat, lon, start_date, end_date) {
  data <- get_power(
    community = "AG",
    lonlat = c(lon, lat),
    pars = c("RH2M", "T2M", "T2M_MIN", "T2M_MAX", "PRECTOTCORR", "ALLSKY_SFC_SW_DWN", "CLRSKY_SFC_SW_DWN"),
    dates = c(start_date, end_date),
    temporal_api = "daily"
  )
  
  # Rename columns for use in Shiny app
  data <- data %>%
    rename(
      Relative_Humidity = RH2M,
      Tmin = T2M_MIN,
      Tmax = T2M_MAX,
      Tmean = T2M,
      Precipitation = PRECTOTCORR, 
      Radiation_All_Sky = ALLSKY_SFC_SW_DWN, 
      Radiation_Clear_Sky = CLRSKY_SFC_SW_DWN
    ) |> 
    mutate(Tmin = round((Tmin * 9/5)+32, 2), 
           Tmax = round((Tmax * 9/5)+32, 2), 
           Tmean = round((Tmean * 9/5) + 32, 2),
           Precipitation = round(Precipitation/25, 4),
           Radiation_All_Sky = round(Radiation_All_Sky, 2), 
           Radiation_Clear_Sky = round(Radiation_Clear_Sky, 2)
    )
  
  return(data)
}


plot_wheather <- function(df, freq, param) {
  if(freq =="DAILY") {
    df |> 
      mutate(DoY = lubridate::yday(date(YYYYMMDD))) |> 
      group_by(YEAR, DoY) |> 
      ggline(x = "DoY", param)+
      facet_wrap(.~YEAR)
  }
}


df <- get_climate_data(-38.0364, -84.5000, "10-1-2023", "15-4-2024")

plot_weather <- function(df, freq, param, col) {
  if(freq =="DAILY") {
    df |> 
      mutate(DoY = as.numeric(lubridate::yday(date(YYYYMMDD)))) |> 
      group_by(YEAR, DoY) |> 
      ggplot(aes(x = DOY, y = !!sym(param)))+
      geom_line(color = col)+
      geom_point(color = col)+
      facet_wrap(.~YEAR, ncol = 2)+
      scale_x_continuous(n.breaks = 15)+
      labs(
        x = "Doy of Year (DoY)", 
        y = case_when(
          param == "Relative_Humidity" ~ paste(param, "(%)"),
          param == "Radiation_All_Sky" ~ "Radiation w/without cloud cover (W/m²)",
          param == "Radiation_Clear_Sky" ~ "Radiation in clear sky (W/m²)",
          param == "Precipitation" ~ paste(param, "(in)"),
          TRUE ~ paste(param, "(F)")
        ), 
        caption = 'Data source: NASA POWER'
      )+
      theme_bw()+
      theme(
        legend.position = 'top',
        strip.text = element_text(family = 'serif', size = 16,
                                  face = "bold", 
                                  color  = 'black'),
        text = element_text(family = 'serif', size = 14, face = "bold", 
                            color  = 'black'),
        axis.title = element_text(family = 'serif', size = 16, face = "bold", 
                                  color  = 'black'),
        axis.text = element_text(family = 'serif', size = 12, face = "bold", 
                                 color  = 'black'),
      )
  } else if (freq =="MONTHLY") {
    
    df |> 
      mutate(  MM_name = case_when(
        MM == 1 ~ "Jan",
        MM == 2 ~ "Feb",
        MM == 3 ~ "Mar",
        MM == 4 ~ "Apr",
        MM == 5 ~ "May",
        MM == 6 ~ "Jun",
        MM == 7 ~ "Jul",
        MM == 8 ~ "Aug",
        MM == 9 ~ "Sep",
        MM == 10 ~ "Oct",
        MM == 11 ~ "Nov",
        MM == 12 ~ "Dec",
        TRUE ~ NA_character_  # Handle any unexpected values
      )) |> 
      group_by(YEAR, MM, MM_name) |>
      reframe(Tmin = mean(Tmin, na.rm = T), 
              Tmax = mean(Tmax, na.rm = T), 
              Tmean = mean(Tmean, na.rm = T), 
              Precipitation = sum(Precipitation, na.rm = T), 
              Relative_Humidity = mean(Relative_Humidity, na.rm = T), 
              Radiation_All_Sky = mean(Radiation_All_Sky, na.rm = T), 
              Radiation_Clear_Sky = mean(Radiation_Clear_Sky, na.rm = T)) |> 
      ggplot(aes(x = reorder(MM_name,MM), y = !!sym(param)))+
      geom_line(group = 1, color = col)+
      geom_point(color = col)+
      facet_wrap(.~YEAR, ncol = 2)+
      labs(
        x = "Month", 
        y = case_when(
          param == "Relative_Humidity" ~ paste(param, "(%)"),
          param == "Radiation_All_Sky" ~ "Radiation w/without cloud cover (W/m²)",
          param == "Radiation_Clear_Sky" ~ "Radiation in clear sky (W/m²)",
          param == "Precipitation" ~ paste(param, "(in)"),
          TRUE ~ paste(param, "(F)")
        ), 
        caption = 'Data source: NASA POWER'
      )+
      theme_bw()+
      theme(
        legend.position = 'top',
        strip.text = element_text(family = 'serif', size = 16,
                                  face = "bold", 
                                  color  = 'black'),
        text = element_text(family = 'serif', size = 14, face = "bold", 
                            color  = 'black'),
        axis.title = element_text(family = 'serif', size = 16, face = "bold", 
                                  color  = 'black'),
        axis.text = element_text(family = 'serif', size = 12, face = "bold", 
                                 color  = 'black'),
      )
    
    
  } else if(freq == "ANNUAL"){
    df |> 
      group_by(YEAR) |>
      reframe(Tmin = mean(Tmin, na.rm = T), 
              Tmax = mean(Tmax, na.rm = T), 
              Tmean = mean(Tmean, na.rm = T), 
              Precipitation = sum(Precipitation, na.rm = T), 
              Relative_Humidity = mean(Relative_Humidity, na.rm = T), 
              Radiation_All_Sky = mean(Radiation_All_Sky, na.rm = T), 
              Radiation_Clear_Sky = mean(Radiation_Clear_Sky, na.rm = T)) |> 
      mutate(YEAR = as.factor(YEAR)) |> 
      ggplot(aes(x = YEAR, y = !!sym(param)))+
      geom_line(group = 1, color = col)+
      geom_point(color = col)+
      labs(
        x = "Year", 
        y = case_when(
          param == "Relative_Humidity" ~ paste(param, "(%)"),
          param == "Radiation_All_Sky" ~ "Radiation w/without cloud cover (W/m²)",
          param == "Radiation_Clear_Sky" ~ "Radiation in clear sky (W/m²)",
          param == "Precipitation" ~ paste(param, "(in)"),
          TRUE ~ paste(param, "(F)")
        ), 
        caption = 'Data source: NASA POWER'
      )+
      theme_bw()+
      theme(
        legend.position = 'top',
        strip.text = element_text(family = 'serif', size = 16,
                                  face = "bold", 
                                  color  = 'black'),
        text = element_text(family = 'serif', size = 14, face = "bold", 
                            color  = 'black'),
        axis.title = element_text(family = 'serif', size = 16, face = "bold", 
                                  color  = 'black'),
        axis.text = element_text(family = 'serif', size = 12, face = "bold", 
                                 color  = 'black'),
      )
    
    
  }
}


#plot_weather(df, "DAILY", 'Radiation_All_Sky', "blue")