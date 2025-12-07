# R/02_import_clean.R
# -------------------------------------------------------------------------
# Purpose: Import the mental health dataset from Excel, clean variable names,
#          recode factors, create derived variables, and save a cleaned version.
# -------------------------------------------------------------------------

source(here::here("R", "01_setup.R"))

raw_path <- here::here("data", "mental_health_dataset.xlsx")

mh_raw <- readxl::read_excel(raw_path) %>%
  janitor::clean_names()

# Quick structure check
glimpse(mh_raw)

# Recode categorical variables as factors
mh <- mh_raw %>%
  mutate(
    sex                       = factor(sex),
    county                    = factor(county),
    education                 = factor(education, ordered = TRUE,
                                      levels = c("Primary","Secondary","College","University","Postgraduate")),
    employment_status         = factor(employment_status),
    marital_status            = factor(marital_status),
    mental_health_history     = factor(mental_health_history),
    physical_health_conditions= factor(physical_health_conditions),
    substance_use             = factor(substance_use),
    trauma_history            = factor(trauma_history, 
                                      levels = c("None","Mild","Moderate","Severe"), ordered = TRUE),
    depression_dx             = factor(depression_dx, levels = c(0, 1), labels = c("No","Yes")),
    anxiety_dx                = factor(anxiety_dx, levels = c(0, 1), labels = c("No","Yes")),
    psychosis_dx              = factor(psychosis_dx, levels = c(0, 1), labels = c("No","Yes")),
    visited_clinic_past_year  = factor(visited_clinic_past_year),
    medication_use            = factor(medication_use),
    violence_exposure         = factor(violence_exposure,
                                      levels = c("None","Low","Moderate","High"), ordered = TRUE),
    phone_access              = factor(phone_access),
    internet_access           = factor(internet_access),
    mh_app_usage              = factor(mh_app_usage,
                                      levels = c("Never","Occasionally","Regularly"), ordered = TRUE),
    coping_style              = factor(coping_style),
    support_group_participation = factor(support_group_participation),
    crisis_event_past_year    = factor(crisis_event_past_year)
  )

# Derived severity categories using common PHQ-9 and GAD-7 cutpoints
mh <- mh %>%
  mutate(
    phq9_category = cut(
      phq9_score,
      breaks = c(-Inf, 4, 9, 14, 19, Inf),
      labels = c("Minimal", "Mild", "Moderate", "Moderately severe", "Severe"),
      right = TRUE
    ),
    gad7_category = cut(
      gad7_score,
      breaks = c(-Inf, 4, 9, 14, Inf),
      labels = c("Minimal", "Mild", "Moderate", "Severe"),
      right = TRUE
    ),
    severe_depression_flag = if_else(phq9_score >= 20, 1L, 0L),
    high_stress_flag       = if_else(perceived_stress_score >= 20, 1L, 0L)
  )

# (Optional) Introduce some missingness for teaching purposes

set.seed(457)

mh$sleep_hours[sample(1:nrow(mh), size = 100)] <- NA_real_

mh$income_monthly[sample(1:nrow(mh), size = 80)] <- NA_real_

# Save cleaned data
clean_path <- here::here("data", "mental_health_dataset_clean.rds")

saveRDS(mh, clean_path)

message("Cleaned dataset saved to: ", clean_path)
