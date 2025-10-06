# SETUP:
# Loading required packages

packages <- c("readr", "tidyverse", "dplyr")
lapply(packages, library, character.only = TRUE)

# Set working directory
setwd("../../")

# INPUT:
# The following files are the input from download.r
title_ratings <- readr::read_csv("gen/temp/ratings.csv")
title_crew <- readr::read_csv("gen/temp/crew.csv")
name_basics <- readr::read_csv("gen/temp/name_basics.csv")
title_basics <- readr::read_csv("gen/temp/title_basics.csv")

# TRANSFORMATION:
# Merge data in a single data file
imdb_movies <- title_basics
imdb_movies <- imdb_movies %>%
  full_join(title_ratings, by = "tconst") %>%
  full_join(title_crew, by = "tconst") 

#Remove writers columns
imdb_movies <- imdb_movies %>% 
  select(-writers)

# Column descriptions
name_basics_cols <- tibble(
  column = c("nconst", "primaryName", "birthYear", "deathYear", "primaryProfession", "knownForTitles"),
  description = c(
    "alphanumeric unique identifier of the name/person",
    "name by which the person is most often credited",
    "in YYYY format",
    "in YYYY format if applicable, else 'NA'",
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
    "TV Series end year. 'NA' for all other title types",
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

# Converting \\N to NA in imdb_movies
imdb_movies <- imdb_movies %>%
  mutate(across(c(runtimeMinutes, genres, startYear, directors), ~ na_if(as.character(.), "\\N")))

# Classing the different data
imdb_movies <- imdb_movies %>%
  mutate(
    startYear = as.integer(startYear),
    runtimeMinutes = as.numeric(runtimeMinutes)
    )

# OUTPUT:
# Save imdb_movies as .csv
dir.create("gen")
dir.create("gen/temp")
readr::write_csv(imdb_movies, "gen/temp/imdb_movies.csv")