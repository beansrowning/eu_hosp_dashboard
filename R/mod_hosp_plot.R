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
#' @param data Hospitalization data from ECDC
#' @noRd 
mod_hosp_plot_server <- function(id, data){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
    ns$plot <- renderPlotly({
      # TODO: Write plot
      plot_ly
    })

  })
}
