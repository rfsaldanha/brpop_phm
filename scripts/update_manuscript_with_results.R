library(readr)
library(dplyr)

input_md <- "/tmp/population_denominators_phm_draft.md"
output_md <- "manuscript/population_denominators_phm_updated.md"

text <- paste(readLines(input_md, warn = FALSE), collapse = "\n")

abstract_results <- paste(
  "**Results:** The workflow retrieved 518,607 source-specific",
  "municipality-year population records from four denominator sources",
  "covering 2000-2030 overall, with complete overlap across all four",
  "sources for 66,840 municipality-year records from 5,570 municipalities",
  "during 2010-2021. Compared with IBGE, median absolute relative",
  "population differences were 1.82% for DataSUS, 2.51% for DataSUS",
  "2024 and 2.12% for UFRN; 95th-percentile absolute differences were",
  "10.18%, 13.14% and 15.74%, respectively. The health-indicator",
  "application used 91,242 municipality-year dengue notification records",
  "for 5,069 municipalities from 2007-2024, totaling 22,031,937 notified",
  "cases. Median absolute relative differences in dengue rates were",
  "1.20% for DataSUS, 2.41% for DataSUS 2024 and 2.16% for UFRN.",
  "Median absolute rank displacement was 1, 7 and 6 positions,",
  "respectively. Quintile reclassification affected 0.76%, 1.74% and",
  "2.15% of municipality-year records, with no municipality shifting by",
  "two or more quintiles.",
  sep = " "
)

text <- sub(
  "\\*\\*Results:\\*\\*[\\s\\S]*?\\*\\*Conclusions:\\*\\*",
  paste0(abstract_results, "\n\n**Conclusions:**"),
  text,
  perl = TRUE
)

health_numerator_section <- paste(
  "## Health numerator data\n\n",
  "The health-indicator application used annual notified dengue case counts ",
  "from a public municipality-level dataset derived from SINAN/DataSUS. The ",
  "source workbook reports dengue notifications for Brazilian municipalities ",
  "from 2007 to 2024. It was reshaped into the minimal numerator format ",
  "required by the reproducible workflow, with one record per municipality, ",
  "year and indicator. The resulting analysis file contained 91,242 ",
  "municipality-year records for 5,069 municipalities and 22,031,937 notified ",
  "dengue cases. The indicator label used in the code was ",
  "`dengue_notified_cases`.\n\n",
  "The source dataset was: Anders K. Annual notified dengue case incidence in ",
  "Brazilian municipalities (SINAN database), 2007-2024. Monash University. ",
  "Dataset. https://doi.org/10.26180/28737815.v1. The dataset metadata cites ",
  "dengue case data from DataSUS TabNet. The source workbook and conversion ",
  "script are included with the reproducible materials.\n\n",
  "The workflow expects a minimal aggregated file with the columns code_muni, ",
  "year, events and indicator. This design avoids redistributing ",
  "individual-level microdata and allows the same denominator sensitivity ",
  "framework to be reused for multiple outcomes. When the numerator is ",
  "available by age group and sex, an optional file with code_muni, year, sex, ",
  "age_group, events and indicator can be used for directly standardised ",
  "rates. Municipality codes are harmonised to six digits to allow joins ",
  "across sources that may use either six- or seven-digit IBGE codes.",
  sep = ""
)

text <- sub(
  "## Health numerator data\\n\\n[\\s\\S]*?## Denominator harmonisation",
  paste0(health_numerator_section, "\n\n## Denominator harmonisation"),
  text,
  perl = TRUE
)

text <- gsub("brpop version 0\\.6\\.3", "brpop version 0.6.2", text)
text <- gsub("version 0\\.6\\.3\\. 2025", "version 0.6.2. 2025", text)

