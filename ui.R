ui <- fluidPage(
  
  # ============================================================
  # HEAD: CSS + JS (single tags$head block — no duplicates)
  # ============================================================
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
    tags$link(rel = "stylesheet",
              href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"),
    
    tags$style(HTML("

      /* ── Global ─────────────────────────────────────── */
      body {
        font-family: 'Segoe UI', Arial, sans-serif;
        background-color: #f4f6f9;
        color: #2c3e50;
      }

      /* ── Top Banner ─────────────────────────────────── */
      .app-banner {
        background: linear-gradient(135deg, #0033A0 0%, #0055CC 60%, #0077FF 100%);
        padding: 18px 30px 14px 30px;
        text-align: center;
        box-shadow: 0 3px 10px rgba(0,0,0,0.25);
        margin-bottom: 0;
      }
      .app-banner h1 {
        color: #ffffff;
        font-size: 28px;
        font-weight: 800;
        letter-spacing: 2px;
        margin: 0;
        text-shadow: 1px 1px 4px rgba(0,0,0,0.3);
      }
      .app-banner h4 {
        color: #cce0ff;
        font-size: 14px;
        margin: 4px 0 0 0;
        font-weight: 400;
        letter-spacing: 1px;
      }
      .banner-icons {
        font-size: 22px;
        color: #cce0ff;
        margin-bottom: 4px;
      }

      /* ── Navbar ─────────────────────────────────────── */
      .navbar {
        background-color: #ffffff !important;
        border-bottom: 3px solid #0033A0;
        box-shadow: 0 2px 6px rgba(0,0,0,0.08);
        margin-bottom: 0 !important;
      }
      .navbar-nav > li > a {
        color: #0033A0 !important;
        font-weight: 600;
        font-size: 13px;
        letter-spacing: 0.5px;
        padding: 14px 16px !important;
        transition: background 0.2s;
      }
      .navbar-nav > li > a:hover {
        background-color: #e8f0fe !important;
        color: #0055CC !important;
        border-radius: 4px;
      }
      .navbar-nav > li.active > a {
        background-color: #0033A0 !important;
        color: #ffffff !important;
        border-radius: 4px;
      }

      /* ── HOME page cards ─────────────────────────────── */
      .home-wrapper {
        max-width: 960px;
        margin: 30px auto;
        padding: 0 20px 40px 20px;
      }
      .home-card {
        background: #ffffff;
        border-radius: 12px;
        padding: 28px 32px;
        margin-bottom: 22px;
        box-shadow: 0 2px 12px rgba(0,51,160,0.08);
        border-left: 5px solid #0033A0;
      }
      .home-card h2 {
        color: #0033A0;
        font-size: 22px;
        font-weight: 700;
        margin-top: 0;
      }
      .home-card h3 {
        color: #0055CC;
        font-size: 16px;
        font-weight: 700;
        margin-top: 0;
      }
      .home-card p, .home-card li {
        font-size: 14px;
        line-height: 1.75;
        color: #444;
        text-align: justify;
      }
      .step-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 16px;
        margin-top: 10px;
      }
      .step-box {
        background: #f0f4ff;
        border-radius: 8px;
        padding: 14px 16px;
        border: 1px solid #ccd9f5;
      }
      .step-box .step-num {
        font-size: 22px;
        font-weight: 800;
        color: #0033A0;
      }
      .step-box p {
        margin: 4px 0 0 0;
        font-size: 13px;
        color: #333;
        text-align: left;
      }
      .badge-row {
        display: flex;
        flex-wrap: wrap;
        gap: 8px;
        margin-top: 10px;
      }
      .param-badge {
        background: #0033A0;
        color: white;
        border-radius: 20px;
        padding: 4px 12px;
        font-size: 12px;
        font-weight: 600;
      }
      .disclaimer-box {
        background: #fff8e1;
        border-left: 5px solid #f59e0b;
        border-radius: 8px;
        padding: 14px 18px;
        font-size: 13px;
        color: #555;
      }
      .link-card {
        display: inline-block;
        background: #0033A0;
        color: white !important;
        padding: 8px 18px;
        border-radius: 6px;
        font-size: 13px;
        font-weight: 600;
        margin: 4px 4px 4px 0;
        text-decoration: none !important;
        transition: background 0.2s;
      }
      .link-card:hover { background: #0055CC; }

      /* ── Sidebar panels ──────────────────────────────── */
      .well {
        background: #ffffff !important;
        border: 1px solid #dde3f0 !important;
        border-radius: 10px !important;
        box-shadow: 0 2px 10px rgba(0,51,160,0.07) !important;
        padding: 20px !important;
      }
      .sidebar-title {
        font-size: 13px;
        font-weight: 700;
        letter-spacing: 1px;
        color: #ffffff;
        background: linear-gradient(90deg, #0033A0, #0055CC);
        padding: 8px 14px;
        border-radius: 6px;
        margin-bottom: 16px;
        display: block;
        text-transform: uppercase;
      }
      label {
        font-size: 12px !important;
        font-weight: 600 !important;
        color: #444 !important;
        margin-top: 8px !important;
      }
      .form-control {
        border-radius: 6px !important;
        border: 1px solid #c5cfe8 !important;
        font-size: 13px !important;
      }
      .form-control:focus {
        border-color: #0033A0 !important;
        box-shadow: 0 0 0 2px rgba(0,51,160,0.15) !important;
      }
      select.form-control { cursor: pointer; }

      /* ── Buttons ─────────────────────────────────────── */
      .btn-location {
        background: transparent;
        color: #0033A0;
        border: 1.5px solid #0033A0;
        border-radius: 6px;
        font-size: 12px;
        font-weight: 600;
        padding: 5px 12px;
        width: 100%;
        margin-top: 6px;
        transition: all 0.2s;
      }
      .btn-location:hover {
        background: #0033A0;
        color: white;
      }
      .btn-submit {
        background: linear-gradient(135deg, #0033A0, #0055CC) !important;
        color: white !important;
        border: none !important;
        border-radius: 6px !important;
        font-weight: 700 !important;
        font-size: 13px !important;
        padding: 8px 0 !important;
        width: 100%;
        margin-top: 14px !important;
        letter-spacing: 0.5px;
        box-shadow: 0 3px 8px rgba(0,51,160,0.3);
        transition: all 0.2s;
      }
      .btn-submit:hover {
        background: linear-gradient(135deg, #002280, #0044AA) !important;
        box-shadow: 0 5px 12px rgba(0,51,160,0.4);
      }
      .btn-download {
        background: #28a745 !important;
        color: white !important;
        border: none !important;
        border-radius: 6px !important;
        font-size: 13px !important;
        font-weight: 600 !important;
        padding: 7px 18px !important;
        margin-top: 14px;
        box-shadow: 0 2px 6px rgba(40,167,69,0.3);
      }
      .btn-download:hover { background: #1e7e34 !important; }

      /* ── Status text ─────────────────────────────────── */
      .location-status {
        font-size: 11px;
        margin-top: 5px;
        min-height: 16px;
        color: #555;
        font-style: italic;
      }

      /* ── Main panel ──────────────────────────────────── */
      .main-panel-box {
        background: #ffffff;
        border-radius: 10px;
        padding: 20px;
        box-shadow: 0 2px 10px rgba(0,51,160,0.07);
        border: 1px solid #dde3f0;
      }
      .plot-caption {
        font-size: 12px;
        color: #777;
        font-style: italic;
        margin-top: 8px;
        text-align: center;
      }

      /* ── DT table ────────────────────────────────────── */
      .dataTables_wrapper .dataTables_filter input {
        border: 1px solid #c5cfe8;
        border-radius: 5px;
        padding: 4px 8px;
      }
      table.dataTable thead th {
        background-color: #0033A0 !important;
        color: white !important;
        font-size: 12px;
      }

      /* ── Kentucky tab ────────────────────────────────── */
      .ky-card {
        background: white;
        border-radius: 10px;
        padding: 30px;
        margin: 30px auto;
        max-width: 700px;
        box-shadow: 0 2px 12px rgba(0,51,160,0.08);
        border-left: 5px solid #0033A0;
      }
      .ky-card h3 { color: #0033A0; font-weight: 700; margin-top: 0; }
      .ky-link-btn {
        display: block;
        background: #f0f4ff;
        border: 1.5px solid #0033A0;
        border-radius: 8px;
        padding: 14px 20px;
        margin-bottom: 12px;
        color: #0033A0 !important;
        font-weight: 600;
        font-size: 14px;
        text-decoration: none !important;
        transition: all 0.2s;
      }
      .ky-link-btn:hover {
        background: #0033A0;
        color: white !important;
      }
      .ky-link-btn i { margin-right: 10px; }

      /* ── Footer ──────────────────────────────────────── */
      .app-footer {
        background: #0033A0;
        color: #cce0ff;
        text-align: center;
        font-size: 12px;
        padding: 12px;
        margin-top: 40px;
      }
      .app-footer a { color: #89b8ff; text-decoration: none; }

    ")),
    
    # ── Geolocation JS ──────────────────────────────────────
    tags$script(HTML("
      function getLocation(inputId, statusId) {
        var statusEl = document.getElementById(statusId);
        if (!navigator.geolocation) {
          statusEl.innerText = '❌ Browser does not support geolocation.';
          return;
        }
        if (navigator.permissions) {
          navigator.permissions.query({name: 'geolocation'}).then(function(result) {
            if (result.state === 'denied') {
              statusEl.innerText = '❌ Permission denied — allow location in browser settings.';
            }
          });
        }
        statusEl.innerText = '⏳ Detecting your location...';
        navigator.geolocation.getCurrentPosition(
          function(position) {
            var lat = position.coords.latitude.toFixed(6);
            var lon = position.coords.longitude.toFixed(6);
            var val = lat + ', ' + lon;
            var el = document.getElementById(inputId);
            el.value = val;
            el.dispatchEvent(new Event('input', {bubbles: true}));
            statusEl.innerText = '✅ Detected: ' + val;
          },
          function(error) {
            switch(error.code) {
              case 1: statusEl.innerText = '❌ Permission denied — check browser settings.'; break;
              case 2: statusEl.innerText = '❌ Position unavailable — check internet/GPS.'; break;
              case 3: statusEl.innerText = '❌ Timed out — please try again.'; break;
              default: statusEl.innerText = '❌ Error: ' + error.message;
            }
          },
          { timeout: 10000, maximumAge: 60000, enableHighAccuracy: false }
        );
      }
    "))
  ),
  
  # ============================================================
  # BANNER
  # ============================================================
  div(class = "app-banner",
      div(class = "banner-icons",
          HTML('<i class="fa-solid fa-satellite"></i> &nbsp;
            <i class="fa-solid fa-cloud-sun-rain"></i> &nbsp;
            <i class="fa-solid fa-seedling"></i>')
      ),
      h1("NASA POWER DATA VIEWER"),
      h4("Meteorological Data for Agriculture | University of Kentucky Extension")
  ),
  
  # ============================================================
  # NAVBAR
  # ============================================================
  navbarPage(
    title = "",
    id    = "main",
    
    # ── HOME ──────────────────────────────────────────────────
    tabPanel(
      HTML('<i class="fa-solid fa-house"></i>  HOME'),
      
      div(class = "home-wrapper",
          
          # Welcome card
          div(class = "home-card",
              h2(HTML('<i class="fa-solid fa-satellite" style="margin-right:10px;"></i>Welcome to the NASA POWER Data Viewer')),
              p("Developed by ", tags$strong("Dr. Mohammad Jan Shamim"), ", Extension Associate, University of Kentucky."),
              p("Modified with suggestions from ", tags$strong("Dr. Chad Lee"), "."),
              p("This web application provides daily meteorological data for any location worldwide,
            based on a single-point coordinate system using NASA POWER (Prediction of Worldwide
            Energy Resources) — a trusted source for agricultural climate data.")
          ),
          
          # Parameters badges
          div(class = "home-card",
              h3(HTML('<i class="fa-solid fa-temperature-half" style="margin-right:8px;"></i>Available Parameters')),
              div(class = "badge-row",
                  span(class = "param-badge", "🌡 Tmin"),
                  span(class = "param-badge", "🌡 Tmean"),
                  span(class = "param-badge", "🌡 Tmax"),
                  span(class = "param-badge", "🌧 Precipitation"),
                  span(class = "param-badge", "💧 Relative Humidity"),
                  span(class = "param-badge", "☀️ Radiation (All Sky)"),
                  span(class = "param-badge", "🌤 Radiation (Clear Sky)")
              )
          ),
          
          # How to use — step grid
          div(class = "home-card",
              h3(HTML('<i class="fa-solid fa-circle-question" style="margin-right:8px;"></i>How to Use')),
              div(class = "step-grid",
                  div(class = "step-box",
                      div(class = "step-num", "①"),
                      p(tags$strong("Get coordinates:"), " Right-click on Google Maps, or long-press on a smartphone then tap 'Dropped pin'.
                You can also press the ", tags$em("📍 Use My Location"), " button.")
                  ),
                  div(class = "step-box",
                      div(class = "step-num", "②"),
                      p(tags$strong("TABLE tab:"), " Enter coordinates and date range → Submit → explore data in the table →
                click ", tags$em("Download Dataset"), " once the table appears.")
                  ),
                  div(class = "step-box",
                      div(class = "step-num", "③"),
                      p(tags$strong("CHART tab:"), " Choose frequency (Daily / Monthly / Annual), plot type (Individual or Overview),
                variable, color, and dates → Submit.")
                  ),
                  div(class = "step-box",
                      div(class = "step-num", "④"),
                      p(tags$strong("Tip:"), " Adjust your browser width to resize the chart.
                Monthly/Annual views need at least 2 months/years of data for line charts.
                This app returns ", tags$strong("historical data only"), ".")
                  )
              )
          ),
          
          # Disclaimer
          div(class = "home-card",
              div(class = "disclaimer-box",
                  HTML('<i class="fa-solid fa-triangle-exclamation" style="color:#f59e0b; margin-right:8px;"></i>
                  <strong>Disclaimer:</strong> We do not accept liability for the accuracy, completeness, or usefulness
                  of the data. Users should verify all information with other reliable sources.
                  For more information, visit <a href="https://power.larc.nasa.gov" target="_blank">NASA POWER</a>.')
              ),
              br(),
              p(
                HTML('<i class="fa-solid fa-envelope" style="margin-right:6px; color:#0033A0;"></i>'),
                "Questions or inquiries? ", a("Contact us", href = "mailto:mshamim11@uky.edu", target = "_blank"), ".",
                tags$br(),
                HTML('<i class="fa-solid fa-chart-bar" style="margin-right:6px; color:#0033A0;"></i>'),
                "Also explore our ", a("NASS Data Viewer", href = "https://uk-extension.shinyapps.io/nass/", target = "_blank"), "."
              )
          )
      )
    ),
    
    # ── WEATHER DATA - TABLE ──────────────────────────────────
    tabPanel(
      HTML('<i class="fa-solid fa-table"></i>  DATA TABLE'),
      
      br(),
      sidebarLayout(
        sidebarPanel(
          width = 3,
          span(class = "sidebar-title",
               HTML('<i class="fa-solid fa-sliders"></i>  Parameters')),
          
          tags$label(HTML('<i class="fa-solid fa-location-dot"></i>  Latitude, Longitude')),
          textInput(inputId = "latlong",
                    label   = NULL,
                    placeholder = "e.g. 38.0364, -84.5000"),
          actionButton("get_location",
                       HTML('<i class="fa-solid fa-crosshairs"></i>  Use My Location'),
                       onclick = "getLocation('latlong', 'location_status')",
                       class   = "btn-location"),
          div(class = "location-status", textOutput("location_status")),
          
          hr(style = "border-color: #dde3f0; margin: 14px 0;"),
          
          dateInput("start_date", HTML('<i class="fa-solid fa-calendar-days"></i>  Start Date')),
          dateInput("stop_date",  HTML('<i class="fa-solid fa-calendar-check"></i>  End Date')),
          
          submitButton(HTML('<i class="fa-solid fa-rocket"></i>  Fetch Data'))
        ),
        
        mainPanel(
          width = 9,
          div(class = "main-panel-box",
              DTOutput("weather_data"),
              br(),
              downloadButton(outputId = "downloadDataweather",
                             label    = HTML('<i class="fa-solid fa-file-csv"></i>  Download Dataset'),
                             class    = "btn btn-download")
          )
        )
      )
    ),
    
    # ── WEATHER DATA - CHART ──────────────────────────────────
    tabPanel(
      HTML('<i class="fa-solid fa-chart-line"></i>  CHART'),
      
      br(),
      sidebarLayout(
        sidebarPanel(
          width = 3,
          span(class = "sidebar-title",
               HTML('<i class="fa-solid fa-sliders"></i>  Parameters')),
          
          tags$label(HTML('<i class="fa-solid fa-location-dot"></i>  Latitude, Longitude')),
          textInput(inputId = "latlong_c",
                    label   = NULL,
                    placeholder = "e.g. 38.0364, -84.5000"),
          actionButton("get_location_c",
                       HTML('<i class="fa-solid fa-crosshairs"></i>  Use My Location'),
                       onclick = "getLocation('latlong_c', 'location_status_c')",
                       class   = "btn-location"),
          div(class = "location-status", textOutput("location_status_c")),
          
          hr(style = "border-color: #dde3f0; margin: 14px 0;"),
          
          selectInput("freq", HTML('<i class="fa-solid fa-calendar-week"></i>  Frequency'),
                      choices  = c("DAILY", "MONTHLY", "ANNUAL"),
                      selected = "DAILY"),
          
          selectInput("plot_type", HTML('<i class="fa-solid fa-chart-area"></i>  Plot Type'),
                      choices  = c("Individual Parameter", "Overview"),
                      selected = "Individual Parameter"),
          
          conditionalPanel(
            condition = "input.plot_type == 'Individual Parameter'",
            selectInput("param_c", HTML('<i class="fa-solid fa-thermometer-half"></i>  Variable'),
                        choices = c("Tmin", "Tmean", "Tmax",
                                    "Precipitation", "Relative_Humidity",
                                    "Radiation_All_Sky", "Radiation_Clear_Sky"))
          ),
          
          conditionalPanel(
            condition = "input.plot_type == 'Individual Parameter'",
            selectInput("col_c", HTML('<i class="fa-solid fa-palette"></i>  Chart Color'),
                        choices = c("blue", "black", "darkblue", "cornflowerblue",
                                    "red", "darkred", "green", "forestgreen",
                                    "cyan", "orange", "purple", "brown",
                                    "gold", "gray", "pink"))
          ),
          
          hr(style = "border-color: #dde3f0; margin: 14px 0;"),
          
          dateInput("start_date_c", HTML('<i class="fa-solid fa-calendar-days"></i>  Start Date')),
          dateInput("stop_date_c",  HTML('<i class="fa-solid fa-calendar-check"></i>  End Date')),
          
          submitButton(HTML('<i class="fa-solid fa-rocket"></i>  Generate Chart'))
        ),
        
        mainPanel(
          width = 9,
          div(class = "main-panel-box",
              shinycssloaders::withSpinner(
                plotOutput("weather_plot", height = "620px", width = "100%"),
                type  = 6,
                color = "#0033A0"
              ),
              p(class = "plot-caption",
                HTML('<i class="fa-solid fa-circle-info"></i>
                    Adjust your browser width to resize the chart. &nbsp;|&nbsp;
                    Data source: <a href="https://power.larc.nasa.gov" target="_blank">NASA POWER</a>'))
          )
        )
      )
    ),
    
    # ── KENTUCKY WEATHER ──────────────────────────────────────
    tabPanel(
      HTML('<i class="fa-solid fa-horse"></i>  KENTUCKY'),
      
      div(class = "ky-card",
          h3(HTML('<i class="fa-solid fa-map-location-dot"></i>  Kentucky Weather Resources')),
          p("This tab provides links to comprehensive weather information sources for Kentucky.
          Stay updated with current conditions, forecasts, and agricultural weather data."),
          br(),
          a(class = "ky-link-btn",
            href   = "https://www.kymesonet.org/",
            target = "_blank",
            HTML('<i class="fa-solid fa-tower-broadcast"></i> Kentucky Mesonet | WKU — Real-time weather station network')),
          a(class = "ky-link-btn",
            href   = "http://weather.uky.edu/",
            target = "_blank",
            HTML('<i class="fa-solid fa-leaf"></i> UK Agricultural Weather Center — Ag-focused forecasts & data')),
          br(),
          p(style = "color: #777; font-size: 12px; font-style: italic;",
            HTML('<i class="fa-solid fa-circle-info"></i>
                Links open in a new tab. Stay updated with the latest weather conditions!'))
      )
    )
  ),
  
  # ============================================================
  # FOOTER
  # ============================================================
  div(class = "app-footer",
      HTML('
      <i class="fa-solid fa-satellite"></i> &nbsp;
      NASA POWER Data Viewer &nbsp;|&nbsp;
      University of Kentucky Extension &nbsp;|&nbsp;
      Developed by Dr. Mohammad Jan Shamim &nbsp;|&nbsp;
      <a href="mailto:mshamim11@uky.edu">mshamim11@uky.edu</a>
    ')
  )
)
