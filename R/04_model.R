
# ---------------------------------------------------------
# Purpose: classical statistical modelling
# --------------- Logistic regression
#  --------------- Linear regression

source(here::here("R", "01_setup.R"))

mh_dat <- readRDS(here::here("data", "mental_health_dataset_clean.rds"))


logistic_mdl <- glm(depression_dx~ predictors)