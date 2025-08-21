
library(troca)
load(here::here("model", "key.RData"))

store <- ragnar::ragnar_store_connect(location = here::here("model", "troca.duckdb"))
chat <- ellmer::chat_google_gemini(api_key = google_key)

troca(store = store, chat = chat)
