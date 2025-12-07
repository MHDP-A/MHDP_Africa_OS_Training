# R/05_ml.R
# -------------------------------------------------------------------------
# Purpose: Illustrate a basic machine learning workflow using tidymodels:
#          - Predict depression_dx (Yes/No)
#          - Train/test split, recipe, model, metrics
# -------------------------------------------------------------------------

source(here::here("R", "01_setup.R"))

mh <- readRDS(here::here("data", "mental_health_dataset_clean.rds"))

mh_ml <- mh %>%
  drop_na(phq9_score, gad7_score, perceived_stress_score,
          age, sex, income_monthly, social_support_score,
          depression_dx)

# Make outcome a factor with clear positive class
mh_ml <- mh_ml %>%
  mutate(depression_dx = forcats::fct_relevel(depression_dx, "Yes"))

set.seed(578)
mh_split <- initial_split(mh_ml, prop = 0.7, strata = depression_dx)
mh_train <- training(mh_split)
mh_test  <- testing(mh_split)

# Recipe: basic preprocessing
mh_recipe <- recipe(depression_dx ~ phq9_score + gad7_score + perceived_stress_score +
                      age + sex + income_monthly + social_support_score +
                      financial_stress_score + work_stress_score,
                    data = mh_train) %>%
  step_impute_median(all_numeric_predictors()) %>%
  step_dummy(all_nominal_predictors()) %>%
  step_zv(all_predictors()) %>%
  step_normalize(all_numeric_predictors())

# Model: random forest (via ranger)
rf_spec <- rand_forest(
  mtry = tune(),
  trees = 500,
  min_n = tune()
) %>%
  set_engine("ranger") %>%
  set_mode("classification")

# Workflow
wf <- workflow() %>%
  add_model(rf_spec) %>%
  add_recipe(mh_recipe)

set.seed(123)
mh_folds <- vfold_cv(mh_train, v = 5, strata = depression_dx)

rf_grid <- grid_regular(
  mtry(range = c(2, 8)),
  min_n(range = c(5, 20)),
  levels = 4
)

rf_tuned <- tune_grid(
  wf,
  resamples = mh_folds,
  grid = rf_grid,
  metrics = metric_set(roc_auc, accuracy)
)

best_rf <- select_best(rf_tuned, "roc_auc")

final_wf <- finalize_workflow(wf, best_rf)

final_fit <- fit(final_wf, data = mh_train)

# Evaluate on test set
test_preds <- predict(final_fit, mh_test, type = "prob") %>%
  bind_cols(predict(final_fit, mh_test)) %>%
  bind_cols(mh_test %>% select(depression_dx))

metrics_rf <- yardstick::metric_set(roc_auc, accuracy, sensitivity, specificity)

results <- metrics_rf(
  data = test_preds,
  truth = depression_dx,
  estimate = .pred_class,
  .pred_Yes
)

results
write.csv(results, here::here("output", "rf_depression_metrics.csv"),
          row.names = FALSE)
