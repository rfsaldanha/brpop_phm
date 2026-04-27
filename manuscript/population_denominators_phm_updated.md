**Population denominators matter: comparing Brazilian municipal
population estimates and their impact on health indicators**

Running title: Population denominators and municipal health indicators
in Brazil

# Author details

Raphael Saldanha1\*; \[Co-author 2\]2; \[Co-author 3\]3; \[Co-author
4\]4

1 Institute of Scientific and Technological Communication and
Information in Health, Oswaldo Cruz Foundation (ICICT/Fiocruz), Rio de
Janeiro, Brazil.

2 \[Affiliation\].

3 \[Affiliation\].

4 \[Affiliation\].

\* Corresponding author: Raphael Saldanha, \[email address\].

# Abstract

**Background:** Health indicators routinely used for surveillance,
planning and evaluation are constructed by dividing health events by
population denominators. Between censuses, however, population
denominators are estimates rather than enumerations. In Brazil, several
municipal population estimates are available for intercensal years,
including series produced or disseminated by IBGE, DataSUS and
UFRN-PPGDEM-LEPP. Differences among these denominators may propagate
into health rates, municipal rankings and the identification of priority
areas. This study aimed to compare available Brazilian municipal
population estimates and quantify the sensitivity of selected health
indicators to denominator choice.

**Methods:** We designed an ecological methodological study of Brazilian
municipalities and calendar years for which overlapping population
estimates were available. Population denominators were retrieved and
harmonised using the brpop R package. We compared estimates pairwise and
against a reference denominator, calculated relative and absolute
differences, and stratified results by year, population size and
denominator source. For selected health numerators aggregated by
municipality and year, we calculated crude rates per 100,000 inhabitants
using each denominator source. We then quantified changes in rates,
rankings, quintile classifications and top-decile priority sets.
Optional scripts support direct age-sex standardisation when numerator
data are available by age group and sex.

**Results:** The workflow retrieved 518,607 source-specific municipality-year population records from four denominator sources covering 2000-2030 overall, with complete overlap across all four sources for 66,840 municipality-year records from 5,570 municipalities during 2010-2021. Compared with IBGE, median absolute relative population differences were 1.82% for DataSUS, 2.51% for DataSUS 2024 and 2.12% for UFRN; 95th-percentile absolute differences were 10.18%, 13.14% and 15.74%, respectively. The health-indicator application used 91,242 municipality-year dengue notification records for 5,069 municipalities from 2007-2024, totaling 22,031,937 notified cases. Median absolute relative differences in dengue rates were 1.20% for DataSUS, 2.41% for DataSUS 2024 and 2.16% for UFRN. Median absolute rank displacement was 1, 7 and 6 positions, respectively. Quintile reclassification affected 0.76%, 1.74% and 2.15% of municipality-year records, with no municipality shifting by two or more quintiles.

**Conclusions:** Denominator choice is a measurable source of
uncertainty in small-area health indicators. The proposed workflow
offers a reproducible way to document this uncertainty, identify
indicators and territories most sensitive to denominator selection, and
support transparent reporting of municipal health rates in Brazil.
Routine denominator sensitivity analysis should accompany health
indicators used for surveillance, equity monitoring and policy
prioritisation.

# Keywords

Population estimates; denominator uncertainty; health indicators;
small-area epidemiology; municipalities; Brazil; R package; reproducible
research.

# Background

Population denominators are a basic but consequential component of
population health measurement. Incidence, mortality, hospitalisation and
notification rates are usually interpreted as properties of populations
and places, but their numerical values depend on the population at risk
used in the denominator. In national and subnational health information
systems, denominators are often treated as fixed quantities, even when
they are projections or model-based estimates rather than census
enumerations. This assumption is especially important for small-area
epidemiology, where population denominators are more sensitive to
migration, boundary changes, ageing, fertility and mortality
assumptions.

Previous studies have shown that small-area demographic estimates may
contain substantial error and that such error can affect prevalence and
rate statistics. Baker et al. evaluated small-area demographic estimates
and argued that denominator error deserves more explicit consideration
in epidemiologic surveillance. Fecht et al. emphasized that temporally
and spatially detailed population counts are essential for computing
rates and risks in small-area health studies. Tatem likewise highlighted
that subnational population data are foundational for disease
surveillance and response, while outdated or inaccurate denominators can
limit the interpretation of risk and intervention needs.

