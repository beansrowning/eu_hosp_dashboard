#' hosp_stats UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @importFrom DT dataTableOutput
mod_hosp_stats_ui <- function(id) {
  ns <- NS(id)
  tagList(
    dataTableOutput(ns("stats_table"))
  )
}

#' hosp_stats Server Functions
#'
#' @importFrom DT datatable renderDataTable
#' @noRd
mod_hosp_stats_server <- function(id, the_data, metrics) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$stats_table <- renderDataTable({
      # shiny::validate(
      #   shiny::need(metrics(), "Waiting for indicators"),
      #   shiny::need(the_data(), "Waiting for data")
      # )

      table_data_raw <- the_data()
      table_metrics <- metrics()

      table_data <- hosp_indicator_diff(table_data_raw, table_metrics)

      # warning(capture.output(table_data), immediate. = TRUE)
      table_data
    })
  })
}
