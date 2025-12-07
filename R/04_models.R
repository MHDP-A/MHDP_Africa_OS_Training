# R/04_models.R
# -------------------------------------------------------------------------
# Purpose: Demonstrate classical statistical modeling:
#          - Logistic regression for depression diagnosis
#          - Linear regression for quality of life
# -------------------------------------------------------------------------

source(here::here("R", "01_setup.R"))

mh <- readRDS(here::here("data", "mental_health_dataset_clean.rds"))

# Logistic regression: depression_dx ~ scores + demographics ---------------

mh_model <- mh %>%
  drop_na(phq9_score, gad7_score, perceived_stress_score,
          age, sex, income_monthly, social_support_score)

logit_fit <- glm(
  depression_dx ~ phq9_score + gad7_score + perceived_stress_score +
    age + sex + income_monthly + social_support_score,
  data = mh_model,
  family = binomial
)

summary(logit_fit)

logit_tidy <- broom::tidy(logit_fit, exponentiate = TRUE, conf.int = TRUE)
logit_tidy

write.csv(logit_tidy,
          here::here("output", "logistic_depression_or.csv"),
          row.names = FALSE)

# Linear regression: quality_of_life_score --------------------------------

lm_fit <- lm(
  quality_of_life_score ~ phq9_score + gad7_score + perceived_stress_score +
    social_support_score + financial_stress_score + work_stress_score +
    age + sex,
  data = mh_model
)

summary(lm_fit)

lm_tidy <- broom::tidy(lm_fit, conf.int = TRUE)
write.csv(lm_tidy,
          here::here("output", "lm_quality_of_life.csv"),
          row.names = FALSE)
