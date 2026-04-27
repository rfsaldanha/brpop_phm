# 05_figures_tables.R
# Create compact manuscript-ready summary tables from outputs.

library(dplyr)
library(readr)
library(tidyr)

if (file.exists("output/tables/population_reference_summary.csv")) {
  pop_sum <- readr::read_csv("output/tables/population_reference_summary.csv", show_col_types = FALSE)

  manuscript_pop_table <- pop_sum |>
    group_by(source, reference_source, pop_size_stratum) |>
    summarise(
      years = paste(range(year, na.rm = TRUE), collapse = "-"),
      median_of_median_relative_difference = median(median_relative_difference, na.rm = TRUE),
      median_p95_abs_relative_difference = median(p95_abs_relative_difference, na.rm = TRUE),
      max_abs_relative_difference = max(max_abs_relative_difference, na.rm = TRUE),
      .groups = "drop"
    )

  readr::write_csv(manuscript_pop_table, "output/tables/manuscript_table_population_summary.csv")
}

if (file.exists("output/tables/rate_reference_summary.csv")) {
  rate_sum <- readr::read_csv("output/tables/rate_reference_summary.csv", show_col_types = FALSE)

  manuscript_rate_table <- rate_sum |>
    group_by(indicator, source, reference_source, pop_size_stratum) |>
    summarise(
      years = paste(range(year, na.rm = TRUE), collapse = "-"),
      median_of_median_relative_rate_difference = median(median_relative_rate_difference, na.rm = TRUE),
      median_p95_abs_relative_rate_difference = median(p95_abs_relative_rate_difference, na.rm = TRUE),
      max_abs_relative_rate_difference = max(max_abs_relative_rate_difference, na.rm = TRUE),
      .groups = "drop"
    )

  readr::write_csv(manuscript_rate_table, "output/tables/manuscript_table_rate_summary.csv")
}

if (file.exists("output/tables/classification_changes_summary.csv")) {
  class_sum <- readr::read_csv("output/tables/classification_changes_summary.csv", show_col_types = FALSE)

  manuscript_class_table <- class_sum |>
    group_by(indicator, source, reference_source) |>
    summarise(
      years = paste(range(year, na.rm = TRUE), collapse = "-"),
      median_pct_reclassified = median(pct_reclassified, na.rm = TRUE),
      max_pct_reclassified = max(pct_reclassified, na.rm = TRUE),
      median_pct_shifted_two_or_more_classes = median(pct_shifted_two_or_more_classes, na.rm = TRUE),
      .groups = "drop"
    )

  readr::write_csv(manuscript_class_table, "output/tables/manuscript_table_classification_summary.csv")
}
