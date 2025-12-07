# R/03_eda.R
# -------------------------------------------------------------------------
# Purpose: Exploratory data analysis for the mental health dataset.
#          - Descriptive statistics
#          - Visualizations
#          - Simple bivariate exploration
# -------------------------------------------------------------------------

source(here::here("R", "01_setup.R"))

mh <- readRDS(here::here("data", "mental_health_dataset_clean.rds"))

# Overall skim summary
skimr::skim(mh)

# Save a basic descriptive table for key variables
desc_tbl <- mh %>%
  select(age, sex, county, phq9_score, gad7_score,
         perceived_stress_score, depression_dx, anxiety_dx,
         quality_of_life_score) %>%
  gtsummary::tbl_summary(
    by = depression_dx,
    statistic = list(all_continuous() ~ "{mean} ({sd})",
                     all_categorical() ~ "{n} ({p}%)")
  ) %>%
  gtsummary::as_gt()

gtsave(desc_tbl, here::here("output", "table1_desc_by_depression.html"))

# Distribution plots ------------------------------------------------------

p_phq_hist <- mh %>%
  ggplot(aes(x = phq9_score)) +
  geom_histogram(binwidth = 2, boundary = 0) +
  labs(
    title = "Distribution of PHQ-9 Depression Scores",
    x = "PHQ-9 score",
    y = "Count"
  )

p_gad_hist <- mh %>%
  ggplot(aes(x = gad7_score)) +
  geom_histogram(binwidth = 2, boundary = 0) +
  labs(
    title = "Distribution of GAD-7 Anxiety Scores",
    x = "GAD-7 score",
    y = "Count"
  )

p_phq_hist + p_gad_hist
ggsave(here::here("figures", "phq9_gad7_histograms.png"), width = 8, height = 4)

# Boxplots by sex
p_phq_sex <- mh %>%
  ggplot(aes(x = sex, y = phq9_score)) +
  geom_boxplot() +
  labs(
    title = "PHQ-9 Scores by Sex",
    x = "Sex",
    y = "PHQ-9 score"
  )

ggsave(here::here("figures", "phq9_by_sex.png"), p_phq_sex, width = 6, height = 4)

# Relationship between depression and quality of life
p_qol_phq <- mh %>%
  ggplot(aes(x = phq9_score, y = quality_of_life_score)) +
  geom_point(alpha = 0.4) +
  geom_smooth(method = "lm", se = TRUE) +
  labs(
    title = "Quality of Life vs PHQ-9 score",
    x = "PHQ-9 score",
    y = "Quality of life score"
  )

ggsave(here::here("figures", "qol_vs_phq9.png"), p_qol_phq, width = 6, height = 4)

# Correlation matrix for selected continuous variables --------------------

cont_vars <- mh %>%
  select(phq9_score, gad7_score, perceived_stress_score,
         social_support_score, financial_stress_score,
         work_stress_score, quality_of_life_score,
         disability_score)

cor_mat <- cor(cont_vars, use = "pairwise.complete.obs")
cor_mat

# Convert to long format for heatmap
cor_long <- as.data.frame(as.table(cor_mat))

p_cor_heat <- cor_long %>%
  ggplot(aes(Var1, Var2, fill = Freq)) +
  geom_tile() +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red") +
  labs(
    title = "Correlation heatmap (selected variables)",
    x = "", y = "", fill = "Correlation"
  ) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave(here::here("figures", "correlation_heatmap.png"), p_cor_heat,
       width = 6, height = 5)
