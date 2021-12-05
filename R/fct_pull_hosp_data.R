#' pull_hosp_data
#'
#' @description Return ECDC Hospital data as data.table
#'
#' @return The return value, if any, from executing the function.
#'
#' @importFrom data.table fread
#' @importFrom shinybusy show_modal_spinner remove_modal_spinner
#' @noRd
pull_hosp_data <- function(session, url = "https://opendata.ecdc.europa.eu/covid19/hospitalicuadmissionrates/csv/data.csv") {
  show_modal_spinner(session = session, text = "Pulling data, please wait.")
  on.exit(remove_modal_spinner())
  out <- fread(url)

  return(out)
}