results_section <- paste(
  "# Results\n\n",
  "## Coverage and overlap of population denominator sources\n\n",
  "The analysis retrieved 518,607 source-specific municipality-year ",
  "population records from four denominator sources. DataSUS contributed ",
  "123,112 records for 5,596 municipalities from 2000 to 2021; DataSUS 2024 ",
  "contributed 139,250 records for 5,570 municipalities from 2000 to 2024; ",
  "IBGE contributed 139,275 records for 5,571 municipalities from 2000 to ",
  "2024; and UFRN contributed 116,970 records for 5,570 municipalities from ",
  "2010 to 2030. Complete overlap across all four sources was available for ",
  "66,840 municipality-year records, representing 5,570 municipalities from ",
  "2010 to 2021.\n\n",
  "## Magnitude of differences among municipal population estimates\n\n",
  "Using IBGE as the reference denominator, median signed relative differences ",
  "were 0.27% for DataSUS, 0.82% for DataSUS 2024 and -0.06% for UFRN. ",
  "Median absolute relative differences were 1.82%, 2.51% and 2.12%, ",
  "respectively. The upper tail was wider: 95th-percentile absolute relative ",
  "differences were 10.18% for DataSUS, 13.14% for DataSUS 2024 and 15.74% ",
  "for UFRN. Maximum absolute relative differences reached 269.19%, 413.28% ",
  "and 356.83%, respectively, indicating that a small subset of ",
  "municipality-year records had very large denominator discrepancies.\n\n",
  "Differences varied by population-size stratum. For DataSUS, median ",
  "absolute differences were 1.84% among municipalities below 5,000 ",
  "inhabitants and 1.25% among municipalities with at least 500,000 ",
  "inhabitants. For UFRN, the corresponding medians were 2.15% and 1.82%. ",
  "For DataSUS 2024, median absolute differences were similar across strata, ",
  "ranging from 2.29% in municipalities with 50,000-99,999 inhabitants to ",
  "2.67% in municipalities with at least 500,000 inhabitants.\n\n",
  "## Effects of denominator choice on crude health indicator rates\n\n",
  "The numerator application used annual notified dengue cases. The input ",
  "dataset contained 91,242 municipality-year records for 5,069 municipalities ",
  "from 2007 to 2024, totaling 22,031,937 notified cases. Because the same ",
  "numerator was used with every denominator source, observed differences in ",
  "rates are attributable to denominator choice and source coverage.\n\n",
  "Compared with rates calculated using IBGE denominators, median signed ",
  "relative differences in dengue rates were 0.00% for DataSUS, -0.29% for ",
  "DataSUS 2024 and 0.07% for UFRN. Median absolute relative differences were ",
  "1.20%, 2.41% and 2.16%, respectively. The 95th-percentile absolute ",
  "relative differences were 6.51%, 12.76% and 15.96%, respectively. Maximum ",
  "absolute relative differences reached 143.94% for DataSUS, 164.71% for ",
  "DataSUS 2024 and 352.73% for UFRN.\n\n",
  "## Changes in rankings, quintile classifications and priority sets\n\n",
  "Denominator choice changed municipal rankings even when median rate ",
  "differences were modest. Median absolute rank displacement was 1 position ",
  "for DataSUS, 7 positions for DataSUS 2024 and 6 positions for UFRN. The ",
  "95th-percentile absolute rank displacement was 33, 74 and 98 positions, ",
  "respectively, and the maximum displacement was 650, 1,252 and 1,090 ",
  "positions.\n\n",
  "Quintile classifications were relatively stable. The proportion of ",
  "municipality-year records assigned to a different quintile was 0.76% for ",
  "DataSUS, 1.74% for DataSUS 2024 and 2.15% for UFRN, and no records shifted ",
  "by two or more quintiles. Top-decile priority sets also showed high overlap ",
  "with the IBGE reference. Median reference-set overlap was 99.61% for ",
  "DataSUS, 98.52% for DataSUS 2024 and 98.82% for UFRN. The lowest annual ",
  "overlap values were 97.63%, 96.45% and 92.90%, respectively. Median Jaccard ",
  "similarity was 0.99, 0.97 and 0.98, respectively.\n\n",
  "## Age-sex-standardised rates\n\n",
  "Age-sex-standardised rates were not calculated because the dengue numerator ",
  "dataset used in this application was aggregated by municipality and year ",
  "only. This does not affect the primary objective of evaluating denominator ",
  "sensitivity in routinely reported crude municipal indicators, but it means ",
  "that age-sex-specific denominator sensitivity remains a topic for future ",
  "applications using stratified numerator data.\n\n",
  sep = ""
)

text <- sub(
  "# Results\\n\\n[\\s\\S]*?# Discussion",
  paste0(results_section, "# Discussion"),
  text,
  perl = TRUE
)

text <- sub(
  "The expected contribution is methodological and operational\\.",
  "The contribution is methodological and operational, illustrated here using notified dengue cases as a real-world municipality-year numerator.",
  text
)

text <- sub(
  "## Availability of data and materials\\n\\n[\\s\\S]*?## Competing interests",
  paste0(
    "## Availability of data and materials\n\n",
    "The reproducible code supporting this manuscript is included with the project materials. ",
    "Population denominator data are accessed through the brpop R package. The health numerator ",
    "application uses a public aggregated municipality-year dengue notification dataset from ",
    "Anders (2025), derived from SINAN/DataSUS and distributed under a CC BY 4.0 licence. The ",
    "source workbook, conversion script and compressed CSV outputs are included with the project ",
    "materials as individual `.csv.zip` archives. A public repository and persistent identifier ",
    "should be added before journal submission.\n\n",
    "## Competing interests"
  ),
  text,
  perl = TRUE
)

text <- sub(
  "14\\. Wakefield J\\. Disease mapping and spatial regression with count data\\.\\n    Biostatistics\\. 2007;8\\(2\\):158-183\\. doi:10\\.1093/biostatistics/kxl008\\.",
  paste0(
    "14. Wakefield J. Disease mapping and spatial regression with count data.\\n",
    "    Biostatistics. 2007;8(2):158-183. doi:10.1093/biostatistics/kxl008.\\n\\n",
    "15. Anders K. Annual notified dengue case incidence in Brazilian municipalities\\n",
    "    (SINAN database), 2007-2024. Monash University. Dataset. 2025.\\n",
    "    doi:10.26180/28737815.v1."
  ),
  text
)

writeLines(text, output_md)
message("Wrote ", output_md)
