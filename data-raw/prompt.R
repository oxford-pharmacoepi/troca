
prompt <- stringr::str_squish(
  "
  You are an expert R programmer and epidemiologist working with OMOP CDM data.
  Use concise, accurate R examples using OMOPverse packages (e.g. CDMConnector,
  CohortConstructor).

  Before answering:
  - Retrieve relevant documents from the knowledge store.
  - Quote or paraphrase the material retrieved, clearly separating source vs your own explanation.
  - Include direct links to cited content (e.g. .io documentation pages).
  - If no relevant information is found, say 'No information available'.

  Only answer if source material is retrieved.
  "
)

# documentation to train troca
documentation <- list(
  "Tidy R programming with OMOP" = list(
    link = "https://oxford-pharmacoepi.github.io/Tidy-R-programming-with-OMOP/"
  ),
  "CDMConnector" = list(
    link = "https://darwin-eu.github.io/CDMConnector/"
  ),
  "omopgenerics" = list(
    link = "https://darwin-eu.github.io/omopgenerics/"
  ),
  "CohortConstructor" = list(
    link = "https://ohdsi.github.io/CohortConstructor/"
  ),
  "visOmopResults" = list(
    link = "https://darwin-eu.github.io/visOmopResults/"
  ),
  "PhenotypeR" = list(
    link = "https://ohdsi.github.io/PhenotypeR/"
  ),
  "OmopViewer" = list(
    link = "https://ohdsi.github.io/OmopViewer/"
  ),
  "DrugUtilisation" = list(
    link = "https://darwin-eu.github.io/DrugUtilisation/"
  ),
  "IncidencePrevalence" = list(
    link = "https://darwin-eu.github.io/IncidencePrevalence/"
  ),
  "DrugExposureDiagnostics" = list(
    link = "https://darwin-eu.github.io/DrugExposureDiagnostics/"
  ),
  "MeasurementDiagnostics" = list(
    link = "https://ohdsi.github.io/MeasurementDiagnostics/"
  ),
  "PatientProfiles" = list(
    link = "https://darwin-eu.github.io/PatientProfiles/"
  ),
  "CohortCharacteristics" = list(
    link = "https://darwin-eu.github.io/CohortCharacteristics/"
  ),
  "OmopSketch" = list(
    link = "https://OHDSI.github.io/OmopSketch/"
  ),
  "CodelistGenerator" = list(
    link = "https://darwin-eu.github.io/CodelistGenerator/"
  ),
  "CohortSurvival" = list(
    link = "https://darwin-eu-dev.github.io/CohortSurvival/"
  ),
  "omock" = list(
    link = "https://ohdsi.github.io/omock/"
  )
) |>
  purrr::map(\(x) {
    sublinks <- ragnar::ragnar_find_links(x = x$link)
    sublinks <- sublinks[!endsWith(x = sublinks, suffix = "/")]
    x$sublinks <- sublinks[!basename(sublinks) %in% c("CONTRIBUTING.html", "LICENSE.html", "authors.html")]
    x
  })

usethis::use_data(prompt, documentation, overwrite = TRUE, internal = TRUE)
