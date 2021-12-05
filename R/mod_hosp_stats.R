#' hosp_stats UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_hosp_stats_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' hosp_stats Server Functions
#'
#' @noRd 
mod_hosp_stats_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_hosp_stats_ui("hosp_stats_ui_1")
    
## To be copied in the server
# mod_hosp_stats_server("hosp_stats_ui_1")