Brazil offers a particularly relevant setting for examining denominator
sensitivity. Municipalities are central units for the organisation,
financing and management of the Sistema Unico de Saude (SUS), and
municipal health indicators are widely used for surveillance, planning,
resource allocation and evaluation. Between censuses, however,
population counts are estimated through different institutional and
methodological processes. The Brazilian Institute of Geography and
Statistics (IBGE) publishes annual resident population estimates for
municipalities and Federation Units, used for administrative and
statistical purposes. DataSUS disseminates age- and sex-specific
resident population estimates used in health information systems.
UFRN-PPGDEM-LEPP provides municipal demographic estimates and
projections, including age and sex structures, derived from demographic
modelling approaches.

The availability of multiple denominator series is valuable because each
source can serve different analytical needs. At the same time, the
coexistence of alternative estimates creates a methodological question
for public health research: how much do health indicators change when a
different denominator is selected? This question is not merely
technical. Changes in the denominator may alter municipal rates, spatial
patterns, trend interpretation, prioritisation of high-risk areas and
conclusions about inequalities. For indicators used in health
surveillance or funding decisions, even modest denominator differences
may influence decisions when applied across thousands of municipalities
and repeated annually.

The brpop R package was developed to make these denominator series
easier to access and compare. It provides Brazilian population estimates
by year, municipality, state, sex and age group from available sources,
including DataSUS, UFRN-PPGDEM-LEPP and IBGE total municipal estimates.
This manuscript uses brpop as the reproducibility layer for a
denominator sensitivity analysis. The objectives were: (1) to compare
available Brazilian municipal population estimates across overlapping
years; (2) to quantify how denominator choice affects selected municipal
health indicators; and (3) to propose a reproducible workflow for
reporting denominator sensitivity in Brazilian population health
studies.

# Methods

## Study design and setting

We conducted an ecological methodological study of Brazilian
municipalities using calendar-year population denominator series and
municipality-year health event counts. The unit of analysis was the
municipality-year, with optional extensions to age-sex strata when
health numerators were available by age group and sex. The study was
designed as a sensitivity analysis rather than as an evaluation of the
demographic correctness of any single population series. Its purpose was
to quantify the consequences of denominator choice for health indicators
as they are commonly produced in surveillance and epidemiological
practice.

The analysis was organised around two complementary components. First,
we compared population denominators from different sources across
overlapping municipality-year records. Second, we applied each
denominator to the same health numerator dataset and examined how rates,
rankings and priority classifications changed. The primary workflow
focused on crude annual rates per 100,000 inhabitants because these are
common in municipal health surveillance. A secondary workflow supported
direct age-sex standardisation when the numerator dataset contained
compatible age-sex strata.

## Population denominator data sources

Population estimates were retrieved with brpop version 0.6.2. The
package documentation describes it as providing yearly Brazilian
population estimates aggregated by state, municipality, sex and age
group, with functions for total population and age-sex-specific
denominators. The sources evaluated in the reproducible workflow are
summarised in Table 1.

  -------------------------------------------------------------------------------------
  **Source label **Institution/source**   **Temporal     **Population    **Use in
  in code**                               coverage in    structure**     analysis**
                                          brpop**                        
  -------------- ------------------------ -------------- --------------- --------------
  datasus        DataSUS resident         2000-2021      Municipality,   Age-sex
                 population estimates                    year, sex and   denominators
                                                         age group       and crude
                                                                         totals.

  datasus2024    Updated DataSUS          2000-2024      Municipality,   Age-sex
                 estimates made available                year, sex and   denominators
                 in brpop                                age group       and
                                                                         alternative
                                                                         crude totals.

  ibge           IBGE municipal resident  2000-2024 in   Municipality    Reference
                 population estimates,    brpop; annual  and year totals source for
                 census and population    estimates                      crude-rate
                 counts                   continue to be                 comparisons
                                          published by                   when
                                          IBGE                           available.

  ufrn           UFRN-PPGDEM-LEPP         2010-2030      Municipality,   Alternative
                 municipal estimates and                 year, sex and   age-sex
                 projections                             age group       denominators
                                                                         and
                                                                         projections.
  -------------------------------------------------------------------------------------

Table 1. Population denominator sources evaluated in the proposed
workflow. The exact available years should be verified at runtime
because package versions and source updates may change.

