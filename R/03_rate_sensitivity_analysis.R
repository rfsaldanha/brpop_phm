# 03_rate_sensitivity_analysis.R
# Compute crude health indicator rates using each denominator source.

source("R/functions.R")

pop_totals_path <- "output/tables/population_totals_all_sources.csv"
num_path <- "output/tables/health_numerators_prepared.csv"

if (!file.exists(pop_totals_path)) {
  source("R/01_population_denominators.R")
}
if (!file.exists(num_path)) {
  source("R/02_prepare_numerator_from_csv.R")
}

pop_totals <- readr::read_csv(pop_totals_path, show_col_types = FALSE)
health_numerators <- readr::read_csv(num_path, show_col_types = FALSE)

# Use sources available for both population and numerator years.
reference_source <- "ibge"
multiplier <- 100000

rates <- compute_crude_rates(health_numerators, pop_totals, multiplier = multiplier)
safe_write_csv(rates, "output/tables/rates_all_sources.csv")

rate_comparison <- compare_rates_to_reference(rates, reference_source = reference_source)
safe_write_csv(rate_comparison, "output/tables/rate_reference_comparison.csv")

rate_summary <- summarise_rate_comparison(rate_comparison)
safe_write_csv(rate_summary, "output/tables/rate_reference_summary.csv")

rank_disp <- rank_displacement(rates, reference_source = reference_source)
safe_write_csv(rank_disp, "output/tables/rank_displacement.csv")

class_changes <- classification_changes(rates, reference_source = reference_source, n_groups = 5)
safe_write_csv(class_changes, "output/tables/classification_changes.csv")

class_summary <- class_changes |>
  group_by(source, reference_source, indicator, year) |>
  summarise(
    n = n(),
    pct_reclassified = 100 * mean(reclassified, na.rm = TRUE),
    pct_shifted_two_or_more_classes = 100 * mean(abs(class_difference) >= 2, na.rm = TRUE),
    .groups = "drop"
  )
safe_write_csv(class_summary, "output/tables/classification_changes_summary.csv")

top_overlap <- top_decile_overlap(rates, reference_source = reference_source)
safe_write_csv(top_overlap, "output/tables/top_decile_overlap.csv")

p <- rate_comparison |>
  ggplot(aes(x = year, y = rate_relative_difference)) +
  geom_hline(yintercept = 0, linewidth = 0.2) +
  geom_boxplot(aes(group = interaction(source, year)), outlier.alpha = 0.05) +
  facet_grid(indicator ~ source, scales = "free_y") +
  labs(
    title = "Effect of denominator source on municipal health indicator rates",
    subtitle = paste("Reference source:", reference_source),
    x = "Year", y = "Relative difference in rate (%)"
  ) +
  theme_minimal()

ggsave("output/figures/rate_relative_difference_reference.png", p, width = 12, height = 8, dpi = 300)

p2 <- rank_disp |>
  group_by(source, indicator, year) |>
  summarise(
    median_abs_rank_displacement = median(rank_displacement_abs, na.rm = TRUE),
    p95_abs_rank_displacement = quantile(rank_displacement_abs, 0.95, na.rm = TRUE),
    .groups = "drop"
  ) |>
  ggplot(aes(x = year, y = median_abs_rank_displacement)) +
  geom_line(linewidth = 0.8) +
  geom_point(size = 1) +
  facet_grid(indicator ~ source, scales = "free_y") +
  labs(
    title = "Municipal rank displacement caused by denominator choice",
    subtitle = paste("Reference source:", reference_source),
    x = "Year", y = "Median absolute rank displacement"
  ) +
  theme_minimal()

ggsave("output/figures/rank_displacement.png", p2, width = 12, height = 8, dpi = 300)
