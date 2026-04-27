# Input data folder

## Included real-world numerator dataset

This repository includes `health_numerators.csv`, derived from a public annual
municipality-level dengue notification dataset:

Anders K. Annual notified dengue case incidence in Brazilian municipalities
(SINAN database), 2007-2024. Monash University. Dataset.
https://doi.org/10.26180/28737815.v1

The source workbook is saved as
`Brazil_SINAN_Dengue_bycity_2007_31DEC2024.xls`. The conversion script
`create_health_numerators_from_dengue_xls.R` reshapes the yearly dengue case
columns into the four-column numerator format used by this project. The
indicator label is `dengue_notified_cases`.

## health_numerators.csv

Create a CSV file named `health_numerators.csv` with the following columns:

| column | description |
|---|---|
| `code_muni` | IBGE municipality code. Six or seven digits are accepted. The analysis harmonises to six digits for joining across denominator sources. |
| `year` | Calendar year. |
| `events` | Health event count. |
| `indicator` | Indicator label. Examples: `all_cause_hospital_admissions`, `dengue_cases`, `respiratory_admissions`. |

## health_numerators_age_sex.csv (optional)

Create this file only if you want age-sex-standardised rates.

| column | description |
|---|---|
| `code_muni` | IBGE municipality code. |
| `year` | Calendar year. |
| `sex` | Sex category matching `brpop` output. |
| `age_group` | Age group category matching `brpop` output. |
| `events` | Health event count. |
| `indicator` | Indicator label. |

For large health datasets, aggregate the numerator outside this repository and save only the municipality-year or municipality-year-age-sex counts here. This avoids redistributing identifiable or very large microdata.
