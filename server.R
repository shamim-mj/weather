source("helpers.R")

# =============================================================================
# server.R — NASA POWER Data Viewer
# =============================================================================

server <- function(input, output, session) {

  # ===========================================================================
  # HELPER: parse & validate lat/lon input — returns named list or NULL
  # ===========================================================================
  parse_latlon <- function(raw_text, notify = TRUE) {
    # 1. Empty / not yet typed
    if (is.null(raw_text) || trimws(raw_text) == "") return(NULL)

    parts <- trimws(unlist(strsplit(raw_text, ",")))

    # 2. Need exactly two parts
    if (length(parts) != 2) {
      if (notify)
        showNotification(
          "⚠️ Enter coordinates as: latitude, longitude  (e.g. 38.03, -84.50)",
          type     = "warning",
          duration = 5
        )
      return(NULL)
    }

    lat <- suppressWarnings(as.numeric(parts[1]))
    lon <- suppressWarnings(as.numeric(parts[2]))

    # 3. Must be real numbers
    if (is.na(lat) || is.na(lon)) {
      if (notify)
        showNotification(
          "❌ Coordinates must be numbers — check for typos.",
          type     = "error",
          duration = 5
        )
      return(NULL)
    }

    # 4. Valid geographic range
    if (lat < -90 || lat > 90) {
      if (notify)
        showNotification(
          "❌ Latitude must be between -90 and 90.",
          type = "error", duration = 5
        )
      return(NULL)
    }
    if (lon < -180 || lon > 180) {
      if (notify)
        showNotification(
          "❌ Longitude must be between -180 and 180.",
          type = "error", duration = 5
        )
      return(NULL)
    }

    list(lat = lat, lon = lon)
  }

  # ===========================================================================
  # DEBOUNCED REACTIVES — defined ONCE, used everywhere
  # ===========================================================================
  latlong_db   <- debounce(reactive(input$latlong),   800)
  latlong_c_db <- debounce(reactive(input$latlong_c), 800)

  # ===========================================================================
  # REACTIVE DATA — TABLE TAB
  # fetched once and shared between the table output and download handler
  # ===========================================================================
  weather_data_r <- reactive({
    coords <- parse_latlon(latlong_db(), notify = TRUE)
    req(coords)   # silently stop if coordinates are invalid / not yet entered

    tryCatch(
      get_climate_data(
        coords$lat,
        coords$lon,
        as.character(input$start_date),
        as.character(input$stop_date)
      ),
      error = function(e) {
        showNotification(
          paste0("❌ Could not fetch data: ", conditionMessage(e)),
          type = "error", duration = 8
        )
        NULL
      }
    )
  })

  # ===========================================================================
  # WEATHER DATA TABLE
  # ===========================================================================
  output$weather_data <- renderDT({
    df <- weather_data_r()
    req(df)   # silently stop if data is NULL
    df
  },
  options = list(
    pageLength  = 15,
    scrollX     = TRUE,
    dom         = "Bfrtip"
  ))

  # ===========================================================================
  # DOWNLOAD HANDLER — reuses the same reactive, no second API call
  # ===========================================================================
  output$downloadDataweather <- downloadHandler(
    filename = function() {
      paste0("weather_data_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".csv")
    },
    content = function(file) {
      df <- weather_data_r()

      if (is.null(df)) {
        showNotification(
          "⚠️ No data to download — please fetch data first.",
          type = "warning", duration = 5
        )
        return()
      }

      write.csv(df, file, row.names = FALSE, na = "")
    }
  )

  # ===========================================================================
  # REACTIVE DATA — CHART TAB
  # ===========================================================================
  weather_data_chart_r <- reactive({
    coords <- parse_latlon(latlong_c_db(), notify = TRUE)
    req(coords)

    tryCatch(
      get_climate_data(
        coords$lat,
        coords$lon,
        as.character(input$start_date_c),
        as.character(input$stop_date_c)
      ),
      error = function(e) {
        showNotification(
          paste0("❌ Could not fetch data: ", conditionMessage(e)),
          type = "error", duration = 8
        )
        NULL
      }
    )
  })

  # ===========================================================================
  # WEATHER PLOT
  # ===========================================================================
  output$weather_plot <- renderPlot({
    df <- weather_data_chart_r()
    req(df)   # silently stop — no red error, no warning flicker

    # Additional guard: need enough rows for the chosen frequency
    n_years  <- length(unique(df$YEAR))
    n_months <- length(unique(paste(df$YEAR, df$MM)))

    if (input$freq == "ANNUAL" && n_years < 2) {
      showNotification(
        "⚠️ Annual view needs at least 2 years of data.",
        type = "warning", duration = 5
      )
      return(NULL)
    }

    if (input$freq == "MONTHLY" && n_months < 2) {
      showNotification(
        "⚠️ Monthly view needs at least 2 months of data.",
        type = "warning", duration = 5
      )
      return(NULL)
    }

    tryCatch(
      plot_weather(
        df,
        input$freq,
        input$param_c,
        input$col_c,
        input$plot_type
      ),
      error = function(e) {
        showNotification(
          paste0("❌ Plot error: ", conditionMessage(e)),
          type = "error", duration = 8
        )
        NULL
      }
    )
  })

} # end server
