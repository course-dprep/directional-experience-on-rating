#required packages
load_pkg <- function(pkg){
  if(!require(pkg, character.only = TRUE)){
    install.packages(pkg, dependencies = TRUE)
    library(pkg, character.only = TRUE)
  }
}
packages <- c("readr", "tidyverse")
lapply(packages, load_pkg)

#set directory
data_dir <- "../../data/raw_data"

# Creating folder
if(!dir.exists("data/raw_data")){
  dir.create("data/raw_data", recursive = TRUE)
}

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

# Naming the files
title_ratings <- readr::read_tsv("data/raw_data/ratings.tsv.gz")
title_crew <- readr::read_tsv("data/raw_data/crew.tsv.gz")
name_basics <- readr::read_tsv("data/raw_data/name_basics.tsv.gz")
title_basics <- readr::read_tsv("data/raw_data/title_basics.tsv.gz") %>% 
  filter(titleType == "movie") %>% 
  select(tconst, runtimeMinutes, genres, startYear)
