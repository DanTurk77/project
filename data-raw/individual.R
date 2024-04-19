## code to prepare `individual` dataset goes here

usethis::use_data(individual, overwrite = TRUE)

## code to prepare `individual` dataset goes here
## Setup ----
library(dplyr)

## Combine individual tables ----
# Create paths to inputs
raw_data_path <- here::here("data-raw", "wood-survey-data-master")
individual_paths <- fs::dir_ls(fs::path(raw_data_path, "individual"))

## Joining data

# Combine NEON data tables ----
# read in additional tables
maptag <- readr::read_csv(
  fs::path(
    raw_data_path,
    "vst_mappingandtagging.csv"
  ),
  show_col_types = FALSE
) %>%
  select(-eventID)

perplot <- readr::read_csv(
  fs::path(
    raw_data_path,
    "vst_perplotperyear.csv"
  ),
  show_col_types = FALSE
) %>%
  select(-eventID)

# Left join tables to individual
individual %<>%
  left_join(maptag,
            by = "individualID",
            suffix = c("", "_map")
  ) %>%
  left_join(perplot,
            by = "plotID",
            suffix = c("", "_ppl")
  ) %>%
  assertr::assert(
    assertr::not_na, stemDistance, stemAzimuth, pointID,
    decimalLongitude, decimalLatitude, plotID
  )