## Health numerator data

The health-indicator application used annual notified dengue case counts from a public municipality-level dataset derived from SINAN/DataSUS. The source workbook reports dengue notifications for Brazilian municipalities from 2007 to 2024. It was reshaped into the minimal numerator format required by the reproducible workflow, with one record per municipality, year and indicator. The resulting analysis file contained 91,242 municipality-year records for 5,069 municipalities and 22,031,937 notified dengue cases. The indicator label used in the code was `dengue_notified_cases`.

The source dataset was: Anders K. Annual notified dengue case incidence in Brazilian municipalities (SINAN database), 2007-2024. Monash University. Dataset. https://doi.org/10.26180/28737815.v1. The dataset metadata cites dengue case data from DataSUS TabNet. The source workbook and conversion script are included with the reproducible materials.

The workflow expects a minimal aggregated file with the columns code_muni, year, events and indicator. This design avoids redistributing individual-level microdata and allows the same denominator sensitivity framework to be reused for multiple outcomes. When the numerator is available by age group and sex, an optional file with code_muni, year, sex, age_group, events and indicator can be used for directly standardised rates. Municipality codes are harmonised to six digits to allow joins across sources that may use either six- or seven-digit IBGE codes.

## Denominator harmonisation

Population datasets were harmonised by source, year and municipality.
The brpop functions return municipal identifiers that may differ across
sources because some series use six-digit municipality codes and others
use seven-digit IBGE codes. The analysis therefore created a harmonised
six-digit code by removing non-numeric characters, padding as needed and
retaining the first six digits. The workflow retained the original code
as supplied by each source for auditability. Records with missing
population counts or non-positive denominators were excluded from rate
calculations but retained in diagnostic logs when possible.

## Comparison of population estimates

For each pair of denominator sources with overlapping municipality-year
observations, we calculated absolute differences, absolute relative
differences and signed relative differences. The signed relative
difference between source A and source B was defined as 100 x
(population_A - population_B) / population_B. For source-specific
analyses against a reference denominator, the same formula was applied
using the selected reference source as the denominator of the
comparison. IBGE was used as the default reference for crude total
population comparisons because it is the official source of annual total
municipal estimates. Sensitivity analyses can change the reference
source in the code.

Differences were summarised by year, source, municipality population
size stratum and, when geographic lookup tables are added, macro-region
or state. Population size strata were defined using the reference
denominator: \<5,000; 5,000-9,999; 10,000-19,999; 20,000-49,999;
50,000-99,999; 100,000-499,999; and \>=500,000 inhabitants. These strata
were selected because relative denominator differences are expected to
be more consequential in small municipalities and because small-area
denominator error often increases as the population at risk decreases.

## Health indicator sensitivity analyses

For each health indicator, crude rates were calculated as events divided
by population and multiplied by 100,000. The same numerator was used
with each denominator source, ensuring that observed differences in
rates resulted only from denominator choice. For each non-reference
denominator, we calculated the absolute rate difference, relative rate
difference, absolute relative rate difference and summary statistics by
year, source and population size stratum.

We assessed whether denominator choice changed the interpretation of
municipal health patterns using three complementary metrics. First, we
calculated municipal rank displacement by ranking municipalities
according to the rate produced by each denominator and subtracting the
rank produced by the reference denominator. Second, we classified
municipalities into quintiles of the rate distribution for each
source-year and measured the proportion assigned to a different quintile
relative to the reference. Third, we identified municipalities in the
top decile of the rate distribution for each source-year and calculated
overlap with the top decile under the reference denominator using both
reference-set overlap and the Jaccard index. These metrics translate
denominator differences into quantities directly relevant to
surveillance and prioritisation.

## Age-sex standardisation

When health numerators are available by age group and sex, the workflow
can compute directly standardised rates. Age-sex-specific rates are
calculated for each municipality, year and denominator source. A
standard population is then derived by summing the age-sex population of
a chosen source and year across municipalities; the default is DataSUS
2024 in 2010, but this can be changed in the configuration file.
Standardised rates are calculated as the weighted average of
age-sex-specific rates multiplied by 100,000. The same sensitivity
metrics used for crude rates can be applied to standardised rates.

## Statistical analysis

