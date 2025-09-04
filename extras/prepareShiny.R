
troca:::trainModel(dbdir = here::here("extras", "shiny", "model", "troca.duckdb"))
envVars <- c(
  GOOGLE_API_KEY = Sys.getenv("GOOGLE_API_KEY")
) |>
  purrr::imap_chr(\(x, nm) paste0(nm, "=\"", x, "\"")) |>
  unname()
writeLines(text = envVars, con = here::here("extras", "shiny", ".Renviron"))
