
#troca:::trainModel(dbdir = here::here("extras", "shiny", "model", "troca.duckdb"))
writeLines(
  text = paste0("GOOGLE_API_KEY=\"", Sys.getenv("GOOGLE_API_KEY"), "\""),
  con = here::here("extras", "shiny", ".Renviron")
)
