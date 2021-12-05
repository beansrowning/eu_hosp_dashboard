#' country_selector UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_country_selector_ui <- function(id) {
  ns <- NS(id)
  tagList(
    selectInput(
      ns("country_choice"),
      label = "Choose Country",
      choices = character(),
      multiple = TRUE
    )
  )
}

#' country_selector Server Functions
#'
#' Server-side handling of country select input.
#' On init: Populates selector with list of countries from data.
#' Reactively filters hospital data by countries selected and returns
#' data for plotting / downstream handling
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @param the_data a reactive containing ECDC data
#'
#' @noRd
mod_country_selector_server <- function(id, the_data) {
  moduleServer(id, function(input, output, session) {
    # Update choices once data resolves
    observe({
      # dt <- need(validate(the_data()), "Waiting for data")
      # Pull list of countries from data
      countries <- the_data()[, unique(country)]

      # warning(sprintf("Countries: %s", paste(countries, collapse = ",")), immediate. = TRUE)
      # Update select input with countries
      updateSelectInput(
        session,
        "country_choice",
        choices = countries,
        selected = countries[1]
      )
    })

    country_selected_data <- reactive({
      # shiny::validate(
      #   shiny::need(input$country_choice,"Select countries", "boop") #,
      #   # shiny::need(the_data(), "Waiting for data")
      # )

      the_data()[country %in% input$country_choice]
    })

    return(country_selected_data)
  })
}
