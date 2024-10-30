source("helpers.R")

# readRenviron("C:\\Users\\msh404\\Documents\\.Renviron")

server <- function(input, output, session) {
  
  #=============================================================================
  #weather data 
  #=============================================================================
  output$weather_data <- renderDT({
    
    tryCatch(
      {
        get_climate_data(parse_number(input$lat), parse_number(input$lon),
                         as.character(input$start_date),
                         as.character(input$stop_date))
      },
      error = function(e) {
        showNotification("Please insert the latitude and longitude!", type = "error")
        return(NULL)  # Return NULL if there is an error in fetching data
      }
    )
  })
  
  # download the data
  output$downloadDataweather <- downloadHandler(
    filename = function(){
      paste("weather_data", now(), ".csv", sep = "")},
    content = function(file) {
      write.csv(get_climate_data(parse_number(input$lat), parse_number(input$lon),
                                 as.character(input$start_date),
                                 as.character(input$stop_date)), file, row.names = F, na ="")
    })
  
  #### weather plot
  output$weather_plot <- renderPlot({
    tryCatch(
      {
        plot_weather(get_climate_data(parse_number(input$lat_c), parse_number(input$lon_c),
                                      as.character(input$start_date_c),
                                      as.character(input$stop_date_c)), input$freq, input$param_c, input$col_c)
      },
      error = function(e) {
        showNotification("Please double check the input parameters!", type = "error")
      }
    )
  })
  
  
  
} # closing server function 