# 00_install_packages.R
# Install required packages for the reproducible workflow.

required_cran <- c(
  "dplyr", "tidyr", "purrr", "readr", "stringr", "ggplot2", "scales",
  "janitor", "yaml", "forcats", "tibble", "remotes", "rlang"
)

missing <- setdiff(required_cran, rownames(installed.packages()))
if (length(missing) > 0) {
  install.packages(missing, repos = "https://cloud.r-project.org")
}

# brpop was archived on CRAN in 2025. Install from GitHub.
if (!requireNamespace("brpop", quietly = TRUE)) {
  remotes::install_github("rfsaldanha/brpop")
}

invisible(lapply(c(required_cran, "brpop"), require, character.only = TRUE))
