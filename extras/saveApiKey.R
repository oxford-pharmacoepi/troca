
google_key <- Sys.getenv("GOOGLE_API_KEY")
save(google_key, file = here::here("extras", "shiny", "model", "key.RData"))
