
# -------------------------------
# Purpose: EDA for the mental health data
#     - Descriptive statistics
#     - data visualization
#     - Bivariate analysis
#     - multivariate analysis

source(here::here("R", "01_setup.R"))

mh_dat <- readRDS(here::here("data", "mental_health_dataset_clean.rds"))

