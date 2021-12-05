#' hosp_plot UI Function
#'
#' @description A shiny Module.
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
#'
#' @noRd 
mod_hosp_plot_server <- function(id, data){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
    ns$plot <- renderPlotly({
      NULL
    })

  })
}
    
## To be copied in the UI
# mod_hosp_plot_ui("hosp_plot_ui_1")
    
## To be copied in the server
# mod_hosp_plot_server("hosp_plot_ui_1")
