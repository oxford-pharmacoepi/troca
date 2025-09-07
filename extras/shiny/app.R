
library(troca)
library(gargle) # needed for authetication

chat <- chat <- ellmer::chat_google_gemini()
troca(chat = chat, storeName = here::here("model", "troca.duckdb"))
