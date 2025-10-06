# SETUP:
# Installing and loading required packages
install.packages(c("readr", "tidyverse"))
packages <- c("readr", "tidyverse")
lapply(packages, library, character.only = TRUE)

# Set working directory
setwd("../../")

# Creating folders
if(!dir.exists("data/raw_data")){
  dir.create("data/raw_data", recursive = TRUE)
}
if(!dir.exists("gen/temp")){
  dir.create("gen/temp", recursive = TRUE)
}
if(!dir.exists("gen/temp/data_complete")){
  dir.create("gen/temp/data_complete", recursive = TRUE)
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
readr::write_csv(title_ratings,"gen/temp/ratings.csv")
readr::write_csv(title_crew,"gen/temp/crew.csv")
readr::write_csv(name_basics,"gen/temp/name_basics.csv")
readr::write_csv(title_basics,"gen/temp/title_basics.csv")
