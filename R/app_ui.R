#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinydashboardPlus
#' @importFrom shinydashboard dashboardBody
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic 
    dashboardPage(
     skin = "blue",
     options = list(sidebarExpandOnHover = TRUE),
     header = dashboardHeader(),
     sidebar = dashboardSidebar(
       minified = TRUE, collapsed = FALSE,
       h3(
         textOutput("data_as_of")
       ),
       mod_country_selector_ui("country_selector_ui_1"),
       br(),
       br(),
       "Source:",
       "<a href='https://www.ecdc.europa.eu/en/publications-data/download-data-hospital-and-icu-admission-rates-and-current-occupancy-covid-19'>https://www.ecdc.europa.eu/en/publications-data/download-data-hospital-and-icu-admission-rates-and-current-occupancy-covid-19</a>"
     ),
     body = dashboardBody(
       box(
         title = "Daily Metrics",
         fluidRow(
          mod_hosp_plot_ui("hosp_plot_ui_1")
        ),
        fluidRow(
          mod_hosp_stats_ui("hosp_stats_ui_1")
        )
       )
     ),
     title = "DashboardPage"
   )
  )
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
 
  tags$head(
    favicon(),
    tags$style("@import url(https://use.fontawesome.com/releases/v5.7.2/css/all.css);"),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'eu.hosp.dashboard'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}

