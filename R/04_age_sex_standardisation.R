# 04_age_sex_standardisation.R
# Optional: compute directly age-sex-standardised rates using brpop age-sex denominators.

source("R/functions.R")

age_sex_path <- "data-raw/health_numerators_age_sex.csv"

if (!file.exists(age_sex_path)) {
  message("No age-sex numerator file found. Skipping age-sex-standardised analysis.")
  message("Create data-raw/health_numerators_age_sex.csv with code_muni, year, sex, age_group, events, indicator to run this step.")
} else {
  sources_age_sex <- c("datasus", "datasus2024", "ufrn")
  reference_source <- "datasus2024"
  standard_year <- 2010
  multiplier <- 100000

  pop_age_sex <- get_pop_age_sex_all_sources(sources_age_sex)
  safe_write_csv(pop_age_sex, "output/tables/population_age_sex_all_sources.csv")

  health_numerators_age_sex <- readr::read_csv(age_sex_path, show_col_types = FALSE) |>
    janitor::clean_names() |>
    mutate(
      code_muni = as.character(code_muni),
      code_muni6 = harmonise_code6(code_muni),
      year = as.integer(year),
      events = as.numeric(events),
      sex = as.character(sex),
      age_group = as.character(age_group),
      indicator = as.character(indicator)
    ) |>
    group_by(code_muni6, year, sex, age_group, indicator) |>
    summarise(events = sum(events, na.rm = TRUE), .groups = "drop")

  std_rates <- direct_standardise(
    health_numerators_age_sex,
    pop_age_sex,
    standard_year = standard_year,
    standard_source = reference_source,
    multiplier = multiplier
  )

  safe_write_csv(std_rates, "output/tables/standardised_rates_all_sources.csv")

  std_rates_rate_df <- std_rates |>
    rename(rate = standardised_rate) |>
    mutate(pop = NA_real_)

  std_comp <- compare_rates_to_reference(std_rates_rate_df, reference_source = reference_source)
  safe_write_csv(std_comp, "output/tables/standardised_rate_reference_comparison.csv")

  p <- std_comp |>
    ggplot(aes(x = year, y = rate_relative_difference)) +
    geom_hline(yintercept = 0, linewidth = 0.2) +
    geom_boxplot(aes(group = interaction(source, year)), outlier.alpha = 0.05) +
    facet_grid(indicator ~ source, scales = "free_y") +
    labs(
      title = "Effect of denominator source on directly standardised municipal rates",
      subtitle = paste("Reference source:", reference_source),
      x = "Year", y = "Relative difference in standardised rate (%)"
    ) +
    theme_minimal()

  ggsave("output/figures/standardised_rate_relative_difference_reference.png", p, width = 12, height = 8, dpi = 300)
}
