# SETUP:
# Installing and loading required packages
install.packages(c("readr", "tidyverse"))

packages <- c("readr", "tidyverse")
lapply(packages, library, character.only = TRUE)

# Set working directory to project root
setwd("../../")

# INPUT:
# URLs for the IMDb datasets
urls <- list(
  title.ratings = "https://datasets.imdbws.com/title.ratings.tsv.gz",
  title.crew = "https://datasets.imdbws.com/title.crew.tsv.gz",
  name.basics = "https://datasets.imdbws.com/name.basics.tsv.gz",
  title.basics = "https://datasets.imdbws.com/title.basics.tsv.gz"
)

for(name in names(urls)){
  destfile <- paste0("data/raw_data/", name, ".tsv.gz")
  if(!file.exists(destfile)){
    download.file(urls[[name]], destfile)
  }
}

# TRANSFORMATION:
# Naming the files in environment
title_ratings <- readr::read_tsv("data/raw_data/title.ratings.tsv.gz")
title_crew <- readr::read_tsv("data/raw_data/title.crew.tsv.gz")
name_basics <- readr::read_tsv("data/raw_data/name.basics.tsv.gz")
title_basics <- readr::read_tsv("data/raw_data/title.basics.tsv.gz") %>% 
  filter(titleType == "movie") %>% 
  select(tconst, runtimeMinutes, genres, startYear)

# OUTPUT 
# Save cleaned datasets as .csv
readr::write_csv(title_ratings, "gen/temp/title_ratings_clean.csv")
readr::write_csv(title_crew, "gen/temp/title_crew_clean.csv")
readr::write_csv(name_basics, "gen/temp/name_basics_clean.csv")
readr::write_csv(title_basics, "gen/temp/title_basics_clean.csv")