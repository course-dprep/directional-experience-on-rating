#Setup
install.packages(c("readr", "tidyverse", "dplyr"))

packages <- c("readr", "tidyverse", "dplyr")
lapply(packages, library, character.only = TRUE)

getwd() #If working directory is not right, set your working directory to the root directory

#Input
imdb_movies
imdb_movies <- read_csv("gen/temp/imdb_movies.csv")

#Transformation

runtime_bounds <- quantile(imdb_movies$runtimeMinutes, probs = c(0.05, 0.95), na.rm = TRUE)

imdb_movies_mod <- imdb_movies %>%
  filter(startYear >= 1990) %>%
  filter(!is.na(runtimeMinutes)) %>%
  filter(!is.na(averageRating)) %>%
  filter(!is.na(directors)) %>%
  filter(runtimeMinutes >= runtime_bounds[1], runtimeMinutes <= runtime_bounds[2]) %>%
  separate_rows(directors, sep = ",")

imdb_movies_mod <- imdb_movies_mod %>%
  separate_rows(genres, sep = ",") %>% #Set every genre at a new row
  mutate(genres = trimws(genres)) %>%
  filter(genres %in% c("Drama", "Action"))

imdb_movies_mod2 <- imdb_movies_mod %>%
  group_by(directors) %>%
  summarise(
    total_runtime = sum(runtimeMinutes, na.rm = TRUE),
    avg_rating = mean(averageRating, na.rm = TRUE),
    n_films = n(),
    most_common_genre = names(sort(table(genres), decreasing = TRUE))[1],
    .groups = "drop"
  )

#Is dit niet een vertekend beeld? Waarom, we kijken nu echt alleen naar de dingen die bekend zijn
#voor action en drama, alleen deze films zijn hier nog bekend. Mogen we dit als geldig zien

#Output
readr::write_csv(imdb_movies_mod2, "gen/temp/imdb_movies_mod2.csv")

