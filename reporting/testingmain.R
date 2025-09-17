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

#Moderator variable in dataset ####################################################
# Down(loading) the dplyr packages
install.packages("dplyr")
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
# ggpairs plot
ggpairs(director_stats,
        columns = c("avg_rating", "film_count", "avg_runtime"),
        title = "Director Statistics")


library(ggplot2)

# Creating a new variable for director_stats
director_stats$total_runtime <- director_stats$avg_runtime * director_stats$film_count

# Regressiemodel
model <- lm(avg_rating ~ total_runtime, data = director_stats)
summary(model)

# Scatterplot with regressionline
ggplot(director_stats %>% dplyr::filter(total_runtime <= 20000),
       aes(x = total_runtime, y = avg_rating)) +
  geom_point(color = "blue", alpha = 0.6, size = 3) +
  geom_smooth(method = "lm", color = "red", se = FALSE) +
  labs(
    x = "Total runtime (avg_runtime * film_count)",
    y = "Average rating",
    title = "Linear Regression: Runtime vs Rating (≤ 20,000)"
  ) +
  theme_minimal()

# Regression with the moderator: first regression model integration with the moderator
data_mod$dominant_genre <- factor(data_mod$dominant_genre, levels = c("Drama", "Action"))

lrmmod <- lm(avg_rating ~ total_runtime * dominant_genre, data = data_mod)
summary(lrmmod)

#####################
#Mean centering ???
####################
