# 01_population_denominators.R
# Retrieve and compare Brazilian municipal population denominator sources.

source("R/functions.R")

sources <- c("datasus", "datasus2024", "ibge", "ufrn")
reference_source <- "ibge"

pop_totals <- get_pop_totals_all_sources(sources)
safe_write_csv(pop_totals, "output/tables/population_totals_all_sources.csv")

pairwise <- population_pairwise_differences(pop_totals)
safe_write_csv(pairwise, "output/tables/population_pairwise_differences.csv")

ref_comp <- population_reference_comparison(pop_totals, reference_source = reference_source)
safe_write_csv(ref_comp, "output/tables/population_reference_comparison.csv")

ref_summary <- summarise_reference_comparison(ref_comp)
safe_write_csv(ref_summary, "output/tables/population_reference_summary.csv")

# Figure: relative difference vs reference over time by source.
p <- ref_comp |>
  group_by(source, year) |>
  summarise(
    median = median(relative_difference, na.rm = TRUE),
    p25 = quantile(relative_difference, 0.25, na.rm = TRUE),
    p75 = quantile(relative_difference, 0.75, na.rm = TRUE),
    .groups = "drop"
  ) |>
  ggplot(aes(x = year, y = median, ymin = p25, ymax = p75, group = source)) +
  geom_ribbon(alpha = 0.15) +
  geom_line(linewidth = 0.8) +
  facet_wrap(~source, scales = "free_x") +
  labs(
    title = "Municipal population differences relative to the reference source",
    subtitle = paste("Reference source:", reference_source),
    x = "Year", y = "Relative difference (%)"
  ) +
  theme_minimal()

ggsave("output/figures/population_relative_difference_reference.png", p, width = 10, height = 7, dpi = 300)

# Figure: distribution of absolute relative differences by population size.
p2 <- ref_comp |>
  ggplot(aes(x = pop_size_stratum, y = relative_difference_abs)) +
  geom_boxplot(outlier.alpha = 0.1) +
  facet_wrap(~source) +
  coord_cartesian(ylim = c(0, quantile(ref_comp$relative_difference_abs, 0.99, na.rm = TRUE))) +
  labs(
    title = "Absolute relative population differences by municipality size",
    x = "Reference population size stratum", y = "Absolute relative difference (%)"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("output/figures/population_difference_by_size.png", p2, width = 11, height = 7, dpi = 300)
