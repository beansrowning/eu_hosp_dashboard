#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {

  hosp_data <- reactiveVal(value = data.frame(), label = "ECDC Hospital Data")
  daily_indicators <- reactiveVal(value = character(), label = "Daily Hospital Indicators")
  weekly_indicators <- reactiveVal(value = character(), label = "Weekly Hospital Indicators")

  # Pull in hospital data
  hosp_data(pull_hosp_data(session))

  # Update data_as_of
  output$data_as_of <- renderText({
    date_stamp <- max(hosp_data()[, date], na.rm=TRUE)
    sprintf("Data as of:\n %s", format(date_stamp, "%B %d, %Y"))
  })
  
  # Pull names for daily and weekly metrics
  observe({
    daily_indicators(hosp_data()[grepl("daily", indicator, ignore.case = TRUE), unique(indicator)])
    weekly_indicators(hosp_data()[grepl("weekly", indicator, ignore.case = TRUE), unique(indicator)])
  })

  # Update country select values, pull subset if countries selected
  country_data <- mod_country_selector_server("country_selector_ui_1", hosp_data)

  # Update / handle Hospitalization stats and plots
  mod_hosp_plot_server("hosp_plot_ui_1", country_data, daily_indicators)
  mod_hosp_stats_server("hosp_stats_ui_1", country_data, daily_indicators)

  # Update / handle Hospitalization stats and plots
  # mod_hosp_plot_server("hosp_plot_ui_2", country_data, daily_indicators)
  # mod_hosp_stats_server("hosp_stats_ui_2", country_data, daily_indicators)


}
