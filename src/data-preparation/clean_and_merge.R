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
data_dir <- "../../data"

# Filter and merge
title_ratings_movies <- title_ratings %>% semi_join(title_basics, by = "tconst")
title_crew_movies <- title_crew %>% semi_join(title_basics, by = "tconst")

imdb_movies <- title_basics %>%
  left_join(title_ratings_movies, by = "tconst") %>%
  left_join(title_crew_movies, by = "tconst")

# Save as csv
readr::write_csv(imdb_movies, "data/imdb_movies_dataset.csv")

# Column description
name_basics_cols <- tibble(
  column = c("nconst", "primaryName", "birthYear", "deathYear", "primaryProfession", "knownForTitles"),
  description = c(
    "alphanumeric unique identifier of the name/person",
    "name by which the person is most often credited",
    "in YYYY format",
    "in YYYY format if applicable, else '\\N'",
    "the top-3 professions of the person",
    "titles the person is known for"
  )
)

title_crew_cols <- tibble(
  column = c("tconst", "directors", "writers"),
  description = c(
    "alphanumeric unique identifier of the title",
    "director(s) of the given title",
    "writer(s) of the given title"
  )
)

title_basics_cols <- tibble(
  column = c("tconst", "titleType", "primaryTitle", "originalTitle", "isAdult", "startYear", "endYear", "runtimeMinutes", "genres"),
  description = c(
    "alphanumeric unique identifier of the title",
    "the type/format of the title (e.g. movie, short, tvseries, tvepisode, video, etc)",
    "the more popular title / the title used by the filmmakers on promotional materials at the point of release",
    "the original title, in the original language",
    "0: non-adult title; 1: adult title",
    "represents the release year of a title. In the case of TV Series, it is the series start year",
    "TV Series end year. '\\N' for all other title types",
    "primary runtime of the title, in minutes",
    "includes up to three genres associated with the title"
  )
)

title_ratings_cols <- tibble(
  column = c("tconst", "averageRating", "numVotes"),
  description = c(
    "alphanumeric unique identifier of the title",
    "weighted average of all the individual user rating",
    "number of votes the title has received"
  )
)
