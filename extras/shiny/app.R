
library(troca)
load(here::here("model", "key.RData"))

chat <- chat <- ellmer::chat_google_gemini()
troca(chat = chat)
