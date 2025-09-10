# This script will be used to populate the \data directory
# with all necessary raw data files.

# This makefile will be used to automate the
load_pkg <- function(pkg){
  if(!require(pkg, character.only = TRUE)){
    install.packages(pkg, dependencies = TRUE)
    library(pkg, character.only = TRUE)
  }
}
packages <- c("readr", "tidyverse", "tidyr", "dplyr", "tinytex", "rmarkdown")

lapply(packages, load_pkg)

# Load raw data
title_ratings <- readr::read_tsv("data/raw_data/title.ratings.tsv")
title_crew <- readr::read_tsv("data/raw_data/title.crew.tsv")
name_basics <- readr::read_tsv("data/raw_data/name.basics.tsv")

# Filter movie titles
title_basics <- readr::read_tsv("data/raw_data/title.basics.tsv") %>%
  filter(titleType == "movie") %>%
  select(tconst, runtimeMinutes, genres)

