#' hosp_indicator_diff 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @import assertthat
#' @noRd
hosp_indicator_diff <- function(data, metrics) {

  assert_that(is.data.table(data), msg = "Data is a data.table")
  assert_that(is.character(metrics), msg = "Metrics is a character vector")

  # Computed column names
  count_cols <- paste("count", metrics, sep="_")
  diff_cols <- paste("diff", metrics, sep="_")
  max_cols <- paste("max", metrics, sep="_")
  lag_1_cols <- paste("lag_1", metrics, sep="_")

  # Pull only metrics selected
  indicator_data <- data[indicator %in% metrics]

  # Pivot
  pivoted <- dcast(indicator_data, date + country ~ indicator, value.var = "value")
  pivoted <- pivoted[order(-date)]

  # Compute lagging differences (change per day / week)
  # and then pull the largest of these differences and store in a column
  pivoted[, (diff_cols) := .SD - shift(.SD, 1, type = "lead"), .SDcols=metrics, by=country]
  pivoted[, (lag_1_cols) := shift(.SD, 1, type = "lead"), .SDcols=metrics, by=country]
  pivoted[, (max_cols) := lapply(.SD, function(x) max(x, na.rm=T)), .SDcols=metrics, by=country]

  # Take top 2 most recent values by metric
  filtered_data <- pivoted[, head(.SD, 2), by = country]

  # melt again to get into a nice shape for calculating pcts
  filtered_data <- setnames(filtered_data, metrics, count_cols)
  re_pivot <- melt(filtered_data, measure=patterns("^count_", "^diff", "^max", "^lag_1"), value.name=c("count", "diff", "max", "lag_1"))

  # By default, the variables are numeric, so we can just use that to
  # subset metrics to get the text labels again
  re_pivot <- re_pivot[, variable := metrics[variable]]

  # Compute pcts, append previous update date
  re_pivot[, c("pct_max", "pct_change") := list(count / max, 1 - (count / lag_1))]
  re_pivot[, last_update := min(date), by = variable]

  # Return only most recent date
  out <- re_pivot[, head(.SD, 1), by =list(variable, country)]


  return(out)
}
