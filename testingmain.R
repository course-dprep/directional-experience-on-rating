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


library(ggplot2)

# Nieuwe variabele maken
director_stats$total_runtime <- director_stats$avg_runtime * director_stats$film_count

# Regressiemodel
model <- lm(avg_rating ~ total_runtime, data = director_stats)
summary(model)

# Scatterplot met regressielijn
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
