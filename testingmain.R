library(dplyr)
library(GGally)
library(ggplot2)
library(tidyr)

# Merge
df1 <- left_join(title_ratings, title_basics, by = "tconst")
df_merged <- left_join(df1, title_crew, by = "tconst")

# Splits meerdere regisseurs in aparte rijen
df_split <- df_merged %>%
  separate_rows(directors, sep = ",")

# ✅ Filter: verwijder onbekende regisseurs en ongeldige runtime
df_clean <- df_split %>%
  filter(directors != "\\N", runtimeMinutes != "\\N") %>%
  mutate(runtimeMinutes = as.numeric(runtimeMinutes))  # Nu veilig

# Bereken stats per regisseur
director_stats <- df_clean %>%
  group_by(directors) %>%
  summarise(
    avg_rating = mean(averageRating, na.rm = TRUE),
    film_count = n(),
    avg_runtime = mean(runtimeMinutes, na.rm = TRUE)
  ) %>%
  ungroup()

# Filter eventueel regisseurs met te weinig films
director_stats <- director_stats %>%
  filter(film_count >= 3)

# ggpairs plot
ggpairs(director_stats,
        columns = c("avg_rating", "film_count", "avg_runtime"),
        title = "Director Statistics")


