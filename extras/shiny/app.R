
library(troca)

chat <- chat <- ellmer::chat_google_gemini()
troca(chat = chat, storeName = here::here("model", "troca.duckdb"))
