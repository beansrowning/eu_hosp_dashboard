#' hosp_indicator_diff
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @import assertthat
#' @import data.table
#' @importFrom tidyr pivot_longer
#' @noRd
hosp_indicator_diff <- function(data, metrics) {
  assert_that(is.data.table(data), msg = "Data is a data.table")
  assert_that(is.character(metrics), msg = "Metrics is a character vector")

  # Computed column names
  count_cols <- paste("count", metrics, sep = "_")
  diff_cols <- paste("diff", metrics, sep = "_")
  max_cols <- paste("max", metrics, sep = "_")
  lag_1_cols <- paste("lag_1", metrics, sep = "_")

  # Pull only metrics selected
  indicator_data <- data[indicator %in% metrics]

  # Early return if no data
  if (dim(indicator_data)[1] == 0) {
    return(data.table(status = "No Data :("))
  }

  # Pivot
  pivoted <- dcast(indicator_data, date + country ~ indicator, value.var = "value")
  pivoted <- pivoted[order(-date)]

  # Compute lagging differences (change per day / week)
  # and then pull the largest of these differences and store in a column
  pivoted[, (diff_cols) := .SD - shift(.SD, 1, type = "lead"), .SDcols = metrics, by = country]
  pivoted[, (lag_1_cols) := shift(.SD, 1, type = "lead"), .SDcols = metrics, by = country]
  pivoted[, (max_cols) := lapply(.SD, function(x) max(x, na.rm = T)), .SDcols = metrics, by = country]

  # Take top 2 most recent values by metric
  filtered_data <- pivoted[, head(.SD, 2), by = country]

  # melt again to get into a nice shape for calculating pcts
  filtered_data <- setnames(filtered_data, metrics, count_cols)

  # BUG: This is broken for some reason
  # re_pivot <- melt(filtered_data, measure=patterns("^count_", "^diff", "^max", "^lag_1"), value.name=c("count", "diff", "max", "lag_1"))

  re_pivot <- pivot_longer(filtered_data, -c(date, country), names_to = c(".value", "variable"), names_pattern = "(.*)_(.*)")
  re_pivot <- as.data.table(re_pivot)
  # By default, the variables are numeric, so we can just use that to
  # subset metrics to get the text labels again
  # re_pivot <- re_pivot[, variable := metrics[variable]]

  # Compute pcts, append previous update date
  re_pivot[, c("pct_max", "pct_change") := list(sprintf("%2.0f%%", 100 * count / max), formatC(((count / lag_1) - 1) * 100, digits = 2, flag = "+"))]
  re_pivot[, prev_update := min(date), by = variable]
  re_pivot[, c("value", "diff") := list(sprintf("%s (%s%%)", format(count, big.mark = ",", digits = 2), pct_change), round(diff, 2))]
  # Return only most recent date
  out <- re_pivot[, head(.SD, 1), by = list(variable, country)]

  out <- out[, list(country, date, variable, value, diff, pct_max, prev_update)]

  return(out)
}
