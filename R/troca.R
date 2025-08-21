
#' Create the TROCA shiny app
#'
#' @param store Link to the store object.
#' @param chat Ellmer chat.
#'
#' @return Opens the shiny app
#' @export
#'
troca <- function(store, chat) {

  chat <- chat$set_system_prompt(value = prompt)

  chat <- ragnar::ragnar_register_tool_retrieve(
    chat = chat,
    store = store,
    top_k = 10
  )

  ui <- bslib::page_fluid(
    shinychat::chat_ui("chat")
  )

  server <- function(input, output, session) {
    shiny::observeEvent(input$chat_user_input, {
      stream <- chat$stream_async(input$chat_user_input)
      shinychat::chat_append(id = "chat", response = stream)
    })
  }

  shiny::shinyApp(ui, server)
}

appendSublinks <- function(x) {
  x |>
    purrr::map(\(x) {
      sublinks <- ragnar::ragnar_find_links(x = x$link)
      x$sublinks <- sublinks[!basename(sublinks) %in% c("CONTRIBUTING.html", "LICENSE.html")]
      x
    })
}

trainModel <- function(path) {
  dbdir <- file.path(path, "troca.duckdb")
  unlink(dbdir, force = TRUE)
  unlink(paste0(dbdir, ".wal"), force = TRUE)

  store <- ragnar::ragnar_store_create(
    location = dbdir,
    embed = \(x) ragnar::embed_ollama(x, model = "mxbai-embed-large"),
    name = "troca"
  )

  # read chunks
  chunks <- documentation |>
    appendSublinks() |>
    purrr::map(\(x) x$sublinks) |>
    unlist(use.names = FALSE) |>
    unique() |>
    purrr::map(\(link) {
      tryCatch(
        expr = {
          cli::cli_inform(c("i" = "Reading information from {.url {link}}"))
          ragnar::markdown_chunk(ragnar::read_as_markdown(link))
        },
        error = function(e) {
          cli::cli_inform(c("x" = "Failed to read markdown in {.url {link}}"))
          NULL
        })
    }) |>
    purrr::compact()

  # Embeding information
  cli::cli_inform(c(i = "Embeding retrieved information."))
  cli::cli_progress_bar("Embeding", total = length(chunks), type = "tasks")
  for (k in seq_along(chunks)) {
    ragnar::ragnar_store_insert(store = store, chunks = chunks[[k]])
    cli::cli_progress_update()
  }
  cli::cli_progress_done()

  # build store index
  ragnar::ragnar_store_build_index(store = store)
}