The analysis is descriptive and comparative. We report medians,
interquartile ranges, 95th percentiles and maximum absolute differences
rather than relying only on means, because denominator differences may
be skewed and concentrated in particular subsets of municipalities. Time
trends are displayed using annual summaries and line plots;
cross-sectional variation is displayed using boxplots or empirical
distributions. Where appropriate, Spearman correlations between rates
produced by different denominators may be reported, but rank
displacement and reclassification metrics are prioritised because high
correlations can mask meaningful changes in the classification of
individual municipalities.

All analyses were designed to be conducted in R. The reproducible code
uses brpop for population denominators and tidyverse-compatible packages
for data management, summaries and figures. The supplied code writes all
intermediate and final outputs to machine-readable CSV files and stores
manuscript-ready figures in PNG format. No inferential testing is
required for the primary objectives because the analysis compares
deterministic denominator choices applied to the same numerator. If
model-based rates are added in future versions, uncertainty in
denominator estimates can be incorporated through simulation or Bayesian
measurement-error models.

## Reproducibility

The complete workflow is provided as supplementary reproducible code.
The code includes installation instructions, data templates, functions
for denominator retrieval and harmonisation, scripts for crude and
standardised rate analyses, and scripts to create summary tables and
figures. The package brpop is installed from GitHub in the setup script
because it is not currently distributed on CRAN. For submission, the
authors should deposit the code in a public repository such as GitHub
and archive a release in Zenodo or another repository that provides a
persistent identifier. The minimal aggregated numerator dataset should
be shared when permitted by data governance rules; otherwise, the
availability statement should specify the conditions for access and
provide a template that allows replication with alternative health
outcomes.

## Use of AI-assisted tools

A large language model was used to assist with drafting and organisation
of the manuscript text and reproducible-code scaffold. The authors
reviewed, edited and take responsibility for all scientific content,
references, code and interpretations. The model was not listed as an
author.

# Results

## Coverage and overlap of population denominator sources

The analysis retrieved 518,607 source-specific municipality-year population records from four denominator sources. DataSUS contributed 123,112 records for 5,596 municipalities from 2000 to 2021; DataSUS 2024 contributed 139,250 records for 5,570 municipalities from 2000 to 2024; IBGE contributed 139,275 records for 5,571 municipalities from 2000 to 2024; and UFRN contributed 116,970 records for 5,570 municipalities from 2010 to 2030. Complete overlap across all four sources was available for 66,840 municipality-year records, representing 5,570 municipalities from 2010 to 2021.

## Magnitude of differences among municipal population estimates

Using IBGE as the reference denominator, median signed relative differences were 0.27% for DataSUS, 0.82% for DataSUS 2024 and -0.06% for UFRN. Median absolute relative differences were 1.82%, 2.51% and 2.12%, respectively. The upper tail was wider: 95th-percentile absolute relative differences were 10.18% for DataSUS, 13.14% for DataSUS 2024 and 15.74% for UFRN. Maximum absolute relative differences reached 269.19%, 413.28% and 356.83%, respectively, indicating that a small subset of municipality-year records had very large denominator discrepancies.

Differences varied by population-size stratum. For DataSUS, median absolute differences were 1.84% among municipalities below 5,000 inhabitants and 1.25% among municipalities with at least 500,000 inhabitants. For UFRN, the corresponding medians were 2.15% and 1.82%. For DataSUS 2024, median absolute differences were similar across strata, ranging from 2.29% in municipalities with 50,000-99,999 inhabitants to 2.67% in municipalities with at least 500,000 inhabitants.

## Effects of denominator choice on crude health indicator rates

The numerator application used annual notified dengue cases. The input dataset contained 91,242 municipality-year records for 5,069 municipalities from 2007 to 2024, totaling 22,031,937 notified cases. Because the same numerator was used with every denominator source, observed differences in rates are attributable to denominator choice and source coverage.

Compared with rates calculated using IBGE denominators, median signed relative differences in dengue rates were 0.00% for DataSUS, -0.29% for DataSUS 2024 and 0.07% for UFRN. Median absolute relative differences were 1.20%, 2.41% and 2.16%, respectively. The 95th-percentile absolute relative differences were 6.51%, 12.76% and 15.96%, respectively. Maximum absolute relative differences reached 143.94% for DataSUS, 164.71% for DataSUS 2024 and 352.73% for UFRN.

## Changes in rankings, quintile classifications and priority sets

