library(dplyr)
library(GGally)
library(ggplot2)
library(tidyr)

# Merge datasets
df1 <- left_join(title_ratings, title_basics, by = "tconst")
df_merged <- left_join(df1, title_crew, by = "tconst")

# Splits directors in different columns
df_split <- df_merged %>%
  separate_rows(directors, sep = ",")

# Deletes unknown directors and false runtimes
df_clean <- df_split %>%
  filter(directors != "\\N", runtimeMinutes != "\\N") %>%
  mutate(runtimeMinutes = as.numeric(runtimeMinutes))  # Nu veilig

#Calculating stats and group_by director
director_stats <- df_clean %>%
  group_by(directors) %>%
  summarise(
    avg_rating = mean(averageRating, na.rm = TRUE),
    film_count = n(),
    avg_runtime = mean(runtimeMinutes, na.rm = TRUE)
  ) %>%
  ungroup()

# Filter directors with small amount of films
director_stats <- director_stats %>%
  filter(film_count >= 3)