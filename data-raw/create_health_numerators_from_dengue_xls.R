# Convert the public SINAN dengue municipality-year workbook into the
# numerator format expected by the analysis pipeline.

library(dplyr)
library(readr)
library(readxl)
library(tidyr)

input_path <- "data-raw/Brazil_SINAN_Dengue_bycity_2007_31DEC2024.xls"
output_path <- "data-raw/health_numerators.csv"

if (!file.exists(input_path)) {
  stop("Missing input workbook: ", input_path)
}

dengue_raw <- readxl::read_excel(input_path, sheet = "Data")

health_numerators <- dengue_raw |>
  select(code_muni = mun_code, matches("^y[0-9]{4}_cases$")) |>
  mutate(code_muni = sprintf("%06.0f", as.numeric(code_muni))) |>
  pivot_longer(
    cols = matches("^y[0-9]{4}_cases$"),
    names_to = "year",
    values_to = "events"
  ) |>
  mutate(
    year = as.integer(sub("^y([0-9]{4})_cases$", "\\1", year)),
    events = as.numeric(events),
    indicator = "dengue_notified_cases"
  ) |>
  select(code_muni, year, events, indicator) |>
  arrange(code_muni, year)

readr::write_csv(health_numerators, output_path)

message("Wrote ", output_path)
message("Rows: ", nrow(health_numerators))
message("Municipalities: ", length(unique(health_numerators$code_muni)))
message("Years: ", paste(range(health_numerators$year, na.rm = TRUE), collapse = "-"))
message("Total events: ", sum(health_numerators$events, na.rm = TRUE))
