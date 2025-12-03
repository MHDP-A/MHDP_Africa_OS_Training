
#------------------------------------------------------
# Purpose: install and load packages needed for analysis. Define helper functions. 

pkgs <- c("dplyr", "lubridate", "stringr", "ggplot2", "tidyr", "forecast", "stats", "forecast","tidyverse", "readxl", 
          "janitor", "gt", "gtsummary", "patchwork", "broom", "here")

if(!"pacman" %in% installed.packages()[,1]){
  install.packages("pacman")
}
pacman::p_load(pkgs, character.only = T, install = T)

# Global options
options(
  scipen = 999,
  dplyr.summarise.inform = FALSE
)

# create output directories, if they don't exist

dir.create(here("outputs"), showWarnings = F)
dir.create(here("figures"), showWarnings = F)
dir.create(here("reports"), showWarnings = F)

message("Setup process complete: packages loaded and directories created")
