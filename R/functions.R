# functions.R
# Helper functions for the population denominator sensitivity analysis.

library(dplyr)
library(tidyr)
library(purrr)
library(stringr)
library(readr)
library(ggplot2)
library(scales)
library(forcats)
library(janitor)

harmonise_code6 <- function(x) {
  x <- as.character(x)
  x <- stringr::str_replace_all(x, "[^0-9]", "")
  x <- stringr::str_pad(x, width = 6, side = "left", pad = "0")
  substr(x, 1, 6)
}

safe_write_csv <- function(x, path) {
  dir.create(dirname(path), showWarnings = FALSE, recursive = TRUE)
  readr::write_csv(x, path)
  invisible(x)
}

add_pop_size_strata <- function(df, pop_col = "pop") {
  p <- rlang::sym(pop_col)
  df |>
    mutate(
      pop_size_stratum = case_when(
        !!p < 5000 ~ "<5,000",
        !!p < 10000 ~ "5,000-9,999",
        !!p < 20000 ~ "10,000-19,999",
        !!p < 50000 ~ "20,000-49,999",
        !!p < 100000 ~ "50,000-99,999",
        !!p < 500000 ~ "100,000-499,999",
        TRUE ~ ">=500,000"
      ),
      pop_size_stratum = factor(
        pop_size_stratum,
        levels = c("<5,000", "5,000-9,999", "10,000-19,999", "20,000-49,999", "50,000-99,999", "100,000-499,999", ">=500,000")
      )
    )
}

get_pop_totals_one_source <- function(source) {
  message("Retrieving municipal population totals from source: ", source)
  brpop::mun_pop_totals(source = source) |>
    janitor::clean_names() |>
    mutate(
      source = source,
      code_muni = as.character(code_muni),
      code_muni6 = harmonise_code6(code_muni),
      year = as.integer(year),
      pop = as.numeric(pop)
    ) |>
    select(source, code_muni, code_muni6, year, pop, everything())
}

get_pop_totals_all_sources <- function(sources = c("datasus", "datasus2024", "ibge", "ufrn")) {
  purrr::map_dfr(sources, get_pop_totals_one_source) |>
    distinct(source, code_muni6, year, .keep_all = TRUE)
}

population_pairwise_differences <- function(pop_df) {
  wide <- pop_df |>
    select(source, code_muni6, year, pop) |>
    tidyr::pivot_wider(names_from = source, values_from = pop)

  sources <- sort(unique(pop_df$source))
  pairs <- combn(sources, 2, simplify = FALSE)

  purrr::map_dfr(pairs, function(pair) {
    a <- pair[1]
    b <- pair[2]
    wide |>
      filter(!is.na(.data[[a]]), !is.na(.data[[b]])) |>
      transmute(
        code_muni6,
        year,
        source_a = a,
        source_b = b,
        pop_a = .data[[a]],
        pop_b = .data[[b]],
        absolute_difference = pop_a - pop_b,
        absolute_difference_abs = abs(absolute_difference),
        relative_difference = 100 * (pop_a - pop_b) / pop_b,
        relative_difference_abs = abs(relative_difference)
      )
  })
}

population_reference_comparison <- function(pop_df, reference_source = "ibge") {
  reference <- pop_df |>
    filter(source == reference_source) |>
    select(code_muni6, year, pop_reference = pop)

  pop_df |>
    filter(source != reference_source) |>
    inner_join(reference, by = c("code_muni6", "year")) |>
    mutate(
      reference_source = reference_source,
      absolute_difference = pop - pop_reference,
      absolute_difference_abs = abs(absolute_difference),
      relative_difference = 100 * absolute_difference / pop_reference,
      relative_difference_abs = abs(relative_difference)
    ) |>
    add_pop_size_strata("pop_reference")
}

summarise_reference_comparison <- function(ref_df) {
  ref_df |>
    group_by(source, reference_source, year, pop_size_stratum) |>
    summarise(
      n_municipalities = n(),
      median_relative_difference = median(relative_difference, na.rm = TRUE),
      p25_relative_difference = quantile(relative_difference, 0.25, na.rm = TRUE),
      p75_relative_difference = quantile(relative_difference, 0.75, na.rm = TRUE),
      p95_abs_relative_difference = quantile(relative_difference_abs, 0.95, na.rm = TRUE),
      max_abs_relative_difference = max(relative_difference_abs, na.rm = TRUE),
      .groups = "drop"
    )
}

compute_crude_rates <- function(numerators, pop_df, multiplier = 100000) {
  code_col <- if ("code_muni6" %in% names(numerators)) "code_muni6" else "code_muni"
  pop_df <- pop_df |>
    mutate(code_muni6 = harmonise_code6(code_muni6))

  numerators |>
    mutate(
      code_muni6 = harmonise_code6(.data[[code_col]]),
      year = as.integer(year),
      events = as.numeric(events)
    ) |>
    inner_join(pop_df |> select(source, code_muni6, year, pop), by = c("code_muni6", "year")) |>
    mutate(rate = multiplier * events / pop)
}

compare_rates_to_reference <- function(rate_df, reference_source = "ibge") {
  reference <- rate_df |>
    filter(source == reference_source) |>
    select(code_muni6, year, indicator, rate_reference = rate, pop_reference = pop)

  rate_df |>
    filter(source != reference_source) |>
    inner_join(reference, by = c("code_muni6", "year", "indicator")) |>
    mutate(
      reference_source = reference_source,
      rate_difference = rate - rate_reference,
      rate_difference_abs = abs(rate_difference),
      rate_relative_difference = 100 * rate_difference / rate_reference,
      rate_relative_difference_abs = abs(rate_relative_difference)
    ) |>
    add_pop_size_strata("pop_reference")
}