Denominator choice changed municipal rankings even when median rate differences were modest. Median absolute rank displacement was 1 position for DataSUS, 7 positions for DataSUS 2024 and 6 positions for UFRN. The 95th-percentile absolute rank displacement was 33, 74 and 98 positions, respectively, and the maximum displacement was 650, 1,252 and 1,090 positions.

Quintile classifications were relatively stable. The proportion of municipality-year records assigned to a different quintile was 0.76% for DataSUS, 1.74% for DataSUS 2024 and 2.15% for UFRN, and no records shifted by two or more quintiles. Top-decile priority sets also showed high overlap with the IBGE reference. Median reference-set overlap was 99.61% for DataSUS, 98.52% for DataSUS 2024 and 98.82% for UFRN. The lowest annual overlap values were 97.63%, 96.45% and 92.90%, respectively. Median Jaccard similarity was 0.99, 0.97 and 0.98, respectively.

## Age-sex-standardised rates

Age-sex-standardised rates were not calculated because the dengue numerator dataset used in this application was aggregated by municipality and year only. This does not affect the primary objective of evaluating denominator sensitivity in routinely reported crude municipal indicators, but it means that age-sex-specific denominator sensitivity remains a topic for future applications using stratified numerator data.

# Discussion

This study addresses a common but underreported source of uncertainty in
population health measurement: the choice of population denominator. In
Brazil, municipal health indicators are frequently calculated for
intercensal years using population estimates, yet several denominator
series are available and may produce different rates. By combining brpop
with a transparent sensitivity workflow, this manuscript provides a
practical way to document how denominator choice affects health
indicators, rankings and priority classifications.

The contribution is methodological and operational, illustrated here using notified dengue cases as a real-world municipality-year numerator. Rather than
attempting to identify a single correct denominator for all purposes,
the workflow quantifies how alternative denominator choices change the
outputs that researchers and managers actually use. This distinction is
important. Official annual total population estimates may be appropriate
for crude administrative indicators, while age-sex-specific estimates
are needed for standardisation and age-specific epidemiological rates.
Projection-based estimates may be useful when recent or future
denominators are required. However, when different sources yield
materially different rates or classifications, the uncertainty should be
made visible.

The findings should be interpreted in light of the broader literature on
small-area denominators. Small-area epidemiology relies on spatially and
temporally relevant population estimates, but such estimates are often
less certain in smaller areas and between census years. Prior work has
shown that denominator error can affect prevalence and incidence
statistics and that ignoring population-at-risk uncertainty can bias
small-area disease mapping. The Brazilian case adds a public health
systems perspective because municipal indicators are not only
descriptive statistics; they are tools for surveillance, resource
allocation, equity monitoring and policy evaluation within SUS.

The practical implication is that denominator sensitivity analysis
should become part of routine reporting for municipal health indicators.
At minimum, studies should name the denominator source, version,
retrieval date, population structure and code harmonisation choices.
When multiple plausible denominators exist, authors should report
whether the substantive conclusion changes under alternative sources.
For indicators used to rank municipalities or define priority areas,
reclassification metrics are particularly useful because they show
whether denominator choice changes who is identified as high risk.

The workflow also supports reproducibility. The brpop package reduces
barriers to accessing and comparing denominator sources, while the
supplied scripts create an auditable pipeline from population retrieval
to health-rate sensitivity summaries. This is consistent with current
expectations for transparent data and code availability in population
health research. A public code repository with a persistent identifier
would also allow the manuscript to be updated when new census results,
revised estimates or additional denominator sources become available.

This study has limitations. First, the proposed analysis compares
available estimates but does not validate them against a true population
for intercensal years, because no such gold standard exists. Census
counts themselves may contain coverage errors, although they remain a
central benchmark for demographic estimation. Second, the magnitude of
denominator effects depends on the selected health numerator. Rare
events, indicators with small numerators, and small municipalities may
show greater instability, while common events in large municipalities
may be less sensitive. Third, health numerators have their own sources
of uncertainty, including underreporting, coding changes, geocoding
errors and changes in service availability. The present design isolates
denominator effects by holding the numerator constant, but numerator
quality should also be evaluated in substantive studies. Fourth, the
default code harmonises municipality identifiers to six digits, which is
practical for joining sources but should be reviewed carefully when
studying historical boundary changes or municipalities created, merged
or recoded during the study period.

