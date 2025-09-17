# Installing and loading the required packages
install.packages("dplyr")
install.packages("GGally")
install.packages("ggplot2")
install.packages("tidyr")

library(dplyr)
library(GGally)
library(ggplot2)
library(tidyr)

# Merge
df1 <- left_join(title_ratings, title_basics, by = "tconst")
df_merged <- left_join(df1, title_crew, by = "tconst")

# Split the directors in multiple rows
df_split <- df_merged %>%
  separate_rows(directors, sep = ",")

# Filter by removing NA's of directors
df_clean <- df_split %>%
  filter(directors != "\\N", runtimeMinutes != "\\N") %>%
  mutate(runtimeMinutes = as.numeric(runtimeMinutes))  # Nu veilig

# !!RUNTIME MINUTES NA'S NOG VULLEN!!

# Calculating stats per director
director_stats <- df_clean %>%
  group_by(directors) %>%
  summarise(
    avg_rating = mean(averageRating, na.rm = TRUE),
    film_count = n(),
    avg_runtime = mean(runtimeMinutes, na.rm = TRUE)
  ) %>%
  ungroup()

# ggpairs plot
ggpairs(director_stats,
        columns = c("avg_rating", "film_count", "avg_runtime"),
        title = "Director Statistics")

# Create new variable
director_stats$total_runtime <- director_stats$avg_runtime * director_stats$film_count

# Regression model
model <- lm(avg_rating ~ total_runtime, data = director_stats)
summary(model)

# Scatter plot with regression line
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

# Testing NA's
summary(imdb_movies)
imdb_movies %>%
  filter(tconst == "\\N") %>%  # Note the double backslash to escape the backslash
  summarise(count = n())
imdb_movies %>%
  filter(runtimeMinutes == "\\N") %>%  # Note the double backslash to escape the backslash
  summarise(count = n())
imdb_movies %>%
  filter(genres == "\\N") %>%  # Note the double backslash to escape the backslash
  summarise(count = n())
imdb_movies %>%
  filter(averageRating == "\\N") %>%  # Note the double backslash to escape the backslash
  summarise(count = n())
imdb_movies %>%
  filter(numVotes == "\\N") %>%  # Note the double backslash to escape the backslash
  summarise(count = n())
imdb_movies %>%
  filter(directors == "\\N") %>%  # Note the double backslash to escape the backslash
  summarise(count = n())
imdb_movies %>%
  filter(writers == "\\N") %>%  # Note the double backslash to escape the backslash
  summarise(count = n())