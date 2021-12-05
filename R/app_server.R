#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # Your application server logic 
  hosp_data <- reactiveVal(value = data.frame(), label = "ECDC Hospital Data")
  hosp_data(pull_hosp_data(session))

  country_data <- mod_country_selector_server("country_selector_ui_1", hosp_data)
  mod_hosp_plot_server("hosp_plot_ui_1", country_data)
  mod_hosp_stats_server("hosp_stats_ui_1", country_data)

}
