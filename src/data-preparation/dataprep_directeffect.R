# SETUP:
# Loading required packages

packages <- c("readr", "tidyverse", "dplyr")
lapply(packages, library, character.only = TRUE)

# Set working directory
setwd("../../")

# INPUT:
imdb_movies <- read_csv("gen/temp/imdb_movies.csv")

# TRANSFORMATION:
runtime_bounds <- quantile(imdb_movies$runtimeMinutes, probs = c(0.05, 0.95), na.rm = TRUE)

imdb_movies_direct <- imdb_movies %>%
  filter(startYear >= 1990) %>%
  filter(!is.na(runtimeMinutes)) %>%
  filter(!is.na(averageRating)) %>%
  filter(!is.na(directors)) %>%
  filter(runtimeMinutes >= runtime_bounds[1], runtimeMinutes <= runtime_bounds[2])

imdb_movies_direct <- imdb_movies_direct %>%
  separate_rows(directors, sep = ",")

imdb_movies_direct <- imdb_movies_direct %>%
  group_by(directors) %>%
  summarise(
    total_runtime = sum(runtimeMinutes, na.rm = TRUE),
    avg_rating = mean(averageRating, na.rm = TRUE),     
    n_films = n()                                      
  ) 

# OUTPUT:
readr::write_csv(imdb_movies_direct, "gen/temp/imdb_movies_direct.csv")