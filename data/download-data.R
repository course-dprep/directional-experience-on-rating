# Laad benodigde packages
load_pkg <- function(pkg){
  if(!require(pkg, character.only = TRUE)){
    install.packages(pkg, dependencies = TRUE)
    library(pkg, character.only = TRUE)
  }
}
packages <- c("readr", "tidyverse")
lapply(packages, load_pkg)

# Maak folder aan als die nog niet bestaat
if(!dir.exists("data/raw_data")){
  dir.create("data/raw_data", recursive = TRUE)
}

# URLs van de IMDb data
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
  # unzip (de compressie is .gz dus readr kan direct gz lezen, dus unzip niet nodig)


# Lees de data rechtstreeks uit de .gz bestanden met read_tsv
title_ratings <- readr::read_tsv("data/raw_data/ratings.tsv.gz")
title_crew <- readr::read_tsv("data/raw_data/crew.tsv.gz")
name_basics <- readr::read_tsv("data/raw_data/name_basics.tsv.gz")
title_basics <- readr::read_tsv("data/raw_data/title_basics.tsv.gz") %>% 
  filter(titleType == "movie") %>% 
  select(tconst, runtimeMinutes, genres)

# Filter en merge zoals in het originele script
title_ratings_movies <- title_ratings %>% semi_join(title_basics, by = "tconst")
title_crew_movies <- title_crew %>% semi_join(title_basics, by = "tconst")

imdb_movies <- title_basics %>%
  left_join(title_ratings_movies, by = "tconst") %>%
  left_join(title_crew_movies, by = "tconst")

# Opslaan als csv
readr::write_csv(imdb_movies, "data/imdb_movies_dataset.csv")