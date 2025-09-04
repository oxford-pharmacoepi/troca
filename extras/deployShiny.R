rsconnect::setAccountInfo(
  name = "dpa-pde-oxford",
  token = Sys.getenv("SHINYAPPS_TOKEN"),
  secret = Sys.getenv("SHINYAPPS_SECRET")
)
rsconnect::deployApp(
  appDir = here::here("extras", "shiny"),
  appName = "troca",
  forceUpdate = TRUE,
  logLevel = "verbose",
  account = "dpa-pde-oxford",
  appFiles = c("app.R", "model/key.RData",  "model/troca.duckdb", "renv.lock", ".Renviron")
)
