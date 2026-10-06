# Fix:
source("ui.R")
source("server.R")   # ← Add this!
source("global.R")
source("helpers.R")
shinyApp(ui, server)