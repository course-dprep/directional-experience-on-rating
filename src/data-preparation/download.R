# SETUP:
# Installing and loading required packages
install.packages(c("readr", "tidyverse"))
packages <- c("readr", "tidyverse")
lapply(packages, library, character.only = TRUE)

# Set working directory
setwd("../../")

# Creating folder
if(!dir.exists("data/raw_data")){
  dir.create("data/raw_data", recursive = TRUE)
}

# INPUT:
# URLs for the IMDb datasets
urls <- list(
  ratings = "https://datasets.imdbws.com/title.ratings.tsv.gz",
  crew = "https://datasets.imdbws.com/title.crew.tsv.gz",
  name_basics = "https://datasets.imdbws.com/name.basics.tsv.gz",
  title_basics = "https://datasets.imdbws.com/title.basics.tsv.gz"
)

for(name in names(urls)){
  destfile <- paste0("data/raw_data/", name, ".tsv.gz")
  if(!file.exists(destfile)){
    download.file(urls[[name]], destfile)
  }
}

# TRANSFORMATION:
# Naming the files in environment
title_ratings <- readr::read_tsv("data/raw_data/ratings.tsv.gz")
title_crew <- readr::read_tsv("data/raw_data/crew.tsv.gz")
name_basics <- readr::read_tsv("data/raw_data/name_basics.tsv.gz")
title_basics <- readr::read_tsv("data/raw_data/title_basics.tsv.gz") %>% 
  filter(titleType == "movie") %>% 
  select(tconst, runtimeMinutes, genres, startYear)

# OUTPUT:
# Write output as csv 
readr::write_csv(title_ratings,"data/raw_data/ratings.csv")
readr::write_csv(title_crew,"data/raw_data/crew.csv")
readr::write_csv(name_basics,"data/raw_data/name_basics.csv")
readr::write_csv(title_basics,"data/raw_data/title_basics.csv")
