
credFile <- here::here("extras", "shiny", "credentials.json")
Sys.getenv("GOOGLE_CREDENTIALS_JSON") |>
  stringr::str_replace_all("\\\\n", "\n") |>
  stringr::str_replace_all("\\\\\"", "\"") |>
  stringr::str_replace_all("~", "\\\\n") |>
  writeLines(credFile)

Sys.setenv(GOOGLE_APPLICATION_CREDENTIALS = credFile)

envVars <- c(
  GOOGLE_API_KEY = Sys.getenv("GOOGLE_API_KEY"),
  GOOGLE_APPLICATION_CREDENTIALS = credFile
) |>
  purrr::imap_chr(\(x, nm) paste0(nm, "=\"", x, "\"")) |>
  unname()
writeLines(text = envVars, con = here::here("extras", "shiny", ".Renviron"))

print(Sys.getenv("GOOGLE_CREDENTIALS_JSON"))
print(readLines(here::here("extras", "shiny", ".Renviron")))
print(readLines(here::here("extras", "shiny", "credentials.json")))

troca:::trainModel(dbdir = here::here("extras", "shiny", "model", "troca.duckdb"))