Despite these limitations, the approach has several strengths. It is
transparent, reproducible, extensible to different health outcomes, and
directly connected to the ways health indicators are used in practice.
It produces interpretable outputs for both researchers and
decision-makers, including rate differences, rank displacement and
changes in priority-set membership. The analysis can also be extended to
Bayesian or simulation-based frameworks that explicitly propagate
denominator uncertainty into models, but its first contribution is to
make denominator sensitivity visible in routine descriptive
epidemiology.

# Conclusions

Population denominators are not neutral technical inputs; they shape the
values and interpretation of small-area health indicators. In Brazil,
the availability of multiple municipal population estimates creates both
an opportunity and a responsibility: researchers can choose denominators
suited to their analytical aims, but they should also report how
sensitive their conclusions are to that choice. The reproducible
workflow proposed here uses brpop to compare denominator sources and
quantify their impact on municipal health rates, rankings and
classifications. Incorporating denominator sensitivity analysis into
health-indicator reporting can improve transparency, strengthen
surveillance practice and support more cautious interpretation of
municipal inequalities and priorities.

# List of abbreviations

  -----------------------------------------------------------------------
  **Abbreviation**                    **Definition**
  ----------------------------------- -----------------------------------
  DataSUS                             Department of Informatics of the
                                      Brazilian Unified Health System

  IBGE                                Brazilian Institute of Geography
                                      and Statistics

  PCDaS                               Plataforma de Ciencia de Dados
                                      aplicada a Saude / Data Science
                                      Platform Applied to Health

  SUS                                 Sistema Unico de Saude / Brazilian
                                      Unified Health System

  UFRN-PPGDEM-LEPP                    Federal University of Rio Grande do
                                      Norte, Graduate Program in
                                      Demography, Laboratory of
                                      Population Estimates and
                                      Projections
  -----------------------------------------------------------------------

# Declarations

## Ethics approval and consent to participate

Not applicable. This methodological study uses aggregated municipal
population denominators and aggregated health event counts. No
individual-level identifiable human participant data are included in the
manuscript or supplementary files. If future versions use restricted
health data, the authors should update this statement according to
institutional review and data-governance requirements.

## Consent for publication

Not applicable.

## Availability of data and materials

The reproducible code supporting this manuscript is included with the project materials. Population denominator data are accessed through the brpop R package. The health numerator application uses a public aggregated municipality-year dengue notification dataset from Anders (2025), derived from SINAN/DataSUS and distributed under a CC BY 4.0 licence. The source workbook, conversion script and compressed CSV outputs are included with the project materials as individual `.csv.zip` archives. A public repository and persistent identifier should be added before journal submission.

## Competing interests

RS is the author and maintainer of the brpop R package used in this
study. The remaining authors declare that they have no competing
interests. This statement should be revised after all co-authors are
confirmed.

## Funding

\[Insert funding information. If no specific funding supported this
work, write: This research received no specific grant from any funding
agency in the public, commercial or not-for-profit sectors.\]

## Authors\' contributions

RS conceived the study, developed the brpop package and drafted the
initial analysis plan. \[Initials\] contributed to study design, health
numerator definition and interpretation. \[Initials\] contributed to
data processing and statistical analysis. \[Initials\] contributed to
manuscript revision and public health interpretation. All authors read
and approved the final manuscript. This section should be updated after
co-authors are confirmed.

## Acknowledgements

\[Insert acknowledgements. Suggested: The authors thank the teams
responsible for maintaining Brazilian demographic and health information
systems and the public data infrastructures that make this analysis
possible.\]

## Authors\' information

Optional. \[Insert concise author information if desired.\]

# References

1.  Baker JD, Alcantara A, Ruan X, Vasan S, Crouse N. An evaluation of
    the accuracy of small-area demographic estimates of population at
    risk and its effect on prevalence statistics. Popul Health Metrics.
    2013;11:24. doi:10.1186/1478-7954-11-24.

2.  Fecht D, Cockings S, Hodgson S, Piel FB, Martin D, Waller LA.
    Advances in mapping population and demographic characteristics at
    small-area levels. Int J Epidemiol. 2020;49(Suppl 1):i15-i25.
    doi:10.1093/ije/dyz179.

3.  Tatem AJ. Small area population denominators for improved disease
    surveillance and response. Epidemics. 2022;40:100597.
    doi:10.1016/j.epidem.2022.100597.

