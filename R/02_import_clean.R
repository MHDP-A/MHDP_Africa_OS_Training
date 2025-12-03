

# -------------------------------------------------------------------------
# Imports the data and the data is taken through a data cleaning process
#----------------------------------------------------------------------------

source(here::here("R","01_setup.R")) # calling the set up file

raw_path <- here::here("data", "mental_health_dataset.xlsx") # setting the data path

mh_raw <- readxl::read_excel(raw_path) %>% # importing the data
  janitor::clean_names()

# Quick structure check

glimpse(mh_raw)

str(mh_raw)

# Changing categorical variables to factor

mh_raw$sex <- factor(mh_raw$sex)

mh_raw$county <- factor(mh_raw$county)

#------ Add all the data cleaning processes above

# Saving the clean data

clean_path <- here::here("data","mental_health_dataset_clean.rds")

saveRDS(mh_raw, clean_path)


message("Cleaned data saved to:",clean_path)

