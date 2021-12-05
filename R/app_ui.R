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
     skin = "midnight",
     options = list(sidebarExpandOnHover = TRUE),
     header = dashboardHeader(),
     sidebar = dashboardSidebar(minified = TRUE, collapsed = TRUE),
     body = dashboardBody(
       box(
         title = "Daily Metrics",
         fluidRow(
        column(
          width = 8,
          mod_hosp_plot_ui("hosp_plot_ui_1")
        ),
        column(
          width = 2,
          
        )
       )
     ),
     title = "DashboardPage"
   )
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

