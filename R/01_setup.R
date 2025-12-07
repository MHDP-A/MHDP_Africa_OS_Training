
# R/01_setup.R
# -------------------------------------------------------------------------
# Purpose: Install and load required packages, set options, and define helper
#          functions for the MHDP-Africa reproducibility tutorial.
# -------------------------------------------------------------------------. 

pkgs <- c("tidyverse","readxl","janitor","lubridate","skimr","gt","gtsummary","patchwork","broom",
          "yardstick","tidymodels","here")

if(!"pacman" %in% installed.packages()[,1]){
  install.packages("pacman")
}
pacman::p_load(pkgs, character.only = T, install = T)

# Global options
options(
  scipen = 999,
  dplyr.summarise.inform = FALSE
)

set.seed(1234)

# Create output directories if they don't exist

dir.create(here("output"), showWarnings = FALSE)
dir.create(here("figures"), showWarnings = FALSE)
dir.create(here("reports"), showWarnings = FALSE)

message("Setup complete: packages loaded and directories created.")

