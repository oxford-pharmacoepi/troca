
library(troca)

print(Sys.getenv("GOOGLE_API_KEY"))

chat <- chat <- ellmer::chat_google_gemini()
troca(chat = chat)