4.  Amodio E, Zarcone M, Casuccio A, Vitale F. Trends in epidemiology:
    the role of denominator fluctuation in population based estimates.
    AIMS Public Health. 2021;8(3):500-506.
    doi:10.3934/publichealth.2021040.

5.  Peterson EN, Nethery RC, Chen JT, Tabb LP, Coull BA, Piel FB, Waller
    LA. A Bayesian spatial measurement error approach to incorporate
    heterogeneous population-at-risk uncertainty in estimating
    small-area opioid mortality rates. Spat Spatiotemporal Epidemiol.
    2025;53:100719. doi:10.1016/j.sste.2025.100719.

6.  Instituto Brasileiro de Geografia e Estatistica. Estimates of
    resident population for Municipalities and Federation Units. Rio de
    Janeiro: IBGE.
    https://www.ibge.gov.br/en/statistics/social/population/18448-population-estimates.html.
    Accessed 27 Apr 2026.

7.  Ministerio da Saude. DataSUS. Populacao residente: estudo de
    estimativas populacionais por municipio, sexo e idade, 2000-2021.
    Brasilia: Ministerio da Saude.
    https://datasus.saude.gov.br/populacao-residente/. Accessed 27 Apr
    2026.

8.  Universidade Federal do Rio Grande do Norte. LEPP - Laboratorio de
    Estimativas e Projecoes Populacionais. Natal: UFRN.
    https://demografiaufrn.net/laboratorios/lepp/. Accessed 27 Apr 2026.

9.  Saldanha R. brpop: Brazilian Population Estimatives. R package
    version 0.6.2. 2025. https://rfsaldanha.github.io/brpop/. Accessed
    27 Apr 2026.

10. Pedroso M, Salles R, Saldanha R, de Almeida VK, Souto G, Paixao B,
    et al. Data Science Platform Applied to Health in Contribution to
    the Brazilian Unified Health System. CEUR Workshop Proceedings.
    2023;3462:1-16.

11. Ministério da Saúde. Departamento de Informatica do SUS. Informações
    de Saude (TABNET). Brasilia: Ministerio da Saude.
    https://datasus.saude.gov.br/informacoes-de-saude-tabnet/. Accessed
    27 Apr 2026.

12. Carroll RJ, Ruppert D, Stefanski LA, Crainiceanu CM. Measurement
    Error in Nonlinear Models: A Modern Perspective. 2nd ed. Boca Raton:
    Chapman and Hall/CRC; 2006.

13. Waller LA, Gotway CA. Applied Spatial Statistics for Public Health
    Data. Hoboken: Wiley; 2004.

14. Wakefield J. Disease mapping and spatial regression with count data.n    Biostatistics. 2007;8(2):158-183. doi:10.1093/biostatistics/kxl008.nn15. Anders K. Annual notified dengue case incidence in Brazilian municipalitiesn    (SINAN database), 2007-2024. Monash University. Dataset. 2025.n    doi:10.26180/28737815.v1.

# Figure legends

Figure 1. Relative differences in municipal population estimates by
source and year, compared with the selected reference denominator.

Figure 2. Distribution of absolute relative population differences by
municipality population size stratum.

Figure 3. Relative differences in municipal health indicator rates
caused by denominator choice.

Figure 4. Municipal rank displacement and classification changes under
alternative denominator sources.

# Tables to be completed after analysis

  ---------------------------------------------------------------------------------------------
  **Table**               **Source output file**                        **Purpose**
  ----------------------- --------------------------------------------- -----------------------
  Table 2                 population_reference_summary.csv              Coverage and summary of
                                                                        denominator differences
                                                                        by year, source and
                                                                        population size.

  Table 3                 manuscript_table_population_summary.csv       Compact manuscript
                                                                        summary of population
                                                                        differences.

  Table 4                 manuscript_table_rate_summary.csv             Effect of denominator
                                                                        source on crude health
                                                                        rates.

  Table 5                 manuscript_table_classification_summary.csv   Reclassification, rank
                          and top_decile_overlap.csv                    and priority-set
                                                                        overlap metrics.
  ---------------------------------------------------------------------------------------------

# Supplementary material

Additional file 1. Reproducible R code and data templates for
denominator sensitivity analysis. File name:
population_denominators_reproducible_code.zip.
