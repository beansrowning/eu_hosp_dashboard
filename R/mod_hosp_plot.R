#' hosp_plot UI Function
#'
#' @description A shiny Module that produces and visualizes hospital data
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @import plotly
mod_hosp_plot_ui <- function(id){
  ns <- NS(id)
  tagList(
    plotlyOutput(ns("plot"))
  )
}
    
#' hosp_plot Server Functions
#' Returns plot of hospitalization data
#' 
#' @param id,input,output,session Internal parameters for {shiny}.
#' @param the_data subset hospitalization data from selector
#' @param metrics a character vector of metrics to visualize
#' 
#' @noRd 
mod_hosp_plot_server <- function(id, the_data, metrics){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
    output$plot <- renderPlotly({
      shiny::validate(
        shiny::need(metrics(), "Waiting for indicators"),
        shiny::need(the_data(), "Waiting for data")
      )

      plot_data <- the_data()[indicators %in% metrics()]

      # TODO: We could use NSE to construct plot in a more advanced way
      metrics_quo <- lapply(metrics(), as.name)

      plot_ly(plot_data, x=~date, y=~value, color=~country, linetype=~indicator) %>%
        add_lines() %>%
        layout(
          # TODO: We could also pass layout as a reactive val
          title = sprintf("hospital_test_plot %s", id),
          xaxis = list(title = "Admission Date"),
          yaxis = list(title = "Inpatients (n)"))
    })

  })
}
