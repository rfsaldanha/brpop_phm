# Reproducible analysis for the Population Health Metrics manuscript

This project contains the R code to reproduce the analyses proposed in the manuscript draft:

**Population denominators matter: comparing Brazilian municipal population estimates and their impact on health indicators**

The workflow compares Brazilian municipal population estimates available through `brpop` and quantifies how denominator choice changes crude and optionally age-sex-standardised health indicators.

## Important notes

* `brpop` was archived on CRAN in September 2025, but the package documentation and source code remain available. The setup script installs `brpop` from GitHub.
* The scripts are outcome-agnostic. They can be used with mortality, hospital admissions, notifiable disease incidence, or other aggregated health events.
* For a full manuscript analysis, provide a municipality-year numerator file in `data-raw/health_numerators.csv` using the template in `data-raw/numerator_template.csv`.
* For age-sex-standardised rates, provide `data-raw/health_numerators_age_sex.csv` using the age-sex template described in `data-raw/README.md`.

## Requirements

R >= 4.3 is recommended.

Run:

```r
source("R/00_install_packages.R")
source("R/01_population_denominators.R")
source("R/02_prepare_numerator_from_csv.R")
source("R/03_rate_sensitivity_analysis.R")
source("R/04_age_sex_standardisation.R")
source("R/05_figures_tables.R")
```

Or run from the shell:

```bash
make all
```

## Expected input files

### Required for health-indicator impact analysis

`data-raw/health_numerators.csv`

Columns:

* `code_muni`: IBGE municipality code, six or seven digits accepted.
* `year`: calendar year.
* `events`: numerator count.
* `indicator`: indicator name, such as `all_cause_hospital_admissions` or `dengue_cases`.

### Optional for direct age-sex standardisation

`data-raw/health_numerators_age_sex.csv`

Columns:

* `code_muni`: IBGE municipality code.
* `year`: calendar year.
* `sex`: sex category matching `brpop` categories.
* `age_group`: age group matching `brpop` categories.
* `events`: numerator count.
* `indicator`: indicator name.

## Outputs

Tables are saved in `output/tables/` and figures in `output/figures/`.

Key outputs:

* `population_totals_all_sources.csv`
* `population_pairwise_differences.csv`
* `population_reference_comparison.csv`
* `rates_all_sources.csv`
* `rate_reference_comparison.csv`
* `rank_displacement.csv`
* `classification_changes.csv`
* `top_decile_overlap.csv`
* `standardised_rates_all_sources.csv` when age-sex numerator data are available

## Recommended manuscript workflow

1. Run the population comparison scripts first.
2. Add the selected health numerator file.
3. Run crude-rate sensitivity analyses.
4. Run age-sex-standardised sensitivity analyses if numerator data support age and sex stratification.
5. Update the Results section placeholders in the Word manuscript with the generated CSV tables and figures.
6. Deposit the code and, when possible, the minimal aggregated analysis dataset in a public repository and replace the placeholder repository URL in the manuscript.
