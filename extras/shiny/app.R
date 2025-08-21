
library(troca)

store <- ragnar::ragnar_store_connect(location = here::here("model", "troca.duckdb"))

troca(store = store)
