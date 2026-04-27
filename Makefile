all:
	Rscript R/00_install_packages.R
	Rscript R/01_population_denominators.R
	Rscript R/02_prepare_numerator_from_csv.R
	Rscript R/03_rate_sensitivity_analysis.R
	Rscript R/04_age_sex_standardisation.R
	Rscript R/05_figures_tables.R

population:
	Rscript R/00_install_packages.R
	Rscript R/01_population_denominators.R

rates:
	Rscript R/02_prepare_numerator_from_csv.R
	Rscript R/03_rate_sensitivity_analysis.R
