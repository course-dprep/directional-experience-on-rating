library(dplyr)
library(GGally)
library(ggplot2)
library(tidyr)
library(stringr)
library(purrr)

# Merge stringr# Merge datasets
df1 <- left_join(title_ratings, title_basics, by = "tconst")
df_merged <- left_join(df1, title_crew, by = "tconst")

# Splits directors in different columns
df_split <- df_merged %>%
  separate_rows(directors, sep = ",")

# Sets runtimeMinutes as numeric and changes "\\N" to NA
df_split <- df_split %>%
  mutate(runtimeMinutes = na_if(runtimeMinutes, "\\N"),
         runtimeMinutes = as.numeric(runtimeMinutes))

# Deletes unknown directors and genres and created column with primary genre
df_clean <- df_split %>%
  filter(directors != "\\N") %>%
  filter(genres != "\\N")
  
# Splitting genres and calculating median for each genre 
df_genres_long <- df_clean %>%
  separate_rows(genres, sep = ",")

genre_runtime_medians <- df_genres_long %>%
  group_by(genres) %>%
  summarise(median_runtime = median(runtimeMinutes, na.rm = TRUE))

# Adding median runtimeMinutes for each genre and calculate the mean for runtimeMinutes for each movie
df_genres_long <- df_genres_long %>%
  left_join(genre_runtime_medians, by = "genres") %>%
  group_by(tconst) %>%
  mutate(mean_median_runtime = mean(median_runtime, na.rm = TRUE)) %>%
  ungroup()

# Changing back to one row per movie
df_imputed <- df_genres_long %>%
  group_by(tconst) %>%
  slice(1) %>%
  ungroup() %>%
  left_join(
    df_clean %>% select(tconst, genres),
    by = "tconst",
    suffix = c("", "_orig")
  ) %>%
  mutate(runtimeMinutes_imputed = if_else(
    is.na(runtimeMinutes),
    mean_median_runtime,
    runtimeMinutes
  ))

#Calculating stats and group_by director
director_stats <- df_imputed %>%
  group_by(directors) %>%
  summarise(
    avg_rating = mean(averageRating, na.rm = TRUE),
    film_count = n(),
    avg_runtime = mean(runtimeMinutes_imputed, na.rm = TRUE)
  ) %>%
  ungroup()

# Filter directors with small amount of films
director_stats <- director_stats %>%
  filter(film_count >= 3)