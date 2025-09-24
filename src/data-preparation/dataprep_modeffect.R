library(GGally)
library(ggplot2)
library(tidyr)
library(dplyr)

# First step: linking: movies + directors to genres and runtime
films <- title_basics %>%
  select(tconst, genres, runtimeMinutes) %>%
  inner_join(title_crew %>% select(tconst, directors), by = "tconst") %>%
  mutate(runtimeMinutes = suppressWarnings(as.numeric(runtimeMinutes)))

# Second step: replace missing runtime values for the average
# Descision: we want to have as much movies in the dataset as possible
# We do not want to remove any values, as this could affect the conclusion about the dominance between action and drama.
mean_runtime <- mean(films$runtimeMinutes, na.rm = TRUE)

films <- films %>%
  mutate(runtimeMinutes = ifelse(is.na(runtimeMinutes), mean_runtime, runtimeMinutes))

# Third step: For the moderating effect, we only look at the effect of action vs drama genres
films <- films %>%
  filter(genres %in% c("Action", "Drama"))

# Fourth step: summate the runtime per genre per director and pivot wider
director_genres <- films %>%
  group_by(directors, genres) %>%
  summarise(total_runtime_genre = sum(runtimeMinutes), .groups = "drop") %>%
  tidyr::pivot_wider(
    names_from = genres,
    values_from = total_runtime_genre,
    values_fill = 0
  ) %>%
  mutate(dominant_genre = ifelse(Action >= Drama, "Action", "Drama"))

# Fifth step, combine this dataset with director_stats
data_mod <- director_stats %>%
  inner_join(director_genres %>% select(directors, dominant_genre), by = "directors")
#With an inner_join you only keep the records where both datasets overlap.
#####################################################################