rank_displacement <- function(rate_df, reference_source = "ibge") {
  rates_ranked <- rate_df |>
    group_by(source, indicator, year) |>
    mutate(rank = min_rank(desc(rate))) |>
    ungroup()

  reference <- rates_ranked |>
    filter(source == reference_source) |>
    select(code_muni6, indicator, year, reference_rank = rank)

  rates_ranked |>
    filter(source != reference_source) |>
    inner_join(reference, by = c("code_muni6", "indicator", "year")) |>
    mutate(rank_displacement = rank - reference_rank, rank_displacement_abs = abs(rank_displacement))
}

classification_changes <- function(rate_df, reference_source = "ibge", n_groups = 5) {
  classified <- rate_df |>
    group_by(source, indicator, year) |>
    mutate(rate_class = ntile(rate, n_groups)) |>
    ungroup()

  reference <- classified |>
    filter(source == reference_source) |>
    select(code_muni6, indicator, year, reference_rate_class = rate_class)

  classified |>
    filter(source != reference_source) |>
    inner_join(reference, by = c("code_muni6", "indicator", "year")) |>
    mutate(
      reference_source = reference_source,
      class_difference = rate_class - reference_rate_class,
      reclassified = rate_class != reference_rate_class
    )
}

top_decile_overlap <- function(rate_df, reference_source = "ibge") {
  classified <- rate_df |>
    group_by(source, indicator, year) |>
    mutate(top_decile = rate >= quantile(rate, 0.9, na.rm = TRUE)) |>
    ungroup()

  reference <- classified |>
    filter(source == reference_source) |>
    select(code_muni6, indicator, year, top_decile_reference = top_decile)

  classified |>
    filter(source != reference_source) |>
    inner_join(reference, by = c("code_muni6", "indicator", "year")) |>
    mutate(reference_source = reference_source) |>
    group_by(source, reference_source, indicator, year) |>
    summarise(
      n_reference_top_decile = sum(top_decile_reference, na.rm = TRUE),
      n_source_top_decile = sum(top_decile, na.rm = TRUE),
      n_overlap = sum(top_decile & top_decile_reference, na.rm = TRUE),
      overlap_fraction_reference = n_overlap / n_reference_top_decile,
      jaccard = n_overlap / sum(top_decile | top_decile_reference, na.rm = TRUE),
      .groups = "drop"
    )
}

summarise_rate_comparison <- function(rate_comparison) {
  rate_comparison |>
    group_by(source, reference_source, indicator, year, pop_size_stratum) |>
    summarise(
      n_municipalities = n(),
      median_relative_rate_difference = median(rate_relative_difference, na.rm = TRUE),
      p25_relative_rate_difference = quantile(rate_relative_difference, 0.25, na.rm = TRUE),
      p75_relative_rate_difference = quantile(rate_relative_difference, 0.75, na.rm = TRUE),
      p95_abs_relative_rate_difference = quantile(rate_relative_difference_abs, 0.95, na.rm = TRUE),
      max_abs_relative_rate_difference = max(rate_relative_difference_abs, na.rm = TRUE),
      .groups = "drop"
    )
}

# Direct standardisation for age-sex numerator data. The age_group and sex values must match brpop.
get_pop_age_sex_one_source <- function(source) {
  message("Retrieving municipal age-sex population from source: ", source)
  brpop::mun_sex_pop(source = source) |>
    janitor::clean_names() |>
    mutate(
      source = source,
      code_muni = as.character(code_muni),
      code_muni6 = harmonise_code6(code_muni),
      year = as.integer(year),
      pop = as.numeric(pop)
    ) |>
    select(source, code_muni, code_muni6, year, sex, age_group, pop, everything())
}

get_pop_age_sex_all_sources <- function(sources = c("datasus", "datasus2024", "ufrn")) {
  purrr::map_dfr(sources, get_pop_age_sex_one_source) |>
    distinct(source, code_muni6, year, sex, age_group, .keep_all = TRUE)
}

direct_standardise <- function(numerators_age_sex, pop_age_sex, standard_year = 2010, standard_source = "datasus2024", multiplier = 100000) {
  code_col <- if ("code_muni6" %in% names(numerators_age_sex)) "code_muni6" else "code_muni"
  pop_age_sex <- pop_age_sex |>
    mutate(code_muni6 = harmonise_code6(code_muni6))

  standard_pop <- pop_age_sex |>
    filter(source == standard_source, year == standard_year) |>
    group_by(sex, age_group) |>
    summarise(std_pop = sum(pop, na.rm = TRUE), .groups = "drop")

  numerators_age_sex |>
    mutate(
      code_muni6 = harmonise_code6(.data[[code_col]]),
      year = as.integer(year),
      events = as.numeric(events)
    ) |>
    inner_join(pop_age_sex, by = c("code_muni6", "year", "sex", "age_group")) |>
    left_join(standard_pop, by = c("sex", "age_group")) |>
    mutate(age_sex_rate = events / pop) |>
    group_by(source, indicator, code_muni6, year) |>
    summarise(
      standardised_rate = multiplier * sum(age_sex_rate * std_pop, na.rm = TRUE) / sum(std_pop, na.rm = TRUE),
      events = sum(events, na.rm = TRUE),
      .groups = "drop"
    )
}
