# 02_prepare_numerator_from_csv.R
# Load and validate the health numerator file.

source("R/functions.R")

numerator_path <- "data-raw/health_numerators.csv"

template <- tibble::tibble(
  code_muni = c("330455", "355030", "261160"),
  year = c(2020, 2020, 2020),
  events = c(NA_integer_, NA_integer_, NA_integer_),
  indicator = c("replace_with_indicator_name", "replace_with_indicator_name", "replace_with_indicator_name")
)

if (!file.exists(numerator_path)) {
  dir.create("data-raw", showWarnings = FALSE, recursive = TRUE)
  readr::write_csv(template, "data-raw/numerator_template.csv")
  stop(
    "Missing data-raw/health_numerators.csv. ",
    "Create it with columns: code_muni, year, events, indicator. ",
    "A template has been written to data-raw/numerator_template.csv."
  )
}

health_numerators <- readr::read_csv(numerator_path, show_col_types = FALSE) |>
  janitor::clean_names() |>
  mutate(
    code_muni = as.character(code_muni),
    code_muni6 = harmonise_code6(code_muni),
    year = as.integer(year),
    events = as.numeric(events),
    indicator = as.character(indicator)
  ) |>
  group_by(code_muni6, year, indicator) |>
  summarise(events = sum(events, na.rm = TRUE), .groups = "drop")

stopifnot(all(c("code_muni6", "year", "events", "indicator") %in% names(health_numerators)))

safe_write_csv(health_numerators, "output/tables/health_numerators_prepared.csv")
