ui <-  fluidPage(
  
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")  # Link to your custom CSS
  ),
  
  
  
  div(
    img(src = "uk-extension-logo.png", style = "display: block; margin: auto; width: auto; max-width: 100%; height: auto; max-height:100px; padding-bottom: 10px"),
    style = "text-align: center; background-color: #0033A0; display: block; margin: auto; width: auto; max-width: 100%; padding-bottom: 10px",
    style = "padding-bottom: 10px;"
  ),
  
  
  navbarPage(title = "",
             id = 'main',
             
             tabPanel("HOME",
                      div(
                        h2("Welcome to the NASA POWER Data Viewer"),
                        p("Developed by Dr. Mohammad Shamim, Extension Associate, University of Kentucky"),
                        p("Modified with suggestions from Dr. Chad Lee."),
                        p("This web application provides meteorological data based on a single-point coordinate system (e.g. lat = 38.5604251; lon = -84.5001234)."),
                        p("The data presented here is sourced from NASA POWER (Prediction of Worldwide Energy Resources) to support the agricultural community."),
                        h3("How to Use the App"),
                        p("The NASA POWER Viewer App is an interactive tool designed to assist users in retrieving meteorological data, including average temperature (Tmean),
                        minimum temperature (Tmin), maximum temperature (Tmax), relative humidity (RH), precipitation, and solar radiation (both with cloud cover, Radiation_All_Sky, and assuming a clear sky, Radiation_Clear_Sky). 
                            To get started, navigate to the 'WEATHER DATA - TABLE' tab, where you can view, explore, and download weather data in table format. Enter the coordinates for your area of interest,
                          select the weather frequency, choose a parameter, and set the start and end dates. Please click the 'Download Dataset' button only after table appears on the screen. To find coordinates, use Google or Apple Maps. On Google Maps, right-click to see coordinates; on a smartphone,
                          long-press the area of interest, then tap 'Dropped pin' to view coordinates."),
                        p("In the 'WEATHER DATA - CHART' view, you can visualize the data as a line chart. You need at least two months/years of data to show it as a line chart when frequency is selected as 'MONTHLY' or 'ANNUAL'. Please keep in mind that 
                          this app return historical data (not current). The 'WEATHER DATA - KENTUCKY' tab provides links to websites that offer comprehensive weather reports for Kentucky."),
                        p("Please note: We do not accept any liability for the accuracy, completeness, or usefulness of the data provided. Users should verify all information with other reliable sources.
                            For more information, please visit ", a("NASA POWER", href = "https://power.larc.nasa.gov", target = "_blank"), "."),
                        p("For questions or inquiries, feel free to contact us at mshamim11@uky.edu."),
                        p("If you are interested in this kind of intereactive tools, you can check our", a("NASS DATA Viewer", href = "https://uk-extension.shinyapps.io/nass/", target = "_blank")),
                        br()
                      )
                      
             ),
             
             # Each tab is now its own tabPanel
             tabPanel("WEATHER DATA - TABLE",
                      sidebarLayout(
                        sidebarPanel(
                          h3("PARAMETERS"),
                          h3(" "),
                          h3(" "),
                          textInput(inputId = 'lat',
                                    label = 'Latitude', placeholder = 38.0364354),
                          textInput(inputId = 'lon',
                                    label = 'Longitude', placeholder =   -84.5000352),
                          dateInput('start_date',
                                    label = "Start date"), 
                          dateInput('stop_date', 
                                    label = "Stop date"),
                          submitButton("Submit")
                        ),
                        mainPanel(
                          DTOutput('weather_data'),
                          br(),
                          downloadButton(outputId = "downloadDataweather",
                                         label = "Download Dataset")
                        )
                      )
             ),
             
             tabPanel("WEATHER DATA - CHART",
                      sidebarLayout(
                        sidebarPanel(
                          h3("PARAMETERS"),
                          textInput(inputId = 'lat_c',
                                    label = 'Latitude', placeholder = 38.0364354),
                          textInput(inputId = 'lon_c',
                                    label = 'Longitude', placeholder =   -84.5000352),
                          selectInput('freq',
                                      label = "Frequency", 
                                      choices = c("DAILY", 
                                                  "MONTHLY",
                                                  "ANNUAL")),
                          selectInput('param_c',
                                      label = "Variable", 
                                      choices = c("Tmin", 
                                                  "Tmean",
                                                  "Tmax",
                                                  "Precipitation", 
                                                  "Relative_Humidity",
                                                  "Radiation_All_Sky", 
                                                  "Radiation_Clear_Sky")),
                          selectInput('col_c',
                                      label = "Chart color", 
                                      choices = c("blue", 
                                                  "black",
                                                  "darkblue",
                                                  "cornflowerblue", 
                                                  "red",
                                                  'darkred',
                                                  'green', 
                                                  "forestgreen",
                                                  'cyan', 
                                                  'orange', 
                                                  'yellow', 
                                                  'purple', 
                                                  'brown',
                                                  'gold',
                                                  'gray',
                                                  'pink')),
                          dateInput('start_date_c',
                                    label = "Start date"), 
                          dateInput('stop_date_c', 
                                    label = "Stop date"), 
                          submitButton("Submit")
                        ),
                        mainPanel(
                          plotOutput("weather_plot", height = "500px", width = "100%")
                        )
                      )
             ),
             
             tabPanel("WEATHER DATA - KENTUCKY",
                      HTML("
                          <h3>Welcome to the Kentucky Weather Information Page</h3>
                          <p>This tab provides links to weather information for Kentucky. For detailed weather forecasts and data, you can visit:</p>
                          <ul>
                            <li><a href='https://www.kymesonet.org/' target='_blank'>KENTUCKY MESONET | WKU</a></li>
                            <li><a href='http://weather.uky.edu/' target='_blank'>UK Ag WEATHER CENTER</a></li>
                          </ul>
                          <p>Stay updated with the latest weather conditions!</p>
                    "))
  )
  
             
             

  
)
