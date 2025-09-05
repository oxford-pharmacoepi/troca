
#' Create the TROCA shiny app
#'
#' @param chat Ellmer chat.
#' @param storeName Name of the store or path to it, if it does not exist it
#' will be created.
#'
#' @return Opens the shiny app
#' @export
#'
troca <- function(chat, storeName = "troca") {
  # input check
  omopgenerics::assertCharacter(storeName, length = 1)

  if (file.exists(storeName)) {
    trocaPath <- storeName
  } else {
    if (!endsWith(x = storeName, suffix = ".duckdb")) {
      storeName <- paste0(storeName, ".duckdb")
    }
    trocaPath <- file.path(dataFolder(), storeName)
    if (!file.exists(trocaPath)) {
      trainModel(dbdir = trocaPath)
    }
  }

  # store
  store <- ragnar::ragnar_store_connect(location = trocaPath)
  chat <- ragnar::ragnar_register_tool_retrieve(chat = chat, store = store)

  # set prompt
  chat <- chat$set_system_prompt(value = prompt)

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

dataFolder <- function() {
  folder <- Sys.getenv("OMOP_DATA_FOLDER", unset = "")
  if (identical(folder, "")) {
    cli::cli_inform(c(
      "!" = "`OMOP_DATA_FOLDER` environment variable has not been set up, using temp folder.",
      "i" = "Please set an environement variable pointing to a folder to save data."
    ))
    folder <- file.path(tempdir(), "OMOP_DATA_FOLDER")
    dir.create(folder)
  } else {
    folder <- file.path(folder, "TROCA_MODELS")
    if (!dir.exists(folder)) {
      cli::cli_inform(c("i" = "Creating folder ({.path {folder}}) as it did not exist."))
      dir.create(folder)
    }
  }
  return(folder)
}
trainModel <- function(dbdir) {
  # read chunks
  chunks <- documentation |>
    purrr::map(\(x) x$sublinks) |>
    unlist(use.names = FALSE) |>
    unique() |>
    purrr::map(\(link) {
      tryCatch(
        expr = {
          cli::cli_inform(c("i" = "Reading information from {.url {link}}"))
          ragnar::markdown_chunk(ragnar::read_as_markdown(link), target_size = Inf)
        },
        error = function(e) {
          cli::cli_inform(c("x" = "Failed to read markdown in {.url {link}}"))
          NULL
        })
    }) |>
    purrr::compact()

  # create storage
  store <- ragnar::ragnar_store_create(
    location = dbdir,
    embed = NULL,
    name = "troca",
    overwrite = TRUE
  )

  # Embeding information
  cli::cli_inform(c(i = "Embeding retrieved information."))
  for (k in seq_along(chunks)) {
    ragnar::ragnar_store_insert(store = store, chunks = chunks[[k]])
  }

  # build store index
  ragnar::ragnar_store_build_index(store = store)
}
